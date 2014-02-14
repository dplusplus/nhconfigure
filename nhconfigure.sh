#!/bin/sh

if [ ! -e Makefile -a -e sys/unix/setup.sh ] ; then
    sh sys/unix/setup.sh
fi

game=`grep '^GAME ' -m1 Makefile | awk '{ print $3 }'`

if [ -n "`grep -i -m1 sporkhack include/patchlevel.h`" ] ; then
    game=sporkhack
fi

if [ -n "`grep -i -m1 jsporkhack include/config.h`" ] ; then
    game=jsporkhack
fi

if [ -n "`grep -m1 FHS include/config.h`" ] ; then
    game=fhspatch
fi

versionfile="include/patchlevel.h"

version_major=`grep -m1 VERSION_MAJOR $versionfile | awk '{ print $3 }'`
version_minor=`grep -m1 VERSION_MINOR $versionfile | awk '{ print $3 }'`
patchlevel=`egrep -m1 "define\s+PATCHLEVEL" $versionfile | awk '{ print $3 }'`

# echo game version
echo "[${game} ${version_major}.${version_minor}.${patchlevel}]"

echo "Modifying Makefiles and Headers."

# fix Makefile
sed -i \
    -e "s|^GAME\s.*$|GAME = ${game}|" \
    -e 's|^GAMEGRP.*$|GAMEGRP = games|' \
    -e 's|^GAMEPERM.*$|GAMEPERM = 02755|' \
    -e 's|^FILEPERM.*$|FILEPERM = 0664|' \
    -e 's|^EXEPERM.*$|EXEPERM = 755|' \
    -e 's|^DIRPERM.*$|DIRPERM = 775|' \
    -e 's|^VARFILEPERM.*$|VARFILEPERM = 664|' \
    -e 's|^VARDIRPERM.*$|VARDIRPERM = 775|' \
    -e 's|^GAMEDIR.*$|GAMEDIR = $(PREFIX)/games/lib/$(GAME)dir|' \
    -e 's|^SHELLDIR.*$|SHELLDIR = $(PREFIX)/games|' \
    Makefile

# fix src/Makefile
sed -i \
    -e "s|^GAME\s.*$|GAME = ${game}|" \
    -e 's|^CFLAGS.*$|CFLAGS = -O2 -fomit-frame-pointer -I../include|' \
    -e 's|^WINTTYLIB.*$|WINTTYLIB = -lncurses|' \
    src/Makefile

# fix util/Makefile
sed -i \
    -e 's|^CFLAGS.*$|CFLAGS = -O2 -fomit-frame-pointer -I../include|' \
    util/Makefile

# fix include/unixconf.h
sed -i -r \
    -e 's|^.*/\*.*(#\s*define\s+SYSV)\s+(\*/)?(.*$)|\1\3|' \
    -e 's|^.*/\*.*(#\s*define\s+TERMINFO)\s+(\*/)?(.*$)|\1\3|' \
    -e 's|^.*/\*.*(#\s*define\s+LINUX)\s+(\*/)?(.*$)|\1\3|' \
    -e 's|^.*/\*.*(#\s*define\s+TIMED_DELAY)\s+(\*/)?(.*$)|\1\3|' \
    include/unixconf.h

# fix include/config.h
sed -i -r \
    -e 's|(^#\s*define\s+XI18N).*$|/* \1 */|' \
    -e "s|(^#\s*define\s+WIZARD\s+).*$|\1\"`whoami`\"|" \
    -e "s|(^#\s*define\s+WIZARD_NAME\s+).*$|\1\"`whoami`\"|" \
    -e "s|(^#\s*define\s+COMPRESS\s+).*$|\1\"`which gzip`\"|" \
    -e 's|^.*/\*.*(#\s*define\s+DLB)\s+(\*/)?(.*$)|\1\3|' \
    include/config.h

# fix for FHS patch
if [ "$game" = "fhspatch" ] ; then
    # delete temporary file
    if [ -e util/dgn_yacc.c ]; then
	rm util/dgn_yacc.c
    fi

    # remove 'register' word
    sed -i \
	-e 's|register coord cc|coord cc|' \
	src/mklev.c

    # avoid error 'virtual memory exhausted'
    sed -i -r \
	-e 's|(^CFLAGS.*$)|\1 -fno-inline|' \
	src/Makefile

    # ignore non-match prototype
    sed -i -r \
        -e 's|(^E.*spec_applies_wield.*$)|/* \1 */|' \
        -e 's|(^E.*spec_applies_class.*$)|/* \1 */|' \
	include/extern.h
fi

case "$game" in
    "fhspatch" ) sed -i 's|nethackrc|fhspatchrc|' src/files.c ;;
esac