Installation of GnuCOBOL on Manjaro Linux (Arch based)

There is no package for gnucobol.

```
# pacman -S gnucobol
error: target not found: gnucobol
```

We will have to build from source.

Sources is available from: https://sourceforge.net/projects/gnucobol/

Unpack the source code to a folder of your choice, and change directory into it.

The DEPENDENCIES file specifies the following relevant requirements:

```
GNU MP (libgmp) 4.1.2 or later
GNU Libtool
Berkeley DB 
Ncurses
libxml2
cJSON
```

Which we can grab using 

```
pacman -S gmp libtool db ncurses libxml2 cjson
```

Then simply invoke:

```
./configure
```

You should, if dependencies have been met, see the following configuration

```
configure: GnuCOBOL Configuration:
configure:  CC                gcc
configure:  CFLAGS            -O2 -pipe -finline-functions -fsigned-char -Wall -Wwrite-strings -Wmissing-prototypes -Wno-format-y2k
configure:  LDFLAGS            -Wl,-z,relro,-z,now,-O1
configure:  LIBCOB_LIBS        -lgmp -lxml2 -lcjson -lncursesw -ldb-6.2
configure:  COB_CC            gcc
configure:  COB_CFLAGS        -pipe -I/usr/local/include -Wno-unused -fsigned-char -Wno-pointer-sign
configure:  COB_LDFLAGS       
configure:  COB_DEBUG_FLAGS   -ggdb3 -fasynchronous-unwind-tables
configure:  COB_LIBS          -L${exec_prefix}/lib -lcob
configure:  COB_CONFIG_DIR    ${datarootdir}/gnucobol/config
configure:  COB_COPY_DIR      ${datarootdir}/gnucobol/copy
configure:  COB_LIBRARY_PATH  ${exec_prefix}/lib/gnucobol
configure:  COB_OBJECT_EXT    o
configure:  COB_MODULE_EXT    so
configure:  COB_EXE_EXT       
configure:  COB_SHARED_OPT    -shared
configure:  COB_PIC_FLAGS     -fPIC -DPIC
configure:  COB_EXPORT_DYN    -Wl,--export-dynamic
configure:  COB_STRIP_CMD     strip --strip-unneeded
configure:  Dynamic loading:                             System
configure:  Use gettext for international messages:      yes
configure:  Use fcntl for file locking:                  yes
configure:  Use math multiple precision library:         gmp
configure:  Use curses library for screen I/O:           ncursesw
configure:  Use Berkeley DB for INDEXED I/O:             yes
configure:  Used for XML I/O:                            libxml2
configure:  Used for JSON I/O:                           cjson
➜  gnucobol-3.2  
```

If you try to make GnuCOBOL now, it will fail with an error:
```
common.c:9714:17: error: implicit declaration of function ‘xmlCleanupParser’ [-Wimplicit-function-declaration]
 9714 |                 xmlCleanupParser ();
      |                 ^~~~~~~~~~~~~~~~
```
The version I downloaded, which was the latest at the time: `gnucobol-3.2.tar.gz`
Simply doesnt include the header which defines this function. Which is an easy fix, and already corrected in the GnuCOBOL project. See bug entry: https://sourceforge.net/p/gnucobol/bugs/941/

Apply the patch:

```
--- libcob/common.c~	2023-07-28 12:16:38.000000000 -0500
+++ libcob/common.c	2024-01-31 13:14:41.168118471 -0600
@@ -136,6 +136,7 @@
 #if defined (WITH_XML2)
 #include <libxml/xmlversion.h>
 #include <libxml/xmlwriter.h>
+#include <libxml/parser.h>
 #endif
 
 #if defined (WITH_CJSON)
```

And `make -j32` again - it should complete fine. We can further check that, using `make test` which will download and run tests. My build successfully performed all tests. Satisfied with that, go ahead and `sudo make install`.

Finally, we can invoke the version command on the `cobc` compiler we just installed to see that everything is in order.

```
➜  gnucobol-3.2 cobc -version
cobc (GnuCOBOL) 3.2.0
Copyright (C) 2023 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
Written by Keisuke Nishida, Roger While, Ron Norman, Simon Sobisch, Edward Hart
Built     Feb 15 2025 12:42:56
Packaged  Jul 28 2023 17:02:56 UTC
C version "14.2.1 20240910"
```

Finally - as discovered while trying to execute a program compiled with `cobc` - it was necessary for me to add a ld.so.conf.d entry in /etc/ld.so.conf.d/gnucobol.conf with the content `/usr/local/lib` and execute `ldconfig` as root. 
