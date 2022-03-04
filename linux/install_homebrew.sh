#!/bin/bash

set -e

if [ ! -d "${HOME}/.linuxbrew/Homebrew" ]; then
    # from https://docs.brew.sh/Homebrew-on-Linux
    git clone https://github.com/Homebrew/brew ~/.linuxbrew/Homebrew
    mkdir ~/.linuxbrew/bin
    ln -s ~/.linuxbrew/Homebrew/bin/brew ~/.linuxbrew/bin
    eval "$(~/.linuxbrew/bin/brew shellenv)"

    # taken from https://docs.brew.sh/Homebrew-on-Linux
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile

    # make sure homebrew is searched after the rest of the system
    {
        echo "temp_path=\"\$PATH\""
        echo "eval \$($(brew --prefix)/bin/brew shellenv)"
        echo "export PATH=\"\$temp_path:\$PATH\"" 
    } >>~/.profile
fi

# shellcheck source=/dev/null
. ~/.profile

brew install \
    exa \
    peco \
    hyperfine \
    mdbook