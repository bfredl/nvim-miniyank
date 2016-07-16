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

# clipboard=unnamed register type fixing!
Currently neovim doesn't have support for register types in the clipboard. This makes blockwise yanking and putting is broken when `clipboard=unnamed` or `unnamedplus` is used. When this option is set, and "p" is mapped to "autoput" mappings as suggested above, this plugin will try to _correct_ the register type when an unnamed paste is done. It uses heuristics that _at least_ will work if you yank blockwise and then immediately paste unnamed in the same or another nvim instance.

Of course, regardless if `clipboard=unnamed` is set or not, you can always do the correct paste using a "startPut" mapping, or cycling one step back in history when needed.

# FAQ

## It doesn't work!

make sure `$XDG_RUNTIME_DIR` is set to a directory that exists.

## How do I cycle backwards?

use `g-`

## It doesn't persist across reboots!

Sigh, just why? Okay, do

    let g:miniyank_filename = $HOME."/.miniyank.mpack"


