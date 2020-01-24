# -*- mode: sh -*-

alias gpj="cd ~/code/pjproject/pjsip-apps/bin"
alias src="source ~/.bashrc"

alias dc="docker-compose"
alias gg="git grep -n"
# alias git="hub"
alias less="less -R" # display colors correctly
alias sbcl="rlwrap sbcl"
alias lisp="sbcl --noinform"
alias lispi="sbcl -noinform --load"
alias la="ls -la"
alias ll="ls -l"
alias ln="ln -v"
alias ls="ls -h"
alias mkdir="mkdir -p"
alias mutt="cd $HOME/downloads; /usr/bin/mutt; cd - > /dev/null"
alias myip="ip address | grep inet.*wlan0 | cut -d' ' -f6 | sed \"s/\/24//g\""
alias speedtest='echo "scale=2; `curl  --progress-bar -w "%{speed_download}" http://speedtest.wdc01.softlayer.com/downloads/test10.zip -o /dev/null` / 131072" | bc | xargs -I {} echo {} mbps'
alias tree="tree -C" # add colors
alias ut="tar xavf"

usage() {
  du -sch "$@" | sort -h
}

### Ruby/Rails-specific
alias be="bundle exec"
alias ber="bundle exec rails"
alias bek="bundle exec rake"
alias migrate="be rake db:migrate db:test:prepare"
alias k=kubectl



### Package management
alias agi="sudo apt install"
alias agr="sudo apt remove"
alias acs="apt search"
alias agu="sudo apt update && sudo apt full-upgrade && sudo apt autoremove && sudo aptitude clean"
alias ali="apt-mark showmanual"

alias oports="echo 'User:      Command:   Port:'; echo '----------------------------' ; lsof -i 4 -P -n | grep -i 'listen' | awk '{print \$3, \$1, \$9}' | sed 's/ [a-z0-9\.\*]*:/ /' | sort -k 3 -n |xargs printf '%-10s %-10s %-10s\n' | uniq"
alias serve="python -m SimpleHTTPServer"
alias air='~/.air -c .air.conf'

# alias gcb='git checkout -b '
alias gbc='git checkout -b '
alias gc='git checkout '
alias gbd='git branch -d '
alias gb='git branch'
alias gbD='git branch -D '

alias guc='git reset --soft HEAD^'
alias gm='git commit -a -m '
alias gs='git status'
alias json_escape="python -c 'import json,sys; print json.dumps(sys.stdin.read())'"
