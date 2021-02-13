# ziglings

Welcome to `ziglings`! This project contains a series of tiny broken programs.
By fixing them, you'll learn how to read and write
[Zig](https://ziglang.org/)
code!

This project was directly inspired by the brilliant and fun
[rustlings](https://github.com/rust-lang/rustlings)
project for the [Rust](https://www.rust-lang.org/) language.
Indirect inspiration comes from [Ruby Koans]( http://rubykoans.com/)
and the Little LISPer/Little Schemer series of books.

## Intended Audience

This will probably be difficult if you've _never_ programmed before.
But no specific programming experience is required. And in particular,
you are _not_ expected to have any prior experience with "systems programming"
or a "systems" level language such as C.

Each exercise is self-contained and self-explained. However, you're encouraged
to also check out these Zig language resources for more detail:

* https://ziglearn.org/
* https://ziglang.org/documentation/master/

## Getting Started

Install a [master build](https://ziglang.org/download/) of the Zig compiler.

Verify the installation and version of `zig` like so:

```bash
$ zig version
0.8.0-dev.1065+<some hexadecimal string>
```

Clone this repository with Git:

```bash
git clone https://github.com/ratfactor/ziglings
cd ziglings
```

Then run `zig build` and follow the instructions to begin!

```bash
zig build
```

## A Note About Compiler Versions

The Zig language is under very active development. Ziglings will attempt to
be current, but not bleeding-edge. However, sometimes fundamental changes
will happen. Ziglings will check for a minimum version and build number
(which is this one: `0.x.x-dev.<build number>`) and exit if your version of
Zig is too old. It is likely that you'll download a build which is greater
than the number in the example shown above in this README.  That's okay!

Once you have a version of the Zig compiler that works with your copy of
Ziglings, they'll continue to work together forever. But if you update one,
keep in mind that you may need to also update the other.

## Manual Usage

If you want to run a single file for testing, you can do so with this command:

```bash
zig run exercises/01_hello.zig
```
or, alternatively
```bash
zig build 01_test
```

To verify a single file, use

```bash
zig build 01_only
```

To prepare an executable for debugging, install it to zig-cache/bin with

```bash
zig build 01_install
```

## TODO

Contributions are very welcome! I'm writing this to teach myself and to create
the learning resource I wished for. There will be tons of room for improvement:

* Wording of explanations
* Idiomatic usage of Zig
* Additional exercises

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
* [x] Structs
* [x] Pointers
* [ ] Multi pointers
* [ ] Slices
* [ ] Unions
* [ ] Numeric types (integers, floats)
* [ ] Labelled blocks and loops
* [ ] Loops as expressions
* [ ] Optionals
* [ ] Comptime
* [ ] Inline loops (how to DEMO this?)
* [ ] Anonymous structs
* [ ] Sentinel termination
* [ ] Vectors
* [ ] Imports
* [ ] Allocators
* [ ] Arraylist
* [ ] Filesystem
* [ ] Readers and Writers
* [ ] Formatting
* [ ] JSON
* [ ] Random Numbers
* [ ] Crypto
* [ ] Threads
* [ ] Hash Maps
* [ ] Stacks
* [ ] Sorting
* [ ] Iterators
* [ ] Formatting specifiers
* [ ] Advanced Formatting
* [ ] Suspend / Resume
* [ ] Async / Await
* [ ] Nosuspend
* [ ] Async Frames, Suspend Blocks

The initial topics for these exercises were unabashedly cribbed from
[ziglearn.org](https://ziglearn.org/). I've since moved things around
in an order that I think best lets each topic build upon each other.

