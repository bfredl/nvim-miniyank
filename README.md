# nvim-miniyank

The killring-alike plugin with no default mappings.

# Usage

Use neovim master.

Map for instance

    map <leader>p <Plug>(miniyank-startput)
    map <leader>P <Plug>(miniyank-startPut)

or if you want to remap `p` but still support `"xp`

    map p <Plug>(miniyank-autoput)
    map P <Plug>(miniyank-autoPut)

and right after paste cycle through history:

    map <leader>n <Plug>(miniyank-cycle)

Maybe the register type was wrong? Well, you can change it after paste:

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


