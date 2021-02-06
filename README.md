# ziglings

Welcome to `ziglings`. This project contains a series of incomplete exercises.
By completing the exercises, you learn how to read and write
[Zig](https://ziglang.org/)
code.

This project was directly inspired by the brilliant and fun
[rustlings](https://github.com/rust-lang/rustlings)
project for the [Rust](https://www.rust-lang.org/) language.

## Intended Audience

This will probably be quite difficult if you've _never_ programmed before.
However, no specific programming experience is required. And in particular,
you are _not_ expected to know C or other "systems programming" language.

Each exercise is self-contained and self-explained. However, you're encouraged
to also check out these Zig language resources for more detail:

* https://ziglearn.org/
* https://ziglang.org/documentation/master/

## Getting Started

_Note: This currently uses a shell (Bash) script to automate the "game". A
future update may remove this requirement. See TODO below._

Install the [master release](https://ziglang.org/download/) of the Zig compiler.

Verify the installation and version of `zig` like so:

```bash
$ zig version
0.7.1+<some hexadecimal string>
```

Clone this repository with Git:

```bash
git clone https://github.com/ratfactor/ziglings
cd ziglings
```

Then run the `ziglings` script and follow the instructions to begin!

```bash
./ziglings
```

## Manual Usage

If you can't (or don't want to) use the script, you can manually verify each
exercise with the Zig compiler:

```bash
zig run 01_hello.zig
```

## TODO

Contributions are very welcome! I'm writing this to teach myself and to create
the learning resource I wished for. There will be tons of room for improvement:

* Wording of explanations
* Idiomatic usage of Zig
* Additional exercises
* Re-write the `ziglings` script using the Zig build system (or just a Zig application)

Planned exercises:

* [x] Hello world (main needs to be public)
* [x] Importing standard library
* [x] Assignment
* [x] Arrays
* [x] Strings
* [x] If
* [x] While
* [x] For
* [x] Functions
* [x] Errors (error/try/catch/if-else-err)
* [x] Defer (and errdefer)
* [x] Switch
* [x] Unreachable
* [x] Enums
* [ ] Structs
* [ ] Unions
* [ ] Pointers
* [ ] Pointer sized integers
* [ ] Multi pointers
* [ ] Slices
* [ ] Integer rules
* [ ] Floats
* [ ] Labelled blocks
* [ ] Labelled loops
* [ ] Loops as expressions
* [ ] Optionals
* [ ] Comptime
* [ ] Inline loops
* [ ] Anonymous structs
* [ ] Sentinel termination
* [ ] Vectors
* [ ] Imports

The initial topics for these exercises were unabashedly cribbed from
[ziglearn.org](https://ziglearn.org/). I've since moved things around
in an order that I think best lets each topic build upon each other.

