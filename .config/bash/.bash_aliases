#!/usr/bin/env bash

# some more ls aliases
alias ll='ls -lh'
alias la='ls -al'
alias l='ls -CF'

# exa aliases
# if command -v exa > /dev/null 2>&1 ; then
if command -v eza &> /dev/null ; then
  alias ls='eza --icons auto'
  alias la='eza -a --icons auto'
  alias ll='eza -la --icons auto'
fi

alias ncdu="ncdu --color=dark"
alias snv="sudoedit"

#source bash
alias srcB='source ~/.bashrc'

#Tmux session (tmuxp)
alias tmxl='tmuxp load localB'

# xclip shortcuts
alias xcopy="xclip -sel clip"
xpaste() {
	xclip -out -selection clipboard;echo
}

#pkg search with fzf
alias pkg=pkgsearch

#nnn - file manager
alias ncp="cat ${NNN_SEL:-${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.selection} | tr '\0' '\n'"

#----------------------------------------------------
#NeoVim
#----------------------------------------------------
alias wgnvn='wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -P $HOME/Softwares/Installed/Terminal/Neovim/Nightly && rm $HOME/Softwares/Installed/Terminal/Neovim/Nightly/nvim.appimage && chmod +x $HOME/Softwares/Installed/Terminal/Neovim/Nightly/nvim.appimage.1 && mv $HOME/Softwares/Installed/Terminal/Neovim/Nightly/nvim.appimage.1 $HOME/Softwares/Installed/Terminal/Neovim/Nightly/nvim.appimage'

alias nv=nvim
#alias nv="$HOME/Softwares/nvim/nvim.appimage"
# alias nv="$HOME/Softwares/Installed/Terminal/Neovim/Nightly/nvim.appimage"

alias lbw="$HOME/Softwares/Installed/LibreWolf/LibreWolf-88.0-1.x86_64.AppImage"

#----------------------------------------------------
# Git Aliases
#----------------------------------------------------
if command -v git &> /dev/null ; then

  alias gis='git status'
  alias giss='git status -sb'

  alias gia='git add'
  alias giaa='git add --all'
  alias giap='git add --patch'
  alias giau='git add --update'

  alias gilc='git log --graph --oneline --decorate'
  alias gila='git log --graph --oneline --decorate --all'

  alias gib='git branch'
  alias giba='git branch --all'
  alias gibr='git branch --remote'
  alias gibd='git branch --delete'
  alias gibD='git branch -D'
  alias gibn='git branch --no-merged'

  alias gibl='git blame -b -w'

  alias gibi='git bisect'
  alias gibib='git bisect bad'
  alias gibig='git bisect good'
  alias gibir='git bisect reset'
  alias gibis='git bisect start'

  alias gic='git commit --verbose'
  alias gicm='git commit --message'
  alias gicam='git commit --all --message'
  alias gicA='git commit -v --amend'
  alias gicna='git commit -v --no-edit --amend'

  alias gicfgl='git config --list'

  alias gicl='git clone --recurse-submodules'

  alias gich='git checkout'
  alias gisw='git switch'
  alias giswc='git switch --create'
  alias giswd='git switch --detach'

  alias gicp='git cherry-pick'
  alias gicpa='git cherry-pick --abort'
  alias gicpc='git cherry-pick --continue'

  alias gid='git diff'
  alias gidc='git diff --cached'
  alias gidcw='git diff --cached --word-diff'
  alias gidw='git diff --word-diff'
  alias gids='git diff --staged'
  alias gidt='git diff-tree --no-commit-id --name-only -r'

fi

#----------------------------------------------------
# Dotfile management
# Using https://github.com/RayZ0rr/DotsManBash
#----------------------------------------------------
if [[ -f ~/.local/bin/dotsgit ]] ; then
  alias dg=dotsgit
  alias dgs="dotsgit status"
  alias dgy="dotsgit sync"
  alias dgt="dotsgit drysync"
  alias dgc="dotsgit commit"
  alias dgcp="dotsgit commitP"
  alias dgca="dotsgit commitA"
  alias dgp="dotsgit push"
  alias dgpp="dotsgit pushP"
  alias dgpa="dotsgit pushA"
  alias dgl="dotsgit log"
  alias dglp="dotsgit logP"
  alias dgla="dotsgit logA"
fi

if [[ -f ~/.local/bin/dotsinit ]] ; then
  alias di=dotsinit
  alias did="dotsinit dry"
  alias dia="dotsinit all"
  alias dil="dotsinit local"
  alias dih="dotsinit home"
  alias dic="dotsinit config"
  alias dir="dotsinit rm"
  alias dib="dotsinit bu"
fi

if [[ -f ~/.local/bin/myfonts ]] ; then
  alias mf=myfonts
fi
