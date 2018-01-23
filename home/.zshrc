# The following lines were added by compinstall

zstyle ':completion:*' list-colors ''
zstyle :compinstall filename '/home/$USER/.zshrc'

autoload -Uz compinit colors && colors
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt histignoredups
# End of lines configured by zsh-newuser-install

# Run zsh syntax highlighter
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    . $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# More colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Aliases
alias l='ls -lahtr'
alias gd='git diff'
alias gs='git status'
alias gg='git grep'
alias gco='git checkout'
alias oops='git commit --amend --no-edit'
alias fb='thunar'

autoload -U promptinit
promptinit
set_prompt()
{
    local tt='$(date +"%r")'

    # current Git branch
    add-zsh-hook precmd rf_precmd_vcs_info
    rf_precmd_vcs_info() {
        local -a git_cmd
        git_cmd=(git rev-parse --abbrev-ref HEAD)
        rf_vcs_branch=$(b=$($git_cmd 2>/dev/null) && echo " %F{red}(%f%F{green}$b%f%F{red})%f" || :)
    }

    setopt prompt_subst
    PROMPT="%F{cyan}[${tt}] %n@%m#%f\${rf_vcs_branch} "
} && set_prompt; unset -f set_prompt

precmd() {
    eval "${PROMPT_COMMAND-}"
    print -Pn "\e]0;%n@%m: %~\a"
}

typeset -A key

key[Home]="$terminfo[khome]"
key[End]="$terminfo[kend]"
key[Insert]="$terminfo[kich1]"
key[Backspace]="$terminfo[kbs]"
key[Delete]="$terminfo[kdch1]"
key[Up]="$terminfo[kcuu1]"
key[Down]="$terminfo[kcud1]"
key[Left]="$terminfo[kcub1]"
key[Right]="$terminfo[kcuf1]"
key[PageUp]="$terminfo[kpp]"
key[PageDown]="$terminfo[knp]"

[ "$key[Home]" ] && bindkey "${key[Home]}"    beginning-of-line
[ "$key[End]"  ] && bindkey "${key[End]}"     end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3~'   delete-char

if [ "${terminfo[smkx]}" ] && [ "${terminfo[rmkx]}" ]; then
    zle-line-init   () { echoti smkx; }
    zle-line-finish () { echoti rmkx; }
    zle -N zle-line-init
    zle -N zle-line-finish
fi


export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="${HOME}/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/bin" # Add personal stuff
export PATH="$PATH:$HOME/binext"
export EDITOR=vim

# added by travis gem
[ -f /home/$USER/.travis/travis.sh ] && source /home/$USER/.travis/travis.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

[[ -s "/home/static/.gvm/scripts/gvm" ]] && source "/home/static/.gvm/scripts/gvm"

