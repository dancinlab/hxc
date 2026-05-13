## Examples

| File | Demonstrates |
|---|---|
| `01_single_schema.hxc` | Minimal single-schema ledger — one `# schema:` header, three `@s1` rows |
| `02_multi_schema.hxc` | Two distinct schemas (`s1`, `s2`) interleaved in one stream |
| `03_tree_dedup.hxc` | `# tree:` sub-tree dedup headers (A4 algorithm) — large literal values factored out and referenced by hash |

All examples are valid HXC v2:

- UTF-8, no BOM
- LF line endings, single trailing `\n`
- No blank lines, no leading/trailing whitespace
- Schema headers at column 0; data rows prefixed with `@<id>`

See `../spec/hxc.md` for the full format spec.
