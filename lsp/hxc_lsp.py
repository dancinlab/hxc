#!/usr/bin/env python3
# hxc-lsp — canonical LSP server for the .hxc wire format. Stdio
# JSON-RPC, zero deps (Python 3.8+). Spec-grounded diagnostics + hover
# from spec/hxc.md: `# schema:<id> k1..kN` then `@<id> v1|..|vN`
# (arity must equal the schema's key count), column-0 anchor invariant.
#
#   hxc-lsp                # speak LSP on stdin/stdout
#   hxc-lsp --check FILE   # one-shot lint (exit 1 on any error)
import json
import re
import sys

SCHEMA = re.compile(r"^#\s*schema:(\S+)\s+(.+)$")
DATA = re.compile(r"^@(\S+)\s+(.*)$")


def diag(ln, c0, c1, msg, sev=1):
    return {"range": {"start": {"line": ln, "character": c0},
                      "end": {"line": ln, "character": c1}},
            "severity": sev, "source": "hxc-lsp", "message": msg}


def validate(text):
    out, arity, keys = [], {}, {}
    if text.startswith("﻿"):
        out.append(diag(0, 0, 1, "byte-canonical: UTF-8 with no BOM"))
    if "\r" in text:
        out.append(diag(0, 0, 1, "byte-canonical: LF line endings only"))
    for i, raw in enumerate(text.split("\n")):
        s = raw.rstrip("\r")
        if s.strip() == "":
            continue
        m = SCHEMA.match(s)
        if m:
            arity[m.group(1)] = len(m.group(2).split())
            keys[m.group(1)] = m.group(2).split()
            continue
        if s.lstrip().startswith("#"):
            if s[0] != "#":
                out.append(diag(i, 0, len(s),
                    "invariant: no leading whitespace — `#` comment / "
                    "header lines anchor at column 0"))
            continue
        if s[0] == "@":
            d = DATA.match(s)
            if not d:
                out.append(diag(i, 0, len(s),
                    "expected `@<schema-id> v1|v2|...`"))
                continue
            sid, rest = d.group(1), d.group(2)
            if sid not in arity:
                out.append(diag(i, 1, 1 + len(sid),
                    "schema %r used before its `# schema:%s ...` "
                    "declaration" % (sid, sid)))
                continue
            n = len(rest.split("|"))
            if n != arity[sid]:
                out.append(diag(i, 0, len(s),
                    "schema %r expects %d fields (%s), got %d"
                    % (sid, arity[sid], " ".join(keys[sid]), n)))
        else:
            out.append(diag(i, 0, len(s),
                "invariant: every line is `# schema:<id> ...`, "
                "`# comment`, or `@<id> v|v|...` at column 0"))
    return out


def hover(line, keys):
    s = line.strip()
    m = SCHEMA.match(s)
    if m:
        return "**schema `%s`** — fields: %s" % (
            m.group(1), ", ".join(m.group(2).split()))
    d = DATA.match(s)
    if d and d.group(1) in keys:
        ks = keys[d.group(1)]
        vs = d.group(2).split("|")
        return "**@%s** → " % d.group(1) + ", ".join(
            "%s=%s" % (k, v) for k, v in zip(ks, vs))
    return None


def _schema_keys(text):
    keys = {}
    for s in text.split("\n"):
        m = SCHEMA.match(s)
        if m:
            keys[m.group(1)] = m.group(2).split()
    return keys


def _read():
    h = {}
    while True:
        ln = sys.stdin.buffer.readline()
        if not ln:
            return None
        ln = ln.decode("ascii", "replace").strip()
        if not ln:
            break
        if ":" in ln:
            k, v = ln.split(":", 1)
            h[k.strip().lower()] = v.strip()
    n = int(h.get("content-length", "0"))
    try:
        return json.loads(sys.stdin.buffer.read(n).decode("utf-8", "replace"))
    except Exception:
        return {}


def _send(o):
    b = json.dumps(o).encode("utf-8")
    sys.stdout.buffer.write(b"Content-Length: %d\r\n\r\n" % len(b) + b)
    sys.stdout.buffer.flush()


def _publish(uri, text):
    try:
        d = validate(text)
    except Exception as e:
        d = [diag(0, 0, 1, "hxc-lsp internal: %s" % e, 2)]
    _send({"jsonrpc": "2.0", "method": "textDocument/publishDiagnostics",
           "params": {"uri": uri, "diagnostics": d}})


def serve():
    docs = {}
    while True:
        m = _read()
        if m is None:
            break
        meth = m.get("method")
        if meth == "initialize":
            _send({"jsonrpc": "2.0", "id": m.get("id"), "result": {
                "capabilities": {"textDocumentSync": 1,
                                 "hoverProvider": True},
                "serverInfo": {"name": "hxc-lsp"}}})
        elif meth == "shutdown":
            _send({"jsonrpc": "2.0", "id": m.get("id"), "result": None})
        elif meth == "exit":
            break
        elif meth == "textDocument/didOpen":
            d = m["params"]["textDocument"]
            docs[d["uri"]] = d.get("text", "")
            _publish(d["uri"], docs[d["uri"]])
        elif meth == "textDocument/didChange":
            p = m["params"]
            ch = p.get("contentChanges") or [{}]
            docs[p["textDocument"]["uri"]] = ch[-1].get("text", "")
            _publish(p["textDocument"]["uri"],
                     docs[p["textDocument"]["uri"]])
        elif meth == "textDocument/didClose":
            u = m["params"]["textDocument"]["uri"]
            docs.pop(u, None)
            _send({"jsonrpc": "2.0",
                   "method": "textDocument/publishDiagnostics",
                   "params": {"uri": u, "diagnostics": []}})
        elif meth == "textDocument/hover":
            p = m["params"]
            txt = docs.get(p["textDocument"]["uri"], "")
            ln = p["position"]["line"]
            lines = txt.split("\n")
            hv = (hover(lines[ln], _schema_keys(txt))
                  if 0 <= ln < len(lines) else None)
            _send({"jsonrpc": "2.0", "id": m.get("id"),
                   "result": ({"contents": {"kind": "markdown",
                                            "value": hv}} if hv else None)})
        elif m.get("id") is not None:
            _send({"jsonrpc": "2.0", "id": m["id"], "result": None})


def main():
    if len(sys.argv) > 2 and sys.argv[1] == "--check":
        text = open(sys.argv[2], encoding="utf-8", errors="replace").read()
        ds = validate(text)
        for d in ds:
            print("%s:%d: %s%s" % (
                sys.argv[2], d["range"]["start"]["line"] + 1,
                "" if d["severity"] == 1 else "[hint] ", d["message"]))
        sys.exit(1 if any(d["severity"] == 1 for d in ds) else 0)
    serve()


if __name__ == "__main__":
    main()
