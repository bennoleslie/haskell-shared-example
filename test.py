from ctypes import *

class ExampleStruct(Structure):
    _fields_ = [("x", c_int),
                ("y", c_int)]

lib = CDLL("./libTest.so")

lib.wrap.restype = c_void_p
assert lib.unwrap(lib.wrap(2000)) == 2000

lib.gethsstruct.restype = POINTER(ExampleStruct)
x = lib.gethsstruct(30, 40)
assert x.contents.x == 30
assert x.contents.y == 40
assert lib.getx(x) == 30


lib.gethslist.restype = POINTER(ExampleStruct)
x = lib.gethslist()

for i in range(10):
    assert x[i].x == 10
    assert x[i].y == 30

z = ExampleStruct(50, 60)
assert lib.getx(pointer(z)) == 50

lib.freehsstruct(x)

TenExampleStruct = ExampleStruct * 10
lst = TenExampleStruct(*[ExampleStruct(50, 60)] * 10)
lib.printlist(lst)

## String stuff
assert lib.hsstrlen("Test!") == 5

lib.gethsstr.restype = c_char_p
assert lib.gethsstr() == "hello world"
