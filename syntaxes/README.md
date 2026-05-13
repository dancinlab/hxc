# HXC TextMate grammar

`hxc.tmLanguage.json` — token rules for `.hxc` files. Uses only standard TextMate scopes, so any published theme renders the format correctly without per-theme tuning.

## What it highlights

| Token | TextMate scope | Visual role |
|---|---|---|
| `# schema:<id> k1 k2 ...` | `keyword.control.schema` + `entity.name.type` + `variable.parameter` | Schema declaration header |
| `# tree:` / `# delta:` / `# col-prefix:` / etc. | `keyword.control.directive` | Algorithm-emitted directive header |
| `# ...` other | `comment.line.number-sign` | Plain comment |
| `@<id>` row prefix | `punctuation.definition.tag` + `entity.name.tag` | Schema reference |
| `"..."` quoted values | `string.quoted.double` | String scalar (with JSON escapes) |
| `~` | `constant.language.null` | Null |
| `true` / `false` | `constant.language.boolean` | Boolean |
| `123` / `-1.5` | `constant.numeric` | Number |
| `{...}` / `[...]` | `meta.structure.object` / `meta.structure.array` | JSON sub-payload |
| `\|` field separator | `punctuation.separator.pipe` | Field delimiter |

## Local use without a published extension

### VS Code (manual install)

1. Copy this directory to your VS Code user extensions folder:
   ```bash
   mkdir -p ~/.vscode/extensions/hxc-local
   cp -r syntaxes ~/.vscode/extensions/hxc-local/
   ```
2. Create `~/.vscode/extensions/hxc-local/package.json`:
   ```json
   {
     "name": "hxc-local",
     "version": "0.0.1",
     "engines": { "vscode": "^1.60.0" },
     "contributes": {
       "languages": [{ "id": "hxc", "extensions": [".hxc"] }],
       "grammars": [{
         "language": "hxc",
         "scopeName": "source.hxc",
         "path": "./syntaxes/hxc.tmLanguage.json"
       }]
     }
   }
   ```
3. Restart VS Code → `.hxc` files highlight automatically.

### Sublime Text

Convert to `.sublime-syntax` via [PackageDev](https://packagecontrol.io/packages/PackageDev), or load `.tmLanguage.json` directly into a package folder.

### TextMate / Atom

Drop `hxc.tmLanguage.json` into the bundle/grammars directory.

## Publishing to VS Code Marketplace

This grammar is publish-ready as a VS Code extension. To ship:

1. Scaffold `vscode-hxc/` separately with `package.json` + this grammar + `language-configuration.json`
2. `npm install -g @vscode/vsce`
3. `vsce package` → `.vsix`
4. `vsce publish` (requires Azure DevOps PAT, owner-only step)

See [`../docs/DESIGN.md` §6](../docs/DESIGN.md) for the full path including the long-term `github/linguist` registration.

## License

CC0-1.0 — free to copy into any extension/package.
