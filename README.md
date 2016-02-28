# nvim-miniyank

The killring-alike plugin with no default mappings.

# Usage

Use neovim with [#4304](https://github.com/neovim/neovim/pull/4304).

Map for instance

    map <leader>p <Plug>(miniyank-startput)
    map <leader>P <Plug>(miniyank-startPut)

or if you want to remap `p` but still support `"xp`

    map p <Plug>(miniyank-autoput)
    map P <Plug>(miniyank-autoPut)

and to cycle

    map <leader>n <Plug>(miniyank-cycle)

Maybe the register type was wrong? Well, you can change it right after paste:

    map <Leader>c <Plug>(miniyank-tochar)
    map <Leader>l <Plug>(miniyank-toline)
    map <Leader>b <Plug>(miniyank-toblock)

# FAQ

## It doesn't work!

make sure `$XDG_RUNTIME_DIR` is set to a directory that exists.

## How do I cycle backwards?

use `g-`

## It doesn't persist across reboots!

Sigh, just why? Okay, do

    let g:miniyank_filename = $HOME."/.miniyank.mpack"


