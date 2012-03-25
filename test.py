from ctypes import *

lib = CDLL("./libTest.so")
print lib
print lib.hsfun
print lib.hsfun(5)

lib.wrap.restype = c_void_p
print lib.unwrap(lib.wrap(2000))
