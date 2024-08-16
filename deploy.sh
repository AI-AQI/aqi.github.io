#!/bin/bash

git add --all
git commit -m "update"
git push origin hexo
hexo clean
hexo g -d
