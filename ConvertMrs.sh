#!/bin/bash
wget -O mihomo.gz \
  $(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest \
  | grep '"browser_download_url":' \
  | sed 's/.*"\(.*\)".*/\1/'\
  | grep linux-amd64-v.*\.gz)

gzip -d mihomo.gz
chmod 777 mihomo

convert() {
  local path="$1"
  local behavior="$2"

  local files=()
  if ls $path/*.list &>/dev/null; then
      files+=($path/*.list)
  fi
  if ls $path/*.yaml &>/dev/null; then
      files+=($path/*.yaml)
  fi

  # 检查是否找到任何文件
  if [ ${#files[@]} -eq 0 ]; then
      echo "[❎] 没有符合条件的文件：$path"
      return
  fi

  for file in "${files[@]}"; do
    local type="${file##*.}"
    local basename="${file%.$type}"
    if [ "$type" == "list" ]; then
      type=text
    fi

    ./mihomo convert-ruleset $behavior $type $file "${basename}.mrs"
    echo "[✅] ${basename}.mrs"
  done
}

convert ./domain domain
convert ./ipcidr ipcidr

rm -f mihomo*
