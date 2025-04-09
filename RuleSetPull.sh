#!/bin/bash
pull(){
	local path="$1"
	local url="$2"
	wget -P $1 https://raw.githubusercontent.com/$2
}

pull ./domain juewuy/ShellCrash/dev/public/fake_ip_filter.list

rm -f ./domain/*.[0-9]
rm -f ./ipcidr/*.[0-9]
rm -f ./classical/*.[0-9]
