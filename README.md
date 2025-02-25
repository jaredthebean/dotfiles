# Dotfiles

Like most dotfiles this can be cloned and then installed with

```sh
./install.sh
```

For machines or containers that make sense, heavier dependencies can be installed
after the intial install with

```sh
./deps.sh "${PWD}" heavy
```

These are mostly "new"-er takes on common CLIs installed with cargo/Rust (and
thus take some compliation time.)
After installing these heavier dependencies you may need to re-source your
shell config/aliases to pick up aliases depending on the new utilities
installed.
