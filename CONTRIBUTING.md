# Contributing

By reading this document, you have already entered the Elite Hall of Ziglings
Maintenance!


## The Ziglings Audience

Ziglings is intended for programmers of all experience levels. No specific
language knowledge is expected.  If you can install the current Zig snapshot,
setup a copy of Ziglings, and understand if/then/else, loops, and functions,
then you're ready.

Experience with strong typing, manual memory management, and certain language
constructs and idioms will greatly increase the speed at which you'll be able
to tackle each exercise. But speed isn't important, only learning is important.

Ziglings is intended to be completely self-contained. If you can't solve an
exercise from the information you've gleaned so far from Ziglings, then the
exercise probably needs some additional work. Please file an issue!

If an example doesn't match a description or if something is unclear, please
file an issue!


## Spelling/Grammar

If you see any typos, please file an issue or make a pull request.

No mistake is too small. The Ziglings must be perfect.


## Ideas

If you have ideas for new lessons or a way Ziglings could be improved, don't
hesitate to file an issue.

I prefer to actually write all of the content myself at this time (part of the
reason I'm building Ziglings is to learn Zig myself!), but I'm always open to
ideas.


## Platforms and Zig Versions

Because it uses the Zig build system, Ziglings should work wherever Zig does.

Since Ziglings is a Zig language learning resource, it tracks the current
development of Zig.

If you run into an error in Ziglings due to language changes (and you have the
latest development build of Zig and the latest commit to Ziglings), that's a
bug! Please file an issue.


## Formatting

All exercises are (or should be) formatted with `zig fmt`.


## Pull Request Workflow

Ziglings uses the "standard" Github workflow as guided by the Web interface.
Specifically:

* Fork this repository
* Create a branch from `main` for your work: `git checkout -b my-branch`
* Make changes, commit them
* When your changes are ready for review, push your branch: `git push origin
  my-branch`
* Create a pull request from your branch to `ziglings/main`
* Your faithful Ziglings maintainer "ratfactor" (that's me!) will take a look
  at your request ASAP
* Once the changes are reviewed, your request will be merged and eternal
  Ziglings contributor glory is yours!


## The Secrets

If you want to peek at the secrets, take a look at the `patches/` directory.
