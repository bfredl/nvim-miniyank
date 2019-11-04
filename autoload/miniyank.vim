if has("nvim")
    let s:lua = v:false
else
    if !has("lua")
       finish
    endif
    let s:lua = v:true
    let s:plug_path = expand( '<sfile>:p:h:h')
    lua <<EOF
        package.path = package.path .. ';'.. vim.eval("expand( '<sfile>:p:h:h')")..'/lua/?.lua'
        miniyank = require'miniyank'
EOF
endif

function! miniyank#read() abort
    if !filereadable(g:miniyank_filename)
        return []
    end
    if s:lua
        return luaeval("miniyank.read(_A)",g:miniyank_filename)
    end
    return msgpackparse(readfile(g:miniyank_filename, 'b'))
endfunction

function! miniyank#write(data) abort
    if s:lua
        return luaeval("miniyank.write(_A[0], _A[1])",[g:miniyank_filename,a:data])
    end
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

function! miniyank#parse_cb() abort
    let parts = split(&clipboard, ',')
    let cbs = ''
    if index(parts, "unnamed") >= 0
        let cbs = cbs.'*'
    endif
    if index(parts, "unnamedplus") >= 0
        let cbs = cbs.'+'
    endif
    return cbs
endfunction

function! miniyank#on_yank(ev) abort
    if len(a:ev.regcontents) == 1 && len(a:ev.regcontents[0]) <= 1
        return
    end
    " avoid expensive copying on delete unless yanking to a register was
    " explcitly requested
    if a:ev.operator != 'y' && a:ev.regname == '' && len(a:ev.regcontents) > g:miniyank_delete_maxlines
        return
    end
    let state = miniyank#read()
    if a:ev.regname == ''
        let a:ev.regname = miniyank#parse_cb()
    endif
    call miniyank#add_item(state, [a:ev.regcontents, a:ev.regtype, a:ev.regname])
    call miniyank#write(state)
endfunction

" TODO: this should be a nvim builtin
function! miniyank#putreg(data,cmd) abort
    let regsave = [getreg('0'), getregtype('0')]
    call setreg('0', a:data[0], a:data[1])
    execute 'normal! '.(s:visual ? 'gv' : '').s:count.'"0'.a:cmd
    call setreg('0', regsave[0], regsave[1])
    let s:last = a:data[0]
endfunction

" work-around nvim:s lack of register types in clipboard
" only use this when clipboard=unnamed[plus]
" otherwise you are expected to use startput
function! miniyank#fix_clip(list, pasted) abort
    if !has("nvim")
        return v:false
    end
    if stridx('*+', a:pasted[2]) < 0 || miniyank#parse_cb() ==# '' || len(a:list) == 0
        return v:false
    endif
    let last = a:list[0]
    if stridx(last[2], a:pasted[2]) < 0
        return v:false
    endif
    if last[1] ==# 'v' && len(last[0]) >= 2 && last[0][-1] == ''
        " this would been had missinterpreted as a line, but is a charwise
        return a:pasted[1] == 'V' && a:pasted[0] ==# last[0][:-2]
    endif
    return a:pasted[1] ==# 'V' && a:pasted[0] ==# last[0]
endfunction

let s:changedtick = -1

" TODO: put autocommand plz
function! miniyank#startput(cmd,defer) abort
    if mode(1) ==# "no"
        return a:cmd " don't override diffput
    end
    let s:pastelist = miniyank#read()
    let s:pos = 0
    let s:cmd = a:cmd
    let s:visual = index(["v","V","\026"], mode()) >= 0
    let s:count = string(v:count1)
    if a:defer
        let first = [getreg(v:register,0,1), getregtype(v:register), v:register]
        if !miniyank#fix_clip(s:pastelist, first)
            call miniyank#add_item(s:pastelist, first)
        endif
    end
    return ":\<c-u>call miniyank#do_putlist()\015"
endfunction

function! miniyank#cycle(dir) abort
    if s:changedtick != b:changedtick
        return
    end
    if a:dir > 0 " forward
      if s:pos+a:dir >= len(s:pastelist)
          echoerr "miniyank: no more items!"
          return
      endif
    elseif a:dir < 0 " backward
      if s:pos+a:dir < 0
          echoerr "miniyank: no previous items!"
          return
      endif
    end
    let s:pos += a:dir
    silent undo
    call miniyank#do_putlist()
endfunction

function! miniyank#do_putlist() abort
    call miniyank#putreg(s:pastelist[s:pos],s:cmd)
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

" FIXME: integrate with the rest
function! miniyank#drop(data,cmd) abort
    let s:pastelist = [a:data]
    let s:pos = 0
    let s:visual = ''
    let s:count = 1
    let s:cmd = a:cmd
    " why not putreg??
    call miniyank#do_putlist()
endfunction
