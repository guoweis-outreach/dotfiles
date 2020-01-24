# -*- mode: sh -*-

function countpage() {
  pdf2dsc "$1" /dev/stdout | grep "Pages" | sed s/[^0-9]//g
}

function path() {
  echo $PATH | tr ':' '\n'
}

function whoseport() {
  lsof -i tcp:$1
}

function gout() {
  cd ~/code/getoutreach
  if ! [ -z "$1" ]; then
    _DIR=`ls | grep $1`
    _DIRS=( $_DIR )
    # ${#_DIRS[@]} counts the number of elements
    # if [[ -gt 1 ]] compares string with number
    if [[ ${#_DIRS[@]} -gt 1 ]]; then
      echo $_DIR
      return
    fi
    cd $_DIR
  fi
}

# quick alias to wrap zap-pretty  and make it work for logs emitted by the go-outreach logger.
zap_pretty_go_outreach() {
   jq -Rrc '. as $line | try(fromjson | . + {"time":.["@timestamp"],"severity":.level,"caller":""} | del(.["@timestamp"], .level)) catch $line' 2>&1 | zap-pretty
}
alias log-pretty=zap_pretty_go_outreach


function railspull() {
  git pull
  bin/rails db:migrate RAILS_ENV=development
  bin/rails db:migrate RAILS_ENV=test
}

function golocal() {
  go mod edit -replace=github.com/getoutreach/$1=/Users/guoweishieh/code/getoutreach/$1
}
