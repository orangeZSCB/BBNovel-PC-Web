#!/bin/bash
# 智墨前端部署：构建 → 推 GitHub Pages（novel.orgu.cc）
# 回滚：git checkout backup/old-dist-20260816 的内容推 main，或
#   cd web-deploy && git checkout -B main backup/old-dist-20260816 && git push -f origin main
set -e
cd "$(dirname "$0")"
FRONTEND=../repo/frontend

echo "==> build"
(cd "$FRONTEND" && CI=true ./node_modules/.bin/vite build)

echo "==> sync to main branch"
git fetch origin
git checkout -B main FETCH_HEAD 2>/dev/null || git checkout -B main backup/old-dist-20260816
rm -rf assets index.html
cp -R "$FRONTEND/dist/." .
git add -A
git commit -m "deploy: $(date '+%Y-%m-%d %H:%M:%S') zhimo"
git push origin main
echo "==> done, https://novel.orgu.cc/"
