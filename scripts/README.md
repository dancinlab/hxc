# scripts

Maintenance scripts. Not part of the format — these regenerate auxiliary artifacts under `docs/`.

## `render_preview.mjs`

Generates `docs/preview.html` — a self-contained side-by-side rendering of every file in `examples/` using the TextMate grammar at `syntaxes/hxc.tmLanguage.json` with two themes (`github-dark` + `github-light`). Open the HTML in any browser; no editor or extension required.

### Run

```bash
npm install --no-save shiki
node scripts/render_preview.mjs
```

Output: `docs/preview.html` (~17 KB, self-contained except for inline CSS).

### When to regenerate

- After editing `syntaxes/hxc.tmLanguage.json`
- After adding or modifying files under `examples/`

The repo keeps a checked-in `docs/preview.html` so viewers don't need Node — but maintainers should re-run this after any grammar or example change so the checked-in HTML stays current.
