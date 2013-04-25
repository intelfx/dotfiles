# ------------------------------------------------------------------
#
#     .zshrc 
#     Author: Alex Sánchez <kniren@gmail.com>
#     Source: https://github.com/kniren/dotfiles/blob/master/.zshrc
#
# ------------------------------------------------------------------
# ---------------------------------------------------------------------
# Basic options --¬
# ---------------------------------------------------------------------
DISABLE_AUTO_UPDATE="true"
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="prompto"
setterm -bfreq 0
# -¬
# ---------------------------------------------------------------------
# Exports --¬
# ---------------------------------------------------------------------
export EDITOR=vim
export NOTEDIR=~/.notes/
export NETHACKOPTIONS="autoquiver,!autopickup,name:Alex,DECgraphics,color,race:human,showexp,hilite_pet"
export JAVA_FONTS=/usr/share/fonts/TTF
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'
export PATH=$PATH:~/Scripts
export PATH=$PATH:~/Scripts/peat
export PATH=$PATH:~/Scripts/mail
export PATH=$PATH:~/Scripts/tmux
export PATH=$PATH:~/.gem/ruby/2.0.0/bin
export PATH=$PATH:~/.cabal/bin
# -¬
# ---------------------------------------------------------------------
# Linux terminal colors --¬
# ---------------------------------------------------------------------
if [[ "$TERM" = "linux" ]]; then

    echo -en "\e]P0050505"
    echo -en "\e]P8121212"
    echo -en "\e]P1DA4939"
    echo -en "\e]P9FF6C5C"
    echo -en "\e]P261C29A"
    echo -en "\e]PA509F7E"
    echo -en "\e]P3DB8D4D"
    echo -en "\e]PBBC9458"
    echo -en "\e]P46D9CBE"
    echo -en "\e]PC91C1E3"
    echo -en "\e]P55E468C"
    echo -en "\e]PD7F62B3"
    echo -en "\e]P6435D75"
    echo -en "\e]PE6E98A4"
    echo -en "\e]P7DEDEDE"
    echo -en "\e]PFB0B0B0"
    clear 

fi
eval $( dircolors -b $HOME/.dircolors )
# -¬
# ---------------------------------------------------------------------
# Archlinux Plugin Documentation --¬
# ---------------------------------------------------------------------
    #pacin='sudo pacman -S'
    #Install specific package not from the repositories but from a file

    #pacins='sudo pacman -U'          
    #Remove the specified package(s), retaining its configuration(s) and required dependencies

    #pacre='sudo pacman -R'           
    #Remove the specified package(s), its configuration(s) and unneeded dependencies

    #pacrem='sudo pacman -Rns'        
    #Display information about a given package in the repositories

    #pacrep='pacman -Si'              
    #Search for package(s) in the repositories

    #pacreps='pacman -Ss'             
    #Display information about a given package in the local database

    #pacloc='pacman -Qi'              
    #Search for package(s) in the local database

    #paclocs='pacman -Qs'
    #Update and refresh the local package and ABS databases against repositories

    #pacupd='sudo pacman -Sy && sudo abs'     
    #Install given package(s) as dependencies of another package

    #pacinsd='sudo pacman -S --asdeps'        
    #Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

    #pacmir='sudo pacman -Syy'
    #Extra functions for package management in Archlinux

    #List all installed packages with a short description - Source

    #paclist
    #List all orphaned packages

    #paclsorphans
    #Delete all orphaned packages

    #pacrmorphans
    #List all disowned files in your system

    #pacdisowned | less +F

# -¬
# ---------------------------------------------------------------------
# Github Plugin Documentation --¬
# ---------------------------------------------------------------------
    #g   git                                   | gst git status
    #gl  git pull                              | gup git fetch && git rebase
    #gp  git push                              | gc  git commit -v
    #gca git commit -v -a                      | gco git checkout
    #gcm git checkout master                   | gb  git branch
    #gba git branch -a                         | gcount  git shortlog -sn
    #gcp git cherry-pick                       | glg git log --stat --max-count=5
    #glgg    git log --graph --max-count=5     | gss git status -s
    #ga  git add                               | gm  git merge
    #grh git reset HEAD                        | grhh    git reset HEAD --hard
    #gsr git svn rebase                        | gsd git svn dcommit
    #ggpull  git pull origin $(current_branch) | ggpush  git push origin $(current_branch)
    #gdv git diff -w "$@"                      | view -
    #ggpnp   git pull origin $(current_branch) && git push origin $(current_branch)
    #git-svn-dcommit-push    git svn dcommit && git push github master:svntrunk
    #gpa git add .; git commit -m "$1"; git push; # only in the ocodo fork.

plugins=(git archlinux pip supervisor systemd zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
# -¬
# ---------------------------------------------------------------------
# Functions --¬
# ---------------------------------------------------------------------
wiki() { dig +short txt $1.wp.dg.cx; }

# Note taking
n() { $EDITOR $NOTEDIR/$@; }
compctl -/ -W $NOTEDIR -f n

nls () { 
    tree ~/.notes -CR --noreport |
    sed -e 's/└── /-/' \
        -e 's/    /-/' \
        -e 's/├── /-/' \
        -e 's/│   /-/' |
    awk 'FS="-" {
        if (NF==1) print "\033[35mNotes";
        if (NF>1) {
            gsub(/-/,"  ");
            gsub(/.md/,"");
            print;
        }
    }'
;}
# -¬
# ---------------------------------------------------------------------
# Aliases --¬
# ---------------------------------------------------------------------
alias clc="clear"
alias :q="exit"
alias :Q="exit"
alias :e="vim"
alias :E="vim"
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias fp="~/Scripts/pass/findpass"
alias ep="~/Scripts/pass/editpass"
alias ls="ls --group-directories-first --color=always"
alias zsnes="optirun zsnes"
alias ftl="cd ~/.local/share/Steam/SteamApps/common/FTL\ Faster\ Than\ Light/ && ./FTL"
#fortune | cowsay | lolcat
# -¬
# ---------------------------------------------------------------------
