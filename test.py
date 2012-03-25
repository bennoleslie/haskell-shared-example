from ctypes import *

class ExampleStruct(Structure):
    _fields_ = [("x", c_int),
                ("y", c_int)]

lib = CDLL("./libTest.so")
print lib
print lib.hsfun
print lib.hsfun(5)

lib.wrap.restype = c_void_p
print lib.unwrap(lib.wrap(2000))

lib.gethsstruct.restype = POINTER(ExampleStruct)
x = lib.gethsstruct(30, 40)
assert x.contents.x == 30
assert x.contents.y == 40

assert lib.getx(x) == 30


lib.gethslist.restype = POINTER(ExampleStruct)
x = lib.gethslist(30, 40)

print "X[0]: ", x[0]
print "      ", x[0].x
print "X[1]: ", x[1]
print "      ", x[1].x


z = ExampleStruct(50, 60)
assert lib.getx(pointer(z)) == 50


lib.freehsstruct(x)

