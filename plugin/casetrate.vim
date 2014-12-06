command! -nargs=1 -complete=customlist,casetrate#completeCases Casetrate call casetrate#setCase(<q-args>)
if exists('g:casetrate_leader')
    for s:case in ['camel', 'pascal', 'snake', 'upper', 'mixed', 'lisp']
        execute 'nnoremap ' . g:casetrate_leader . s:case[0] . ' :Casetrate ' . s:case . '<Cr>'
    endfor
endif
if exists('s:case') "It should exist, but I don't want to fail over something like that...
    unlet s:case
endif
