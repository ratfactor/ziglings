#!/bin/bash
# This script checks that `zig build` will return an useful error message when
# the Zig compiler is not compatible, instead of failing due to a syntax error.
#
# This script should be run on an UNIX system.

zig_version=$(zig version)

zig build -Dn=1 -Dhealed &> /dev/null 2>&1
zig_ret=$?

if [ "$zig_ret" -eq 0 ]; then
    printf "zig %s unexpectedly succeeded\n" "$zig_version"
    exit 1
fi

zig_error=$(zig build -Dn=1 -Dhealed 2>&1)

echo "$zig_error" | grep -q "it looks like your version of zig is too old"
zig_ret=$?

if [ "$zig_ret" -ne 0 ]; then
    printf "zig %s is not compatible\n" "$zig_version"
    exit 1
fi
