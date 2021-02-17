# ziglings

Welcome to `ziglings`! This project contains a series of tiny broken programs.
By fixing them, you'll learn how to read and write
[Zig](https://ziglang.org/)
code.

Those tiny broken programs need your help! (You'll also help some friendly
elephants stick together, which is very sweet of you.)

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

Install a [development build](https://ziglang.org/download/) of the Zig compiler.
(See the "master" section of the downloads page.)

Verify the installation and build number of `zig` like so:

```bash
$ zig version
0.8.0-dev.1065+xxxxxxxxx
```

Clone this repository with Git:

```bash
$ git clone https://github.com/ratfactor/ziglings
$ cd ziglings
```

Then run `zig build` and follow the instructions to begin!

```bash
$ zig build
```

## A Note About Versions

The Zig language is under very active development. In order to be current,
Ziglings tracks **development** builds of the Zig compiler rather than
versioned **release** builds. The last stable release was `0.7.1`, but Ziglings
needs a dev build with pre-release version "0.8.0" and a build number at least
as high as that shown in the example version check above.

It is likely that you'll download a build which is _greater_ than the minimum.

Once you have a build of the Zig compiler that works with Ziglings, they'll
continue to work together. But keep in mind that if you update one, you may
need to also update the other.

## Advanced Usage

It can be handy to check just a single exercise or _start_ from a single
exercise:

```bash
zig build 19
zig build 19_start
```

You can also run without checking for correctness:

```bash
zig build 01_test
```

Or skip the build system entirely and interact directly with the compiler
if you're into that sort of thing:

```bash
zig run exercises/01_hello.zig
```

Calling all wizards: To prepare an executable for debugging, install it
to zig-cache/bin with:

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
* [x] Optionals
* [ ] Struct methods
* [ ] Slices
* [ ] Multi pointers
* [ ] Unions
* [ ] Numeric types (integers, floats)
* [ ] Labelled blocks and loops
* [ ] Loops as expressions
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

