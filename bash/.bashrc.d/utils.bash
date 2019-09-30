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

function bpj() {
	cd ~/code/pjproject
	if ["%1" == "full"]; then
		./configure
		make dep
	fi
	make
}
