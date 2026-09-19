# pyenv-uv-rehash

Runs `pyenv rehash` after `uv pip install` and `uv pip uninstall`, so console scripts installed by uv get a pyenv shim.

pyenv ships this behaviour for `pip`, `easy_install` and `conda` only (`pyenv.d/exec/pip-rehash`).
Without it, a uv-installed entry point lands in the venv's `bin/` but never gets a shim, and `~/.pyenv/shims` earlier on `PATH` means the command stays unresolvable.

pyenv declined to bundle a uv script and pointed to a plugin instead: https://github.com/pyenv/pyenv/issues/2979
Tracking issue on the uv side: https://github.com/astral-sh/uv/issues/4130

## Install

```bash
ln -s ~/git/new-mac-setup/pyenv-uv-rehash "$(pyenv root)"/plugins/pyenv-uv-rehash
pyenv hooks exec  # should list etc/pyenv.d/exec/uv-rehash.bash
```

Requires `uv` itself to resolve through a pyenv shim.
A uv installed outside pyenv (for example `~/.local/bin/uv` from the Astral installer) never runs `pyenv exec`, so the hook does not fire.
