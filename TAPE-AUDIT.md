# TAPE-AUDIT — hxc

`.tape` (agent-execution trace grammar) adoption audit. Read-only; no code changes.

## A. Audit-class ledgers

`hxc` is a **spec + reference algorithms + tooling** repo. The 31 `algorithms/hxc_a*.hexa` modules + 6 `tool/` reference utilities are the porting surface. No `state/` dir, no `*.jsonl`, no `*.marker` files committed — the repo does not itself run encoder pipelines. **However**, the spec (`spec/hxc.md`) cites concrete pilot runs ("r29-T1: `state/init/audit.jsonl` 48774B → 1595B 96.73% A1+A8+A4 chain", "r29-T2", "r29-J1", "r29-M", Pilot A/B) as evidence — and those pilot results live in the spec body as a table, not in a structured event ledger. Pilot results are DESIGN-grade SSOT, not CARGO.

## B. Identity surface

Empty `AGENTS.md` (zero bytes) + symlinked `CLAUDE.md`. No agent identity carried. No `identity.tape` opportunity.

## C. Domain.md files

Root: `README.md` only (plus AGENTS/CLAUDE empties). No `<UPPERCASE>(+<UPPERCASE>)*.md` domain convention. `docs/DESIGN.md` is a meta note about README decoration, not a project-domain SSOT. Nothing to sibling-pair as `<DOMAIN>.tape`.

## D. Per-run / per-event history

**The headline opportunity.** Every r29 pilot ("48774B → 1595B with A1+A8+A4 chain") is exactly the shape of a Class-T schema-repetitive event row: `@T r29_pilot_T1 :: input=state/init/audit.jsonl size_in=48774 size_out=1595 chain=A1+A8+A4 saving=96.73% -> verified [10*]`. The spec currently keeps a static table of ~6 pilot rows; a `pilots.tape` would (a) keep the chain append-only as new corpora are measured, (b) carry provenance edges (`<- a1, a8, a4`) tying each pilot to the algorithm modules that fired, (c) let the per-class reachability section auto-derive instead of being hand-curated. The historian role is wide open.

## E. Promotion candidates

- **n6 atoms** — pilot results that are saturating ("A1 baseline" / "A4 column-stat") can promote to `.n6` `@F` facts once the empirical floor stabilizes.
- **hxc (self-host)** — `pilots.tape` being Class-T (schema-rich) means it is hxc's own best customer; r29-T1 demonstrated 96.73% saving on exactly this shape.
- **n12 cells** — saving × class × algorithm-chain is a natural 3-axis cube slice; could feed n12 if a metric warehouse appears.

## Verdict

**MEDIUM** — no cargo and no identity, but a clean and high-signal `pilots.tape` Class-T opportunity that would (i) dogfood `.tape` and (ii) self-compress via hxc itself. Second-strongest dogfood case of the four siblings, behind hexa-lang.
