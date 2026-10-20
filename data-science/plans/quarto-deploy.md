# Plan: Deploying the Quarto Site to Apache

**Status:** implemented.

## Context

Every project gets a Quarto website under `quarto/`. It always deploys as pre-rendered static HTML to an Apache server.

**Constraint that shapes everything:** the site is rendered from code that reads `data/`, and `data/` never leaves the local machine (gitignored, `.claudeignore`d). So rendering happens locally and no CI is involved. Deploying means copying the rendered `_site/` from the local machine to the server.

## Decisions

| Question | Answer |
|---|---|
| Server access | SSH (key auth via `~/.ssh/config` alias) + rsync |
| URL layout | one subdirectory per project: `<base_path>/<project>/` → `<base_url>/<project>/` |
| Access control | password protection handled server-side; nothing in the template |
| Who deploys | only Tony, from his machine |

## Design

### Config

`config.yaml` → `deploy:` holds `ssh_host`, `base_path` and `base_url`. `create` writes `quarto/_deploy.conf` (shell variables: `PROJECT`, `SSH_HOST`, `REMOTE_DIR`, `SITE_URL`), so each project can be repointed later. It contains no secrets and is committed. If `deploy:` is empty, `create` writes blank values and prints a reminder.

### `quarto/deploy`

```
./deploy              # render, check, sync
./deploy --dry-run
./deploy --no-render
```

1. **Validate:** required vars are set; `REMOTE_DIR` must be absolute and end in `/<PROJECT>` (guards `--delete`).
2. **Render:** `quarto render`, with `QUARTO_PYTHON` pointing at `../.venv` when present.
3. **Safety check:** abort if `_site/` has `.claudeignore` data extensions, anything under `collab/` or `converted/`, or a file over 50 MB.
4. **Permissions:** `chmod -R u=rwX,go=rX _site`, done locally because macOS's openrsync silently ignores `--chmod`.
5. **Sync:** `rsync -avz --delete --copy-links _site/ host:REMOTE_DIR/`. `--copy-links` resolves the `figures` symlink.

### Other changes

- `_quarto.yml`: render excludes `**/collab/**` and `**/converted/**` (`papers/convert to-qmd` writes `.qmd` there); `website.site-url` comes from the new `site_url` token, and the line is dropped when it's unset.
- `make deploy` / `make deploy-dry` in the Python Makefiles (`r-project` has no Makefile).
- Docs: data-science `CLAUDE.md`/`README.md`; each template's `CLAUDE.md` says never to run `deploy` unless asked.

## Server setup (one-time, manual)

1. SSH key auth and a `Host` alias in `~/.ssh/config`.
2. Write access to `base_path`.
3. Password protection configured on the server for `base_path`.

## Verification

Done in a scratch dir with a fake `ssh` that runs rsync's remote side locally:
- `_deploy.conf` and `site-url` are generated correctly, with and without `deploy:` config
- dry run changes nothing; a real run copies files and resolves the figures symlink
- files deleted locally are removed on the server
- `.csv` and `collab/*.docx` in `_site/` abort the deploy
- a bad `REMOTE_DIR` or an empty config aborts the deploy
- files end up world-readable even if they were `600` locally

Still to verify on the real server: a full `quarto render` + deploy, then check that the site loads at `SITE_URL` behind the server's auth and that relative links work under the subpath.
