# repl.vim

Open the interactive environment with the code you are writing.

## Ruby Example

You are writing the following code in an unnamed buffer.

    class C
      def self.f(x)
        x + 1
      end
    end

Now you want to try running the code in an interactive environment. Usually you are supposed to (1) save the code on somewhere, (2) open a terminal, (3) run `irb -r {the-file}`.

If you already installed quickinteractive.vim, you just have to run `:Repl` or to type `<space>i`. It opens a buffer that is the environment you wanted.

    irb>

You can do

    irb> C.f 23
    24
    irb>

## Haskell Example

    import Test.HUnit
    foo _ = (1, 2)
    test1 = TestCase (assertEqual "for (foo 3)," (1,2) (foo 3))
    tests = TestList [TestLabel "test1" test1]

Run `:Repl` without saving the code on a file.

    ghci> runTestTT tests

## Supports

* Ruby
* Haskell
* Erlang

## Installation

    $ jolt install repl.vim

will be available soon.

This plugin depends on quickrun, vimshell and their dependencies.

## Author

Tatsuhiro Ujihisa
