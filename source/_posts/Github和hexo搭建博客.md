---
title: Github和Hexo搭建博客
date: 2024-08-08 16:21:17
tags: 博客
---

### ⭐搭建博客

#### 1. 创建仓库

远程仓库并增加hexo分支

```
GithubUsername.github.io  // 仓库名称第一部分用github的用户名，后面固定为github.io
```

创建本地仓库

```
mkdir GithubUsername.github.io
```
<!--more-->

#### 2. 本地仓库初始化

hexo文档：https://hexo.io/zh-cn/docs/

具体步骤：

```
npm install hexo-cli -g

cd GithubUsername.github.io
hexo init (必须是空目录)

npm install
npm install hexo-deployer-git --save
```

```cmd
# 使用hexo初始化后目录结构为
|--.gitignore
|--node_modules
|--package-lock.json
|--package.json
|--scaffolds
|--source
|--themes
`--_config.yml
```

#### 3. 修改本地_config.yml

```yaml
# 这部分是网站基础信息
# Site
title: 
subtitle: 
description: ''
keywords: 
author: 
language: zh-CN
timezone: ''

# 需要改成博客的url，否则线上会404
## Set your site url here. For example, if you use GitHub Page, set url as 'https://username.github.io/project'
url: https://xxx.github.io/

deploy:
  type: git
  repository: git@github.com:xxx/xxx.github.io.git //git远程仓库地址 
  branch: master
```

#### 4. 本地代码同步远程

连接本地仓库和远程仓库

```cmd
git init
git remote add origin git@github.com:xxx/xxx.github.io.git
```

上传代码

```cmd
git add --all
git commit -m "update"
git push origin hexo
```

#### 5. 远程仓库配置

1. `Settings` -> `General`  配置`hexo`为默认分支

2. `Settings` -> `Pages` -> `Build and deployment` -> `Source` 配置为 `Deploy from a branch`

3. `Settings` -> `Pages` -> `Build and deployment` -> `Branch` 配置为`master`

#### 6. 部署

```
hexo s 		// 本地启动（调试用）
hexo clean  // 清理缓存
hexo g  	// 生成静态文件
hexo d 		// 部署到github
```

^_^ 到这里就可以进入博客啦👍

![1723794212487](/images/1723794212487.png)

------

### ⭐更新博客

#### 1. 新建文章

新增文章（文章默认都在`source/_posts`目录下）

```
hexo new [layout] <title>
```

文章开头内容为

```sh
---
title: Github和Hexo搭建博客
date: 2024-08-08 16:21:17
tags: 博客
---
```

#### 2. 更新

##### 2.1 手动更新

```
git add --all
git commit -m "update"
git push origin hexo
hexo clean
hexo g -d
```

##### 2.2 shell文件一键更新

```sh
# 写一个shell文件
vim deploy.sh

-------------

#!/bin/bash

git add --all
git commit -m "update"
git push origin hexo
hexo clean
hexo g -d

-------------

# 改权限
chmod +x deploy.sh

# 运行
./deploy.sh
```

------

### ⭐丰富博客

#### 1. 更换主题

选择主题：https://hexo.io/themes/index.html 

配置主题

```sh
# 在根目录下 拉取主题代码到theme文件夹
git clone https://github.com/next-theme/hexo-theme-next themes/next

# 修改根目录的_config.yml的theme字段为刚拉取的文件名
vim _config.yml

-------------
theme: next
-------------
```

其他主题配置项可以在`themes/next/_config.yml`里自定义

#### 2. 新建分类/标签

新建分类/标签页面

```sh
# 新建分类页
hexo new page categories

# 根据返回提示打开source/categories/index.md 增加：
---
title: categories
date: 2024-08-09 10:51:27
type: "categories" 
---
```

```sh
# 新建标签页
hexo new page tags

# 根据返回提示打开source/tags/index.md 增加：
---
title: tags
date: 2024-08-09 10:51:34
type: "tags"
---
```

配置路径

```sh
# 编辑next主题下的_config.yml文件
vim themes/next/_config.yml

-------------

menu:
  home: / || fa fa-home
  #about: /about/ || fa fa-user
  tags: /tags/ || fa fa-tags
  categories: /categories/ || fa fa-th
  archives: /archives/ || fa fa-archive
  #schedule: /schedule/ || fa fa-calendar
  #sitemap: /sitemap.xml || fa fa-sitemap
  #commonweal: /404/ || fa fa-heartbeat
  
-------------
```

给文章设置分类/标签

```sh
# 在文章开头增加tags/categories
---
title: Github和Hexo搭建博客
date: 2024-08-08 16:21:17
tags: 标签1
categories: 分类1
---
```

#### 3. 文章内容

##### 3.1 “阅读全文”按钮

在文章内增加`<!--more-->`

##### 3.2 文章中添加图片

###### 全局资源

source目录下新建images目录，图片放到images文件夹中

文章中使用图片格式为`![1723794212487](/images/1723794212487.png)`  

###### 文章资源

见官网 https://hexo.io/zh-cn/docs/asset-folders

