function! miniyank#read() abort
    if !filereadable(g:miniyank_filename)
        return []
    end
    return msgpackparse(readfile(g:miniyank_filename, 'b'))
endfunction

function! miniyank#write(data) abort
    call writefile(msgpackdump(a:data), g:miniyank_filename, 'b')
endfunction

function! miniyank#add_item(list, item) abort
    for n in range(len(a:list))
        if a:list[n][:1] ==# a:item[:1]
            call remove(a:list, n)
            break
        endif
    endfor
    call insert(a:list, a:item, 0)
    if len(a:list) > g:miniyank_maxitems
        call remove(a:list, g:miniyank_maxitems, -1)
    endif
    return a:list
endfunction

function! miniyank#on_yank(event) abort
    if len(a:event.regcontents) == 1 && len(a:event.regcontents[0]) == 1
        return
    end
    let state = miniyank#read()
    call miniyank#add_item(state, [a:event.regcontents, a:event.regtype, a:event.regname])
    call miniyank#write(state)
endfunction

" TODO: this should be a nvim builtin
function! miniyank#putreg(data,cmd) abort
    let regsave = [getreg('0'), getregtype('0')]
    call setreg('0', a:data[0], a:data[1])
    execute 'normal! '.(s:visual ? 'gv' : '').'"0'.a:cmd
    call setreg('0', regsave[0], regsave[1])
    let s:last = a:data[0]
endfunction

let s:changedtick = -1

" TODO: put autocommand plz
function! miniyank#startput(cmd,defer) abort
    let s:pastelist = miniyank#read()
    let s:cmd = a:cmd
    let s:visual = index(["v","V","\026"], mode()) >= 0
    if a:defer
        let first = [getreg(v:register,1,1), getregtype(v:register), v:register]
        call miniyank#add_item(s:pastelist, first)
    end
    return ":call miniyank#do_putnext()\015"
endfunction

function! miniyank#cycle() abort
    if s:changedtick != b:changedtick
        return
    end
    silent undo
    call miniyank#do_putnext()
endfunction

function! miniyank#do_putnext() abort
    if s:pastelist == []
        echoerr "miniyank: no more items!"
        return
    endif
    call miniyank#putreg(remove(s:pastelist,0),s:cmd)
    let s:changedtick = b:changedtick
endfunction

function! miniyank#force_motion(motion) abort
    if s:changedtick != b:changedtick
        return
    end
    silent undo
    call miniyank#putreg([s:last, a:motion], s:cmd)
    let s:changedtick = b:changedtick
endfunction
