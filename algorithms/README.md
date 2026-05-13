# Algorithm catalog — A1 to A35

31 deterministic algorithms covering the HXC compression chain. All are pure functions of input bytes — no neural mixers, no LZMA dependency, no online learning. Each algorithm declares an axis, a witness path, and a falsifier threshold (see [`../spec/hxc.md` §Algorithm-witness pairing](../spec/hxc.md)).

## Provenance

These `.hexa` files are mirrored from `hexa-lang/self/stdlib/`. They are written in [hexa-lang](https://github.com/dancinlab/hexa-fusion) and require the hexa-lang interpreter to execute. They are kept here as the reference encoder/decoder source — port to other languages by reading the algorithm structure declared in each file.

Each module exposes a CLI surface:

```
hxc_a<N>_<name>.hexa --selftest
hxc_a<N>_<name>.hexa encode <input> <output>
hxc_a<N>_<name>.hexa decode <input> <output>
hxc_a<N>_<name>.hexa measure <input>
```

## Families

### Structural (Tier-A 80% target sufficient on Class-T)

| ID | Module | Role |
|---|---|---|
| A4 | `hxc_a4_structural.hexa` | tree-shape strip; `# tree:` / `# schema:` header |
| A8 | `hxc_a8_column_stat.hexa` | per-column statistics encode |
| A11 | `hxc_a11_cross_row_delta.hexa` | per-(schema, column) delta encoding for monotonic columns |
| A12 | `hxc_a12_column_prefix.hexa` | column-prefix factoring; `# col-prefix:` header |
| A13 | `hxc_a13_constant_column.hexa` | constant-column elision; `# const:` header |
| A14 | `hxc_a14_row_prefix.hexa` | row-prefix factoring; `# row-prefix:` header |
| A15 | `hxc_a15_nested_subschema.hexa` | nested sub-schema; `# subschema:` header |

A1, A2, A5 are inherent to the byte-canonical form itself and have no separate module.

### Tokenizer / dictionary

| ID | Module | Role |
|---|---|---|
| A9 | `hxc_a9_tokenizer.hexa` | hexa-native BPE — **RETIRED 2026-04-28** (kept for reference) |
| A19 | `hxc_a19_cross_file_dict.hexa` + `hxc_a19_cross_file_fed.hexa` | per-corpus shared-dict top-N tokens |
| A20 | `hxc_a20_schema_aware_bpe.hexa` | schema-key pre-seed + literal-residue BPE (A9 successor) |
| A33 | `hxc_a33_cross_repo_dict.hexa` | LZ77 256KB rolling ring buffer crossing file boundaries |

### Entropy coder (Tier-A 80% target on Class-J/M)

| ID | Module | Role |
|---|---|---|
| A7 | `hxc_a7_shared_dict.hexa` | shared-dictionary arithmetic coding |
| A16 | `hxc_a16_arithmetic_coder.hexa` | order-0 byte-frequency arithmetic (range) coder; Witten-Neal-Cleary 1987 |
| A17 | `hxc_a17_ppm_order3.hexa` | PPMd-style order-3 with escape-method-D fallback |
| A18 | `hxc_a18_lz_ppm_order4.hexa` | LZ77 sliding-window + PPMd order-4 + 6 wire variants min-of-N |
| A23 | `hxc_a23_sparse_ppm.hexa` | sparse-context PPMd |
| A26 | `hxc_a26_escape_sweep.hexa`, `hxc_a26_sparse_ppmd.hexa`, `hxc_a26_v2_bounded.hexa`, `hxc_a26_v3_inline.hexa` | text-heavy sparse-context byte coder (4 variants) |
| A30 | `hxc_a30_bwt_mtf.hexa` | Burrows-Wheeler transform + MTF |
| A32 | `hxc_a32_static_huffman.hexa` | static Huffman |
| A34 | `hxc_a34_sub_byte_arith.hexa` | sub-byte (bit-stream) arithmetic + order-3 PPM-D escape chain |

### Source-transform (pre-encode)

| ID | Module | Role |
|---|---|---|
| A24 | `hxc_a24_grammar_induction.hexa` + `hxc_a24_v2_bounded.hexa` | corpus grammar induction PCFG-style + adaptive order-1 byte-context residual |
| A25 | `hxc_a25_type_aware.hexa` | type-aware dispatch (umbrella over a18/a23/a29/a30/a33/a34/a35) |
| A29 | `hxc_a29_deflate.hexa` | deflate-class |
| A35 | `hxc_a35_source_transform.hexa` | schema-aware column reorder + integer delta varint + dictionary tokenization |

### Self-decoding

| ID | Module | Role |
|---|---|---|
| A22 | `hxc_a22_self_decoding.hexa` | self-decoding bootstrap parser |

### Other

| ID | Module | Role |
|---|---|---|
| A10 | `hxc_a10_varint.hexa` | bit-packed varint (protobuf/leb128 zigzag) |

### Wire / composite

| Module | Role |
|---|---|
| `hxc_base94_codec.hexa` | base85/base94 wire codec |
| `hxc_composite_chain.hexa`, `hxc_composite_chain_v2.hexa` | composite algorithm chain dispatch |

## Status

31 LIVE / A9 RETIRED. raw 137 cmix-ban maintained across all entries.
