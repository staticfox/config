# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
    else
    color_prompt=
    fi
fi

hostname_to_color() {
    case ${1-} in
        *fox*) host_color=red;;
    esac
}

set_prompt() {

    # constants
    local begin='\[\e['
    local end='m\]'
    local pwd='\w'

    # foreground (fg):  30 to 37
    # background (bg):  40 to 47
    # weight:           0 [normal] or 1 [bold]
    local weight=1
    local primary_bg=47
    local user='\u'
    local hostname=' :3'
    local prompt='\$'

    # time
    local tt='$(date +"%r")'

    # current Git branch
    local git_cmd='git 2>/dev/null rev-parse --abbrev-ref HEAD'
    local branch='$(b=`'"$git_cmd"'` && echo "($b) " || :)'
    local changes='' #'$(if git >/dev/null 2>&1 rev-parse --git-dir && ! git diff-index --quiet HEAD --; then echo "[uncommitted] "; fi)'

    # don't use bold in the Linux terminal because it looks bad
    if [ "$TERM" = linux ]; then
        weight=0
    fi

    # hide hostname on some systems and use color instead
    hostname_to_color "$HOSTNAME"
    unset -f hostname_to_color
    case $host_color in
        black)   primary_bg=40;;
        red)     primary_bg=41;;
        green)   primary_bg=42;;
        yellow)  primary_bg=43;;
        blue)    primary_bg=44;;
        magenta) primary_bg=45;;
        cyan)    primary_bg=46;;
        white)   primary_bg=47;;
        *)       hostname='@\h';;
    esac

    # change color based on username
    if [[ "$USER" = root ]]; then
        primary_bg=41
        user=
        hostname='@\h'
        prompt='#'
    fi

    # disable Git branch on Windows because it's slooow
    case $OSTYPE in
        cygwin) branch=; hostname='[cygwin]';;
        msys)   branch=; hostname='[msys]';;
    esac

    local primary_fg=$((primary_bg - 10))

    PS1=
    PS1+="${begin}$weight;41;$primary_bg${end} $user$hostname${begin}$primary_bg;41${end} $tt"
    PS1+="${begin}32;49${end} $branch${begin}33${end}$changes"
    PS1+="${begin}$primary_fg${end}$pwd"
    PS1+="${begin}${end}\n"    # weird things can happen if newline is colored
    PS1+="${begin}$weight;$primary_fg${end}$prompt${begin}${end} "
    PS2="${begin}$weight;$primary_fg${end}|${begin}${end} "
    PS3="${begin}$weight;$primary_fg${end}?${begin}${end} "
    PS4="${begin}$weight;$primary_fg${end}|${begin}${end} "

} && set_prompt; unset -f set_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

LS_COLORS=$LS_COLORS:'di=0;36:' ; export LS_COLORS

#PATH="/home/static/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/static/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/static/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/static/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/static/perl5"; export PERL_MM_OPT;
export GPG_TTY=$(tty)

# added by travis gem
[ -f /home/static/.travis/travis.sh ] && source /home/static/.travis/travis.sh

man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

alias gs='git status'
alias gg='gs'
alias mm='mt'

alias oops='git commit --amend --no-edit'

alias tls='tmux list-session'

export EDITOR=vim
export STEAM_RUNTIME=0

export PATH="/usr/bin:$PATH"
export PATH="${HOME}/bin:$PATH"
export PATH="${HOME}/.cargo/bin:$PATH"
PROMPT_COMMAND='echo -en "\033]0; $(whoami)@$(hostname)|$( pwd|cut -d "/" -f 4-100 ) \a"'

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

# allow the title to be set using the `TITLE` variable (if supported);
# PROMPT_COMMAND is understood directly by Bash, whereas ~/.zshrc will evaluate
# the contents of PROMPT_COMMAND
case ${TERM} in
    *xterm*|*rxvt*|*konsole*)
        # note that the tilde replacement won't work if `HOME` has a trailing
        # slash, so don't put a trailing slash when setting `HOME` on Windows
        PROMPT_COMMAND='
            if [ "${TITLE+x}" ]; then          # if `TITLE` is set, use that
                printf "\033]0;%s\a" "${TITLE}"
            else
                case ${PWD} in
                    "${HOME}")   printf "\033]0;%s\a" "~";;
                    "${HOME}/"*) printf "\033]0;%s\a" "~${PWD#"${HOME}"}";;
                    *)           printf "\033]0;%s\a" "${PWD}";;
                esac
            fi
        '
esac

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
