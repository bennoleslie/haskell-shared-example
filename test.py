from ctypes import *

class ExampleStruct(Structure):
    _fields_ = [("x", c_int),
                ("y", c_int)]

lib = CDLL("./libTest.so")

# Test simple function
print lib.hsfun(5)

# Test wrap/unwrap functions
lib.wrap.restype = c_void_p
assert lib.unwrap(lib.wrap(2000)) == 2000

# Test simple structure handling
lib.gethsstruct.restype = POINTER(ExampleStruct)
x = lib.gethsstruct(30, 40)
assert x.contents.x == 30
assert x.contents.y == 40
assert lib.getx(x) == 30

lib.freehsstruct(x)

# Test list/array of structures
lib.gethslist.restype = POINTER(ExampleStruct)
x = lib.gethslist()

for i in range(10):
    assert x[i].x == 10
    assert x[i].y == 30

lib.freehsstruct(x)

z = ExampleStruct(50, 60)
assert lib.getx(pointer(z)) == 50

TenExampleStruct = ExampleStruct * 10
lst = TenExampleStruct(*[ExampleStruct(50, 60)] * 10)
lib.printlist(lst)

## Test string stuff
assert lib.hsstrlen("Test!") == 5

lib.gethsstr.restype = c_char_p
assert lib.gethsstr() == "hello world"

# Something a little more interesting
print "wc('Test.hs')", lib.export_wc("Test.hs")
