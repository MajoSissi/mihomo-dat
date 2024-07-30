#!/bin/bash
wget -O mihomo.gz \
  $(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest \
  | grep '"browser_download_url":' \
  | sed 's/.*"\(.*\)".*/\1/'\
  | grep linux-amd64-v.*\.gz)

gzip -d mihomo.gz
rm mihomo*

# Convert
convert() {
  local path="$1"
  local type="$2"

  local files=$path/*.list
  if [ ! -e "${files[0]}" ]; then
      echo "[❎] 没有符合条件的文件：$path"
      return
  fi

  for file in "${files[@]}"; do
    ./mihomo convert-ruleset $type text "$file" "${file%.list}.mrs"
    echo "[✅] ${file%.list}.mrs"
  done
}

convert ./domain domain
convert ./ipcidr ipcidr
