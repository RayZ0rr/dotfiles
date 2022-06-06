# Setup fzf
# ---------
#if [[ ! "$PATH" == *${MY_FZF_PATH}/bin* ]]; then
#  export PATH="${PATH:+${PATH}:}${MY_FZF_PATH}/bin"
#fi

# Auto-completion
#---------------------------------------------------------------------------------
if [[ $- == *i* ]]
then
  if [[ -d "/usr/share/fzf" ]] ; then
    source "/usr/share/fzf/completion.zsh" 2> /dev/null
  elif [[ -d "${MY_FZF_PATH}/shell" ]] ; then
    source "${MY_FZF_PATH}/shell/completion.zsh" 2> /dev/null
  fi
fi

# Key bindings
#---------------------------------------------------------------------------------
if [[ -d "/usr/share/fzf" ]] ; then
  source "/usr/share/fzf/key-bindings.zsh" 2> /dev/null
elif [[ -d "${MY_FZF_PATH}/shell" ]] ; then
  source "${MY_FZF_PATH}/shell/key-bindings.zsh"
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
export FZF_DEFAULT_OPTS='--height=80% --layout=reverse --border'

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
--color=dark
--color=fg:-1,bg:-1,hl:#5fff87,fg+:-1,bg+:-1,hl+:#ffaf5f
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7
'

export FZF_CTRL_T_COMMAND=$FZF_FILE_COMMAND
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :100 {}' --bind=ctrl-z:ignore --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)' ${FZF_FILE_WINDOW[@]}"

export FZF_ALT_C_COMMAND=$FZF_FOLDER_COMMAND
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -100' --bind=ctrl-z:ignore --bind 'ctrl-space:toggle-preview,ctrl-o:execute(xdg-open {} 2> /dev/null &)' ${FZF_FOLDER_WINDOW[@]}"

# CTRL-T + CTRL-T - Paste the selected file path(s) from $HOME into the command line
#---------------------------------------------------------------------------------
__sff__() {
  local cmd="${FZF_FILE_COMMAND} $HOME"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | fzf-tmux -m "${FZF_FILE_PREVIEW[@]}" ${FZF_FILE_WINDOW[@]} "$@" | while read item; do
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
  eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]} "$@" | while read item; do
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
bindkey -M emacs '\ef' __sdfw__
bindkey -M vicmd '\ef' __sdfw__
bindkey -M viins '\ef' __sdfw__
# bindkey '\ef' __sdfw__

# alt-F+alt-F - Paste the selected folder path(s) from $HOME into the command line
#---------------------------------------------------------------------------------
__sdhf__() {
  local cmd="${FZF_FOLDER_COMMAND} $HOME"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]} "$@" | while read item; do
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
bindkey -M emacs '\ef\ef' __sdhfw__
bindkey -M vicmd '\ef\ef' __sdhfw__
bindkey -M viins '\ef\ef' __sdhfw__
# bindkey '\ef\ef' __sdhfw__

# (ALT-c)+(Alt-c) - cd into the selected directory from anywhere
#---------------------------------------------------------------------------------
__cda__() {
  local cmd="${FZF_FOLDER_COMMAND} $HOME"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | fzf-tmux -m ${FZF_FOLDER_PREVIEW[@]} ${FZF_FOLDER_WINDOW[@]})"
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
  file=$(fzf-tmux +m ${FZF_FILE_PREVIEW[@]} ${FZF_FILE_WINDOW[@]} -q "$1") && dir=$(dirname "$file") && builtin cd "$dir"
  local ret=$?
}

# zle     -N    cdf
# bindkey '\ecf' cdf
bindkey -s '\ec\ef' '__cdf__\n'

# (Ctrl-t)+(f) fd1 - List contents of the current directory only (not recursive).
#---------------------------------------------------------------------------------
__fd1__() {
  local cmd="${FZF_FILE_COMMAND} -td --max-depth=1"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | fzf-tmux -m "$@" | while read item; do
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

# Open files from current directory recursively with vim(nvim)
#---------------------------------------------------------------------------------
FZF_FD_COMMAND=( "${FZF_FILE_COMMAND[@]}" " | fzf -m " "${FZF_FILE_PREVIEW[@]}" )
onv() {
  local files

  # files=(${(f)"${FZF_FD_COMMAND[@]}"})
  files=(${(f)"$(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf -m ${FZF_FILE_WINDOW[@]} --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute(xdg-open {} 2> /dev/null &)')"})
  # files=("$(fdfind --type f --color=never --hidden --follow | fzf -m ${FZF_FILE_WINDOW[@]} --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute(xdg-open {} 2> /dev/null &)' --height=80% --layout=reverse)")

  if [[ -n $files ]]
  then
    ${EDITOR:-vim} -- $files
    echo $(echo $files[@] | awk 'BEGIN{ORS=" "};{print $0}')
  fi
}
fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --hidden --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

# Open files from $HOME directory recursively with vim(nvim)
#---------------------------------------------------------------------------------
anv() {
  filepath=$PWD
  cd
  local files

  files=(${(f)"$(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf -m ${FZF_FILE_WINDOW[@]} --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute(xdg-open {} 2> /dev/null &)')"})

  if [[ -n $files ]]
  then
    ${EDITOR:-vim} -- $files
    echo $(echo $files[@] | awk 'BEGIN{ORS=" "};{print $0}')
  fi
  cd $filepath
}

#---------------------------------------------------------------------------------
__fzfmenu__(){
  # alacritty -t fzf-menuFn --config-file=$HOME/.config/alacritty/scratchpad.yml -e ~/.local/bin/fzfmenu
  local cmd="${FZF_FILE_COMMAND} -td --max-depth=1"
  eval $cmd | ~/.local/bin/fzfmenu -m
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

#---------------------------------------------------------------------------------
fzfnova(){
  #xterm -T fzf-nova -geometry 90x25+350+200 -fs 16 -e ~/.config/fzf_nova/fzf-nova
  alacritty -t fzf-menuNova --config-file=$HOME/.config/alacritty/scratchpad.yml -e ~/.local/bin/fzf-nova
}

zle     -N    fzfnova
bindkey -M emacs '\eft' fzfnova
bindkey -M vicmd '\eft' fzfnova
bindkey -M viins '\eft' fzfnova
# bindkey '\efr' fzfnova

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
