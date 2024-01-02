################################################################################
# bloated theme ################################################################
################################################################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


################################################################################
# speed up completion by compiling compdump ####################################
################################################################################

# to measure startup times 
# zmodload zsh/zprof

# compile compdump for maximum speed

autoload -Uz compinit
ZSH_COMPDUMP=${ZSH_COMPDUMP:-${ZDOTDIR:-~}/.zcompdump}

# cache .zcompdump for about a day
if [[ $ZSH_COMPDUMP(#qNmh-20) ]]; then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -i -d "$ZSH_COMPDUMP"; touch "$ZSH_COMPDUMP"
fi
{
  # compile .zcompdump
  if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
    zcompile "$ZSH_COMPDUMP"
  fi
} &!


################################################################################
# wayland stuff ################################################################
################################################################################
 
# export WLR_EGL_NO_MODIFIERS=1 
# this breaks hyprland. DO NOT EXPORT

# possible this shouldn't be here
# export XDG_CURRENT_DESKTOP=Hyprland 
# export XDG_SESSION_TYPE=wayland 
# export XDG_SESSION_DESKTOP=Hyprland
# tell firefox to run natively in wayland
MOZ_ENABLE_WAYLAND=1

# without this u have no cursor on hyprland
export WLR_NO_HARDWARE_CURSORS=1

# # Without this IDEA won't work
export _JAVA_AWT_WM_NONREPARENTING=1


################################################################################
# SSH and GPG ##################################################################
################################################################################

export GPG_TTY="$(tty)"

# thank u contre
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
#   # Only use gpg/ssh keys when not in an SSH connection. Not to replace the keys forwarded by the ssh agent.
#   # SSH Configuration with GPG
#   #echo [KEYGRIP] >> ~/.gnupg/sshcontrol
#   export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#   gpgconf --launch gpg-agent
# fi

if [[ -z $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
  # Only use gpg/ssh keys when not in an SSH connection. Not to replace the keys forwarded by the ssh agent.
  # SSH Configuration with GPG
  #echo [KEYGRIP] >> ~/.gnupg/sshcontrol
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
  gpgconf --launch gpg-agent
  alias cat=bat
fi


################################################################################
# misc #########################################################################
################################################################################

# interactive cd on tab with fzf
# source /home/zspekt/.cache/antidote/https-COLON--SLASH--SLASH-github.com-SLASH-ohmyzsh-SLASH-ohmyzsh/plugins/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh

export ZSH_CACHE_DIR=$HOME/.cache/zsh

# History in cache directory:
setopt SHARE_HISTORY
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt HIST_EXPIRE_DUPS_FIRST


################################################################################
# aliases ######################################################################
################################################################################

# alias cat=bat
#
alias gcsmsp="gcsm 'submodule' && gp"
alias gs="git switch"

alias du="du -hc"
alias rwb="killall waybar; waybar & disown"
alias p=passmenu
alias int="ping -c 3 ping.archlinux.org"
# alias vim=nvim
# alias vi=nvim
alias ls='ls -l'
alias nvlog="journalctl | nvim"
alias gmi="go mod init"
alias gor="go run"
alias ipv6="ifconfig |  grep -o 'inet6 [^fde:].*global>' | awk '{print \$2}'"

# zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
# zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
# zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
# zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default

################################################################################
# plugins ######################################################################
################################################################################

# antidote
source ~/.zsh/zsh_plugins.sh

bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^o' 'lfcd\n'

setopt HIST_IGNORE_ALL_DUPS

# bindings for history-substring-search-up
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# autoload -Uz compinit && compinit
# zstyle ':completion:*' menu select
# zmodload zsh/complist
# compinit
# _comp_options+=(globdots)               # Include hidden files.
# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history


################################################################################
# paths ########################################################################
################################################################################

export PATH=$PATH:/home/zspekt/programs/scripts

export PATH=$PATH:/home/zspekt/go

export PATH=$PATH:/home/zspekt/go/bin

################################################################################
# more bloated theme stuff #####################################################
################################################################################

autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
