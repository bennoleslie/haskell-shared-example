-- From: http://weblog.haskell.cz/pivnik/building-a-shared-library-in-haskell/

{-# LANGUAGE ForeignFunctionInterface #-}
module Test where

import Foreign.C.Types
 
hsfun :: CInt -> IO CInt
hsfun x = do
    putStrLn "Hello World"
    return (42 + x)

foreign export ccall
    hsfun :: CInt -> IO CInt
