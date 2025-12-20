#!/bin/bash
set -e

# 退出时清理临时文件
cleanup() {
    rm -f mihomo*
}
trap cleanup EXIT

mihomo_download(){
  ARCH=amd64
  echo "Fetching latest version..."
  VERSION=$(curl -sL https://github.com/MetaCubeX/mihomo/releases/latest/download/version.txt)

  if [ -z "$VERSION" ]; then
      echo "Failed to get version"
      exit 1
  fi

  echo "Downloading mihomo $VERSION..."
  curl -sL -o mihomo.gz "https://github.com/MetaCubeX/mihomo/releases/latest/download/mihomo-linux-${ARCH}-${VERSION}.gz"
  gzip -d mihomo.gz
  chmod +x mihomo
}

convert() {
  local path="$1"
  local behavior="$2"

  # 开启 nullglob，如果没有匹配文件则数组为空，而不是原样保留通配符
  shopt -s nullglob
  local files=("$path"/*.list "$path"/*.yaml)
  shopt -u nullglob

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

    if ./mihomo convert-ruleset "$behavior" "$type" "$file" "${basename}.mrs"; then
        echo "[✅] ${basename}.mrs"
    else
        echo "[❌] Failed to convert $file"
    fi
  done
}

# 开始执行

mihomo_download

convert ./domain domain
convert ./ipcidr ipcidr