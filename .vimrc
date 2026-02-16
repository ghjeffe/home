" On pressing tab, insert 2 spaces
set expandtab

" Show existing tab with 2 spaces width
set tabstop=2
set softtabstop=2

" When indenting with '>', use 2 spaces width
set shiftwidth=2

set smartindent
set autoindent

set runtimepath+=~/.vim_runtime
set number "add line numbers
set relativenumber "use offset numbers above and below current line for easier line navigation
set smartcase "case insensitive unless capital letters are used in search
set ignorecase "necessary to make smartcase work as expected

" Display filename
set laststatus=2 " Always show the last status line (0: never, 1: only with multiple windows, 2: always)
set statusline=%F " Display full file path

let &t_SI = "\e[5 q"   " cursor in insert mode
let &t_EI = "\e[2 q"   " cursor in normal mode
let &t_SR = "\e[3 q"   " cursor in replace mode
let &t_ti .= "\e[2 q"  " cursor when vim starts
let &t_te .= "\e[3 q"  " cursor when vim exits

"source ~/.vim_runtime/vimrcs/basic.vim
"source ~/.vim_runtime/vimrcs/filetypes.vim
"source ~/.vim_runtime/vimrcs/plugins_config.vim
"source ~/.vim_runtime/vimrcs/extended.vim

try
source ~/.vim_runtime/my_configs.vim
catch
endtry
