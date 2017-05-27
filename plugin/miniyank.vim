if !exists('##TextYankPost')
    finish
endif

if !has_key(g:,"miniyank_filename")
    if exists('$XDG_RUNTIME_DIR')
        let g:miniyank_filename = $XDG_RUNTIME_DIR."/miniyank.mpack"
    else
        let g:miniyank_filename = "/tmp/".$USER."_miniyank.mpack"
    endif
endif

if !has_key(g:,"miniyank_maxitems")
    let g:miniyank_maxitems = 10
endif

if !has_key(g:,"miniyank_delete_maxlines")
    let g:miniyank_delete_maxlines = 1000
endif

augroup MiniYank
    au! TextYankPost * call miniyank#on_yank(copy(v:event))
augroup END

noremap <silent> <expr> <Plug>(miniyank-startput) miniyank#startput("p",0)
noremap <silent> <expr> <Plug>(miniyank-startPut) miniyank#startput("P",0)
noremap <silent> <expr> <Plug>(miniyank-autoput) miniyank#startput("p",1)
noremap <silent> <expr> <Plug>(miniyank-autoPut) miniyank#startput("P",1)
noremap <silent> <Plug>(miniyank-cycle) :<c-u>call miniyank#cycle()<cr>

noremap <silent> <Plug>(miniyank-tochar) :<c-u>call miniyank#force_motion('v')<cr>
noremap <silent> <Plug>(miniyank-toline) :<c-u>call miniyank#force_motion('V')<cr>
noremap <silent> <Plug>(miniyank-toblock) :<c-u>call miniyank#force_motion('b')<cr>
