# Setup fzf
# ---------
#if [[ ! "$PATH" == *${MY_FZF_PATH}/bin* ]]; then
# export PATH="${PATH:+${PATH}:}${MY_FZF_PATH}/bin"
#fi

# if [ -f ~/.fzf_test.bash ]; then
#     source ~/.fzf_test.bash
# fi

# Auto-completion
#---------------------------------------------------------------------------------
if [[ $- == *i* ]]
then
  if [[ -f "/usr/share/fzf/shell/completion.bash" ]] ; then
    source "/usr/share/fzf/shell/completion.bash" 2> /dev/null
  elif [[ -f "/usr/share/fzf/completion.bash" ]] ; then
    source "/usr/share/fzf/completion.bash" 2> /dev/null
  elif [[ -f "${MY_FZF_PATH}/completion.bash" ]] ; then
    source "${MY_FZF_PATH}/completion.bash" 2> /dev/null
  fi
fi

if [[ -f ${BASH_CONFIG_PATH}/fzf-bash-completion.sh ]] ; then
  source ${BASH_CONFIG_PATH}/fzf-bash-completion.sh
  bind -x '"\t": fzf_bash_completion'
  # _fzf_bash_completion_loading_msg() { echo "${PS1@P}${READLINE_LINE}" | tail -n1; }
  FZF_COMPLETION_AUTO_COMMON_PREFIX=true
  FZF_COMPLETION_AUTO_COMMON_PREFIX_PART=true
fi
# Key bindings
#---------------------------------------------------------------------------------
if [[ -f "/usr/share/fzf/shell/key-bindings.bash" ]] ; then
  source "/usr/share/fzf/shell/key-bindings.bash" 2> /dev/null
elif [[ -f "/usr/share/fzf/key-bindings.bash" ]] ; then
  source "/usr/share/fzf/key-bindings.bash" 2> /dev/null
elif [[ -f "${MY_FZF_PATH}/key-bindings.bash" ]] ; then
  source "${MY_FZF_PATH}/key-bindings.bash"
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
# CTRL-T + CTRL-T - Paste the selected file path(s) into the command line
#---------------------------------------------------------------------------------
__sff__() {
    local cmd="${FZF_FILE_COMMAND} $HOME"
    eval "$cmd" | fzf-tmux -m "${FZF_FILE_PREVIEW[@]}" ${FZF_FILE_WINDOW[@]} --header 'Choose Files from Home' "$@" | while read -r item; do
        printf '%q ' "$item"
    done
    local ret=$?
    echo
    return $ret
}

__sffw__() {
  local selected="$(__sff__ "$@")"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
bind -x '"\C-t\C-t":"__sffw__"'
# bind -x '"__FileSeach__": fzf-file-widget'
# bind '"\C-t":"__FileSeach__"'
# bind -x '"__HomeFileSearch__":"__sffw__"'
# bind '"\C-t\C-t":"__HomeFileSearch__"'

# alt-F - Paste the selected folder path(s) into the command line
#---------------------------------------------------------------------------------
__sdf__() {
    local cmd="${FZF_FOLDER_COMMAND}"
    eval "$cmd" |
        fzf-tmux -m "${FZF_FOLDER_PREVIEW[@]}" ${FZF_FOLDER_WINDOW[@]} --header 'Choose Dir' "$@" | while read -r item; do
        printf '%q ' "$item"
    done
    local ret=$?
    echo
    return $ret
}

__sdfw__() {
    local selected="$(__sdf__)"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
bind -m emacs-standard -x '"\et": "__sdfw__"'
# bind -m emacs-standard -x '"__FolderSearch__": __sdfw__'
# bind -m emacs-standard '"\ef": "__FolderSearch__"'

# alt-t + alt-t - Paste the selected folder path(s) from $HOME into the command line
#---------------------------------------------------------------------------------
__sdhf__() {
    local cmd="${FZF_FOLDER_COMMAND} $HOME"
    setopt localoptions pipefail no_aliases 2> /dev/null
    eval "$cmd" |
        fzf-tmux -m "${FZF_FOLDER_PREVIEW[@]}" ${FZF_FOLDER_WINDOW[@]} --header 'Choose Dir from Home' "$@" | while read -r item; do
        printf '%q ' "$item"
    done
    local ret=$?
    echo
    return $ret
}
__sdhfw__() {
    local selected="$(__sdhf__)"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
bind -m emacs-standard -x '"\et\et": __sdhfw__'
bind -m vi-command -x '"\et\et": __sdhfw__'
bind -m vi-insert -x '"\et\et": __sdhfw__'

# (ALT-c)+(Alt-c) - cd into the selected directory from anywhere
#---------------------------------------------------------------------------------
__cda__() {
    local cmd dir
    cmd="${FZF_FOLDER_COMMAND} $HOME"
    dir=$(eval "($cmd)" | fzf-tmux -m "${FZF_FOLDER_PREVIEW[@]}" ${FZF_FOLDER_WINDOW[@]} --header 'cd from Home') && printf 'builtin cd -- %q' "$dir"
}
# Bind cda() to Alt a
bind -m emacs-standard '"\ec\ec": " \C-b\C-k \C-u`__cda__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
bind -m vi-command '"\ec\ec": "\C-z\ec\ec\C-z"'
bind -m vi-insert '"\ec\ec": "\C-z\ec\ec\C-z"'
#bind -x '"\ev":cda'

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
    local cmd
    # cmd="${some_command:-"command fd . $HOME --type f --color=never --follow --hidden 2> /dev/null "}"
    # file=$(eval "($cmd)" | fzf-tmux +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
    file=$(fzf-tmux +m "${FZF_FILE_PREVIEW[@]}" ${FZF_FILE_WINDOW[@]} --header 'Choose file to cd to its pwd' -q "$1") && dir=$(dirname "$file") && builtin cd "$dir"
}
bind '"\ec\et": "__cdf__\n"'
# bind -m emacs-standard -x '"\ec\et": "__cdf__"'
# bind -m vi-command -x '"\ec\et": "__cdf__"'
# bind -m vi-insert -x '"\ec\et": "__cdf__"'
# bind -m emacs-standard '"\ec\et": " \C-b\C-k \C-u`__cdf__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
# bind -m vi-command '"\ec\et": "\C-z\ec\et\C-z"'
# bind -m vi-insert '"\ec\et": "\C-z\ec\et\C-z"'

# (Ctrl-t)+(f) fd1 - List contents of the current directory only (not recursive).
#---------------------------------------------------------------------------------
__fd1__() {
    local cmd="${FZF_FILE_COMMAND} -td --max-depth=1"
    eval "$cmd" | fzf-tmux -m --header 'PWD content' "$@" | while read -r item; do
    printf '%q ' "$item"
    done
    local ret=$?
    echo
    return $ret
}

__fd1w__() {
    local selected="$(__fd1__)"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
bind -x '"\C-t\C-f":"__fd1w__"'

#---------------------------------------------------------------------------------
__fzfmenu__() {
    local cmd="${FZF_FILE_COMMAND} -td --max-depth=1"
    eval "$cmd" | ~/.local/bin/fzfmenu
}
__fzf-menu__() {
    local selected="$(__fzfmenu__)"
    READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
    READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
bind -x '"\C-t\C-g":"__fzf-menu__"'

#ROFI replacement
#---------------------------------------------------------------------------------
bind -x '"\C-t\C-r":"alacritty -t fzf-menuNova --config-file=$HOME/.config/alacritty/scratchpad.yml -e ~/.local/bin/fzf-nova"'

# Open files from current directory recursively with vim(nvim)
#---------------------------------------------------------------------------------
onv() {
    IFS=$'\n' files=($(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf-tmux --query="$1" --multi ${FZF_FILE_WINDOW[@]} --header 'Choose Files for Vim' --preview 'bat --color=always --line-range :100 {}' --bind 'f2:execute(xdg-open {} 2> /dev/null &),ctrl-space:toggle-preview'))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Open files from $HOME directory recursively with vim(nvim)
#---------------------------------------------------------------------------------
anv() {
    IFS=$'\n' files=($(fd . $HOME --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf-tmux --query="$1" --multi ${FZF_FILE_WINDOW[@]} --header 'Choose Files for Vim from Home' --preview 'bat --color=always --line-range :100 {}' --bind 'f2:execute(xdg-open {} 2> /dev/null &),ctrl-space:toggle-preview'))
    [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
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
# End ---------------------------------------------------------------------------------------------
