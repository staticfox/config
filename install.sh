#!/bin/bash
set -ue

PWD=`pwd`
pkgmgr=
pkgmgr_install=
need_sudo_pkg=
rversion="ruby-2.3.4"
nodeversion="v7.10.0"
want_pkgs=false

# This should only be run by an actual user
if [ $UID -eq 0 ] ; then
    echo "Please do not run this as root."
    exit 1
fi

if [ $# -ge 1 ] ; then
    if [ $1 = "-p" ]; then
        want_pkgs=true
    fi
fi

have_prog() {
    [ -x "$(which $1)" ]
}

setup_pacaur() {
    pacaur -Syu
    pkgmgr="pacaur"
    pkgmgr_install="-S"
}

setup_apt() {
    sudo apt-get update
    sudo apt-get upgrade
    pkgmgr="apt-get"
    pkgmgr_install="install"
    need_sudo_pkg="sudo"
}

pkg_install() {
    $need_sudo_pkg $pkgmgr $pkgmgr_install $1
}

install_if_need() {
    if ! have_prog $1 ; then
        pkg_install $1
        echo 0
    else
        echo 1
    fi
}

install_rvm() {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable
}

if $want_pkgs ; then
    if have_prog pacaur ; then
        setup_pacaur
    elif have_prog apt-get ; then
        setup_apt
    else
        echo "Unable to determine package manager!"
        exit 1
    fi
else
    echo "Skipping package update"
fi

if $want_pkgs ; then
    echo "Installing packages..."
    # Install packages
    want_progs=(git clang htop iftop iotop nmap mtr whois zsh)

    for p in "${want_progs[@]}" ; do
        res=$(install_if_need $p)
        if [[ $p = 'zsh' && $res -eq 0 ]]; then
            pkg_install 'zsh-syntax-highlighting'
        fi
    done
else
    echo "Skipping package installation"
fi

# Create a general purpose bin directory
mkdir -p ${HOME}/bin
mkdir -p ${HOME}/binext

echo "Installing utilities..."
for p in `ls ${PWD}/home/bin/` ; do
    rm -f ${HOME}/bin/${p}
    ln -s ${PWD}/home/bin/$p ${HOME}/bin/${p}
done

echo "Installing Sublime Text 3 dependencies..."
# Customized theme and syntax highlighting beacuse I like my code
# pretty :3
mkdir -p ~/.config/sublime-text-3/Packages/Rust/
rm -f ~/.config/sublime-text-3/Packages/Rust/Rust-Static.sublime-syntax
ln -s ${PWD}/st3/Rust-Static.sublime-syntax ~/.config/sublime-text-3/Packages/Rust/Rust-Static.sublime-syntax

mkdir -p ~/.config/sublime-text-3/Packages/User/
rm -f ~/.config/sublime-text-3/Packages/User/Monokai-Static.tmTheme
ln -s ${PWD}/st3/Monokai-Static.tmTheme ~/.config/sublime-text-3/Packages/User/Monokai-Static.tmTheme

rm -f ~/.config/sublime-text-3/Packages/User/Package\ Control.sublime-settings
ln -s ${PWD}/st3/Package\ Control.sublime-settings ~/.config/sublime-text-3/Packages/User/Package\ Control.sublime-settings

echo "Installing .zshrc..."
# Relink zshrc
rm -f ~/.zshrc
ln -s ${PWD}/home/.zshrc ~/.zshrc

echo "Installing .vimrc..."
# Relink vimrc
rm -f ~/.vimrc
ln -s ${PWD}/home/.vimrc ~/.vimrc

if ! $want_pkgs ; then
    echo "Not installing languages."
    echo "Done."
    exit 0
fi

echo "Installing Ruby..."
# Ruby!
if ! have_prog rvm ; then
    install_rvm
    . ${HOME}/.rvm/scripts/rvm
    rvm install "$rversion"
    rvm use "$rversion"
    gem install bundler
fi

echo "Installing Rust..."
# Rust!
if ! have_prog rustc ; then
    wget https://static.rust-lang.org/dist/rust-1.13.0-x86_64-unknown-linux-gnu.tar.gz
    tar -zxvf rust-1.13.0-x86_64-unknown-linux-gnu.tar.gz
    cd rust-1.13.0-x86_64-unknown-linux-gnu
    sudo ./install.sh
    cd ..
    rm -rf rust-1.13.0-x86_64-unknown-linux-gnu
    rm -f rust-1.13.0-x86_64-unknown-linux-gnu.tar.gz
fi

echo "Installing Node..."
# NodeJS!
if ! have_prog nvm ; then
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | $SHELL
    . ${HOME}/.nvm/nvm.sh
    nvm install $nodeversion
fi

echo "Installing EmberJS..."
if ! have_prog ember ; then
    npm install -g ember
fi

echo "Installing Bower..."
if ! have_prog bower ; then
    npm install -g bower
fi

echo "Done."
