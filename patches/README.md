# No Peeking! :-)

Welcome to the ziglings/patches directory. This is how ziglings is tested.

The patches fix the broken exercises so that they work again, which means the
answers are here, so no peeking!

## Éowyn

A Bash shell script named `eowyn.sh` dwells here. She heals the little broken
programs and places them in a `healed` directory, which is NOT committed to the
repo.

```bash
$ patches/eowyn.sh
```

(If you invoke her from elsewhere, she'll come here to ply her trade.)

The `build.zig` build script at the heart of Ziglings has a top-secret option
which tells it to test from the `patches/healed/` dir rather than `exercises/`:

```bash
$ zig build -Dhealed [step]
```

Éowyn tests all healed programs using this secret option.


## Gollum

Another Bash shell script named `gollum.sh` may also be found. He snatches the
original answers and stows them in his secret answers stash. If you leave him
alone, he'll leave you alone.
