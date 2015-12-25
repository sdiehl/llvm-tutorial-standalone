{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ForeignFunctionInterface #-}

import JIT
import Codegen
import qualified LLVM.General.AST as AST
import qualified LLVM.General.AST.Float as F
import qualified LLVM.General.AST.Constant as C

import Foreign.C.Types

{-

; ModuleID = 'my cool jit'

declare void @myfunc(i64)

define void @main() {
entry:
  call void @myfunc(i64 5)
  ret void
}

-}

foreign import ccall safe "myfunc" myfunc
    :: CInt -> IO ()

initModule :: AST.Module
initModule = emptyModule "my cool jit"

example :: LLVM ()
example = do
  external void "myfunc" [(AST.IntegerType 64, "count")]
  define void "main" [] $ do
    let a = cons $ C.Int 64 5
    call (externf AST.VoidType "myfunc") [a]
    retvoid

main :: IO AST.Module
main = do
  let ast = runLLVM initModule example
  rc <- runJIT ast
  return ast
