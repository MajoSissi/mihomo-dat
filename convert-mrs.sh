#!/bin/bash
ARCH=amd64
VERSION=$(curl -L https://github.com/MetaCubeX/mihomo/releases/latest/download/version.txt)
wget -O mihomo.gz https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-${ARCH}-${VERSION}.gz
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

    ./mihomo convert-meta-rules-dat $behavior $type $file "${basename}.mrs"
    echo "[✅] ${basename}.mrs"
  done
}

convert ./domain domain
convert ./ipcidr ipcidr

rm -f mihomo*
