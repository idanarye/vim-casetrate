INTRODUCTION
============

Casetrate is a plugin for changing the case of identifiers. It can change
the case to camelCase, PascalCase, snake_case, UPPER_CASE or Mixed_Case. In
addition, in 'lisp' buffers it can change identifiers' case to lisp-case.


USAGE
=====

Use the `:Casetrate` command to change the case of the word under the cursor.
:Casetrate's argument must be one of the following:

* "camel"  - Change the word under the cursor to camelCase.
* "pascal" - Change the word under the cursor to PascalCase.
* "snake"  - Change the word under the cursor to snake_case.
* "upper"  - Change the word under the cursor to UPPER_CASE.
* "mixed"  - Change the word under the cursor to Mixed_Case.
* "lisp"   - Change the word under the cursor to lisp-case(only works in
             'lisp' mode).

KEYMAPS
=======

If you want Casetrate to create keymaps, you must set `g:casetrate_leader` to
a prefix of your choice in your |vimrc|. For example, if you set it to:
```vim
let g:casetrate_leader = '\c'
```
You'll get the colloring keymaps:

* `\cc` - `:Casetrate camel`
* `\cp` - `:Casetrate pascal`
* `\cs` - `:Casetrate snake`
* `\cu` - `:Casetrate upper`
* `\cm` - `:Casetrate mixed`
* `\cl` - `:Casetrate lisp`
