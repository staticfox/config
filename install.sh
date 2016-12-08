set -ue

# This should only be run by an actual user
if [ $UID == 0 ]
    then
        echo "Please do not run this as root."
        exit
fi

PWD=`pwd`

# Customized theme and syntax highlighting beacuse I like my code
# pretty :3
mkdir -p ~/.config/sublime-text-3/Packages/Rust/
rm -f ~/.config/sublime-text-3/Packages/Rust/Rust-Static.sublime-syntax
ln -s ${PWD}/st3/Rust-Static.sublime-syntax ~/.config/sublime-text-3/Packages/Rust/Rust-Static.sublime-syntax

mkdir -p ~/.config/sublime-text-3/Packages/User/
rm -f ~/.config/sublime-text-3/Packages/User/Monokai-Static.tmTheme
ln -s ${PWD}/st3/Monokai-Static.tmTheme ~/.config/sublime-text-3/Packages/User/Monokai-Static.tmTheme
