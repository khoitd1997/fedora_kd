#!/bin/bash

if [ ! -d "~/.linuxbrew/Homebrew" ]; then
    # from https://docs.brew.sh/Homebrew-on-Linux
    git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
    mkdir ~/.linuxbrew/bin
    ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
    eval $(~/.linuxbrew/bin/brew shellenv)

    # taken from https://docs.brew.sh/Homebrew-on-Linux
    test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv)
    test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile
fi

source ~/.profile

brew install \
    hexyl \
    tig \
    exa \
    peco \
    bat \
    hyperfine \
    fzf \
    ripgrep \
    tldr \
    fd

$(brew --prefix)/opt/fzf/install --all