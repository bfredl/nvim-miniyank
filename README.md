# nvim-miniyank

The killring-alike plugin with no default mappings.

# Usage

Use neovim master.

Startput mapping is used to start putting from the yank history, which is shared between nvim instances:

    map <leader>p <Plug>(miniyank-startput)
    map <leader>P <Plug>(miniyank-startPut)

If you want to remap `p` it is better to use "autoput", which will always first put the text that nonremapped "p" would have anyway, and thus still support `"xp` and `clipboard=unnamed[plus]`:

    map p <Plug>(miniyank-autoput)
    map P <Plug>(miniyank-autoPut)

Right after a put, use "cycle" to go back through history:

    map <leader>n <Plug>(miniyank-cycle)

Maybe the register type was wrong? Well, you can change it after putting:

    map <Leader>c <Plug>(miniyank-tochar)
    map <Leader>l <Plug>(miniyank-toline)
    map <Leader>b <Plug>(miniyank-toblock)

# clipboard=unnamed register type fixing!
Currently neovim doesn't have support for register types in the clipboard. This makes blockwise yanking and putting broken when `clipboard=unnamed` or `unnamedplus` is used. When this option is set, and "p" is mapped to "autoput" mappings as suggested above, this plugin will try to _correct_ the register type when an unnamed paste is done. It uses heuristics that _at least_ will work if you yank blockwise and then immediately paste unnamed in the same or another nvim instance.

Of course, regardless if `clipboard=unnamed` is set or not, you can always do the correct paste using a "startPut" mapping, or cycling one step back in history when needed.

# FAQ

## It doesn't work!

make sure `$XDG_RUNTIME_DIR` is set to a directory that exists.

## How do I cycle backwards?

use `g-`

## It doesn't persist across reboots!

Sigh, just why? Okay, do

    let g:miniyank_filename = $HOME."/.miniyank.mpack"


