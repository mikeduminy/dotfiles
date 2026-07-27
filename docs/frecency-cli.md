# Extract a reusable `frecency` CLI

## Context

`tmux/select-project` grew inline frecency logic (load TSV → score by count×recency →
sort → write back on pick). That logic is generic and wanted in more places
(session picker, worktree picker, interactive use) over more datasets. Bespoke
copies would drift. Extract it into one well-formed CLI that any script can drive as
a unix filter, keyed per **dataset**. Scope now: build the CLI + migrate
`select-project` onto it (no other consumers wired yet).

## Design

### The CLI: `bin/frecency` (zsh)
New file `~/.xdg/config/bin/frecency`. Store per dataset:
`${XDG_DATA_HOME:-$HOME/.local/share}/frecency/<dataset>.tsv`
(`XDG_DATA_HOME` = `~/.xdg/data` here), lines `key<TAB>count<TAB>last_epoch`.
Keys are opaque strings (no tabs); line == key, so it composes as a plain filter.

Subcommands (`frecency <dataset> <cmd> [args]`):
- `add <key>` — increment count, set last=now; atomic rewrite (temp + `mv`); `mkdir -p` store dir.
- `rank` — read candidate keys from stdin (one/line), print them reordered:
  highest frecency first, unknown keys → score 0 sorted last, alpha tiebreak.
  Preserves input strings verbatim. This is the reusable primitive.
- `list` — print `score<TAB>key` for all stored keys, desc (debug/inspection).
- `delete <key>` — drop an entry (pruning).
- no/unknown args or bad dataset (`[A-Za-z0-9._-]+` only) → usage on stderr, exit 2.

Scoring (shared internal fn, same integer scheme as current script):
age = now−last → ×16 (<1h), ×8 (<1d), ×2 (<1w), ×1 (older); score = count×mult;
count 0 ⇒ score 0.

`rank` impl: load store into assoc arrays, for each stdin line emit `score\tline`,
`sort -t$'\t' -k1,1rn -k2,2 | cut -f2-`.

### Make it a real CLI
Symlink `~/.local/bin/frecency -> ~/.xdg/config/bin/frecency` (that dir is on PATH,
zshrc:94, and already holds a symlinked tool `codex`). So both `frecency ...` and an
absolute-path call work.

### Migrate `tmux/select-project`
Strip the inline frecency block (state file read, per-folder scoring, write-back).
Replace with the CLI as filter, dataset **`projects`**, key = `short_folder`:
- rank:  `... | printf lines | frecency projects rank | fzf-tmux --reverse ... --tiebreak=index`
- record: on selection, `frecency projects add "$selected_folder"`
Call the CLI by absolute path (`${0:h}/../bin/frecency`) so it works under tmux
`run-shell` regardless of PATH. Net: script goes back to ~its pre-frecency shape plus
two CLI calls; scoring lives in one place.

Note: store path moves `tmux/project-frecency` → `frecency/projects.tsv`. The old
file has 1 trivial entry; leave it (harmless) — history rebuilds on use.

## Critical files
- New: `bin/frecency` — the CLI (all scoring/storage logic).
- New symlink: `~/.local/bin/frecency`.
- Edit: `tmux/select-project` — delegate to CLI, remove inline frecency code.

## Verification
1. **CLI unit** (temp store): `frecency proj add foo` ×N, `frecency proj add bar`;
   `printf 'bar\nfoo\nbaz\n' | frecency proj rank` → `foo` then `bar` then unknown
   `baz`; `list` shows scores; `delete foo` removes it. Bad dataset / missing args → exit 2.
2. **Recency**: hand-write TSV old vs fresh timestamp, confirm fresh outranks stale.
3. **zsh -n** both files; run CLI with `zsh -f` (clean env) to catch env assumptions.
4. **Integration**: stub `fzf-tmux`/`tmux` on PATH, `PROJECT_ROOTS` → temp dirs, run
   `select-project`; pick writes via CLI to `frecency/projects.tsv`, reordering takes
   effect next run.
5. Cancel path (fzf exit≠0) writes nothing. Fresh/no store → alpha order, no error.
