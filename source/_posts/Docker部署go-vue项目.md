---
title: Docker部署go+vue项目
date: 2024-08-16 16:36:41
tags:
- go
- docker
categories:
- 工作技术记录
---

### ⭐启动mysql

##### 1. 拉取镜像 

```
docker pull mysql:8.0.19 
```

##### 2. 启动

1. 后台运行mysql，并挂载mysql数据
2. 如遇到权限错误增加 `--privileged=true`

```cmd
docker run -p 3307:3306 --name mysql -v /mysql_data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:8.0.19

# -p 3307:3306	表示宿主机开放的mysql端口为3307，容器内mysql端口为3306
```

<!--more-->

### ⭐启动后端

##### 1. 构建镜像

```cmd
docker build --network host -t go-api .  # 镜像名称为go-api
```

```sh
# 构建时文件目录：
   ├── Dockerfile   # 后端Dockerfile  使用docker启动之前使用该dockerfile构建镜像
   └── src  # 所有后端代码
       └── xxx
```
##### 2. Dockerfile

```Dockerfile
FROM golang:alpine AS builder

# 为我们的镜像设置必要的环境变量
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# 移动到工作目录：/build
WORKDIR /build

# 将代码复制到容器中
COPY . .

# 下载依赖信息
RUN go mod download

# 将我们的代码编译成二进制可执行文件 app
RUN go build -o app .

###################
# 接下来创建一个小镜像
###################
#FROM scratch
#FROM debian:stretch-slim
# FROM python:3.8-slim
FROM python:3

COPY ./nvm_tool /nvm_tool
COPY ./wait-for-it.sh /

# 从builder镜像中把/dist/app 拷贝到当前目录
COPY --from=builder /build/app /

# apt-get换源
RUN touch /etc/apt/sources.list
RUN echo "deb http://mirrors.ustc.edu.cn/kali kali main non-free contrib" > /etc/apt/sources.list

# python3镜像是ubuntu 使用apt-get安装需要的包
RUN apt-get install libgomp1

RUN chmod 755 wait-for-it.sh

# 需要运行的命令
ENTRYPOINT ["/app", "-c", "/config.yaml"]

```

##### 3. 启动

1. 后台启动后端，并关联mysql

```cmd
docker run -d -p 8777:8777 --link=mysql --privileged -v ./config.yaml:/config.yaml -v./files:/files --name goapp go-api

# --link    	关联名为mysql的容器
# -p        	宿主机port和容器port映射
# -p 8777:8777	宿主机开放的后端端口为8777 
# -v        	挂载数据卷，容器中操作数据卷，宿主机的数据卷也会变更 
```

2. go连接mysql

```go
gdb, err := gorm.Open("mysql", "root:root@tcp(mysql:3306)/test?charset=utf8&parseTime=True&loc=Local&timeout=10s")
```

### ⭐启动前端

##### 1. 构建镜像

```cmd
docker build -t vue-web .  # 镜像名称为vue-web
```

##### 2. nginx启动前端，关联后端

```cmd
docker run -d -p 8008:80 --link goapp:goapp --name web vue-web
```

```sh
# 文件目录：
├── Dockerfile 
├── dist       # 前端打包
└── nginx
    └── conf.d
        └── default.compose.conf
```
##### 3. Dockerfile

```dockerfile
FROM nginx

COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY dist/ /usr/share/nginx/html
```
##### 4. default.compose.conf

```nginx
server {
    listen       80;
    server_name  localhost;

    access_log  /var/log/nginx/host.access.log  main;
    error_log  /var/log/nginx/error.log  error;

    client_max_body_size 0;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    location /api {
            rewrite  ^.+api/?(.*)$ /$1 break;
            proxy_pass http://goapp:8778;
            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_send_timeout 3600;
            proxy_read_timeout 3600;
            proxy_connect_timeout 3600;
    }

    error_page 404 /404.html;
            location = /40x.html {
    }
    error_page 500 502 503 504 /50x.html;
            location = /50x.html {
    }
}

```
⭐访问前端 http:// ip:8008
⭐访问后端 http:// ip:8008/api

