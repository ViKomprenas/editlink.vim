" Edit a file through a symbolic link
" Maintainer: Viko <viko@vikomprenas.com>
" License: This file is in the public domain (Creative Commons Zero)

if exists("g:loaded_editlink")
    finish
endif
let g:loaded_editlink = 1

let s:cpo = &cpo
set cpo&vim

func! <SID>edit_symlink(bang)
    if &modified && !a:bang
        " can't trigger actual vim errors? ok! fake it 'til ya make it!
        echohl  Error
        echomsg "E37: No write since last change (add ! to override)"
        echohl  None
    else
        let l:new_file = resolve(expand('%'))

        " We need to wipe out the original buffer because otherwise, vim
        " correctly notices that it's the same file, and incorrectly decides
        " to just reuse the old buffer. We use a :enew buffer briefly to
        " preserve the window layout (so long as there's only one window into
        " this buffer, anyway... if there are multiple, all but one die.
        " TODO: fix that)

        let l:original_bufnr = bufnr('%')
        let l:cursor = getcurpos()
        silent enew
        silent execute l:original_bufnr . 'bwipeout'
        silent execute 'edit' l:new_file
        call setpos('.', l:cursor)
        normal zv
    endif
endfunc
command! -bar -bang EditLink call <SID>edit_symlink("<bang>" == "!")

let &cpo = s:cpo
unlet s:cpo
