---
title: Github和Hexo搭建博客
date: 2024-08-08 16:21:17
tags: 博客
---

##### 1. 创建仓库

远程仓库并增加hexo分支

```
GithubUsername.github.io  // 仓库名称
```

创建本地仓库

```
mkdir GithubUsername.github.io
```
<!--more-->

##### 本地仓库初始化

https://hexo.io/zh-cn/docs/

```
npm install hexo-cli -g

cd GithubUsername.github.io
hexo init (必须是空目录)

npm install
npm install hexo-deployer-git --save
```

##### 使用hexo初始化后目录结构为

```
.gitignore
node_modules
package-lock.json
package.json
scaffolds
source
themes
_config.yml
```

##### 连接本地仓库和远程仓库

```
git init
git remote add origin git@github.com:xxx/xxx.github.io.git
```

##### 修改_config.yml文件

```
deploy:
  type: git
  repository: git远程仓库地址 git@github.com:xxx/xxx.github.io.git
  branch: master
```

##### 同步代码

```
git add --all
git commit -m "blabla"
git push origin hexo
```

##### 部署博客到Github Pages

```
hexo clean  // 清理缓存
hexo g  	// 生成静态文件
hexo d 		// 部署到github
hexo s 		// 本地启动
```

##### Github仓库配置

Settings -> General 

```
设置hexo为默认分支
```

Settings -> Pages 

```
Build and deployment -> Source配置为 Deploy from a branch
Build and deployment -> Branch配置为master
```

进入博客

##### 更换主题

在https://hexo.io/themes/index.html选择主题，clone主题到theme文件夹下，修改根目录的_config.yml的theme字段

示例：

```
git clone https://github.com/next-theme/hexo-theme-next themes/next

修改_config.yml
theme: next
```

##### 阅读全文按钮

在文章内增加<!--more-->
