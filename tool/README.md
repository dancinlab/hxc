# HXC tools

Reference encoder/decoder/lint utilities. Mirrored from `anima/tool/` and `hive/tool/`. Written in [hexa-lang](https://github.com/dancinlab/hexa-fusion) — require the hexa-lang interpreter to execute.

| File | Role |
|---|---|
| `hxc_consumer_adapter.hexa` | Universal reader — A1–A19 reverse-decode chain via subprocess dispatch |
| `hxc_d1_canary_watcher.hexa` | Deploy D1 canary watcher (consumer-side health monitoring) |
| `hxc_pre_encoder.hexa` | Pre-encode source-transform dispatcher |
| `hxc_composite_chain.hexa` | Composite algorithm chain (multi-stage encode/decode) |
| `hxc_composite_dispatcher.hexa` | Composite chain dispatcher |
| `hxc_corpus_manifest.hexa` | Corpus manifest generator (per-file measurement registry) |

## Usage shape

```
hxc_<tool>.hexa --selftest                    # built-in test suite
hxc_<tool>.hexa encode <input.jsonl> <out.hxc>
hxc_<tool>.hexa decode <input.hxc>  <out.jsonl>
hxc_<tool>.hexa measure <input>               # byte-saving report
```

Selftest is the first thing to run after porting — every module ships with a fixture-based round-trip verifier.

## Porting

These references are intentionally readable: each `.hexa` module declares its algorithm structure in plain code. To port to Python / Go / Rust / etc., read the encode/decode pair top-to-bottom and reimplement against the same fixture I/O contract. The byte-canonical invariants in [`../spec/hxc.md`](../spec/hxc.md) define correctness.
