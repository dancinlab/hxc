#!/usr/bin/env tape
# ══════════════════════════════════════════════════════════════════════
# .tape v1.2 — grammar primer (cold-read by any LLM / agent / human)
# ══════════════════════════════════════════════════════════════════════
# Form: each entry is `@<type> <id> := "<subject>" :: <kind> [<grades>]`
#       optionally followed by body lines (2-space indent) — key=value,
#       edges (<- -> => …), or quoted prose.
#
# ENTRY TYPES (17):
#   Runtime (10): @S session  @U user  @A assistant  @T tool-call  @R result
#                 @H hook  @D decision  @K cost  @P provider  @? anomaly
#   Foundation:   @I identity-claim
#   Declarative:  @X external-citation  @F forbidden-pattern  @N note
#                 @C config  @L layout  @V spec-version
#
# EDGES (12, on body lines, 2-space indent):
#   Causal:     <- caused-by   -> triggers   == continues
#               ~> supersedes  !! aborts     |> verified-by
#   Effect:     => produces (followed by quoted natural-language)
#   Structural: <: specializes  :> generalizes  ?> soft-depends
#               !> conflicts-with  @> projects-to (e.g. @> AGENTS.md)
#
# GRADE TAGS (in [...] on entry header):
#   Delivery:   ok · err · denied · cancelled · partial · superseded
#   Governance: required · recommended · optional · draft · active · deprecated
#   Scoped:     allow:<x> · deny:<x>
#   Time/index: T<n> (turn)  N<n> (wall-sec)  d=<YYYY-MM-DD>
#
# PAYLOAD SYNTAX (body lines):
#   key = "value"           single-line string
#   key = [a, b, c]         array literal
#   key <<~EOF              heredoc (multi-line; ends with EOF on own line)
#     multi-line text
#   EOF
#   "see [@x1] §3"          inline citation by entry id
#   `cmd or path`           backtick code-span (inline only)
#
# Full spec: ~/core/tape/spec/tape.md (or github.com/dancinlab/tape)
# ══════════════════════════════════════════════════════════════════════
#
# AGENTS.tape for `dancinlab/hxc` — Hexa-Canonical Format
# byte-canonical wire · KV-cache stable · cross-host ship

# ─── §1 Spec version ──────────────────────────────────────────────────

@V := "tape" :: spec [active]
  version = "1.2"
  uses = [@I, @D, @F, @X, @L, @H, @C, @N, "<:", "@>", "[required]", "[deny:write]"]
  primer = "see top-of-file 35-line comment block"

@X hexa_verify := "hexa verify — verification via hexa CLI only" :: guide [active]
  tldr = "Any correctness / purity / grade / identity claim → verify with `hexa <verb>` or `hexa run <verifier>.hexa` (e.g. `hexa run tool/atlas_verify.hexa`) and paste the verdict VERBATIM. NEVER cite sympy / PyPhi / Wolfram / Mathematica output as evidence."
  detail = "~/core/atlas/VERIFY.tape"

@X wilson_pool := "wilson pool — resource utilization" :: guide [active]
  tldr = "Heavy / deterministic work (build · drill · probe · compile · test-sweep · GPU fire) → do NOT serialize on localhost; route to the host pool: `wilson pool list` then `wilson pool on <host> <cmd>`, or a ToolUse `\"host\"` field. Empty roster = degrade-to-local, fine."
  detail = "~/core/atlas/POOL.tape"

# ─── §2 Identity claims (what hxc IS) ─────────────────────────────────

@I id001 := "hxc" :: identity-claim [d=2026-05-14 active]
  kind = "byte-canonical wire format — HXC v2 · KV-cache stable · cross-host ship"
  brief = "byte-canonical wire · HXC v2 · KV-cache stable · cross-host ship"
  tagline = "Hexa-Canonical Format · line-oriented · ASCII-stable · KV-cache friendly"
  axis = "wire/storage format for AI-native pipelines · repeated-context prefill reuse"
  algorithms = "31 deterministic algorithms (A1-A35) · cmix-ban invariant · no neural mixers"
  parent = "dancinlab"

@I id002 := "hxc.sibling-role" :: identity-claim [d=2026-05-14 active]
  <: id001
  role = "the byte/wire layer of the 4-sibling format quartet"
  siblings <<~EOF
    n6   — semantic atlas (typed verified atoms · grade ladder · `*` / `!` / `?` markers)
    hxc  — byte-canonical wire (THIS · HXC v2 · KV-cache stable · cross-host ship)
    n12  — 12-axis sparse cube
    tape — agent-execution trace (this file's source format)
  EOF
  orthogonality = "each format occupies an orthogonal placement; hxc owns the bytes-on-the-wire axis"

# ─── §3 Repo layout ───────────────────────────────────────────────────

@L l1 := "repo-layout" :: structure [active]
  README.md -> "human intro · at-a-glance · honest pilot measurements"
  AGENTS.tape -> "this file · governance + identity (.tape v1.2)"
  CLAUDE.md -> "symlink → AGENTS.tape (Claude Code auto-discovery)"
  LICENSE -> "CC0-1.0 · public domain"
  TAPE-AUDIT.md -> ".tape v1.1 adoption audit"
  spec/hxc.md -> "full v2 spec · per-class reachability table"
  algorithms/ -> "31 deterministic algorithms (A1-A35) · README.md catalog"
  examples/ -> "HXC sample rows · class-T / class-J / class-M surfaces"
  scripts/ -> "encode/decode helpers"
  docs/ -> "DESIGN.md · INDEX.md · logo.svg · preview-{dark,light}.svg"
  syntaxes/ -> "editor syntax highlighting"
  tool/ -> "tooling support"

# ─── §4 Governance — inherited lattice policy ─────────────────────────

@D g_inherit := "inherits-lattice-policy" :: governance [required]
  rule = "All echoes/LATTICE_POLICY.md rules apply — real-limits-first · lattice-is-tool · verification-anchor-real-limit · no-artificial-ceilings · honesty-obligation-external."
  authority = "[@x_lattice_policy]"
  @> AGENTS.md

@D g1 := "real-limits-first" :: governance [required]
  rule = "The format's ceiling is set by REAL information-theoretic limits (entropy floor · class reachability), NEVER by the n=6 invariant lattice."
  authority = "[@x_lattice_policy]"
  proof = "see spec/hxc.md §Per-class reachability — honest measurements, not lattice-derived"
  @> AGENTS.md

@D g2 := "lattice-is-tool" :: governance [required]
  rule = "n=6 lattice is a TOOL, not a CONSTRAINT. Algorithm count (31 / A1-A35) is set by what works, not by lattice fit."
  <: g1
  @> AGENTS.md

@D g3 := "honesty-obligation-external" :: governance [required deny:write]
  rule = "Claims about external entities (compression libs · model vendors · standards bodies) must NOT include lattice-fit assertions. Use their OWN invariants."
  @> AGENTS.md

@D g4 := "commit-conventions" :: governance [recommended]
  rule = "AI-assisted commits include `Co-Authored-By: <model> <noreply@anthropic.com>` trailer; Conventional Commits title (`feat:`/`fix:`/`docs:`/`agents:`)."
  @> AGENTS.md

# ─── §5 Governance — hxc-native byte-canonical rule ───────────────────

@D g_byte_canonical := "byte-canonical-wire" :: governance [required]
  rule = "byte-canonical wire: UTF-8 · LF only · no BOM · single trailing newline · deterministic ordering. KV-cache stable means hash-bit-identical across hosts."
  applies-to <<~EOF
    All .hxc payloads (data rows · schema declarations · multi-rule envelopes)
    Encoder output (must be reproducible from input bytes alone)
    Cross-host ship semantics (identical bytes → identical KV-cache prefix → prefill reuse)
  EOF
  why = "the format's whole value proposition collapses if two hosts emit different bytes for the same logical content"
  proof = "see [@x_self_spec] §Byte-canonical guarantees"
  @> AGENTS.md

@D g_arch_vs_log_split := "v1.2 architecture-vs-history split" :: governance [required d=2026-05-14 active]
  rule = "UPPERCASE.tape files are EDITABLE architecture (latest-wins per id). Append-only event history lives in UPPERCASE.log.tape siblings."
  why = "declarative entries (governance · config · layout · identity) evolve naturally; locking them as append-only via ~> supersedes creates noisy histories. The split lets architecture stay current and history stay immutable."
  applies-to = "AGENTS.tape · all UPPERCASE.tape root files"
  authority = "[@x_tape_spec] §Domain-tape sibling §Architecture-vs-history split"
  @> AGENTS.md


# ─── §6 Forbidden patterns ────────────────────────────────────────────

@F f1 := "lattice-fit-on-external-entity" :: governance [required deny:write]
  pattern = "applying n=6 lattice as derivation rule to TSMC · ASML · IPCC · NASA · SpaceX · CERN · DeepMind · NIST · or any external vendor / standards body"
  exception = "values may coincidentally match — observation OK, derivation NOT OK"
  authority = "[@x_lattice_policy] §1.2/§1.3"

@F f2 := "non-canonical-bytes" :: governance [required deny:write]
  pattern = "emitting .hxc with CRLF · BOM · trailing-whitespace · unsorted JSON object keys · or any byte sequence not bit-identical to canonical encoder output"
  why = "violates byte-canonical wire invariant (g_byte_canonical) — breaks KV-cache stability and cross-host ship guarantees"
  remedy = "always round-trip through the canonical encoder; lint via `scripts/` before commit"
  authority = "[@x_self_spec] §Byte-canonical guarantees"

# ─── §7 External citations ────────────────────────────────────────────

@X x_lattice_policy := "echoes/LATTICE_POLICY.md" :: policy [d=2026-05-12 active]
  url = "https://github.com/dancinlab/echoes/blob/main/LATTICE_POLICY.md"

@X x_tape_spec := "tape v1.2 spec" :: spec [d=2026-05-14 active]
  url = "https://github.com/dancinlab/tape/blob/main/spec/tape.md"
  scope = "this file's grammar reference · 17 entry types · 12 edges · grade tags · payload syntax"

@X x_self_spec := "hxc v2 spec" :: spec [d=2026-04-30 active]
  url = "https://github.com/dancinlab/hxc/blob/main/spec/hxc.md"
  scope = "HXC v2 byte-canonical wire format · per-class reachability · 31-algorithm catalog"

@X x_siblings := "sibling-format quartet" :: cross-ref [active]
  n6 = "https://github.com/dancinlab/n6"
  hxc = "https://github.com/dancinlab/hxc"
  n12 = "https://github.com/dancinlab/n12"
  tape = "https://github.com/dancinlab/tape"
  scope = "4 directly-orthogonal sister formats — n6 (semantic atlas) · hxc (byte wire · THIS) · n12 (12-axis cube) · tape (execution trace)"

# ─── §8 Generator hooks ───────────────────────────────────────────────

@H h1 := "agents-md-replaced" :: generator [active]
  note = "AGENTS.md replaced by this AGENTS.tape (tape v1.2) — AGENTS.tape is SSOT"
  consumer = "agents.md ecosystem tooling that doesn't speak .tape yet falls back to README.md"

@H h2 := "claude-md-symlink" :: generator [active]
  rule = "CLAUDE.md → AGENTS.tape symlink ships so Claude Code auto-discovery picks up the grammar primer first"
  command = `ln -sf AGENTS.tape CLAUDE.md`
