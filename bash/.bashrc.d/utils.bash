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

function myports() {
  lsof -aPi -p $1
}

function _init() {
  gTargetDir=
  gSubDir=
  gK8fdir=
}

function _find_dir() {
  local _DIR=`ls ~/code/getoutreach/ | grep $1`
  local _DIRS=( $_DIR )
  # ${#_DIRS[@]} counts the number of elements
  # if [[ -gt 1 ]] compares string with number
  if [[ ${#_DIRS[@]} -gt 1 ]]; then
    echo $_DIR
  else
    gTargetDir=$_DIR
  fi
}

function gout() {
  cd ~/code/getoutreach
  if ! [ -z "$1" ]; then
    local _DIR=`ls | grep $1`
    if [ "$1" == "server" ]; then
      _DIR="outreach"
    fi
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
  jq -Rrc '. as $line | try(fromjson | . + {"time":.["@timestamp"],"severity":.level,"caller":""} | del(.["@timestamp"], .level)) catch $line' 2>&1 | awk '{gsub(/\\n\\t/,"\n        ")}1'| zap-pretty
}
alias log-pretty=zap_pretty_go_outreach



function railspull() {
  cd ~/code/getoutreach/outreach/server/
  git pull
  bundle install
  bin/rails db:migrate RAILS_ENV=development
  bin/rails db:migrate RAILS_ENV=test
}

function golocal() {
  _init
  _find_dir $1
  go mod edit -replace=github.com/getoutreach/$gTargetDir=/Users/guoweishieh/code/getoutreach/$gTargetDir
}

function goup() {
  _init
  _find_dir $1
  go get -u github.com/getoutreach/$gTargetDir
  go mod tidy
}


function _getsub_dir() {
  for d in $1/*/ ; do
    gSubDir="${d%"${d##*[!/]}"}"
    gSubDir="${gSubDir##*/}"
  done
}

function _k8fd() {
  _find_dir $1
  local root=/Users/guoweishieh/code/getoutreach/
  _getsub_dir $root/$gTargetDir/deployments/
  # local gSubDir=${gTargetDir#"meeting-"}
  case $2 in
    b)
      gK8fdir=$root/$gTargetDir/deployments/$gSubDir/base/
      ;;
    p)
      gK8fdir=$root/$gTargetDir/deployments/$gSubDir/overlay/azure-private
      ;;
    r)
      gK8fdir=$root/$gTargetDir/deployments/$gSubDir/overlay/azure-rolling
      ;;
    s)
      gK8fdir=$root/$gTargetDir/deployments/$gSubDir/overlay/azure-staging
      ;;
  esac
}


function kb8f() {
  _k8fd $1 $2
  kustomize build $gK8fdir
}

function cd8f() {
  _k8fd $1 $2
  cd $gK8fdir
}

# $1: ext
# $2: old
# $3: new
function frr() {
  LC_ALL=C find . -type f -name "*.$1" -exec sed -i '' s/$2/$3/ {} +
}

# 1: project
# 2: branch
function azb() {
  _init
  if [ $1 == "orchestrator-docker" ]; then
    pid=40
  else
    _find_dir $1
    local pid=0
    case $gTargetDir in
      transcription-frontdoor)
        pid=31
        ;;
      vi-kube)
        pid=32
        ;;
      meeting-orchestrator)
        pid=41
        ;;
    esac
  fi
  az pipelines run --branch $2 --id $pid --variables "namespace=private" --open
}

function syncm() {
  gc master
  git pull
  if ! [ -z "$1" ]; then
    gbc guoweis/$1
  fi
}

function syncmd() {
  local cur=`git branch --show-current`
  syncm $*
  if [[ $cur != "master" ]]; then
    git branch -D $cur
  fi
}

function gmpo() {
  gm $1
  local output=$(git push 2>&1)
  echo "output is"
  local line=`echo $output | grep https`
  echo "line is "
  echo $line
  local link=${line#"remote:"}
  echo "link is "
  echo $link
  open $link
}

function apiv2up() {
  cd /Users/guoweishieh/code/getoutreach/outreach/server/
  bundle exec rake api:generate_schema
  cd ../client
  yarn generate-classes
}


function create_hotfix() {
  local PR_NUMBER=$1
  shift
  outreach internal channel generate-hotfix-prs --pr-number=$PR_NUMBER --upstream-remote=git@github.com:getoutreach/outreach.git $*
}


function gbDq() {
  # git branch has a *, which shell will expand
  local ab=`git branch`
  # combine everything into a line, and replace * to space
  local cc=`echo "$ab" |awk '{printf $0;}' | tr '*' ' '`
  # split into an array
  local vars=( $cc )
  # walk the array
  for ii in "${vars[@]}"
  do
    if [[ $ii == "master" ]]; then
      continue
    fi
    read -p "deleteing: $ii? " del
    if [[ $del == "y" ]]; then
      git branch -D $ii
    fi
  done
}

function rtk() {
  pushd ~/code/getoutreach/outreach/server
  bundle exec rake api:generate_token[1,1]
  popd
}

function azinit() {
  az aks get-credentials -g voice-intelligence-meeting -n development
}

function azssh() {
  ssh azureuser@outreach-aks-gateway.westus.cloudapp.azure.com
}

function gtc() {
  go test ./... -coverprofile=coverage.out -coverpkg .
  go tool cover -html=./coverage.out
}

function gt() {
  go test ./...
}

function expod() {
  _init
  _find_dir $1
  pod=`kubectl -n rolling get pods | grep $gTargetDir | cut -d' ' -f1`
  kubectl -n rolling exec -it $pod sh
}

function apit {
  cd ~/code/getoutreach/meeting-verifier/tools/apitest/
  go run main.go -server localhost:5090 -b -f ../../tests/$1
}

function poweroffaudreyvm {
  az vm stop --ids /subscriptions/b0bb73fc-8668-496b-8333-e5b5ccbac7c7/resourceGroups/AUDREY-COMPUTING/providers/Microsoft.Compute/virtualMachines/audrey-vm
}

function poweronaudreyvm {
  az vm start --ids /subscriptions/b0bb73fc-8668-496b-8333-e5b5ccbac7c7/resourceGroups/AUDREY-COMPUTING/providers/Microsoft.Compute/virtualMachines/audrey-vm
}

function runapit {
  local verifier=`kubectl get pods | grep verifier | cut -d' ' -f1`
  cat ~/code/getoutreach/meeting-verifier/tests/$1 | kubectl exec -it $verifier -- /usr/local/bin/apitest -b -f -
}

function dn {
  kubectl ingress-nginx  -n $1 $2 --deployment nginx-ingress-controller
}

# az account set --subscription "Sponsorship Credit"
# az aks get-credentials -g voice-intelligence-test -n aks

function azelist {
  az storage entity query --table-name $1 --account-name generalrolling --account-key paFaDtBt4ceo0IRNZ+bFw0RdLTw9ekKXed/Wdm6GmALNuXIYEYOA8OUnRmjowe9S+nNOyMJJnnLTFYD8BYmvkQ==
}

function aztdel {
  az storage table delete --account-name generalrolling --account-key paFaDtBt4ceo0IRNZ+bFw0RdLTw9ekKXed/Wdm6GmALNuXIYEYOA8OUnRmjowe9S+nNOyMJJnnLTFYD8BYmvkQ== --name $1
}

function aztlist {
  az storage table list --account-name generalrolling --account-key paFaDtBt4ceo0IRNZ+bFw0RdLTw9ekKXed/Wdm6GmALNuXIYEYOA8OUnRmjowe9S+nNOyMJJnnLTFYD8BYmvkQ==
}

# egrep -lRZ 'rewrite' . | xargs sed -i '' '/rewrite/d'
# egrep -lRZ 'internals' . | xargs sed -i '' "s/path: \/internals\/\(\.\*\)/path :\/internals/g"

function reftpl {
  pushd /Users/guoweishieh/code/getoutreach/asrpipeline/deployments/asrtool/base/templates
  argo template delete $1
  argo template create $1.yaml
  popd
}

function killpods {
  kubectl get pod | cut -d' ' -f1 | grep $1 | xargs kubectl delete pod
}

# rsync -a asrtool/ asrtool-tts/ --include \*/ --exclude \*

function tlint {
  argo template lint deployments/asrtool/base/templates/$1.yaml
}

function mbs {
  mbsync -c ~/.dotfiles/email/.mbsyncrc personal
}

function batchrename {
  for file in *.$1; do
    mv "$file" "$(basename "$file" .$1).$2"
  done
}
