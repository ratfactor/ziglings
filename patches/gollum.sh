#!/bin/sh
#
#     "It isn't fair, my precious, is it,
#      to ask us what it's got in it's
#      nassty little pocketsess?"
#             Gollum, The Hobbit, or There and Back Again
#

if [ ! -f 'patches/gollum.sh' ]
then
    echo "We must be run from the project root dir, precious!"; exit 1
fi

ex=$(printf "%03d" $1)
echo "Nassssty exercise $ex..."

f=$(basename exercises/${ex}_*.zig .zig 2> /dev/null)
b=exercises/$f.zig
a=answers/$f.zig
p=patches/patches/$f.patch

if [ ! -f $b ]; then echo "No $f! We hates it!"; exit 1; fi
if [ ! -f $a ]; then echo "No $a! Where is it? Where is the answer, precious?"; exit; fi

echo "Hissss!    before: '$b'"
echo "            after: '$a'"
echo "            patch: '$p'"

diff $b $a > $p

cat $p
