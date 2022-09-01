# Lines configured by zsh-newuser-install
HISTFILE=${ZDOTDIR}/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
HISTORY_IGNORE="(ls|la|ll|cd|zd|pwd|exit|cd ..)"
#setopt appendhistory beep nomatch notify
setopt appendhistory
setopt histignorealldups
setopt histignorespace
setopt share_history
setopt HIST_SAVE_NO_DUPS
setopt autocd extendedglob
bindkey -e
zle_highlight+=(paste:none)
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '$HOME/.config/zsh/.zshrc'

# autoload -Uz compinit
# compinit
# End of lines added by compinstall

# Clone zcomet if necessary
if [[ ! -f ${HOME}/.config/zcomet/bin/zcomet.zsh ]]; then
  command git clone https://github.com/agkozak/zcomet.git ${HOME}/.config/zcomet/bin
fi

source ${HOME}/.config/zcomet/bin/zcomet.zsh

zstyle ':zcomet:*' home-dir ~/.config/zcomet
# zstyle ':zcomet:*' repos-dir ~/.config/zcomet/repos
# zstyle ':zcomet:*' snippets-dir ~/.config/zcomet/snippets

# Load some plugins
# zcomet load ohmyzsh plugins/gitfast
zcomet load zsh-users/zsh-autosuggestions
zcomet load zsh-users/zsh-completions
zcomet load zsh-users/zsh-syntax-highlighting

# Run compinit and compile its cache
zcomet compinit

# Only main highlight by default
# ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

[ -f $ZDOTDIR/.zsh_sources ] && source $ZDOTDIR/.zsh_sources

[ -f $ZDOTDIR/.zsh_aliases ] && source $ZDOTDIR/.zsh_aliases

[ -f $ZDOTDIR/.zsh_functions ] && source $ZDOTDIR/.zsh_functions

[ -f $ZDOTDIR/.zsh_extra ] && source $ZDOTDIR/.zsh_extra

command -v colorscript &> /dev/null && colorscript random
command -v fortune &> /dev/null && printf "\n$(fortune -s)\n\n"

eval "$(starship init zsh)"
