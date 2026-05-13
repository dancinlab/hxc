# HXC Documentation Index

## Format

- [`spec/hxc.md`](../spec/hxc.md) — canonical v2 spec (header form, data form, byte-canonical invariants, base85 wire encoding)

## Examples

- [`examples/01_single_schema.hxc`](../examples/01_single_schema.hxc) — minimal single-schema ledger
- [`examples/02_multi_schema.hxc`](../examples/02_multi_schema.hxc) — multi-schema interleaved stream
- [`examples/03_tree_dedup.hxc`](../examples/03_tree_dedup.hxc) — `# tree:` sub-tree dedup (A4)

## Algorithm catalog (planned mirrors)

The full algorithm catalog A1–A35 lives in the upstream `hexa-lang/self/stdlib/hxc_a*.hexa`. A standalone mirror under `algorithms/` is planned (see repo TODO).

Families covered:

| Family | Algorithms |
|---|---|
| Structural | A1, A2, A4, A5, A8, A11, A12, A13, A14, A15 |
| Tokenizer / Dict | A19, A20, A33 (A9 retired 2026-04-28) |
| Entropy coder | A7, A16, A17, A18, A23, A26, A30, A32, A34 |
| Source-transform | A24, A25, A29, A35 |
| Self-decoding | A22 |
| Other | A10 (varint) |

## Reachability (raw 137 80% target)

| Class | Description | 80% reachable? |
|---|---|---|
| T | telemetry / audit ledger | verified |
| J-large | JSON ≥100KB | reachable |
| J-small | JSON <10KB | mixed |
| M | code/data mix | gap |
| X | text-heavy prose | carve-out (semantic-class boundary) |
| D | <1KB degenerate | exempt |

## Tools (planned mirrors)

- `tool/hxc_consumer_adapter.hexa` — universal reader
- `tool/hxc_pilot.hexa` — measurement pilot
- `tool/hxc_lint.hexa` — byte-canonical invariant linter

These currently live in the upstream hexa-lang/anima/hive ecosystem.

## Status

- v1: 2026-04-26 forward-spec
- v2: 2026-04-30 live (31-algorithm catalog, base85 wire mandate, per-class reachability)
- mk2 dogfooding: 2026-05-02 (hive `core/hxc_format/` + `modules/hxc_format/{v1,v2,v3}`)
- v3: future (per-class lint gating, encoder dispatcher unified surface, tokenizer-class vocab persistence)
