#!/usr/bin/env python

import os
import os.path
import subprocess


IGNORE = subprocess.DEVNULL

EXERCISES_PATH = "exercises"
ANSWERS_PATH = "answers"
PATCHES_PATH = "patches/patches"


# Heals all the exercises.
def heal():
    maketree(ANSWERS_PATH)

    with os.scandir(EXERCISES_PATH) as it:
        for entry in it:
            name = entry.name

            original_path = entry.path
            patch_path = os.path.join(PATCHES_PATH, patch_name(name))
            output_path = os.path.join(ANSWERS_PATH, name)

            patch(original_path, patch_path, output_path)


def main():
    heal()

    with os.scandir(EXERCISES_PATH) as it:
        for entry in it:
            name = entry.name

            broken_path = entry.path
            healed_path = os.path.join(ANSWERS_PATH, name)
            patch_path = os.path.join(PATCHES_PATH, patch_name(name))

            with open(patch_path, "w") as file:
                term = subprocess.run(
                    ["diff", broken_path, healed_path],
                    stdout=file,
                    text=True,
                )
                assert term.returncode == 1


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


main()
