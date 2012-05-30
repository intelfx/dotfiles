" ///////// Vim colorscheme /////////" 
"   Name:     darkmirror
"   Author:   Alex Sanchez (kniren)
"   Email:    kniren@gmail.com
" ///////////////////////////////////" 
"
" ///////////////////////////////////////////////////////" 
"
"       .:::::                     .::     
"       .::   .::                  .::     
"       .::    .::   .::    .: .:::.::  .::
"       .::    .:: .::  .::  .::   .:: .:: 
"       .::    .::.::   .::  .::   .:.::   
"       .::   .:: .::   .::  .::   .:: .:: 
"       .:::::      .:: .:::.:::   .::  .::
"
"   .::       .::                                  
"   .: .::   .::: .:                               
"   .:: .:: . .::   .: .:::.: .:::   .::    .: .:::
"   .::  .::  .::.:: .::    .::    .::  .::  .::   
"   .::   .:  .::.:: .::    .::   .::    .:: .::   
"   .::       .::.:: .::    .::    .::  .::  .::   
"   .::       .::.::.:::   .:::      .::    .:::   
"
" ///////////////////////////////////////////////////////" 
                                   
" //////////// URxvt Colors ////////////" 
"
    "*foreground: #DDDDDD
    "*background: #050505
    "!black
    "*color0: #393939
    "*color8: #121212
    "!red
    "*color1: #da4939
    "*color9: #ff6c5c
    "!green
    "*color2: #509F7E
    "*color10: #61C29A
    "!yellow
    "*color3: #cc7833
    "*color11: #bc9458
    "!blue
    "*color4: #6d9cbe
    "*color12: #d0d0ff
    "!magenta
    "*color5: #9966D9
    "*color13: #9954DE
    "!cyan
    "*color6: #435d75
    "*color14: #6e98a4
    "!white
    "*color7: #dedede
    "*color15: #dddddd

" //////////////////////////////////////" 

set background=dark
hi clear
if exists("syntax on")
    syntax reset
endif

let g:color_name="darkmirror"

" Normal colors
hi Normal          ctermfg=7
hi Ignore          ctermfg=0
hi Comment         ctermfg=0 
hi LineNr          ctermfg=0
hi CursorLine                   ctermbg=8       cterm=none
hi CursorLineNr                 ctermbg=8       cterm=none
hi ColorColumn                  ctermbg=8
hi VertSplit       ctermfg=8    ctermbg=none    cterm=none 
hi Float           ctermfg=1
hi Include         ctermfg=3
hi Define          ctermfg=3
hi Macro           ctermfg=3
hi PreProc         ctermfg=2
hi PreCondit       ctermfg=3
hi NonText         ctermfg=0
hi Directory       ctermfg=6
hi SpecialKey      ctermfg=11
hi Type            ctermfg=3
hi String          ctermfg=2
hi Constant        ctermfg=9
hi Special         ctermfg=10
hi SpecialChar     ctermfg=9
hi Number          ctermfg=9
hi Identifier      ctermfg=2
hi Conditional     ctermfg=14
hi Repeat          ctermfg=4
hi Statement       ctermfg=3
hi label           ctermfg=7
hi operator        ctermfg=3
hi keyword         ctermfg=7  
hi StorageClass    ctermfg=3 
hi Structure       ctermfg=14
hi Typedef         ctermfg=2
hi Function        ctermfg=11
hi Exception       ctermfg=2
hi Underlined      ctermfg=8
hi Title           ctermfg=8  
hi Tag             ctermfg=8
hi Delimiter       ctermfg=1  
hi SpecialComment  ctermfg=0
hi Boolean         ctermfg=1
hi Todo            ctermfg=11
hi MoreMsg         ctermfg=15
hi ModeMsg         ctermfg=7
hi Debug           ctermfg=1
hi MatchParen      ctermfg=8     ctermbg=7
hi ErrorMsg        ctermfg=7     ctermbg=1
hi WildMenu        ctermfg=5     ctermbg=15
hi Folded          ctermfg=3     ctermbg=none
hi IncSearch       ctermfg=0     ctermbg=3
hi Search          ctermfg=0     ctermbg=15
hi WarningMsg      ctermfg=9     ctermbg=15
hi Question        ctermfg=7     ctermbg=none
hi Pmenu           ctermfg=0     ctermbg=8
hi PmenuSel        ctermfg=8    
hi Visual          ctermfg=8     ctermbg=15
hi StatusLine      ctermfg=15    ctermbg=0
hi StatusLineNC    ctermfg=8     ctermbg=0

" Diff lines
hi DiffLine        ctermfg=6     ctermbg=none
hi DiffText        ctermfg=15
hi DiffAdd         ctermfg=2     ctermbg=none
hi DiffChange      ctermfg=3     ctermbg=none
hi DiffRemoved     ctermfg=1

" Spell checking
if version >= 700
  hi clear SpellBad
  hi clear SpellCap
  hi clear SpellRare
  hi clear SpellLocal
  hi SpellBad      cterm=underline
  hi SpellCap      cterm=underline
  hi SpellRare     cterm=underline
  hi SpellLocal    cterm=underline
endif

" Python
hi pythonString    ctermfg=2
hi pythonFunction  ctermfg=7

" HTML
hi htmlHead        ctermfg=7
hi htmlTitle       ctermfg=7

" NERDTree
hi NERDTreeRO      ctermfg=2     ctermbg=none
hi NERDTreeToggleOn              ctermbg=none
hi NERDTreeToggleOff             ctermbg=none
hi NERDTreeExecFile ctermfg=2             ctermbg=none

" Markdown
hi markdownH1      ctermfg=2 
hi markdownH2      ctermfg=2 
hi markdownH3      ctermfg=2 
hi markdownH4      ctermfg=2 
hi markdownHeadingDelimiter ctermfg=2
hi markdownLinkText ctermfg=3 
