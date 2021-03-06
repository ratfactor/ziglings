#!/bin/sh
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

# We run from the patches dir. Go there now if not already.
cd $(dirname $(realpath $0))
pwd # Show it upon the screen so all shall be made apparent.

# Create healed/ directory here if it doesn't already exist.
mkdir -p healed

# Cycle through all the little broken Zig applications.
for broken in ../exercises/*.zig
do
    # Remove the dir and extension, rendering the True Name.
    true_name=$(basename $broken .zig)
    patch_name="patches/$true_name.patch"


    if [ -f $patch_name ]
    then
        # Apply the bandages to the wounds, grow new limbs, let
        # new life spring into the broken bodies of the fallen.
        echo Healing $true_name...
        patch --output=healed/$true_name.zig $broken $patch_name
    else
        echo Cannot heal $true_name. No patch found.
    fi
done

# Return to the home of our ancestors.
cd ..

# Test the healed exercises. May the compiler have mercy upon us.
zig build -Dhealed
