/**
 * tree-sitter grammar for .hxc (byte-canonical wire format).
 *
 * Total line model, no external scanner, no regex look-around. Every
 * line token requires a trailing newline → no zero-width token, the
 * top-level repeat always progresses. .hxc is line-oriented, column-0
 * anchored: `# schema:<id> ...` / `# comment` / `@<id> v1|v2|...`.
 * Exposes `schema_id` (data-row selector) + `comment` for highlights.
 */
module.exports = grammar({
  name: 'hxc',

  extras: $ => [],

  rules: {
    source_file: $ => repeat($._line),

    _line: $ => choice(
      $.blank,
      $.comment,
      $.data,
      $.text,
    ),

    blank: $ => token(prec(1, /[ \t]*\n/)),

    // `# schema:<id> ...` headers and plain `#` comments alike
    comment: $ => token(prec(5, /#[^\n]*\n/)),

    // `@<schema-id> v1|v2|...|vN`
    data: $ => seq($.schema_id, $._rest),

    schema_id: $ => token(prec(4, /@[^ \t\n|]+/)),

    _rest: $ => token(prec(1, /[^\n]*\n/)),

    text: $ => token(prec(0, /[^#@\n][^\n]*\n/)),
  },
});
