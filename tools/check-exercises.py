#!/usr/bin/env python

import difflib
import io
import os
import os.path
import subprocess
import sys


IGNORE = subprocess.DEVNULL
PIPE = subprocess.PIPE

EXERCISES_PATH = "exercises"
HEALED_PATH = "patches/healed"
PATCHES_PATH = "patches/patches"


# Heals all the exercises.
def heal():
    maketree(HEALED_PATH)

    with os.scandir(EXERCISES_PATH) as it:
        for entry in it:
            name = entry.name

            original_path = entry.path
            patch_path = os.path.join(PATCHES_PATH, patch_name(name))
            output_path = os.path.join(HEALED_PATH, name)

            patch(original_path, patch_path, output_path)


# Yields all the healed exercises that are not correctly formatted.
def check_healed():
    term = subprocess.run(
        ["zig", "fmt", "--check", HEALED_PATH], stdout=PIPE, text=True
    )
    if term.stdout == "" and term.returncode != 0:
        term.check_returncode()

    stream = io.StringIO(term.stdout)
    for line in stream:
        yield line.strip()


def main():
    heal()

    # Show the unified diff between the original example and the correctly
    # formatted one.
    for i, original in enumerate(check_healed()):
        if i > 0:
            print()

        name = os.path.basename(original)
        print(f"checking exercise {name}...\n")

        from_file = open(original)
        to_file = zig_fmt_file(original)

        diff = difflib.unified_diff(
            from_file.readlines(), to_file.readlines(), name, name + "-fmt"
        )
        sys.stderr.writelines(diff)


def maketree(path):
    return os.makedirs(path, exist_ok=True)


# Returns path with the patch extension.
def patch_name(path):
    name, _ = os.path.splitext(path)

    return name + ".patch"


# Applies patch to original, and write the file to output.
def patch(original, patch, output):
    subprocess.run(
        ["patch", "-i", patch, "-o", output, original], stdout=IGNORE, check=True
    )


# Formats the Zig file at path, and returns the possibly reformatted file as a
# file object.
def zig_fmt_file(path):
    with open(path) as stdin:
        term = subprocess.run(
            ["zig", "fmt", "--stdin"], stdin=stdin, stdout=PIPE, check=True, text=True
        )

        return io.StringIO(term.stdout)


main()
