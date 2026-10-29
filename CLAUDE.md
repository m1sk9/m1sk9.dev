# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal site and blog (https://m1sk9.dev) built with Zola. The Serene theme is **vendored** at the repository root (`templates/`, `sass/`, `static/`) — there is no `themes/` directory or submodule, and upstream is not tracked. Edit theme files directly; the upstream MIT license lives in `LICENSES/serene.LICENSE`.

## Commands

Zola version is pinned in `mise.toml` (CI uses `jdx/mise-action`).

```sh
mise install          # install the pinned Zola
zola serve            # dev server with live reload
zola build            # build into build/ (output_dir in config.toml)
zola check            # build + validate external links
./x <slug> [category] # scaffold content/posts/<slug>/index.md from _template.md
```

There is no test suite. CI (`.github/workflows/ci.yaml`) runs `zola build`, then validates the Discord component embed JSON on `/`, `/posts/`, and `/pythia/` (must exist, `.component.type == 17`, ≤ 3000 bytes). Re-run that check locally after touching `templates/_head_extend.html` or `templates/discord_embed/`.

## Content

- Posts are page bundles: `content/posts/<slug>/index.md` with images colocated next to it. Front matter is TOML (`+++`); see `_template.md`.
- Posts default to `lang = "ja"`; the home page (`content/_index.md`) is English.
- Categories use a `__NN__Label` prefix to control group order on the posts index (`categorized = true` in `content/posts/_index.md`). The canonical mapping is the `category_label` function in `x` — add new categories there to keep numbering consistent.
- `content/pythia/` is a standalone page rendered with `prose.html`.
- Shortcodes (callouts such as `note`/`tip`/`warning`, `figure`, `caption`, `mermaid`, `detail`, `quote`, `collection`) are in `templates/shortcodes/`. Usage for authors is documented in `docs/shortcodes.md` and `docs/front-matter.md`; update them when adding or changing a shortcode or `[extra]` flag.
- Image captions use `{% caption() %}text{% end %}` on the line after the image, **separated by a blank line** — otherwise the output is nested inside the image's `<p>`.

## Templates

- Site-specific `<head>` additions (OGP tags and the Discord component embed) go in `templates/_head_extend.html`. Scope per-page output with `current_path`, **not** `section`: `post.html` and `tags/list.html` set `section` to the posts section, so a `section.path` guard leaks onto every post and tag page.
- Tera cannot `import` macros inside an included template, so partials included from `_base.html` must not use macros.
- Mermaid diagrams are rendered by [pele](https://github.com/obsidianmd/pele), loaded from jsDelivr as `pele@1` (major-pinned, not vendored, so no `LICENSES/` entry). The mount script is duplicated in `post.html`, `prose.html` and `home.html`; keep them in sync. Zoom is forced on with `zoom: { always: true }` because pele's default `auto` only zooms diagrams that shrink to fit. Colors come from `--pele-*` variables mapped to the site tokens in `sass/main.scss`.
- Color tokens for light/dark mode are CSS variables in `templates/_custom_css.html`; syntax highlighting themes are `highlight_themes/` → `static/hl-{light,dark}.css`.

## Deployment

Pushing to `main` triggers `.github/workflows/cd.yaml`, which deploys the same build to both GitHub Pages and Cloudflare Workers (`wrangler.jsonc`, static assets from `build/`). The Pages job is kept as a rollback path until the DNS cutover (m1sk9/infra#325) is verified.

## security.txt

`static/.well-known/security.txt` is a GPG clearsigned file generated from `security.txt.in` with the maintainer's YubiKey (command in `README.md`). Never edit the signed file directly; edit `security.txt.in` and ask the maintainer to re-sign.
