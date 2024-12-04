---
title: Github和Hexo搭建博客
date: 2024-08-08 16:21:17
tags: 博客
---

### ⭐搭建博客

#### 创建仓库

远程仓库并增加hexo分支

```
GithubUsername.github.io  // 仓库名称第一部分用github的用户名，后面固定为github.io
```

创建本地仓库

```
mkdir GithubUsername.github.io
```
<!--more-->

#### 本地仓库初始化

https://hexo.io/zh-cn/docs/

```
npm install hexo-cli -g

cd GithubUsername.github.io
hexo init (必须是空目录)

npm install
npm install hexo-deployer-git --save
```

使用hexo初始化后目录结构为

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

#### 修改配置

_config.yml文件

```yaml
# site这部分是网站基础信息
# Site
title: 
subtitle: 
description: ''
keywords: 
author: 
language: zh-CN
timezone: ''

# url需要改成博客的url，否则线上会404
## Set your site url here. For example, if you use GitHub Page, set url as 'https://username.github.io/project'
url: https://xxx.github.io/

deploy:
  type: git
  repository: git@github.com:xxx/xxx.github.io.git //git远程仓库地址 
  branch: master
```

#### 同步代码

连接本地仓库和远程仓库

```
git init
git remote add origin git@github.com:xxx/xxx.github.io.git
```

上传代码

```
git add --all
git commit -m "blabla"
git push origin hexo
```

#### github远程仓库配置

Settings -> General  配置hexo为默认分支

Settings -> Pages -> Build and deployment -> Source 配置为 Deploy from a branch

Settings -> Pages -> Build and deployment -> Branch 配置为master

#### 部署博客到Github Pages

```
hexo clean  // 清理缓存
hexo g  	// 生成静态文件
hexo d 		// 部署到github
hexo s 		// 本地启动（调试用）
```

^_^ 到这里就可以进入博客啦

![1723794212487](/images/1723794212487.png)

------

### ⭐更新博客

#### 新建文章

文章默认都在source/_posts目录下

```
hexo new [layout] <title>
```

文章开头：

```
---
title: Github和Hexo搭建博客
date: 2024-08-08 16:21:17
tags: 博客
---
```

#### 更新

##### 手动更新

```
git add --all
git commit -m "update"
git push origin hexo
hexo clean
hexo g -d
```

##### 一键更新

```
vim deploy.sh
```

deploy.sh内容

```sh
#!/bin/bash

git add --all
git commit -m "update"
git push origin hexo
hexo clean
hexo g -d
```

改权限

```
chmod +x deploy.sh
```

执行

```
./deploy.sh
```

------

### ⭐增加一些小玩意儿

#### 更换主题

选择主题：https://hexo.io/themes/index.html 

clone主题到theme文件夹下，修改根目录的_config.yml的theme字段

示例：

```
git clone https://github.com/next-theme/hexo-theme-next themes/next

修改 根目录/_config.yml
theme: next
```

注：有一些主题配置项可以在themes/next/_config.yml里自定义修改

#### 新建分类页、标签页

```
hexo new page categories

根据返回提示打开source/categories/index.md，增加
---
title: categories
date: 2024-08-09 10:51:27
type: "categories" 
---
```

```
hexo new page tags

根据返回提示打开source/tags/index.md，增加
---
title: tags
date: 2024-08-09 10:51:34
type: "tags"
---
```

示例：next主题下在config中有对应页面的路径配置

```
themes/next/_config.yml

menu:
  home: / || fa fa-home
  #about: /about/ || fa fa-user
  tags: /tags/ || fa fa-tags
  categories: /categories/ || fa fa-th
  archives: /archives/ || fa fa-archive
  #schedule: /schedule/ || fa fa-calendar
  #sitemap: /sitemap.xml || fa fa-sitemap
  #commonweal: /404/ || fa fa-heartbeat
```

给每个文章设置分类、标签，文章开头增加：

```markdown
---
title: Github和Hexo搭建博客
date: 2024-08-08 16:21:17
tags: 博客
categories: 记录怕忘
---
```

#### 显示阅读全文按钮

在文章内增加`<!--more-->`

#### 在文章中添加图片

##### 全局资源

source目录下新建images目录，图片放到images文件夹中

文章中使用图片格式为`![1723794212487](/images/1723794212487.png)`  

##### 文章资源

见官网 https://hexo.io/zh-cn/docs/asset-folders

