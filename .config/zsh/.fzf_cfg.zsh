# Setup fzf
# ---------
#if [[ ! "$PATH" == *${MY_FZF_PATH}/bin* ]]; then
# export PATH="${PATH:+${PATH}:}${MY_FZF_PATH}/bin"
#fi

# Auto-completion
#---------------------------------------------------------------------------------
if [[ $- == *i* ]]
then
    if [[ -f "/usr/share/fzf/shell/completion.zsh" ]] ; then
        source "/usr/share/fzf/shell/completion.zsh" 2> /dev/null
    elif [[ -f "/usr/share/fzf/completion.zsh" ]] ; then
        source "/usr/share/fzf/completion.zsh" 2> /dev/null
    elif [[ -f "${MY_FZF_PATH}/completion.zsh" ]] ; then
        source "${MY_FZF_PATH}/completion.zsh" 2> /dev/null
    fi
fi

if [[ -f $ZDOTDIR/fzf-zsh-completion.sh ]] ; then
    source $ZDOTDIR/fzf-zsh-completion.sh
    bindkey '^I' fzf_completion

    zstyle ':completion:*' fzf-search-display true
    # basic file preview for ls (you can replace with something more sophisticated than head)
    zstyle ':completion::*:(ls|eza)::*' fzf-completion-opts -m --preview='eval head {+1}'
    zstyle ':completion::*:(vim|nvim|nv)::*' fzf-completion-opts -m --preview='eval head {+1}'
    zstyle ':completion::*:(cd|zd)::*' fzf-completion-opts --preview='eval tree {+1}'

  # preview when completing env vars (note: only works for exported variables)
  # eval twice, first to unescape the string, second to expand the $variable
  zstyle ':completion::*:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-completion-opts --preview='eval eval echo {1}'

  # preview a `git status` when completing git add
  zstyle ':completion::*:git::git,add,restore,*' fzf-completion-opts -m --preview='git -c color.status=always status --short'

  # if other subcommand to git is given, show a git diff or git log
  # zstyle ':completion::*:git::*,[a-z]*' fzf-completion-opts -m --preview='
  # eval set -- {+1}
  # for arg in "$@"; do
  #     { git diff --color=always -- "$arg" | git log --color=always "$arg" } 2>/dev/null
  # done'
fi
# Key bindings
#---------------------------------------------------------------------------------
if [[ -f "/usr/share/fzf/shell/key-bindings.zsh" ]] ; then
    source "/usr/share/fzf/shell/key-bindings.zsh" 2> /dev/null
elif [[ -f "/usr/share/fzf/key-bindings.zsh" ]] ; then
    source "/usr/share/fzf/key-bindings.zsh" 2> /dev/null
elif [[ -f "${MY_FZF_PATH}/key-bindings.zsh" ]] ; then
    source "${MY_FZF_PATH}/key-bindings.zsh"
fi

#---------------------------------------------------------------------------------
#Custom fzf settings (keybindings & functions)
#---------------------------------------------------------------------------------

FD_IGNORE_COMMAND="fd --color=never --hidden --follow --exclude .git --exclude node_modules --no-ignore"

FZF_FILE_COMMAND="fd . --type f --color=never --hidden --follow --exclude .git --exclude node_modules"
FZF_FOLDER_COMMAND="fd . --type d --color=never --hidden --follow --exclude .git --exclude node_modules"
FZF_RG_COMMAND='rg --hidden --follow --glob "!.git" --files'

FZF_FILE_PREVIEW=(--preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-z:ignore' --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)')
FZF_FILE_WINDOW=(--preview-window '50%,+{2}+3/3,~3')

FZF_FOLDER_PREVIEW=(--preview 'tree -C {} | head -100' --bind 'ctrl-z:ignore' --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)')
FZF_FOLDER_WINDOW=(--preview-window '50%,~1')

export FZF_DEFAULT_COMMAND=$FZF_RG_COMMAND
export FZF_DEFAULT_OPTS="--prompt=' ' --info=inline-right --tmux center --height '100%' --no-separator --input-border=rounded --border=block --layout=reverse --cycle --preview-border=line --preview-window '<80(down)'"

_gen_fzf_default_opts() {
local color00='#2E3440'
local color01='#3B4252'
local color02='#434C5E'
local color03='#4C566A'
local color04='#bbc2cf'
local color06='#D8DEE9'
local color07='#E5E9F0'
local grey_brown='#a89984'
local grey_dark1='#424242'
local grey_dark2='#2E2E2E'
local grey_dark3='#262A31'
local grey_cool='#B1B8C5'
local black_light1='#1F2228'
local black_light2='#1A1D22'
local black_light3='#202328'
local black='#151515'
local white='#ECEFF4'
local teal='#8FBCBB'
local red='#BF616A'
local dark_red='#ec5f67'
local orange='#D08770'
local yellow='#EBCB8B'
local green='#A3BE8C'
local cyan='#88C0D0'
local blue='#81A1C1'
local blue2='#5E81AC'
local pink='#B48EAD'
local rose='#ff87d7'
local violet='#af87ff'
local purple='#6e0ced'
local fg1="$white"
local fg2="$grey_cool"
local bg1="$grey_dark3"
local bg2="$black_light1"
local bg3="$black_light2"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --color=dark
  --color=input-fg:$fg1,fg:$fg2,bg:$bg1,fg+:$black,bg+:$green
  --color=input-bg:$bg1,list-bg:$bg2,preview-bg:$bg3,header-bg:$bg1
  --color=hl:$red,hl+:$purple,info:$pink:italic
  --color=border:$bg1,list-border:$bg1,preview-border:$fg1,input-border:$fg1
  --color=header:$yellow:italic,spinner:$cyan,prompt:$blue,marker:$orange,pointer:$dark_red,gutter:$bg2
  --bind=ctrl-d:preview-page-down
  --bind=ctrl-u:preview-page-up
"
}

_gen_fzf_default_opts

export FZF_CTRL_T_COMMAND=$FZF_FILE_COMMAND
export FZF_CTRL_T_OPTS="--header 'Choose Files' --preview 'bat --color=always --line-range :100 {}' --bind=ctrl-z:ignore --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)' ${FZF_FILE_WINDOW[@]}"

export FZF_ALT_C_COMMAND=$FZF_FOLDER_COMMAND
export FZF_ALT_C_OPTS="--header 'cd Dir' --preview 'tree -C {} | head -100' --bind=ctrl-z:ignore --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)' ${FZF_FOLDER_WINDOW[@]}"

FZF_FD_COMMAND=( "${FZF_FILE_COMMAND[@]}" " | fzf -m " "${FZF_FILE_PREVIEW[@]}" )
# CTRL-T + CTRL-T - Paste the selected file path(s) from $HOME into the command line
#---------------------------------------------------------------------------------
__sff__() {
    local cmd="${FZF_FILE_COMMAND} $HOME"
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    eval "$cmd" | fzf-tmux -m "${FZF_FILE_PREVIEW[@]}" ${FZF_FILE_WINDOW[@]} --header 'Choose Files from Home' "$@" | while read item; do
        echo -n "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}

__sffw__() {
    LBUFFER="${LBUFFER}$(__sff__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
zle     -N   __sffw__
bindkey -M emacs '^T^T' __sffw__
bindkey -M vicmd '^T^T' __sffw__
bindkey -M viins '^T^T' __sffw__
# bindkey '^T^T' __sffw__

# alt-F - Paste the selected folder path(s) into the command line
#---------------------------------------------------------------------------------
__sdf__() {
    local cmd="${FZF_FOLDER_COMMAND}"
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]} --header 'Choose Dir' "$@" | while read item; do
        echo -n "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}

__sdfw__() {
    LBUFFER="${LBUFFER}$(__sdf__)"
    local ret=$?
    zle reset-prompt
    return $ret
}

zle     -N   __sdfw__
bindkey -M emacs '\et' __sdfw__
bindkey -M vicmd '\et' __sdfw__
bindkey -M viins '\et' __sdfw__
# bindkey '\ef' __sdfw__

# alt-t + alt-t - Paste the selected folder path(s) from $HOME into the command line
#---------------------------------------------------------------------------------
__sdhf__() {
    local cmd="${FZF_FOLDER_COMMAND} $HOME"
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]} --header 'Choose Dir from Home' "$@" | while read item; do
        echo -n "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}
__sdhfw__() {
    LBUFFER="${LBUFFER}$(__sdhf__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
zle     -N   __sdhfw__
bindkey -M emacs '\et\et' __sdhfw__
bindkey -M vicmd '\et\et' __sdhfw__
bindkey -M viins '\et\et' __sdhfw__
# bindkey '\ef\ef' __sdhfw__

# (ALT-c)+(Alt-c) - cd into the selected directory from anywhere
#---------------------------------------------------------------------------------
__cda__() {
    local cmd="${FZF_FOLDER_COMMAND} $HOME"
    setopt localoptions pipefail no_aliases 2> /dev/null
    local dir="$(eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]} --header 'cd from Home')"
    if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
    fi
    zle push-line # Clear buffer. Auto-restored on next prompt.
    BUFFER="builtin cd -- ${(q)dir}" #"
    zle accept-line
    local ret=$?
    unset dir # ensure this doesn't end up appearing in prompt expansion
    zle reset-prompt
    return $ret
}
zle     -N    __cda__
bindkey -M emacs '\ec\ec' __cda__
bindkey -M vicmd '\ec\ec' __cda__
bindkey -M viins '\ec\ec' __cda__
# bindkey '\ec\ec' __cda__

# ripgrep->fzf->vim/nvim [QUERY]
fzfrg() {
    RELOAD='reload:rg --hidden --follow --glob "!.git" --column --color=always --smart-case {q} || :'
    OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            $EDITOR {1} +{2}     # No selection. Open the current line in Vim.
        else
            $EDITOR +cw -q {+f}  # Build quickfix list for the selected items.
    fi'
    fzf < /dev/null \
        --disabled --layout=reverse --ansi --multi \
        --bind "start:$RELOAD" --bind "change:$RELOAD" \
        --bind "enter:become:$OPENER" \
        --bind "ctrl-o:execute:$OPENER" \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(down)' \
        --query "$*"
}

# (ALT-c)+(f) cdf - cd into the directory of the selected file
#---------------------------------------------------------------------------------
__cdf__() {
    local file
    local dir
    file=$(fzf-tmux +m ${FZF_FILE_PREVIEW[@]} ${FZF_FILE_WINDOW[@]} --header 'Choose file to cd to its pwd' -q "$1") && dir=$(dirname "$file") && builtin cd "$dir"
}
# zle     -N    cdf __cdf__
# bindkey '\ec\et' cdf
bindkey -s '\ec\et' '__cdf__\n'

# (Ctrl-t)+(f) fd1 - List contents of the current directory only (not recursive).
#---------------------------------------------------------------------------------
__fd1__() {
    local cmd="${FZF_FILE_COMMAND} -td --max-depth=1"
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    eval "$cmd" | fzf-tmux -m --header 'PWD content' "$@" | while read item; do
    echo -n "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}

__fd1w__() {
    LBUFFER="${LBUFFER}$(__fd1__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
zle     -N   __fd1w__
bindkey -M emacs '^T^f' __fd1w__
bindkey -M vicmd '^T^f' __fd1w__
bindkey -M viins '^T^f' __fd1w__
# bindkey '^T^f' __fd1w__

#---------------------------------------------------------------------------------
__fzfmenu__(){
    local cmd="${FZF_FILE_COMMAND} -td --max-depth=1"
    eval $cmd | ~/.local/bin/fzfmenu
}
__fzf-menu__() {
    LBUFFER="${LBUFFER}$(__fzfmenu__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
zle     -N    __fzf-menu__
bindkey -M emacs '^T^G' __fzf-menu__
bindkey -M vicmd '^T^G' __fzf-menu__
bindkey -M viins '^T^G' __fzf-menu__
# bindkey '\efr' fzfnova

#ROFI replacement
#---------------------------------------------------------------------------------
fzfnova(){
  #xterm -T fzf-nova -geometry 90x25+350+200 -fs 16 -e ~/.config/fzf_nova/fzf-nova
  alacritty -t fzf-menuNova --config-file=$HOME/.config/alacritty/scratchpad.yml -e ~/.local/bin/fzf-nova
}

zle     -N    fzfnova
bindkey -M emacs '^T^R' fzfnova
bindkey -M vicmd '^T^R' fzfnova
bindkey -M viins '^T^R' fzfnova
# bindkey '\efr' fzfnova

# Open files from current directory recursively with vim(nvim)
#---------------------------------------------------------------------------------
onv() {
    local files

    # files=(${(f)"${FZF_FD_COMMAND[@]}"})
    files=(${(f)"$(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf -m ${FZF_FILE_WINDOW[@]} --header 'Choose Files for Vim' --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute(xdg-open {} 2> /dev/null &)')"})
    # files=("$(fdfind --type f --color=never --hidden --follow | fzf -m ${FZF_FILE_WINDOW[@]} --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute(xdg-open {} 2> /dev/null &)' --height=80% --layout=reverse)")

    if [[ -n $files ]]
    then
        ${EDITOR:-vim} -- $files
        echo $(echo $files[@] | awk 'BEGIN{ORS=" "};{print $0}')
    fi
}
# Open files from $HOME directory recursively with vim(nvim)
#---------------------------------------------------------------------------------
anv() {
    filepath=$PWD
    cd
    local files

    files=(${(f)"$(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf -m ${FZF_FILE_WINDOW[@]} --header 'Choose Files for Vim from Home' --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute(xdg-open {} 2> /dev/null &)')"})

    if [[ -n $files ]]
    then
        ${EDITOR:-vim} -- $files
        echo $(echo $files[@] | awk 'BEGIN{ORS=" "};{print $0}')
    fi
    cd $filepath
}

#---------------------------------------------------------------------------------
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --hidden --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}
# Use fpfr to generate the list for directory completion using fdfind
#---------------------------------------------------------------------------------
fpfr() {
  fd --hidden --type f --follow --exclude ".git" --exclude node_modules . "$1"
}
# Use dpfr to generate the list for directory completion using fdfind
#---------------------------------------------------------------------------------
dpfr() {
  fd --type d --hidden --follow --exclude ".git" --exclude node_modules . "$1"
}
# TMux sessoins create or select
#---------------------------------------------------------------------------------
fzts() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}
# bindkey -r '\C-g'
# bindkey -s '\C-g' 'fzts\n'
# End ---------------------------------------------------------------------------------------------
