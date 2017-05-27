# nvim-miniyank

The killring-alike plugin with no default mappings.

# Usage

Use recent neovim. Yanks and deletes will be detected using `TextYankPost` autocommand, so no mappings for these actions are needed.
The yank history is shared between nvim instances.

There is two different mappings for starting to put from the history.
To remap `p`, "autoput" mapping should be used. This will first put the same text as unmapped "p" would have, and still support `"xp` and `clipboard=unnamed[plus]`:

    map p <Plug>(miniyank-autoput)
    map P <Plug>(miniyank-autoPut)

"startput" will directly put the most recent item in the shared history:

    map <leader>p <Plug>(miniyank-startput)
    map <leader>P <Plug>(miniyank-startPut)

Right after a put, use "cycle" to go back through history:

    map <leader>n <Plug>(miniyank-cycle)

Maybe the register type was wrong? Well, you can change it after putting:

    map <Leader>c <Plug>(miniyank-tochar)
    map <Leader>l <Plug>(miniyank-toline)
    map <Leader>b <Plug>(miniyank-toblock)

# clipboard=unnamed register type fixing
Currently neovim doesn't have support for register types in the clipboard. This makes blockwise yanking and putting broken when `clipboard=unnamed` or `unnamedplus` is used. When this option is set, and "p" is mapped to "autoput" mappings as suggested above, this plugin will try to _correct_ the register type when an unnamed paste is done. It uses heuristics that _at least_ will work if you yank blockwise and then immediately paste unnamed in the same or another nvim instance.

Of course, regardless if `clipboard=unnamed` is set or not, you can always do the correct paste using a "startPut" mapping, or cycling one step back in history when needed.

# Throttling of big unnamed deletes

The plugin tries to avoid unnecessary copying on unnamed deletes (`d` or `c` with no preceeding `"x`). Unnamed deletes with more than `g:miniyank_delete_maxlines` (default 1000) will be ignored. To force yanking, just add a register name, like `""d` or `"*d`.

# Denite source

If Denite is installed, the yank history can be displayed using `:Denite miniyank`

# FAQ

## It doesn't work!

make sure `$XDG_RUNTIME_DIR` is set to a directory that exists.

## Is python3 required?

Python is only required for the optional Denite source. The rest of the plugin is pure vimscript.

## How do I cycle backwards?

use `g-`

## 10 items? That is not close to be enough!

How about

    let g:miniyank_maxitems = 100

## It doesn't persist across reboots!

Sigh, just why? Okay, do

    let g:miniyank_filename = $HOME."/.miniyank.mpack"


