---

title: git
date: 2024-12-04 16:37:25
tags:
categories:
- 工作技术记录
---

##### Git global setup

```cmd
# 生成公钥
ssh-keygen -t rsa
```

``````cmd
# 配置用户和邮箱
git config --global user.name "dev"
git config --global user.email ""

# --local	对当前仓库有效
# --global	全局范围设置
``````

<!--more-->

##### Create a new repository

```python
git clone 远程git仓库地址  （git@gitlab.xxx.net:dev/test.git）
# 克隆时指定目录名
git clone 远程git仓库地址 目录名  （git clone git@gitlab.xxx.net:dev/test.git Test）
# 使用dev分支
git checkout -b test origin/dev

# 创建分支并上传远程
git checkout -b dev
git push origin dev

# 上传文件
git add .
git commit -m "xxx"
git push -u origin dev

```

##### Existing folder

```python
cd existing_folder

git init
git remote add origin 远程git仓库地址  （git@gitlab.dev.tulong.net:dev/test.git）

# 填写忽略文件
vim .gitignore 

git add .
git commit
git push -u origin master
```

##### 实例

```python
# 创建分支并上传远程
git checkout -b dev
git push origin dev

# 使用远程上其他人的分支
# 在master分支
git fetch origin
git checkout -b password origin/password

# merge request之前进行rebase
# 在dev分支
git fetch      '相当于git pull 但是会在合并之前判断是否可以pull'
git rebase origin/master   
git push -f origin dev

# 回退版本
git log   
git reset --hard 6158a46839b43(版本号)
git push -f / git push -f --set-upstream origin dev
'--set-upstream 本地关联远程分支'

# 删除远程和本地分支
git checkout master '切换到master分支'
git branch -a     
git push origin --delete dev   '删除远程dev分支'
git branch -D dev  '删除本地dev分支'

# 暂存本地
git stash / git stash save "添加暂存备注"
git stash list   '查看暂存版本'
>> 返回示例
stash@{0}: WIP on app-detail: 953b6b3 fix/token check
stash@{1}: WIP on app-detail: 953b6b3 fix/token check
git stash show stash@{0}
git stash apply stash@{0}
git stash drop stash@{0}
git stash pop stash@{0}
git stash clear

# 删除远程文件
git rm -r --cached .idea
git commit -m 'delete'
git push -u origin master

# 压缩commit
git rebase -i HEAD~7 把顶部的六个版本聚到一起进入编辑页面
```

##### Existing Git repository

```python
cd existing_repo
# 本地仓库关联远程仓库
git remote add origin 远程git仓库地址  （git@gitlab.dev.tulong.net:dev/test.git）
git push -u origin --all
git push -u origin --tags`
```

##### add时报错

git warning: LF will be replaced by CRLF in

```cmd
# git init之前
git config --global core.autocrlf false  # 禁用自动转换 
git pull origin master
```

在使用git pull时,或者切换分支的时候 ，经常会遇到报错: Please move or remove them before you can merge

```cmd
# 这是因为本地有修改,与云端别人提交的修改冲突,又没有merge.如果确定使用云端的代码,最方便的解决方法是删除本地修改,可以使用以下命令:

git clean  -d  -fx ""

# d  -----删除未被添加到git的路径中的文件
# f  -----强制运行
# x  -----删除忽略文件已经对git来说不识别的文件
# 该命令会删除本地的修改,最好先备份再使用
```



```
admin@DESKTOP-99DVA5P MINGW64 /d/WEB/testtengxun/test (test)
$ git checkout mast
Switched to branch 'master'
Your branch is up to date with 'origin/master'.

admin@DESKTOP-99DVA5P MINGW64 /d/WEB/testtengxun/test (master)
$ git pull origin master
remote: Enumerating objects: 1, done.
remote: Counting objects: 100% (1/1), done.
remote: Total 1 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (1/1), done.
From https://git.dev.tencent.com/dtid_6cc354516de124fc/test
 * branch            master     -> FETCH_HEAD
   cb9d360..963cd38  master     -> origin/master
Updating cb9d360..963cd38
Fast-forward
 1.py | 1 +
 1 file changed, 1 insertion(+)
```
