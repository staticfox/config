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
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ -f $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
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
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
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

if [ "$(uname -r)" = *Microsoft* ]; then
    if [ "$(umask)" = "000" ]; then
        umask 022
    fi

    LS_COLORS='rs=0:di=1;35:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
    export LS_COLORS
fi
