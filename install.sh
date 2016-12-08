#!/bin/bash
set -e

PWD=`pwd`
pkgmgr=
pkgmgr_install=
need_sudo_pkg=
rversion="ruby-2.3.3"

# This should only be run by an actual user
if [ $UID -eq 0 ] ; then
    echo "Please do not run this as root."
    exit
fi

have_prog() {
    [ -x "$(which $1)" ]
}

setup_pacaur() {
    #pacaur -Syu
    pkgmgr="pacaur"
    pkgmgr_install="-S"
}

setup_apt() {
    sudo apt update
    sudo apt upgrade
    pkgmgr="apt"
    pkgmgr_install="install"
    need_sudo_pkg="sudo"
}

pkg_install() {
    $need_sudo_pkg $pkgmgr $pkgmgr_install $1
}

install_if_need() {
    if ! have_prog $1 ; then
        pkg_install $1
    fi
}

install_rvm() {
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable
}

if have_prog pacaur ; then
    setup_pacaur
elif have_prog apt ; then
    setup_apt
else
    echo "Unable to determine package manager!"
    exit
fi

want_progs=(git clang htop iftop iotop nmap mtr whois)

for p in "${want_progs[@]}" ; do
    install_if_need $p
done

# Create a genera purpose bin directory
mkdir -p ${HOME}/bin

# Customized theme and syntax highlighting beacuse I like my code
# pretty :3
mkdir -p ~/.config/sublime-text-3/Packages/Rust/
rm -f ~/.config/sublime-text-3/Packages/Rust/Rust-Static.sublime-syntax
ln -s ${PWD}/st3/Rust-Static.sublime-syntax ~/.config/sublime-text-3/Packages/Rust/Rust-Static.sublime-syntax

mkdir -p ~/.config/sublime-text-3/Packages/User/
rm -f ~/.config/sublime-text-3/Packages/User/Monokai-Static.tmTheme
ln -s ${PWD}/st3/Monokai-Static.tmTheme ~/.config/sublime-text-3/Packages/User/Monokai-Static.tmTheme

# Ruby!
install_rvm

rvm install "$rversion"
rvm use "$rversion"
gem install bundler
