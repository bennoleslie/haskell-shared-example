from ctypes import *

lib = CDLL("./libTest.so")
print lib
print lib.hsfun
print lib.hsfun(5)
