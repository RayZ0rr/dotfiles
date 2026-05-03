# Setup fzf
#-------------------------------------------------------------------------------
if [[ ! "$+commands[fzf]" && -n "${MY_FZF_PATH}" && ! "$PATH" == *${MY_FZF_PATH}/bin* ]]; then
    export PATH="${PATH:+${PATH}:}${MY_FZF_PATH}/bin"
fi

# Auto-completion & Key bindings
#-------------------------------------------------------------------------------
source <(fzf --zsh)

if [[ -f ${ZDOTDIR}/fzf-zsh-completion.sh ]] ; then
    source ${ZDOTDIR}/fzf-zsh-completion.sh
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

#-------------------------------------------------------------------------------
#Custom fzf settings (keybindings & functions)
#-------------------------------------------------------------------------------
FIND_IGNORE_COMMAND="fd . --color=never --hidden --follow --exclude .git --exclude node_modules --no-ignore"
FIND_FILE_COMMAND="fd . --type f --color=never --hidden --follow --exclude .git --exclude node_modules"
FIND_FOLDER_COMMAND="fd . --type d --color=never --hidden --follow --exclude .git --exclude node_modules"

RG_FILE_COMMAND='rg --hidden --follow --glob "!.git" --files'

FZF_FILE_PREVIEW=(
    --preview "bat --style=-header-filename --color=always --line-range :100 {}"
    --bind "ctrl-z:ignore,ctrl-space:toggle-preview,ctrl-o:execute-silent(xdg-open {} 2> /dev/null &),ctrl-e:execute-silent(nvim {} 2> /dev/null)"
)
FZF_FILE_WINDOW=(--preview-window '50%,+{2}+3/3,~3')

FZF_FOLDER_PREVIEW=(--preview='tree -C {} | head -100' --bind='ctrl-z:ignore,ctrl-space:toggle-preview,ctrl-o:execute-silent(xdg-open {} 2> /dev/null &)')
FZF_FOLDER_WINDOW=(--preview-window '50%,~1')

FZF_FIND_COMMAND=( "${FIND_FILE_COMMAND}" " | fzf -m " "${FZF_FILE_PREVIEW[@]}" "${FZF_FILE_WINDOW[@]}")

export FZF_DEFAULT_COMMAND=${FIND_FILE_COMMAND}
export FZF_DEFAULT_OPTS="--prompt=' ' --info=inline-right --height 100% --tmux center,95%,95% --no-separator --style full --border=rounded --padding 1% --pointer '' --layout=reverse --cycle"
bind_str="focus:transform-preview-label:[[ -n {} ]] && printf ' Previewing [%s] ' {}"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
  --bind=ctrl-j:preview-page-down
  --bind=ctrl-k:preview-page-up
  --bind=\"${bind_str}\"
"
unset bind_str

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
    local blue3="#6cb8f4"
    local blue_dark="#51afef"
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
      --color=input-fg:$fg1,selected-fg:$blue_dark,selected-bg:$bg1,fg:$fg2,bg:$bg1,fg+:$black,current-bg:$green,scrollbar:$bg2
      --color=input-bg:$bg1,list-bg:$bg2,preview-bg:$bg3,header-bg:$bg1
      --color=hl:$dark_red,hl+:$purple,info:$pink:italic
      --color=border:$bg1,header-border:$grey_dark1,list-border:$bg2,preview-border:$bg3,input-border:$grey_dark1
      --color=header:$yellow:italic,spinner:$cyan,prompt:$blue,marker:$blue_dark,pointer:$dark_red,gutter:$rose
      --color=label:#cccccc,preview-label:$orange,list-label:$orange,input-label:$blue
    "
}
_gen_fzf_default_opts

export FZF_CTRL_T_COMMAND=${FIND_FILE_COMMAND}
export FZF_CTRL_T_OPTS="--header 'Choose files'"

export FZF_ALT_C_COMMAND=${FIND_FOLDER_COMMAND}
export FZF_ALT_C_OPTS="--header 'cd to directory'"

# Ctrl-t - Paste the selected file path(s) from cwd (recursive) into the command line
#-------------------------------------------------------------------------------
__fzf_ff__() {
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    FZF_DEFAULT_COMMAND=${FZF_CTRL_T_COMMAND:-} \
        FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=file,follow,hidden --scheme=path" "${FZF_CTRL_T_OPTS-} -m") \
        FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "${FZF_FILE_PREVIEW[@]}" "${FZF_FILE_WINDOW[@]}" "$@" < /dev/tty | while read -r item; do
        echo -n -E "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}
fzf_ff_widget() {
    LBUFFER="${LBUFFER}$(__fzf_ff__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
if [[ "${FZF_CTRL_T_COMMAND-x}" != "" ]]; then
    zle     -N            fzf_ff_widget
    bindkey -M emacs '^T' fzf_ff_widget
    bindkey -M vicmd '^T' fzf_ff_widget
    bindkey -M viins '^T' fzf_ff_widget
fi

# Ctrl-t + Ctrl-t - Paste the selected file path(s) from $HOME into the command line
#-------------------------------------------------------------------------------
__fzf_ffh__() {
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    FZF_DEFAULT_COMMAND="${FIND_FILE_COMMAND} $HOME" \
        FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=file,follow,hidden --scheme=path" "--header 'Choose files from HOME' -m") \
        FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "${FZF_FILE_PREVIEW[@]}" "${FZF_FILE_WINDOW[@]}" "$@" < /dev/tty | while read -r item; do
        echo -n -E "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}
fzf_ffh_widget() {
    LBUFFER="${LBUFFER}$(__fzf_ffh__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
if [[ "${FIND_FILE_COMMAND-x}" != "" ]]; then
    zle     -N              fzf_ffh_widget
    bindkey -M emacs '^T^T' fzf_ffh_widget
    bindkey -M vicmd '^T^T' fzf_ffh_widget
    bindkey -M viins '^T^T' fzf_ffh_widget
fi

# Alt-t - Paste the selected folder path(s) into the command line
#-------------------------------------------------------------------------------
__fzf_fd__() {
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    FZF_DEFAULT_COMMAND="${FZF_ALT_C_COMMAND}" \
        FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "--header 'Choose dirs' -m") \
        FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "${FZF_FOLDER_PREVIEW[@]}" "${FZF_FOLDER_WINDOW[@]}" "$@" < /dev/tty | while read -r item; do
        echo -n -E "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}
fzf_fd_widget() {
    LBUFFER="${LBUFFER}$(__fzf_fd__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
if [[ "${FZF_ALT_C_COMMAND-x}" != "" ]]; then
    zle     -N             fzf_fd_widget
    bindkey -M emacs '\et' fzf_fd_widget
    bindkey -M vicmd '\et' fzf_fd_widget
    bindkey -M viins '\et' fzf_fd_widget
fi

# Alt-t + Alt-t - Paste the selected folder path(s) from $HOME into the command line
#-------------------------------------------------------------------------------
__fzf_fdh__() {
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    FZF_DEFAULT_COMMAND="${FIND_FOLDER_COMMAND} $HOME" \
        FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "--header 'Choose dirs from HOME' -m") \
        FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "${FZF_FOLDER_PREVIEW[@]}" "${FZF_FOLDER_WINDOW[@]}" "$@" < /dev/tty | while read -r item; do
        echo -n -E "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}
fzf_fdh_widget() {
    LBUFFER="${LBUFFER}$(__fzf_fdh__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
if [[ "${FIND_FOLDER_COMMAND-x}" != "" ]]; then
    zle     -N                fzf_fdh_widget
    bindkey -M emacs '\et\et' fzf_fdh_widget
    bindkey -M vicmd '\et\et' fzf_fdh_widget
    bindkey -M viins '\et\et' fzf_fdh_widget
fi

# Alt-c - cd into the selected directory in cwd (recursive) from anywhere
#-------------------------------------------------------------------------------
fzf_cd_widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(
    FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
    FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
    FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "${FZF_FOLDER_PREVIEW[@]}" "${FZF_FOLDER_WINDOW[@]}" < /dev/tty)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="builtin cd -- ${(q)dir:a}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
if [[ "${FZF_ALT_C_COMMAND-x}" != "" ]]; then
  zle     -N             fzf_cd_widget
  bindkey -M emacs '\ec' fzf_cd_widget
  bindkey -M vicmd '\ec' fzf_cd_widget
  bindkey -M viins '\ec' fzf_cd_widget
fi

# Alt-c + Alt-c - cd into the selected directory from anywhere
#-------------------------------------------------------------------------------
fzf_cdh_widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(
    FZF_DEFAULT_COMMAND="${FIND_FOLDER_COMMAND} $HOME" \
    FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=dir,follow,hidden --scheme=path" "--header 'cd to directory from HOME' +m") \
    FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "${FZF_FOLDER_PREVIEW[@]}" "${FZF_FOLDER_WINDOW[@]}" < /dev/tty)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="builtin cd -- ${(q)dir:a}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
if [[ "${FIND_FOLDER_COMMAND-x}" != "" ]]; then
  zle     -N                fzf_cdh_widget
  bindkey -M emacs '\ec\ec' fzf_cdh_widget
  bindkey -M vicmd '\ec\ec' fzf_cdh_widget
  bindkey -M viins '\ec\ec' fzf_cdh_widget
fi

# ripgrep->fzf->vim/nvim [QUERY]
#-------------------------------------------------------------------------------
fzfrg() {
    RELOAD='reload:rg --hidden --follow --glob "!.git" --column --color=always --smart-case {q} || :'
    OPENER='if [[ $FZF_SELECT_COUNT -eq 0 ]]; then
            $EDITOR {1} +{2}     # No selection. Open the current line in Vim.
        else
            $EDITOR +cw -q {+f}  # Build quickfix list for the selected items.
    fi'
    fzf -m < /dev/null \
        --ansi \
        --bind "start:$RELOAD" --bind "change:$RELOAD" \
        --bind "enter:become:$OPENER" \
        --bind "ctrl-o:execute-silent:$OPENER" \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(down)' \
        --query "$*"
}

# Alt-c + Alt-t - cd into the directory of the selected file
#-------------------------------------------------------------------------------
fzf_cdf_widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(
    FZF_DEFAULT_COMMAND=${FZF_CTRL_T_COMMAND:-} \
    FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=file,follow,hidden --scheme=path" "--header 'cd to file directory' +m") \
    FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "${FZF_FILE_PREVIEW[@]}" "${FZF_FILE_WINDOW[@]}" < /dev/tty)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  dir=${dir:h}
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="builtin cd -- ${(q)dir:a}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
if [[ "${FZF_CTRL_T_COMMAND-x}" != "" ]]; then
  zle     -N                fzf_cdf_widget
  bindkey -M emacs '\ec\et' fzf_cdf_widget
  bindkey -M vicmd '\ec\et' fzf_cdf_widget
  bindkey -M viins '\ec\et' fzf_cdf_widget
fi

# Ctrl-t + Ctrl-f - List contents of the current directory only (not recursive).
#-------------------------------------------------------------------------------
__fzf_ffc__() {
    setopt localoptions pipefail no_aliases 2> /dev/null
    local item
    FZF_DEFAULT_COMMAND="${FIND_FILE_COMMAND} $PWD" \
        FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse --walker=file,follow,hidden --scheme=path" "--header 'Choose files from CWD' -m") \
        FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "${FZF_FILE_PREVIEW[@]}" "${FZF_FILE_WINDOW[@]}" "$@" < /dev/tty | while read -r item; do
        echo -n -E "${(q)item} "
    done
    local ret=$?
    echo
    return $ret
}
fzf_ffc_widget() {
    LBUFFER="${LBUFFER}$(__fzf_ffc__)"
    local ret=$?
    zle reset-prompt
    return $ret
}
if [[ "${FIND_FILE_COMMAND-x}" != "" ]]; then
    zle     -N              fzf_ffc_widget
    bindkey -M emacs '^T^F' fzf_ffc_widget
    bindkey -M vicmd '^T^F' fzf_ffc_widget
    bindkey -M viins '^T^F' fzf_ffc_widget
fi

#---------------------------------------------------------------------------------
__fzfmenu__(){
    local cmd="${FIND_FILE_COMMAND} -td --max-depth=1"
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

    local list_files=$(fd --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf --query="$1" -m "${FZF_FILE_PREVIEW[@]}" "${FZF_FILE_WINDOW[@]}" --header 'Choose Files for Vim')
    # files=(${(f)"${FZF_FD_COMMAND[@]}"})
    files=(${(f)"${list_files}"})
    # files=("$(fdfind --type f --color=never --hidden --follow | fzf -m ${FZF_FILE_WINDOW[@]} --preview 'bat --color=always --line-range :100 {}' --bind 'ctrl-space:toggle-preview,f2:execute-silent(xdg-open {} 2> /dev/null &)' --height=80% --layout=reverse)")

    if [[ -n $files ]]
    then
        ${EDITOR:-vim} -- $files
        echo $(echo $files[@] | awk 'BEGIN{ORS=" "};{print $0}')
    fi
}
# Open files from $HOME directory recursively with vim(nvim)
#---------------------------------------------------------------------------------
anv() {
    local files

    files=(${(f)"$(fd . $HOME --type f --color=never --hidden --follow --exclude .git --exclude node_modules | fzf --query="$1" -m "${FZF_FILE_PREVIEW[@]}" "${FZF_FILE_WINDOW[@]}" --header 'Choose Files for Vim from Home')"})

    if [[ -n $files ]]
    then
        ${EDITOR:-vim} -- $files
        echo $(echo $files[@] | awk 'BEGIN{ORS=" "};{print $0}')
    fi
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
