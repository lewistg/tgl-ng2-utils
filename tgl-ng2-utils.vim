function! TglNg2OpenComponentFiles()
    let commonFilename = substitute(expand("%"), "\\..*$", "", "g")

    let componentFilename = commonFilename . ".component.ts"
    let styleFilename = commonFilename . ".less"
    let templateFilename = commonFilename . ".html"

    let alreadyOpenFilename = expand("%")

    if winnr("$") == 1 " if there is a single window open
        if componentFilename ==# alreadyOpenFilename
            execute "vertical topleft split " . styleFilename
            execute "aboveleft split " . templateFilename
        elseif styleFilename ==# alreadyOpenFilename
            execute "topleft split " . templateFilename
            execute "vertical botright split " . componentFilename
        else
            execute "botright split " . styleFilename
            execute "vertical botright split " . componentFilename
        endif
    else
        " open the files into horizontal splits
    endif
endfunction
