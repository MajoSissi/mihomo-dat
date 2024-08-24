#!/bin/bash
pull(){
	local path="$1"
	local url="$2"
	wget -P $1 https://raw.githubusercontent.com/$2
}

pull ./domain juewuy/ShellCrash/dev/public/fake_ip_filter.list
pull ./domain TG-Twilight/AWAvenue-Ads-Rule/main/Filters/AWAvenue-Ads-Rule-Clash.yaml
pull ./classical blackmatrix7/ios_rule_script/master/rule/Clash/Gemini/Gemini.list
pull ./classical blackmatrix7/ios_rule_script/master/rule/Clash/Game/GameDownloadCN/GameDownloadCN.list

rm -f ./domain/*.[0-9]
rm -f ./ipcidr/*.[0-9]
rm -f ./classical/*.[0-9]
