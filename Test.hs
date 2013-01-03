-- From: http://weblog.haskell.cz/pivnik/building-a-shared-library-in-haskell/
-- Parts cribbed from: http://stackoverflow.com/questions/4502115/interchange-structured-data-between-haskell-and-c
{-# LANGUAGE ForeignFunctionInterface #-}
module Test where

import Foreign.C.Types
import Foreign.C.String
import Foreign.StablePtr
import Foreign.Storable
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array
import Foreign.Ptr

-- Very simple haskell function
hsfun :: CInt -> IO CInt
hsfun x = do
    putStrLn "Hello World"
    return (42 + x)

foreign export ccall
    hsfun :: CInt -> IO CInt

-- Wrapping up a Haskell object (and then unrwapping it )
data Wrapper = Wrap CInt

wrap :: CInt -> IO (StablePtr Wrapper)
wrap x = newStablePtr $ Wrap x

unwrap :: StablePtr Wrapper -> IO CInt
unwrap wrapped = do
  Wrap d <- deRefStablePtr wrapped
  return d

foreign export ccall
    wrap :: CInt -> IO (StablePtr Wrapper)

foreign export ccall
    unwrap :: StablePtr Wrapper -> IO CInt

-- Writing to memory
data ExampleStruct = ExampleStruct Int Int deriving (Eq, Show)

instance Storable ExampleStruct where
  alignment _ = alignment (undefined :: CDouble)
  sizeOf _ = 8
  peek p = do
      x <- peekByteOff p 0 ::IO CInt
      y <- peekByteOff p 4 ::IO CInt
      return $ ExampleStruct (fromIntegral x) (fromIntegral y)

  poke p (ExampleStruct x y) = do
      _x <- return x
      _y <- return y
      pokeByteOff p 0 _x
      pokeByteOff p 4 _y

gethsstruct :: CInt -> CInt -> IO (Ptr ExampleStruct)
gethsstruct x y = do
  let e = ExampleStruct (fromIntegral x) (fromIntegral y)
  p <- malloc
  poke p e
  return p

freehsstruct :: (Ptr ExampleStruct) -> IO ()
freehsstruct = free

getx :: (Ptr ExampleStruct) -> IO CInt
getx e = do
  (ExampleStruct x _) <- peek e
  return $ fromIntegral x

foreign export ccall
    gethsstruct :: CInt -> CInt -> IO (Ptr ExampleStruct)

foreign export ccall
    getx :: (Ptr ExampleStruct) -> IO CInt

foreign export ccall
    freehsstruct :: (Ptr ExampleStruct) -> IO ()


-- Convert array to list

gethslist :: IO (Ptr ExampleStruct)
gethslist = do
  let e = ExampleStruct (fromIntegral 10) (fromIntegral 30)
  let e10 = [e, e, e, e, e, e, e, e, e, e]
  p <- mallocArray 10
  pokeArray p e10
  return p

printlist :: (Ptr ExampleStruct) -> IO ()
printlist lst_e = do
  es <- peekArray 10 lst_e
  putStr "Blah: "
  putStr $ show es
  putStr "\n"


foreign export ccall
    gethslist :: IO (Ptr ExampleStruct)

foreign export ccall
    printlist :: (Ptr ExampleStruct) -> IO ()


-- Some string handling
hsstrlen :: CString -> IO CInt
hsstrlen str = do
  s <- peekCString str
  return $ fromIntegral $ length s

gethsstr :: IO CString
gethsstr = do
  newCString "hello world"

foreign export ccall
    hsstrlen :: CString -> IO CInt

foreign export ccall
    gethsstr :: IO CString

-- Something more substrantional

wc :: String -> IO Int
wc file = do
  contents <- readFile file
  return $ length $ words $ contents

export_wc :: CString -> IO CInt
export_wc file = do
  _file <- peekCString file
  _count <- wc _file
  return $ fromIntegral $ _count

foreign export ccall
        export_wc ::CString -> IO CInt
