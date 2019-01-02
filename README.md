# nvim-miniyank

The killring-alike plugin with no default mappings.

Works in neovim, as well as vim with lua enabled and patch 8.0.1394.

# Usage

Yanks and deletes will be detected using `TextYankPost` autocommand, so no mappings for these actions are needed.
The yank history is shared between [n]vim instances.

There is two different mappings for starting to put from the history.
To remap `p`, "autoput" mapping should be used. This will first put the same text as unmapped "p" would have, and still support `"xp` and `clipboard=unnamed[plus]`:

    map p <Plug>(miniyank-autoput)
    map P <Plug>(miniyank-autoPut)

"startput" will directly put the most recent item in the shared history:

    map <leader>p <Plug>(miniyank-startput)
    map <leader>P <Plug>(miniyank-startPut)

Right after a put, use "cycle" to go through history:

    map <leader>n <Plug>(miniyank-cycle)

Stepped too far? You can cycle back to more recent items using:

    map <leader>N <Plug>(miniyank-cycleback)

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

## Does it work in vim 8?

Yes, if lua is enabled and with vim 8.1 or later. (Lua is not really intrinsically needed. One day I might implement the small necessary subset of msgpack directly in vimL.)

## It doesn't work!

This plugin tries to autodetect a suitable file path for the shared yankring. `$XDG_RUNTIME_DIR` is used if set, otherwise  `stdpath('cache')` will be used. Check that `g:miniyank_filename` was set to a location that is both readable and writeable by your user account. If not, either fix your environment, or override it manually:


    let g:miniyank_filename = $HOME."/.miniyank.mpack"



## Is python3 required?

Python is only required for the optional Denite source. The rest of the plugin is pure vimscript.

## 10 items? That is not close to be enough!

How about

    let g:miniyank_maxitems = 100

## It doesn't persist across reboots!

Sigh, just why? Okay, do

    let g:miniyank_filename = $HOME."/.miniyank.mpack"


