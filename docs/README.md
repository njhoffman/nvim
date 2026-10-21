# docs

Reference material for this config: notes, specs and code worth keeping to read, not to load.
Nothing under `docs/` is on the runtimepath. Vim help files (`:help` tags) stay in `doc/`.

- [specs/](specs/): designs for work not yet built.
  - [dashboard.md](specs/dashboard.md): in-repo replacement for alpha-nvim (TODO.md project 4).
- [reference/](reference/): records of finished work and code kept for reference.
  - [deprecated-apis.md](reference/deprecated-apis.md): the v0.13.0 - v0.14.0 deprecated API
    migration and what was left upstream.
  - [hlslens-templating.md](reference/hlslens-templating.md): lens templating draft for the
    nvim-hlslens fork.

Adding reference code: put it in `reference/<topic>.md` (or `reference/<topic>/` for several
files), one fenced block per snippet with a one-line description above it, and link it here.
