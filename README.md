<p align="center">
  <img src="docs/logo.svg" width="140" alt="hxc">
</p>

<h1 align="center">⬡ hxc</h1>

<p align="center"><strong>Hexa-Canonical Format</strong> — a wire/storage format for AI-native pipelines</p>

<p align="center">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-CC0--1.0-blue"></a>
  <a href=".github/workflows/lint.yml"><img alt="CI" src="https://github.com/dancinlab/hxc/actions/workflows/lint.yml/badge.svg"></a>
  <img alt="Spec" src="https://img.shields.io/badge/spec-v2-success">
  <img alt="Status" src="https://img.shields.io/badge/status-live-success">
  <img alt="Algorithms" src="https://img.shields.io/badge/algorithms-31-informational">
</p>

<p align="center">Line-oriented · byte-canonical · ASCII-stable · KV-cache friendly</p>

---

HXC is what JSON/JSONL looks like when you optimize for *repeated AI context* instead of human eyeballs: schemas declared once, values pipe-separated, same logical content → byte-identical prefix → prefill reuse.

> [!NOTE]
> HXC is **not** a replacement for hexa-lang's `.raw` (SSOT-rule format). HXC is the wire form for *what currently is JSON / JSONL* — ledgers, dispatch envelopes, witness rows. The two are sister formats with disjoint scopes.

## At a glance

```yaml
# HXC sample — yaml fence used for color approximation only;
# `.hxc` is not yet a registered GitHub Linguist language.
# schema:s1 ts action balance_usd delta_usd
@s1 "2026-04-22T16:03:14Z"|"session"|"135.842"|"0.0000"
@s1 "2026-04-22T16:10:25Z"|"session"|"135.842"|"0.0000"
@s1 "2026-04-22T17:01:08Z"|"session"|"136.110"|"0.2680"
```

- `# schema:<id> k1 k2 ...` declares a positional schema.
- `@<id> v1|v2|...` is a data row referencing it.
- `~` = null. Object/array values → JSON-compact with sorted keys.
- UTF-8, no BOM, LF only, single trailing `\n`.

See [`examples/`](examples/) for more, [`spec/hxc.md`](spec/hxc.md) for the full v2 spec.

## Why HXC

Honest pilot measurements on representative JSONL/JSON surfaces:

| Surface class | Native → HXC | Saving |
|---|---|---|
| Audit ledger (Class-T, schema-rich) | 48,774 B → 1,595 B | **96.73%** |
| Large JSON registry (Class-J ≥100KB) | 128,229 B → 18,049 B | **85.92%** |
| Atlas witness (Class-M mixed) | 3,002 B → 2,171 B | 27.7% |
| Already-canonical raw text | 6,093 B → 6,078 B | 0.25% (no-op) |

> [!TIP]
> HXC delivers measurable wins **on JSON/JSONL surfaces with schema repetition**. On already-canonical text it is a near-no-op (correct — nothing to compress). On text-heavy prose it is a deliberate carve-out: a byte-level compression algorithm cannot fight Indo-European semantic floor. See [`spec/hxc.md` §Per-class reachability](spec/hxc.md).

## Algorithm catalog

31 deterministic algorithms (A1–A35) — no neural mixers, no LZMA dep, no online learning. Every algorithm is reproducible from input bytes alone.

Full module list → [`algorithms/README.md`](algorithms/README.md).

> [!IMPORTANT]
> All algorithms maintain the `raw 137 cmix-ban` invariant — deterministic predictors only. This makes encoder output reproducible across machines and forbids neural-mixer dependencies that would compromise the format's portability.

## Status

- **v2 live** (2026-04-30) — 31-algorithm catalog, base85 wire encoding, per-class reachability table
- **mk2 dogfooded** (2026-05-02) — `core/hxc_format/` plug-in module with `HXC2` magic, multi-rule indexed
- **v3 planned** — per-class lint gating, unified encoder dispatcher

## License

[CC0-1.0](LICENSE) — public domain. Use freely.

## Repo layout

```
hxc/
├── README.md         this file
├── LICENSE           CC0-1.0
├── spec/
│   └── hxc.md        canonical v2 spec
├── examples/         valid .hxc samples
├── algorithms/       A1–A35 stdlib mirror (34 .hexa modules)
├── tool/             encoder/decoder/lint references
├── syntaxes/
│   └── hxc.tmLanguage.json    TextMate grammar (theme-agnostic)
├── docs/
│   ├── INDEX.md      doc index
│   ├── DESIGN.md     README design notes + syntax-highlighting path
│   └── logo.svg      hexagon mark
└── .github/workflows/
    └── lint.yml      byte-canonical invariant CI
```

## Editor support

`.hxc` is not yet a registered language on [github/linguist](https://github.com/github-linguist/linguist), so GitHub does not natively highlight `.hxc` fences. The repo ships a TextMate grammar that any modern editor can load — see [`syntaxes/README.md`](syntaxes/README.md) for VS Code / Sublime / TextMate install steps. Roadmap to upstream registration is in [`docs/DESIGN.md` §6](docs/DESIGN.md).

### Live preview

Inline below — GitHub auto-switches between `github-dark` and `github-light` to match your theme. Rendered with [shiki](https://shiki.style/) from the shipped grammar.

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="docs/preview-dark.svg">
  <img alt="hxc syntax preview (examples/*.hxc rendered with github theme)" src="docs/preview-light.svg">
</picture>

Browser-only view (side-by-side both themes, larger): [`docs/preview.html`](docs/preview.html). Regenerate either after grammar/example changes — see [`scripts/README.md`](scripts/README.md).
