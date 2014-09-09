llvm-tutorial-standalone
------------------------

A simple LLVM builder DSL in a Haskell DSL. Basically the same code as the [Haskell Kaleidoscope
tutorial](http://www.stephendiehl.com/llvm/) uses but without going through an AST. Multiple people asked for
this to be extracted. If you want to roll a LLVM compiler backend this might be a good starting point.

```haskell
initModule :: AST.Module
initModule = emptyModule "my cool jit"

logic = do
  define double "main" [] $ do
    let a = cons $ C.Float (F.Double 10)
    let b = cons $ C.Float (F.Double 20)
    res <- fadd a b
    ret res

main = do
  let ast = runLLVM initModule logic
  runJIT ast
  return ast
```

This will generate and JIT compile into the following IR:

```llvm
; ModuleID = 'my cool jit'

define double @main() {
entry:
  %1 = fadd double 1.000000e+01, 2.000000e+01
  ret double %1
}
```

**Why isn't this on Hackage?**

The dependencies all require static linking against LLVM which has a reckless diregard for backwards
compatability. Because the system packages involved are not managed by cabal, unless something like NixOS is
used, it's unlikely that ``cabal install`` would ever behave the same on two different systems. The linker
behavior also differs even between different versions of GHC.

I'll suggest the following versions which track the NixOS versions, but your mileage may vary.

* ghc 7.8.3
* llvm-3.4.1 
* llvm-general 3.4.4.0
* llvm-general-pure 3.4.4.0

License
-------

Released under the MIT License.
Copyright (c) 2014, Stephen Diehl
