esp-easy-sdk
============

This project is based on the esp-open-sdk (https://github.com/pfalcon/esp-open-sdk).


Requirements and Dependencies
=============================

To build the standalone SDK and toolchain, you need a GNU/POSIX system
(Linux, BSD, MacOSX, Windows with Cygwin) with the standard GNU development
tools installed: bash, gcc, binutils, flex, bison, etc.

Please make sure that the machine you use to build the toolchain has at least
1G free RAM+swap (or more, which will speed up the build).

## Debian/Ubuntu

Ubuntu 14.04:
```
$ sudo apt-get install make unrar autoconf automake libtool gcc g++ gperf \
    flex bison texinfo gawk ncurses-dev libexpat-dev python-dev python python-serial \
    sed git unzip bash help2man wget bzip2
```

Later Debian/Ubuntu versions may require:
```
$ sudo apt-get install libtool-bin
```

## MacOS:
```bash
$ brew tap homebrew/dupes
$ brew install binutils coreutils automake wget gawk libtool help2man gperf gnu-sed --with-default-names grep
$ export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
```

In addition to the development tools MacOS needs a case-sensitive filesystem.
You might need to create a virtual disk and build esp-open-sdk on it:
```bash
$ sudo hdiutil create ~/Documents/case-sensitive.dmg -volname "case-sensitive" -size 10g -fs "Case-sensitive HFS+"
$ sudo hdiutil mount ~/Documents/case-sensitive.dmg
$ cd /Volumes/case-sensitive
```


Installing SDK + Toolchain
==========================

Be sure to clone recursively:

```
$ git clone --recursive https://github.com/liotio/esp-easy-sdk.git
```

The toolchain itself can be build in two modes.
As the common Makefile will do compiling and linking for you, is does not
matter which mode will be chosen.
Licensing is more clear if you choose the following non-standalone mode:

```
$ make STANDALONE=n
```

This will download all necessary components and compile them
(takes about 30 minutes).

Also export the following variables so that the use of esp-easy-sdk is even more easy.

```
export ESP_EASY_SDK=/path/to/esp-easy-sdk
export PATH=${ESP_EASY_SDK}/xtensa-lx106-elf/bin:$PATH
```


Building a Firmware
===================

The greatest strength of the esp-easy-sdk is the `common.mk` Makefile that
relives you of writing own Makesfiles. This makes building new projects very
easy.

Create the following files and directories:

```
app
|--- app.c
|--- user_config.h
+--- Makefile
```

The `user_config.h` can be left empty, it must exist only.

Edit the `app.c` and insert the following:

```c
#include "osapi.h"
#include "user_interface.h"

void user_init()
{
    wifi_set_opmode(NULL_MODE);
}
```

Edit the `Makefile` and insert the following:

```bash
PROGRAM = app
include $(ESP_EASY_SDK)/common.mk
```

That's it! Now you can build the app by easily running:

```bash
make
```

Run the help target to see the other build targets:

```bash
make help
```

Open the `$(ESP_EASY_SDK)/parameters.mk` to see what parameters can be
overwritten by your project's Makefile.
Also see the examples folder in this repository for more infos.


Pulling updates
===============
The project is updated from time to time, to get updates and prepare to
build a new SDK, run:

```
$ make clean
$ git pull
$ git submodule sync
$ git submodule update --init
$ make STANDALONE=n
```

If you don't issue `make clean` (which causes toolchain and SDK to be
rebuilt from scratch on next `make`), you risk getting broken/inconsistent
results.


License
=======

esp-open-sdk is based on the esp-open-sdk.

esp-open-sdk is in its nature merely a makefile, and is in public domain.
However, the toolchain this makefile builds consists of many components,
each having its own license. You should study and abide them all.

Quick summary: gcc is under GPL, which means that if you're distributing
a toolchain binary you must be ready to provide complete toolchain sources
on the first request.

Since version 1.1.0, vendor SDK comes under modified MIT license. Newlib,
used as C library comes with variety of BSD-like licenses. libgcc, compiler
support library, comes with a linking exception. All the above means that
for applications compiled with this toolchain, there are no specific
requirements regarding source availability of the application or toolchain.
(In other words, you can use it to build closed-source applications).
(There're however standard attribution requirements - see licences for
details).
