# HXC — Hexa-Canonical Format (v2 spec, 2026-04-30)

> Standalone mirror of the canonical spec. Path references to `tool/`, `self/stdlib/`, anima docs, and hive convergence ledgers are provenance markers pointing to the original hexa-lang/anima/hive ecosystem where HXC was developed. The format itself is self-contained and fully described below.

Wire/storage format for AI-native pipelines. Sister of hexa-lang `.raw` (raw 2 self-format) — `.raw` is the SSOT-rule SPEC, HXC is the WIRE/STORAGE form for non-rule artifacts (JSONL ledgers, dispatch envelopes, witness rows). HXC is **NOT** a replacement for `.raw`; it is the format for *what currently is JSON/JSONL* in this repo.

Status: **live (v2)**. Promotion path: raw 92 (`format-ai-native-canonical`) + raw 137 (`format-compression-pareto-frontier-80pct-shannon`) + raw 157 (`hxc-wire-encoding-base85-mandate`).

v1 → v2 transition (r29 STRENGTHEN, 2026-04-30): algorithm catalog A1-A6 forward-spec → A4-A35 31 modules LIVE in hexa-lang stdlib (`self/stdlib/hxc_a*.hexa`); A9 RETIRED 2026-04-28; per-class reachability table added per raw 137 80% target empirical disambiguation.

## Why

Honest pilot measurements (cumulative 2026-04-26 → 2026-04-30):

| Pilot | Surface | Native → HXC | Saving | Status |
|---|---|---|---|---|
| A | `.raw` raw 86 section (already raw-canonical) | 6093B → 6078B | 0.25% | no-op (correct) |
| B | `state/atlas_convergence_witness.jsonl` (8 rows / 2 schemas) | 3002B → 2171B | 27.7% | A1+A2 baseline |
| r29-T1 | `state/init/audit.jsonl` (Class-T, schema-rich) | 48774B → 1595B | 96.73% | A1+A8+A4 chain |
| r29-T2 | `state/hive_cli_audit/audit.jsonl` (Class-T) | 122345B → 8840B | 92.77% | A1+A8 chain |
| r29-J1 | `state/raw_addition_requests/registry.jsonl` (Class-J large) | 128229B → 18049B | 85.92% | A1+A4+A12 chain |
| r29-M | `state/atlas_convergence_witness.jsonl` (Class-M, re-measured) | 3577B → 2516B | 29.66% | A1+A2 (no entropy coder fired) |

Conclusion: HXC delivers measurable wins **on JSON/JSONL surfaces with schema repetition**. On already-canonical `.raw` surfaces it is a no-op (correct — raw 2 already does the work). 80% target reachability per raw 137 is **content-class dependent** — see §Per-class reachability table below.

## Surfaces in scope

- `state/*/*.jsonl` — append-only ledgers (raw 77 audit ledger, raw 91 honesty triad audit, raw 88 transition gate, etc.)
- `state/design_strategy_trawl/*.json` — cycle-JSON artifacts
- `.hook-commands/active.json` — runtime invocation stack (raw 84 forward-spec)
- `state/blockers/*.json` payloads
- **Out of scope**: `.raw` `.own` `.roadmap` `.ext` `.guide` `.turn` `.end` `.command` — these are SSOT root files, raw 2 self-format already canonical.

## Form

HXC is line-oriented, byte-canonical, ASCII-stable. One record per line. Schema declared once per stream.

### Header lines

```
# schema:<id> <key1> <key2> ... <keyN>
```

- `<id>` is short hash or stable name (e.g. `s1`, `rawL0v1`, `auditv1`).
- Keys listed left-to-right define positional order for following rows.
- Multiple `# schema:` lines per stream are allowed (one per distinct schema).
- A header line may appear at any point; subsequent rows reference its `<id>` until a different `<id>` is referenced.

### Data lines

```
@<id> <v1>|<v2>|...|<vN>
```

- `@<id>` selects the schema declared above.
- Values are pipe-separated (`|`). Field count must equal schema's key count.
- Each value is the canonical scalar serialization:
  - strings: bare; if the value contains `|` `\n` or starts with `"`, escape as `"<json-escaped>"` (JSON string literal)
  - integers / floats: decimal; no leading `+`, no `e+`, no trailing zeros after `.`
  - booleans: `true` / `false`
  - null: `~`
  - arrays/objects: JSON-compact (`{"k":"v"}` / `[1,2,3]`) with sorted object keys

### Comment lines

- `#` at column 0 = comment, ignored by parser (except `# schema:` headers + algorithm headers per §Algorithm catalog).

### Streaming validity

- Every byte-prefix is a valid partial parse: complete records up to last `\n` are accepted; trailing partial line is buffered.
- Parser emits records as they close.

### Byte-canonical invariants (enforce by `tool/hxc_lint.hexa`)

1. UTF-8, no BOM.
2. LF line endings only (no CRLF).
3. No trailing whitespace on any line.
4. No leading whitespace on header / data lines (column 0 anchor).
5. Single trailing `\n` at EOF (one).
6. Object-value JSON sub-payloads: sorted keys; compact (`,` `:` separators, no spaces).
7. No blank lines inside a stream (stream end marked by EOF only).

These rules give: same logical content → byte-identical prefix → KV-cache prefill reuse on repeated context.

### Wire encoding (raw 157)

base85 raw printable ASCII (5/4 expansion, sigil-safe) — selected via raw 240 v2 weighted rubric across 3 wire candidates 2026-04-28 (Option A base64url 4/3 expansion REGRESSION on text / Option B base85 NET POSITIVE on n6 atlas / Option C per-bit binary REJECTED raw 92 ai-native-canonical violation). All entropy-coder outputs (A16/A17/A18/A19/A33/A34) wrap raw bytes in base85 to preserve byte-canonical invariants.

## Algorithm catalog (raw 93 algorithm-witness pairing)

31 algorithms LIVE in hexa-lang stdlib `self/stdlib/hxc_a*.hexa` as of 2026-04-30. raw 137 cmix-ban MAINTAINED across all entries (deterministic predictors only — no neural mixer, no LZMA dep, no online-learning).

### Structural family (Tier-A 80% target sufficient on Class-T)

| ID | Module | Role | Status |
|---|---|---|---|
| **A1** | (canonical re-pass) | bare structural / raw text passthrough | LIVE |
| **A2** | (byte-canonical) | no-spec-cost re-emit | LIVE — Pilot A 0.998 ratio |
| **A4** | hxc_a4_structural | tree-shape strip; `# tree:` / `# schema:` header | LIVE |
| **A5** | (streaming-prefix validity) | random-truncate parse rate | LIVE — 11/11 prefix-classes resumable |
| **A8** | hxc_a8_column_stat | per-column statistics encode-only | LIVE |
| **A11** | hxc_a11_cross_row_delta | per-(schema, column) delta encoding for monotonic columns; `# delta:` header | LIVE — projects +15-25pp on log corpora |
| **A12** | hxc_a12_column_prefix | column-prefix factoring; `# col-prefix:` header | LIVE |
| **A13** | hxc_a13_constant_column | constant-column elision; `# const:` header | LIVE |
| **A14** | hxc_a14_row_prefix | row-prefix factoring; `# row-prefix:` header | LIVE |
| **A15** | hxc_a15_nested_subschema | nested sub-schema; `# subschema:` header | LIVE |

### Tokenizer / dictionary family

| ID | Module | Role | Status |
|---|---|---|---|
| ~~A9~~ | hxc_a9_tokenizer | hexa-native BPE tokenizer | **RETIRED 2026-04-28** (F-A9-3 latency 46.4× ceiling + F-A9-5 chain-amortize 5/5 0pp delta fired) |
| **A19** | hxc_a19_cross_file_dict + hxc_a19_cross_file_fed | per-corpus shared-dict top-N tokens; `# hxc-shared-dict` header | LIVE |
| **A20** | hxc_a20_schema_aware_bpe | schema-key pre-seed + literal-residue BPE; **A9 successor** for text-heavy class | LIVE |
| **A33** | hxc_a33_cross_repo_dict | LZ77 256KB rolling ring buffer crossing file boundaries; sigil `^h`; PASS 4 BUILD measured 5MB stratified | LIVE |

### Entropy coder family (Tier-A 80% target on Class-J/M)

| ID | Module | Role | Status |
|---|---|---|---|
| **A7** | hxc_a7_shared_dict | shared-dictionary arithmetic coding; per-corpus column statistics + per-row range coder + base85 | LIVE |
| **A16** | hxc_a16_arithmetic_coder | order-0 byte-frequency arithmetic (range) coder; Witten-Neal-Cleary 1987 integer-only; `# arith:s` header | LIVE — 4/4 corpora measured, hive_triad_audit 77.32% chain saving |
| **A17** | hxc_a17_ppm_order3 | PPMd-style order-3 with escape-method-D fallback; `# ppm:` header | LIVE — 87% selftest on synthetic text |
| **A18** | hxc_a18_lz_ppm_order4 | LZ77 sliding-window + PPMd order-4 + 6 wire variants (v1/v2/v3-o2/v4-w64/v6-optimal) min-of-N; `# a18:s` header | LIVE — 22/22 selftest, AOT byte-eq |
| **A23** | hxc_a23_sparse_ppm | sparse-context PPMd | LIVE |
| **A26** | hxc_a26_escape_sweep / sparse_ppmd / v2_bounded / v3_inline | text-heavy specific sparse-context byte coder | LIVE (4 variants) |
| **A30** | hxc_a30_bwt_mtf | Burrows-Wheeler transform + MTF | LIVE |
| **A32** | hxc_a32_static_huffman | static Huffman | LIVE |
| **A34** | hxc_a34_sub_byte_arith | sub-byte (bit-stream) arithmetic + order-3 PPM-D escape chain; sigil `^l` | LIVE — v2 PASS 3 selftest |

### Source-transform family (pre-encode, axis-D)

| ID | Module | Role | Status |
|---|---|---|---|
| **A24** | hxc_a24_grammar_induction (+ v2_bounded) | corpus grammar induction PCFG-style + adaptive order-1 byte-context residual; sigil `^X` | LIVE (first-tick) |
| **A25** | hxc_a25_type_aware | type-aware encoding | LIVE |
| **A29** | hxc_a29_deflate | deflate-class | LIVE — anima 50.83% / n6 60.62% measured |
| **A35** | hxc_a35_source_transform | schema-aware column reorder (Stage 1) + integer delta varint (Stage 2) + dictionary tokenization (Stage 3); pre-A1-raw axis (raw 156 placement-orthogonality); sigil `^o` | LIVE — v2 Stage 1+2+3 ACTIVE |

### Self-decoding family

| ID | Module | Role | Status |
|---|---|---|---|
| **A22** | hxc_a22_self_decoding | self-decoding bootstrap parser | LIVE — Phase 11 P3 scaffold |

### Other

| ID | Module | Role | Status |
|---|---|---|---|
| **A10** | hxc_a10_varint | bit-packed varint (protobuf/leb128 zigzag); `# ints:` header | LIVE — projects +1-3pp integer-rich JSONL |

## Per-class reachability table (raw 137 80% target)

Per anima 2026-04-28 entropy_floor_measurement.jsonl + r29 hive cohort 2026-04-30 (cumulative empirical):

| Class | Description | Per-file Shannon floor (H_4) | 80% reachability | Required path | Status |
|---|---|---:|:---:|---|---|
| **T** | telemetry / audit-ledger schema-rich | 4.7-5.6 bit/byte | ✅ **VERIFIED** | A1 + A8 (column stat) + structural-family chain | hexa-lang 82% / airgenome 82% / hive 92.77-96.73% (≥80% on 10 cumulative files) |
| **J-large** | json-heavy ≥100KB | 5.1-5.7 bit/byte | ✅ **REACHABLE** | A1 + A4 + A12 + entropy coder (A16) | r29 raw_addition_requests 85.92% on 128KB |
| **J-small** | json-heavy <10KB single-file | 4.9-5.5 bit/byte | ⚠️ **MIXED** | A33 cross-repo dict federation (A19-fed amortizes header) | r29 discovery_absorption 41.77% / nexus_proposals 86 small +13.12pp via A19; break-even ~2353B/file |
| **M** | mixed code/data | 4.7-5.5 bit/byte | ⚠️ **GAP** | A17 PPMd order-3 + A34 sub-byte arith + base85 wire | r29 atlas_convergence 29.66% (Pilot B baseline 27.7% within 2pp); requires entropy coder activation |
| **X** | text-heavy prose (.md / .roadmap) | 4.4-5.5 bit/byte | ❌ **CARVE-OUT** | language-impossible at byte level (Indo-European structure floor); semantic-class re-spec required | anima alm_r13 24% / n6 papers 28-44%; **NOT a compression algorithm gap — semantic-class boundary** |
| **D** | degenerate small (<1KB) | n/a | ❌ **EXEMPT** | Shannon overhead exceeds payload; identity passthrough correct | r29 audit_escalation_pending 0% on 319B |

## Algorithm-witness pairing (raw 93)

Each algorithm declares (a) `measurement-axis` (b) `witness-path` (c) `falsifier-threshold`. Witnesses live under `state/format_witness/` (hive) and `anima/state/format_witness/` (cross-repo).

### A1+A2: Byte-canonical (no-spec-cost)

- Axis: byte count
- Witness: `tool/hxc_pilot.hexa` Pilot A
- Falsifier: HXC bytes > native bytes on already-canonical `.raw` (regression ban)
- 2026-04-26 result: 6078 / 6093 = **0.998** (passed; near-zero overhead)

### A1+A8 schema-hash + delta encoding

- Axis: byte count
- Witness: `tool/hxc_pilot.hexa` Pilot B + r29 cohort
- Falsifier: HXC bytes ≥ 0.85 × native bytes on a JSONL with ≥2 distinct schemas
- Result: 0.723 (atlas pilot B 27.7%) / 0.0327-0.0723 (r29 Class-T 92-97%)

### A5 Streaming-prefix validity

- Axis: random-truncate parse rate
- Witness: `tool/hxc_lint.hexa --stream-test`
- Falsifier: any byte-prefix yielding non-resumable parse state
- 2026-04-26 result: **11/11 prefix-classes resumable** on `state/format_witness/sample_v1.hxc`

### A33 Cross-repo dict (LZ77 256KB rolling)

- Axis: byte saving on multi-file SESSION (cross-file context)
- Witness: anima 2026-04-29 PASS 4 hash-chain measurement
- Falsifier: per-corpus saving < per-file equivalent (LZ77 chain ineffective)
- 2026-04-29 result: 5MB stratified MEASURED — 5/5 fixture selftest interp + AOT byte-identical

## Reader / writer reference

- Universal reader: `tool/hxc_consumer_adapter.hexa` (343 LoC, 12/12 selftest PASS, A1-A19 reverse-decode chain via subprocess dispatch)
- Encoder dispatcher: `hexa-lang self/stdlib/hxc_a*.hexa` (per-algorithm CLI: `--selftest` / `encode <in> <out>` / `decode <in> <out>` / `measure <in>`)
- Universal pilot: `tool/hxc_pilot.hexa` v1 (A1+A2 only — v2 full-chain wire-in deferred to r29 follow-up #2)

## Versioning

- v1 (2026-04-26 forward-spec): bytes-only canonical, schema-hash delta, optional JSON sub-payloads
- **v2 (this doc, 2026-04-30 LIVE)**: 31-algorithm catalog A4-A35; per-class reachability table; A9 RETIRED; raw 157 base85 wire mandate; raw 156 placement-orthogonality (pre-A1-raw / post-A1 / secondary-stacking / cross-file)
- v3 (future): per-class lint gating (r29 follow-up #3); encoder dispatcher unified surface; tokenizer-class A20 vocab persistence

## Cross-references

- raw 2 self-format — `.raw` SSOT format (HXC parent in spirit; HXC defers to raw 2 on `.raw`)
- raw 77 execution-audit-append-only-ledger — first migration target (JSONL ledger surface)
- raw 80 execution-sentinel-result-decoding — sub-tree dedup pairing
- raw 86 design-cost-attribution-required-forward-spec — same forward-spec promotion pattern
- raw 91 design-honesty-triad-process-quality — cycle-JSON measurement integrity gate
- raw 92 format-ai-native-canonical — HXC parent rule
- raw 93 algorithm-ai-native-required-witness — A* algorithm-witness pairing
- raw 137 format-compression-pareto-frontier-80pct-shannon — 80% target Pareto frontier (cmix-ban)
- raw 156 placement-orthogonality-mandate — axis (ii) placement
- raw 157 hxc-wire-encoding-base85-mandate — wire ceiling axis (i)
- raw 160 consumer-canary 7d
- raw 161 cross-file-shared-dictionary-cross-link
- nexus / airgenome (cross-repo drift) — adoption candidates for raw 92 contract
- anima `docs/hxc_physical_math_limit_saturation_20260427_landing.md` — parent ω-cycle (raw 72 tri-axis ceiling)
- anima `docs/hxc_a9_retirement_a20_priority_shift_20260428.md` — A9 retirement
- anima `state/format_witness/2026-04-28_anima_n6_entropy_floor_measurement.jsonl` — Class-X carve-out empirical anchor
- hive `convergence/r29_2026_04_30_raw_137_80pct_shannon_pareto_honest_c3.convergence` — r29 ledger
