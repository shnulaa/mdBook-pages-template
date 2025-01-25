#!/bin/bash

# 设置要搜索的目录，默认是当前目录
target_dir="${1:-.}"

# 检查目标目录是否存在
if [ ! -d "$target_dir" ]; then
  echo "错误: 目标目录 '$target_dir' 不存在"
  exit 1
fi

# 使用 find 命令递归查找所有 .md 文件
find "$target_dir" -type f -name "*.md" -print0 | while IFS= read -r -d $'\0' file; do
  # 检查文件是否已经有 [TOC] 在第一行
  if ! head -n 1 "$file" | grep -q "^[[:space:]]*\[TOC\]"; then
     echo "[TOC]" | cat - "$file" > "$file.tmp" && mv "$file.tmp" "$file"
     echo "已添加 [TOC] 到文件: $file"
   else
    echo "文件: $file 已包含 [TOC] 在第一行，跳过"
  fi
done

echo "操作完成"
