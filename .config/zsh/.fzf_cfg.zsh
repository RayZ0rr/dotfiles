# Setup fzf
# ---------
#if [[ ! "$PATH" == *${MY_FZF_PATH}/bin* ]]; then
#  export PATH="${PATH:+${PATH}:}${MY_FZF_PATH}/bin"
#fi

# Auto-completion
#---------------------------------------------------------------------------------
if [[ $- == *i* ]]
then
  if [[ -d "/usr/share/fzf/shell" ]] ; then
    source "/usr/share/fzf/shell/completion.zsh" 2> /dev/null
  elif [[ -d "/usr/share/fzf" ]] ; then
    source "/usr/share/fzf/completion.zsh" 2> /dev/null
  elif [[ -d "${MY_FZF_PATH}" ]] ; then
    source "${MY_FZF_PATH}/completion.zsh" 2> /dev/null
  fi
fi

if [[ -f $ZDOTDIR/fzf-zsh-completion.sh ]] ; then
  source $ZDOTDIR/fzf-zsh-completion.sh
  bindkey '^I' fzf_completion

  zstyle ':completion:*' fzf-search-display true
  # basic file preview for ls (you can replace with something more sophisticated than head)
  zstyle ':completion::*:(ls|exa)::*' fzf-completion-opts -m --preview='eval head {+1}'
  zstyle ':completion::*:(vim|nvim)::*' fzf-completion-opts -m --preview='eval head {+1}'
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
if [[ -d "/usr/share/fzf/shell" ]] ; then
  source "/usr/share/fzf/shell/key-bindings.zsh" 2> /dev/null
elif [[ -d "/usr/share/fzf" ]] ; then
  source "/usr/share/fzf/key-bindings.zsh" 2> /dev/null
elif [[ -d "${MY_FZF_PATH}" ]] ; then
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

FZF_FD_COMMAND=( "${FZF_FILE_COMMAND[@]}" " | fzf -m " "${FZF_FILE_PREVIEW[@]}" )
# CTRL-T + CTRL-T - Paste the selected file path(s) from $HOME into the command line
#---------------------------------------------------------------------------------
__sff__() {
  local cmd="${FZF_FILE_COMMAND} $HOME"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | fzf-tmux -m "${FZF_FILE_PREVIEW[@]}" ${FZF_FILE_WINDOW[@]} --header 'Choose Files from Home' --color header:italic "$@" | while read item; do
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

# alt-F - Paste the selected folder path(s) from into the command line
#---------------------------------------------------------------------------------
__sdf__() {
  local cmd="${FZF_FOLDER_COMMAND}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]} --header 'Choose Dir' --color header:italic "$@" | while read item; do
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

# alt-F+alt-F - Paste the selected folder path(s) from $HOME into the command line
#---------------------------------------------------------------------------------
__sdhf__() {
  local cmd="${FZF_FOLDER_COMMAND} $HOME"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]} --header 'Choose Dir from Home' --color header:italic "$@" | while read item; do
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
  local dir="$(eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]} --header 'cd from Home' --color header:italic)"
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

# (ALT-c)+(f) cdf - cd into the directory of the selected file
#---------------------------------------------------------------------------------
__cdf__() {
  local file
  local dir
  file=$(fzf-tmux +m ${FZF_FILE_PREVIEW[@]} ${FZF_FILE_WINDOW[@]} --header 'Choose file to cd to its pwd' --color header:italic -q "$1") && dir=$(dirname "$file") && builtin cd "$dir"
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
  eval "$cmd" | fzf-tmux -m --header 'PWD content' --color header:italic "$@" | while read item; do
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
  files=(${(f)"$(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf -m ${FZF_FILE_WINDOW[@]} --header 'Choose Files for Vim' --color header:italic --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute(xdg-open {} 2> /dev/null &)')"})
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

  files=(${(f)"$(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf -m ${FZF_FILE_WINDOW[@]} --header 'Choose Files for Vim from Home' --color header:italic --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute(xdg-open {} 2> /dev/null &)')"})

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
