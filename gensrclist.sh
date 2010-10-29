#!/bin/sh

DIRLIST=". Source Source/Metadata Source/FreeImageToolkit Source/LibTIFF"

echo "VER_MAJOR = 3" > Makefile.srcs
echo "VER_MINOR = 10.0" >> Makefile.srcs

echo -n "SRCS = " >> Makefile.srcs
for DIR in $DIRLIST; do
	VCPRJS=`echo $DIR/*.2003.vcproj`
	if [ "$VCPRJS" != "$DIR/*.2003.vcproj" ]; then
		egrep 'RelativePath=.*\.(c|cpp)' $DIR/*.2003.vcproj | cut -d'"' -f2 | tr '\\' '/' | awk '{print "'$DIR'/"$0}' | tr '\r\n' '  ' | tr -s ' ' >> Makefile.srcs
	fi
done
echo >> Makefile.srcs

echo -n "INCLS = " >> Makefile.srcs
find . -name "*.h" -print | xargs echo >> Makefile.srcs
echo >> Makefile.srcs

echo -n "INCLUDE =" >> Makefile.srcs
for DIR in $DIRLIST; do
	echo -n " -I$DIR" >> Makefile.srcs
done
echo >> Makefile.srcs

