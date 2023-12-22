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
FZF_FILE_WINDOW=(--preview-window 'down,50%,+{2}+3/3,~3')

FZF_FOLDER_PREVIEW=(--preview 'tree -C {} | head -100' --bind 'ctrl-z:ignore' --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)')
FZF_FOLDER_WINDOW=(--preview-window 'down,50%,~1')

export FZF_DEFAULT_COMMAND=$FZF_RG_COMMAND
export FZF_DEFAULT_OPTS='--height=80% --layout=reverse --border --cycle'

_gen_fzf_default_opts() {
local color00='#2E3440'
local color01='#3B4252'
local color02='#434C5E'
local color03='#4C566A'
local color04='#D8DEE9'
local color05='#E5E9F0'
local cream='#a89984'
local black='#202328'
local grey='#bbc2cf'
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

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --color=dark,bg+:-1,bg:-1,spinner:$cyan,hl:$red,hl+:$purple
  --color=fg:$white,fg+:$black,bg+:$green,info:$blue
  --color=prompt:$cream,marker:$green,pointer:$dark_red
  --color=header:$yellow,border:$orange,gutter:-1
  --bind=ctrl-d:preview-page-down
  --bind=ctrl-u:preview-page-up
"
}

_gen_fzf_default_opts

export FZF_CTRL_T_COMMAND=$FZF_FILE_COMMAND
export FZF_CTRL_T_OPTS="--header 'Choose Files' --color header:italic --preview 'bat --color=always --line-range :100 {}' --bind=ctrl-z:ignore --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)' ${FZF_FILE_WINDOW[@]}"

export FZF_ALT_C_COMMAND=$FZF_FOLDER_COMMAND
export FZF_ALT_C_OPTS="--header 'cd Dir' --color header:italic --preview 'tree -C {} | head -100' --bind=ctrl-z:ignore --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)' ${FZF_FOLDER_WINDOW[@]}"

# CTRL-T + CTRL-T - Paste the selected file path(s) into the command line
#---------------------------------------------------------------------------------
__sff__() {
  local cmd="${FZF_FILE_COMMAND} $HOME"
  eval "$cmd" | fzf-tmux -m "${FZF_FILE_PREVIEW[@]}" ${FZF_FILE_WINDOW[@]} --header 'Choose Files from Home' --color header:italic "$@" | while read -r item; do
    printf '%q ' "$item"
  done
  echo
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
  fzf-tmux -m "${FZF_FOLDER_PREVIEW[@]}" ${FZF_FOLDER_WINDOW[@]} --header 'Choose Dir' --color header:italic "$@" | while read -r item; do
		printf '%q ' "$item"
  done
	echo
}

__sdfw__() {
  local selected="$(__sdf__)"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
bind -m emacs-standard -x '"\et": "__sdfw__"'
# bind -m emacs-standard -x '"__FolderSearch__": __sdfw__'
# bind -m emacs-standard '"\ef": "__FolderSearch__"'

# alt-F+alt-F - Paste the selected folder path(s) from $HOME into the command line
#---------------------------------------------------------------------------------
__sdhf__() {
  local cmd="${FZF_FOLDER_COMMAND} $HOME"
  eval "$cmd" |
  fzf-tmux -m "${FZF_FOLDER_PREVIEW[@]}" ${FZF_FOLDER_WINDOW[@]} --header 'Choose Dir from Home' --color header:italic "$@" | while read -r item; do
		printf '%q ' "$item"
  done
	echo
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
  dir=$(eval "($cmd)" | fzf-tmux -m "${FZF_FOLDER_PREVIEW[@]}" ${FZF_FOLDER_WINDOW[@]} --header 'cd from Home' --color header:italic) && printf 'builtin cd -- %q' "$dir"
}
# Bind cda() to Alt a
bind -m emacs-standard '"\ec\ec": " \C-b\C-k \C-u`__cda__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
bind -m vi-command '"\ec\ec": "\C-z\ec\ec\C-z"'
bind -m vi-insert '"\ec\ec": "\C-z\ec\ec\C-z"'
#bind -x '"\ev":cda'


# cdf - cd into the directory of the selected file
#---------------------------------------------------------------------------------
__cdf__() {
  local file
  local dir
  local cmd
  # cmd="${some_command:-"command fd . $HOME --type f --color=never --follow --hidden 2> /dev/null "}"
  # file=$(eval "($cmd)" | fzf-tmux +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
  file=$(fzf-tmux +m "${FZF_FILE_PREVIEW[@]}" ${FZF_FILE_WINDOW[@]} --header 'Choose file to cd to its pwd' --color header:italic -q "$1") && dir=$(dirname "$file") && builtin cd "$dir"
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
  eval "$cmd" | fzf-tmux -m --header 'PWD content' --color header:italic "$@" | while read -r item; do
    printf '%q ' "$item"
  done
  echo
}

__fd1w__() {
  local selected="$(__fd1__)"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}
bind -x '"\C-t\C-f":"__fd1w__"'

# (Ctrl-t)+(f) fd1 - List contents of the current directory only (not recursive).
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
#---------------------------------------------------------------------------------
onv() {
  IFS=$'\n' files=($(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf-tmux --query="$1" --multi ${FZF_FILE_WINDOW[@]} --header 'Choose Files for Vim' --color header:italic --preview 'bat --color=always --line-range :100 {}' --bind 'f2:execute(xdg-open {} 2> /dev/null &),ctrl-space:toggle-preview'))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
}

# Open files from $HOME directory recursively with vim(nvim)
#---------------------------------------------------------------------------------
anv() {
  IFS=$'\n' files=($(fd . $HOME --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf-tmux --query="$1" --multi ${FZF_FILE_WINDOW[@]} --header 'Choose Files for Vim from Home' --color header:italic --preview 'bat --color=always --line-range :100 {}' --bind 'f2:execute(xdg-open {} 2> /dev/null &),ctrl-space:toggle-preview'))
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
