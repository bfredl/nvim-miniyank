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

augroup MiniYank
    au! TextYankPost * call miniyank#on_yank(v:event)
augroup END

noremap <silent> <Plug>(miniyank-startput) :<c-u>call miniyank#startput("p",0)<cr>
noremap <silent> <Plug>(miniyank-startPut) :<c-u>call miniyank#startput("P",0)<cr>
noremap <silent> <Plug>(miniyank-autoput) :<c-u>call miniyank#startput("p",1)<cr>
noremap <silent> <Plug>(miniyank-autoPut) :<c-u>call miniyank#startput("P",1)<cr>
noremap <silent> <Plug>(miniyank-cycle) :<c-u>call miniyank#cycle()<cr>

noremap <silent> <Plug>(miniyank-tochar) :<c-u>call miniyank#force_motion('v')<cr>
noremap <silent> <Plug>(miniyank-toline) :<c-u>call miniyank#force_motion('V')<cr>
noremap <silent> <Plug>(miniyank-toblock) :<c-u>call miniyank#force_motion('b')<cr>
