-- From: http://weblog.haskell.cz/pivnik/building-a-shared-library-in-haskell/

{-# LANGUAGE ForeignFunctionInterface #-}
module Test where

import Foreign.C.Types
import Foreign.StablePtr
 
hsfun :: CInt -> IO CInt
hsfun x = do
    putStrLn "Hello World"
    return (42 + x)


--extract :: Example -> CInt
--extract (Foo x) = x

data Wrapper = Wrap CInt

wrap :: CInt -> IO (StablePtr Wrapper)
wrap x = newStablePtr $ Wrap x

unwrap :: StablePtr Wrapper -> IO CInt
unwrap wrapped = do
  Wrap d <- deRefStablePtr wrapped
  return d

foreign export ccall
    hsfun :: CInt -> IO CInt

foreign export ccall
    wrap :: CInt -> IO (StablePtr Wrapper)

foreign export ccall
    unwrap :: StablePtr Wrapper -> IO CInt
