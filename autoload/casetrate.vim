let s:nonAlphanumericCharacters = '_+*=.-'

function! casetrate#isUpperCase(char)
    return 'A' < a:char && a:char < 'Z'
endfunction

function! casetrate#capitalize(word)
    return toupper(a:word[0]) . tolower(a:word[1:])
endfunction

function! casetrate#splitToWords(identifier)
    let l:result = []
    let l:wordStart = 0
    for l:i in range(1, len(a:identifier) - 1)
        let l:char = a:identifier[l:i]
        let l:prevChar = a:identifier[l:i - 1]
        if '_' == l:prevChar || '-' == l:prevChar
            let l:wordStart = l:i
        elseif '_' == l:char || '-' == l:char
            call add(l:result, a:identifier[l:wordStart : l:i - 1])
            let l:wordStart = l:i
        elseif casetrate#isUpperCase(l:char) && !casetrate#isUpperCase(l:prevChar)
            call add(l:result, a:identifier[l:wordStart : l:i - 1])
            let l:wordStart = l:i
        endif
    endfor
    call add(l:result, a:identifier[l:wordStart :])
    return map(l:result, 'tolower(v:val)')
endfunction

function! s:joinCamel(words)
    "Capitalize all words but the first
    return join(map(copy(a:words), '0 < v:key ? casetrate#capitalize(v:val) : v:val'), '')
endfunction

function! s:joinPascal(words)
    "Capitalize all words
    return join(map(copy(a:words), 'casetrate#capitalize(v:val)'), '')
endfunction

function! s:joinSnake(words)
    "Downcase all words, join with underscores
    return join(map(copy(a:words), 'tolower(v:val)'), '_')
endfunction

function! s:joinUpper(words)
    "Upcase all words, join with underscores
    return join(map(copy(a:words), 'toupper(v:val)'), '_')
endfunction

function! s:joinMixed(words)
    "Capitalize all words, join with underscores
    return join(map(copy(a:words), 'casetrate#capitalize(v:val)'), '_')
endfunction

function! s:joinLisp(words)
    if !&lisp
        throw 'Lisp mode disabled'
    endif
    "Downcase all words, join with minus
    return join(map(copy(a:words), 'tolower(v:val)'), '-')
endfunction

function! s:join(words, targetCase)
    let l:functionName = 's:join' . casetrate#capitalize(a:targetCase)
    if exists('*' . l:functionName)
        return function(l:functionName)(a:words)
    else
        throw 'Unknown case ' . a:targetCase
    endif
endfunction

function! casetrate#changeCase(identifier, targetCase)
    let l:prefixIdentifierPostfix = matchlist(a:identifier, '\v^([' . s:nonAlphanumericCharacters . ']*)(.*[^_-])([' . s:nonAlphanumericCharacters . ']*)$')
    if empty(l:prefixIdentifierPostfix)
        return a:identifier
    end
    let l:prefix = l:prefixIdentifierPostfix[1]
    let l:identifier = l:prefixIdentifierPostfix[2]
    let l:postfix = l:prefixIdentifierPostfix[3]
    let l:words = casetrate#splitToWords(l:identifier)
    return l:prefix . s:join(l:words, a:targetCase) . l:postfix
endfunction

function! casetrate#setCase(targetCase)
    let l:word = expand('<cword>')
    let l:line = getline('.')
    for l:i in range(col('.') - len(l:word), col('.') + len(l:word))
        let l:wordHere = l:line[l:i : l:i + len(l:word) - 1]
        if l:word == l:wordHere
            let l:wordStartIndex = l:i
            break
        endif
    endfor
    let l:posInWord = col('.') - l:wordStartIndex - 1

    let l:alphaNumericCharactersBefore = 0
    for l:i in range(l:posInWord + 1)
        if l:word[l:i] =~ '[^' . s:nonAlphanumericCharacters . ']'
            let l:alphaNumericCharactersBefore += 1
        endif
    endfor

    let l:newWord = casetrate#changeCase(l:word, a:targetCase)
    let l:posInNewWord = 0
    for l:i in range(len(l:newWord))
        if l:newWord[l:i] =~ '[^' . s:nonAlphanumericCharacters . ']'
            let l:alphaNumericCharactersBefore -= 1
        endif
        if l:alphaNumericCharactersBefore <= 0
            break
        endif
        let l:posInNewWord += 1
    endfor

    if 0 < l:wordStartIndex
        let l:beforeWord = l:line[: l:wordStartIndex - 1]
    else
        let l:beforeWord = ''
    endif
    let l:afterWord = l:line[l:wordStartIndex + len(l:word) :]

    let l:newLine = l:beforeWord . l:newWord . l:afterWord
    call setline('.', l:newLine)
    call cursor(0, l:wordStartIndex + l:posInNewWord + 1)
endfunction

function! casetrate#completeCases(argLead, cmdLine, cursorPos)
    let l:cases = ['camel', 'pascal', 'snake', 'upper', 'mixed']
    if &lisp
        call add(l:cases, 'lisp')
    endif
    if empty(a:argLead)
        return l:cases
    else
        return filter(l:cases, 'v:val[: len(a:argLead) - 1] == a:argLead')
    endif
endfunction
