source $HOME/.bin/git-completion.sh

export ALTERNATE_EDITOR=""
# export BROWSER="chrome"
export EDITOR="$HOME/.bin/em"
export EMAIL="guoweis@gmail.com"
export GOPATH="$HOME/code/go"
export GPG_TTY=$(tty)
export HISTFILESIZE=20000
export HOMEBREW_NO_ANALYTICS=1
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export NAME="Guowei Shieh"
export PROMPT_DIRTRIM=3

source /etc/bash_completion.d/password-store

source "/usr/local/share/chruby/chruby.sh"
chruby 2.5.3

### local config settings, if any

if [ -e $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi

### Outreach
export GOPRIVATE=github.com/getoutreach/*
export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/
export OUTREACH_PROJECT_ROOT="$HOME/code/getoutreach"
