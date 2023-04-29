#!/bin/bash
#
#     "I will be a shieldmaiden no longer,
#      nor vie with the great Riders, nor
#      take joy only in the songs of slaying.
#      I will be a healer, and love all things
#      that grow and are not barren."
#             Éowyn, The Return of the King
#
#
# This script shall heal the little broken programs
# using the patches in this directory and convey them
# to convalesce in the healed directory.
#
set -e

# We check ourselves before we wreck ourselves.
if [ ! -f patches/eowyn.sh ]
then
    echo "But I must be run from the project root directory."
    exit 1
fi

# Which version we have?
echo "I am in version 23.4.25.1, let's try our magic power."

# Create directory of healing if it doesn't already exist.
mkdir -p patches/healed

# Cycle through all the little broken Zig applications.
for broken in exercises/*.zig
do
    # Remove the dir and extension, rendering the True Name.
    true_name=$(basename "$broken" .zig)
    patch_name="patches/patches/$true_name.patch"

    if [ -f "$patch_name" ]
    then
        # Apply the bandages to the wounds, grow new limbs, let
        # new life spring into the broken bodies of the fallen.
        echo Healing "$true_name"...
        patch --output="patches/healed/$true_name.zig" "$broken" "$patch_name"
    else
        echo Cannot heal "$true_name". No patch found.
    fi
done

echo "Looking for non-conforming code formatting..."
zig fmt --check patches/healed

# Test the healed exercises. May the compiler have mercy upon us.
zig build -Dhealed
