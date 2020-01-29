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

function find_dir() {
  local _DIR=`ls ~/code/getoutreach/ | grep $1`
  local _DIRS=( $_DIR )
  # ${#_DIRS[@]} counts the number of elements
  # if [[ -gt 1 ]] compares string with number
  if [[ ${#_DIRS[@]} -gt 1 ]]; then
    echo $_DIR
  else
    targetDir=$_DIR
  fi
}

function gout() {
  cd ~/code/getoutreach
  if ! [ -z "$1" ]; then
    local _DIR=`ls | grep $1`
    local _DIRS=( $_DIR )
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

function getsub_dir() {
  for d in $1/*/ ; do
    subDir="${d%"${d##*[!/]}"}"
    subDir="${subDir##*/}"
  done
}

function k8f() {
  find_dir $1
  local root=/Users/guoweishieh/code/getoutreach/
  getsub_dir $root/$targetDir/deployments/
  # local subDir=${targetDir#"meeting-"}
  case $2 in
    b)
      cd $root/$targetDir/deployments/$subDir/base/
      ;;
    p)
      cd $root/$targetDir/deployments/$subDir/overlay/azure-private
      ;;
    r)
      cd $root/$targetDir/deployments/$subDir/overlay/azure-rolling
      ;;
    s)
      cd $root/$targetDir/deployments/$subDir/overlay/azure-staging
      ;;
  esac
}


function kustb() {
  local curDir=${PWD##*/}
  local target=undefined
  getsub_dir $curDir
  case $1 in
    p)
      target=deployments/$subDir/overlay/azure-private
      ;;
    r)
      target=deployments/$subDir/overlay/azure-rolling
      ;;
    s)
      target=deployments/$subDir/overlay/azure-staging
      ;;
  esac

  kustomize build $target
}
