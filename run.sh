#!/bin/bash

# 1. 获取脚本所在路径和系统时间日期
script_path=$(dirname "$(readlink -f "$0")")
current_datetime=$(date "+%Y-%m-%d %H:%M:%S")
echo "脚本所在路径：$script_path"
echo "系统时间：$current_datetime"

# 2. 切换到程序所在目录
echo "切换到程序所在目录..."
cd "$script_path"

# 3. 设置 Git 用户名和邮箱
git config user.name "vbskycn"
git config user.email "zhoujie218@gmail.com"

# 4. 执行 Git 操作，放弃本地更改并拉取最新代码
echo "正在执行 Git 操作..."
git fetch origin
git reset --hard origin/master
git clean -fd
git pull

# 5. 检查并创建虚拟环境
if [ ! -d "/venv" ]; then
    echo "正在创建虚拟环境..."
    python3 -m venv /venv
else
    echo "虚拟环境已存在，跳过创建步骤。"
fi

# 6. 激活虚拟环境
source /venv/bin/activate

# 7. 安装pipenv并运行
echo "正在安装pipenv并运行项目..."
pip3 install pipenv
pipenv install
pipenv run build

# 8. 提交更改并推送
echo "正在提交更改并推送到Git..."
git add .
commit_message="debian100 $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$commit_message"
git push

echo "脚本执行完成"