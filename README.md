Base64
======

Base64 is a type of binary-to-text encryption. In this type of encryption, each byte that contains 8 bits is put together as binary numbers, and each 6 bits are divided into bytes of size 6 bits, and finally, according to the value of 6-bit bytes, new characters it's gonna be built.

This was a summary of my knowledge of Base64. read more from [wikipedia](https://en.wikipedia.org/wiki/Base64).

What are the development goals?
-------------------------------

 - Re-implementation of Base64 for better understanding
 - Practicing C++, Cython and Makefile programming languages

How to compile?
---------------

For each type of compilation, you need make, and to compile for Python language, you need to install Python3 and Visual Studio (2014 or later) or MinGW (for windows) or GCC (for linux), and to compile for C++ you need GCC or MinGW

> NOTE: Make is installed together with MinGW

for compile all:
```console
$ make compile-all
$ make compile-all python=python3 # for selecting python version
```

for only Python:
```console
$ make py-compile
$ make py-compile python=python3 # for selecting python version
```

> NOTE: In the above cases, to compile for Python, you need to install Visual Studio 2014 or later, and to compile with GCC or MinGW, the instructions are given below.

for only Python with GCC or MinGW:
```console
$ make py-gpp-compile
$ make py-gpp-compile python=python3 # for selecting python version
```

for only C++:
```console
$ make cpp-compile
```

for remove extra files:
```console
$ make clean
```

The End
-------