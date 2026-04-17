#!/bin/bash
# deploy_github_pages.sh - 部署 PyViz3D 到 GitHub Pages
# 使用方法: GITHUB_TOKEN=xxx ./deploy_github_pages.sh

set -e

DIST_DIR="dist"

# 检查 token
if [ -z "$GITHUB_TOKEN" ]; then
    echo "错误: 请设置 GITHUB_TOKEN 环境变量"
    echo "使用方法: GITHUB_TOKEN=你的token ./deploy_github_pages.sh"
    exit 1
fi

echo "=========================================="
echo "PyViz3D GitHub Pages 部署脚本"
echo "=========================================="

# 1. 创建 dist 目录并复制静态文件
echo "[1/4] 准备静态文件..."
rm -rf $DIST_DIR
mkdir -p $DIST_DIR
cp -r pyviz3d/src/* $DIST_DIR/
echo "✓ 静态文件已准备到 $DIST_DIR/"

# 2. 检查 git 状态
echo "[2/4] 检查 Git 状态..."
if [ ! -d ".git" ]; then
    echo "错误: 当前目录不是 Git 仓库"
    exit 1
fi

# 3. 创建 gh-pages 分支并部署
echo "[3/4] 部署到 gh-pages 分支..."
git branch -D gh-pages 2>/dev/null || true
git checkout --orphan gh-pages
git rm -rf . 2>/dev/null || true
if [ -d "$DIST_DIR" ] && [ "$(ls -A $DIST_DIR)" ]; then
    cp -r $DIST_DIR/* .
fi
git add -A
git commit -m "Deploy to GitHub Pages - $(date +'%Y-%m-%d %H:%M:%S')"

# 4. 推送到 GitHub
echo "[4/4] 推送到 GitHub..."
git push -u https://${GITHUB_TOKEN}@github.com/tools-research/PyViz3D.git gh-pages --force

echo ""
echo "=========================================="
echo "✓ 部署完成！"
echo "访问地址: https://tools-research.github.io/PyViz3D/"
echo "(可能需要 1-5 分钟生效)"
echo "=========================================="
