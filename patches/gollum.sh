#!/bin/sh
#
#     "It isn't fair, my precious, is it,
#      to ask us what it's got in it's
#      nassty little pocketsess?"
#             Gollum, The Hobbit, or There and Back Again
#

cd $(dirname $(realpath $0))
f=$(basename ../exercises/$1*.zig .zig 2> /dev/null)
b=../exercises/$f.zig
a=../answers/$f.zig
p=patches/$f.patch

printf "\tf: '$f'\n\tb: '$b'\n\ta: '$a'\n"

if [ ! -f $b ]; then echo "We hates it!"; exit 1; fi
if [ ! -f $a ]; then echo "Where is it? Where is the answer, precious?"; exit; fi

echo Hisssss!

diff $b $a > $p

cat $p
