let s:classFileExtensions = ["component.ts"]
let s:templateFileExtensions = ["component.html", "html"]
let s:stylesFileExtensions = ["component.less", "less"]

function! s:GetComponentFilenameWithExtension(commonFilename, fileExtensions)
    for extension in a:fileExtensions
        let fileNameWithExtension = a:commonFilename . "." . extension
        if filereadable(fileNameWithExtension)
            return fileNameWithExtension
        endif
    endfor
    return a:commonFilename . "." . a:fileExtensions[0]
endfunction

function! s:SingleComponentFileOpen()
    if !filereadable(expand("%"))
        return 0
    endif

    " if there is some other readable file open in the current window
    let currFileBufNr = bufnr("%")
    for bufnr in tabpagebuflist()
        if bufnr != currFileBufNr && filereadable(bufname(bufnr))
            return 0
        endif
    endfor

    return 1
endfunction

" Opens the component files tiled like so:
" +-------------------------+
" |              |          |
" |    <html>    |          |
" |              |          |
" |--------------+   <ts>   |
" |              |          |
" |  <css/less>  |          |
" |              |          |
" +-------------------------+
function! s:OpenComponentFilesCircularTiling()
    let commonFilename = substitute(expand("%"), "\\..*$", "", "g")

    let componentFilename = s:GetComponentFilenameWithExtension(commonFilename, s:classFileExtensions)
    let styleFilename = s:GetComponentFilenameWithExtension(commonFilename, s:stylesFileExtensions)
    let templateFilename = s:GetComponentFilenameWithExtension(commonFilename, s:templateFileExtensions)

    let alreadyOpenFilename = expand("%")

    if componentFilename ==# alreadyOpenFilename
        execute "vertical leftabove split " . styleFilename
        execute "leftabove split " . templateFilename
    elseif styleFilename ==# alreadyOpenFilename
        execute "leftabove split " . templateFilename
        execute "vertical botright split " . componentFilename
    else
        execute "rightbelow split " . styleFilename
        execute "vertical botright split " . componentFilename
    endif
endfunction

" Opens the component files, stacked horizontally in no paticular order
function! s:OpenComponentFilesStacked()
    echom "Opening the files"
endfunction

function! s:TglNg2OpenComponentFiles()
    if s:SingleComponentFileOpen()
        call s:OpenComponentFilesCircularTiling()
    else
        call s:OpenComponentFilesStack()
    endif
endfunction

" Public commands
command! TglNg2OpenComponent call s:TglNg2OpenComponentFiles()
