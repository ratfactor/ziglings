#!/bin/sh
# Find the latest commit that is compatible with a specified Zig version, like
# 0.10.1.
#
# The zig executable can be set using the ZIG_EXE environment variable.
#
# This script will clone the ziglings repository to the path specified by the
# first parameter, that is required.  Commits are processed in date order.

# Heals all the exercises.
heal() {
    if [ ! -d exercises ]
    then
        echo "Must be run from the project root directory."
        exit 1
    fi

    mkdir -p patches/healed
    for original in exercises/*.zig; do
        name=$(basename "$original" .zig)
        patch_name="patches/patches/$name.patch"
        output="patches/healed/$name.zig"

        if [ -f "$patch_name" ]; then
            patch -i "$patch_name" -o "$output" -s "$original"
        else
            printf "Cannot heal %s: no patch found\n" "$name"
        fi
    done
}

# Configure input parameters.
if [ -z "$ZIG_EXE" ]; then
    echo '$ZIG_EXE is required'
    exit 1
fi

work_path="$1"
if [ -z "$work_path" ] ; then
    echo "The work_path parameter is required and must be a directory"
    exit 1
elif [ ! -d "$work_path" ]; then
    printf "%s does not exist\n" "$work_path"
    exit 1
fi

# Clone ziglings repository.
cd "$work_path" || exit 1
echo "Cloning into 'ziglings'"
git clone -q https://github.com/ratfactor/ziglings.git ziglings || exit 1

# Find a commit compatible with the specified Zig version.
cd ziglings || exit 1
for commit in $(git log --date-order --pretty=format:"%H"); do
    git checkout --detach -q "$commit"
    printf "\nTesting commit %s\n" "$commit"

    heal

    # Some versions exits with exit code 0 instead of 1, if version check fails.
    sed -i 's/exit(0)/exit(1)/g' build.zig

    "$ZIG_EXE" build -Dhealed
    zig_ret=$?

    git restore build.zig

    if [ "$zig_ret" -eq 0 ]; then
        printf "Find working commit: %s\n" "$commit"
        exit 0
    fi
done
