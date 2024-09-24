HISTFILE=${ZDOTDIR}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
HISTORY_IGNORE="(ls|la|ll|cd|zd|pwd|exit|cd ..|nv|vim|nvim|gis|dgs|dgy)"
#setopt appendhistory beep nomatch notify
setopt appendhistory
setopt histignorealldups
setopt histignorespace
setopt share_history
setopt HIST_SAVE_NO_DUPS
setopt autocd extendedglob
bindkey -e
zle_highlight+=(paste:none)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

# Clone antidote if necessary.
[[ -d ${ZDOTDIR:-~}/.antidote ]] ||
  git clone --depth 1 -- \
    https://github.com/mattmc3/antidote ${ZDOTDIR:-~}/.antidote

source ${ZDOTDIR:-~}/.antidote/antidote.zsh
antidote load

[[ -f $ZDOTDIR/.zsh_sources ]] && source $ZDOTDIR/.zsh_sources

[[ -f $ZDOTDIR/.zsh_aliases ]] && source $ZDOTDIR/.zsh_aliases

[[ -f $ZDOTDIR/.zsh_functions ]] && source $ZDOTDIR/.zsh_functions

[[ -f $ZDOTDIR/.zsh_extra ]] && source $ZDOTDIR/.zsh_extra

typeset -gU path fpath

command -v colorscript &> /dev/null && colorscript --random
command -v fortune &> /dev/null && printf "\n$(fortune -s)\n\n"

eval "$(starship init zsh)"
