# ziglings

Welcome to `ziglings`. This project contains a series of incomplete exercises.
By completing the exercises, you learn how to read and write
[Zig](https://ziglang.org/)
code.

This project was directly inspired by the brilliant and fun
[rustlings](https://github.com/rust-lang/rustlings)
project for the [Rust](https://www.rust-lang.org/) language.

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
zig run exercises/01_hello.zig
```

## TODO

Contributions are very welcome! I'm writing this to teach myself and to create
the learning resource I wished for. There will be tons of room for improvement:

* Wording of explanations
* Idiomatic usage of Zig
* Additional exercises
* Re-write the `ziglings` script using the Zig build system (???)

Planned exercises:

* [x] Hello world (main needs to be public)
* [x] Importing standard library
* [x] Assignment
* [x] Arrays
* [x] Strings
* [ ] If
* [ ] While
* [ ] For
* [ ] Functions
* [ ] Defer
* [ ] Errors
* [ ] Switch
* [ ] Runtime safety
* [ ] Unreachable
* [ ] Pointers
* [ ] Pointer sized integers
* [ ] Multi pointers
* [ ] Slices
* [ ] Enums
* [ ] Structs
* [ ] Unions
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
[ziglearn.org](https://ziglearn.org/).
