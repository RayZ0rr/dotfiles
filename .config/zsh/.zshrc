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

# Download Znap, if it's not there yet.
[[ -r ${ZDOTDIR}/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ${ZDOTDIR}/znap
source ${ZDOTDIR}/znap/znap.zsh  # Start Znap

zstyle ':znap:*:*' git-maintenance off

# Load some plugins
# zcomet load ohmyzsh plugins/gitfast
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-completions
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
# znap source zsh-users/zsh-syntax-highlighting
znap source zdharma-continuum/fast-syntax-highlighting

[ -f $ZDOTDIR/.zsh_sources ] && source $ZDOTDIR/.zsh_sources

[ -f $ZDOTDIR/.zsh_aliases ] && source $ZDOTDIR/.zsh_aliases

[ -f $ZDOTDIR/.zsh_functions ] && source $ZDOTDIR/.zsh_functions

[ -f $ZDOTDIR/.zsh_extra ] && source $ZDOTDIR/.zsh_extra

command -v colorscript &> /dev/null && colorscript --random
command -v fortune &> /dev/null && printf "\n$(fortune -s)\n\n"

eval "$(starship init zsh)"
