#!/bin/sh


# Remove intermediate files (probably a better way to do this)
rm -f *so *o

if [ $# -lt 1 ]
then
        echo "Usage : $0 build-method"
        exit
fi

case $1 in

# From: http://weblog.haskell.cz/pivnik/building-a-shared-library-in-haskell/
1) ghc -O2 --make \
    -no-hs-main -optl '-shared' -optc '-DMODULE=Test' \
    -o libTest.so Test.hs module_init.c
;;

# Alternative to #1 with -dynamic
2) ghc -O2 --make \
    -no-hs-main -optl '-shared' -optl '-dynamic' -optc '-DMODULE=Test' \
    -o libTest.so Test.hs module_init.c
;;

# From: http://stackoverflow.com/questions/5131182/how-to-compile-haskell-to-a-static-library
3) ghc --make -dynamic -shared -fPIC Test.hs -o libTest.so
;;

# Alternative to #3 without -dynamic
4) ghc --make -shared -fPIC Test.hs -o libTest.so
;;

# From: http://haskell.1045720.n5.nabble.com/Make-shared-library-questions-td4737971.html
5) ghc -O2 --make -no-hs-main -dynamic -shared -fPIC -optl '-shared' -optc '-DMODULE=Test' -o \
    libTest.so Test.hs module_init.c  -optl-Wl -lHSrts
;;

# Alternative to #5 withouth -dynamic
### This one works for 32-bit (but not 64-bit)
6) ghc -O2 --make -no-hs-main -shared -fPIC -optl '-shared' -optc '-DMODULE=Test' -o \
    libTest.so Test.hs module_init.c  -optl-Wl -lHSrts
;;

*) echo "Unknown build method"
;;

esac
