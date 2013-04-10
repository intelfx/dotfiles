# ---------------------------------------------------------------------
# Basic options
# ---------------------------------------------------------------------

export EDITOR=vim
export NOTEDIR=~/.notes/

# Linux terminal colors
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

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="prompto"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Install specific package(s) from the repositories

# ---------------------------------------------------------------------
# Archlinux Plugin Documentation
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


# ---------------------------------------------------------------------
# Github Plugin Documentation
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

# ---------------------------------------------------------------------
# Functions
# ---------------------------------------------------------------------
wiki() { dig +short txt $1.wp.dg.cx; }

# Note taking
n() { $EDITOR $NOTEDIR/"$*".md }
nls () { tree -CR --noreport ~/.notes \
        | awk '{ if ((NR > 1) gsub(/.md/,"")); \
        if (NF==1) print $1; else if (NF==2) print $2; else if (NF==3) printf "  %s\n", $3 }' ;}

# ---------------------------------------------------------------------
# Exports
# ---------------------------------------------------------------------
export JAVA_FONTS=/usr/share/fonts/TTF
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'
export PATH=~/Scripts:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl
export PATH=$PATH:~/.gem/ruby/2.0.0/bin
export PATH=$PATH:~/.cabal/bin
export PATH=$PATH:~/Scripts/peat
#export LANGUAGE="es_ES:es_ES:es"
#export LANG=es_ES.utf8

# ---------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------
alias :q="exit"
alias :Q="exit"
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias fp="~/Scripts/pass/findpass"
alias ep="~/Scripts/pass/editpass"
alias matlab="matlab >/dev/null 2>/dev/null &"
alias google-chrome chrome="google-chrome --audio-buffer-size=4096"
