nhconfigure
===========

Fix NetHack's Makefiles and Headers for compiling on Ubuntu Linux.

supported variant:

* NetHack 3.4.3
* JNetHack 3.4.3-0.11
* Slash'EM 0.0.7E7F3
* JSlash'EM 0.0.7E7F3-J0.2.1
* SporkHack 0.6.3
* JSporkHack 0.6.0-0.1

----

## How to compile NetHack on Ubuntu Linux:

### 0. Install required library and tools

 # apt-get install flex bison libncurses-dev

### 1. Download tarball

Show http://sourceforge.net/projects/nethack/files/nethack/3.4.3/ and download nethack-343-src.tgz

### 2. Extract it

% tar zxvf nethack-343-src.tgz

### 3. generate Makefiles

% cd nethack-3.4.3  
% sh sys/unix/setup.sh

### 4. fix Makefiles and Headers (by this script)

% sh nhconfigure.sh

### 5. make

% make

### 6. install to /usr/games

 # make install

### 7. Enjoy!

% nethack
