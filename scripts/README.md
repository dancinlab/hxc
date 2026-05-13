# scripts

Maintenance scripts. Not part of the format — these regenerate auxiliary artifacts under `docs/`.

## `render_preview.mjs` — browser HTML preview

Generates `docs/preview.html` — a self-contained side-by-side rendering of every file in `examples/` using the TextMate grammar at `syntaxes/hxc.tmLanguage.json` with two themes (`github-dark` + `github-light`). Open the HTML in any browser; no editor or extension required.

```bash
npm install --no-save shiki
node scripts/render_preview.mjs
```

Output: `docs/preview.html` (~17 KB).

## `render_svg.mjs` — README-embeddable SVG previews

Generates `docs/preview-dark.svg` + `docs/preview-light.svg` — two self-contained SVG renderings (one per theme) using shiki's `codeToTokens` to emit `<tspan fill="...">` per token. These are embedded in the root `README.md` via a `<picture>` element so GitHub auto-switches them to match the viewer's dark/light mode.

```bash
npm install --no-save shiki
node scripts/render_svg.mjs
```

Output: `docs/preview-dark.svg` + `docs/preview-light.svg` (~10 KB each).

## When to regenerate

- After editing `syntaxes/hxc.tmLanguage.json`
- After adding or modifying files under `examples/`

Re-run **both** scripts so the checked-in HTML and SVGs stay current with the grammar.
