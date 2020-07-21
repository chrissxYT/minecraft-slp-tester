#!/bin/sh

[ $# -lt 1 ] && { echo "You need to pass the Minecraft version to use" ; exit 1 ; }

initial_dir=$(pwd)
test_dir=$(tempfile -s MC)
rm -f $test_dir

cp -rf setup$1 $test_dir || exit 1
cd $test_dir
curl -Lo s.jar "$(cat _url)"
{ while [ ! -f scandone ] ; do sleep 1 ; done ; echo stop ; } | java -jar s.jar nogui >/dev/null 2>/dev/null &
sleep 60

echo "Trying v1:"
/bin/echo -e '\xfe' | nc localhost $(cat _port) > abc
hd abc
rm -f abc

echo "Trying v2:"
/bin/echo -e '\xfe\x01' | nc localhost $(cat _port) > abc
hd abc
rm -f abc

echo "Trying v3:"
/bin/echo -e '\xfe\x01\xfa\x00\x0b\x00\x4d\x00\x43\x00\x7c\x00\x50\x00\x69\x00\x6e\x00\x67\x00\x48\x00\x6f\x00\x73\x00\x74\x00\x19\x49\x00\x09\x00\x6c\x00\x6f\x00\x63\x00\x61\x00\x6c\x00\x68\x00\x6f\x00\x73\x00\x74\x00\x00\x63\x'"$(cat _port.x2)" | nc localhost $(cat _port) > abc
hd abc
rm -f abc

echo "Trying v4:"
/bin/echo -e '\x0f\x00\x00\tlocalhost\x'"$(cat _port.x2)"'c\x01\x01\x00' | nc localhost $(cat _port) > abc
hd abc
rm -f abc

echo > scandone

wait
cd $initial_dir
