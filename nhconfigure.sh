#!/bin/sh

# fix Makefile
sed -i \
    -e 's|^GAMEGRP.*$|GAMEGRP = games|' \
    -e 's|^GAMEPERM.*$|GAMEPERM = 02755|' \
    -e 's|^FILEPERM.*$|FILEPERM = 0664|' \
    -e 's|^EXEPERM.*$|EXEPERM = 755|' \
    -e 's|^DIRPERM.*$|DIRPERM = 775|' \
    Makefile

# fix src/Makefile
sed -i \
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
    -e "s|(^#\s*define\s+XI18N).*$|/* \1 */|" \
    -e "s|(^#\s*define\s+WIZARD\s+).*$|\1\"`whoami`\"|" \
    -e "s|(^#\s*define\s+WIZARD_NAME\s+).*$|\1\"`whoami`\"|" \
    -e "s|(^#\s*define\s+COMPRESS\s+).*$|\1\"`which gzip`\"|" \
    -e 's|^.*/\*.*(#\s*define\s+DLB)\s+(\*/)?(.*$)|\1\3|' \
    include/config.h
