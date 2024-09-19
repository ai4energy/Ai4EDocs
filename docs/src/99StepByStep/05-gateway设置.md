# GateWay设置

## 网关和反向代理
我们拥有一个域名`mydomain.com`，并希望在其下承载多种服务。目前，我们考虑了以下两种实现方式：

1. **子域名与虚拟主机**：为每一项服务设置一个子域名，并在服务器上使用虚拟主机（VirtualHost）配置进行区分和管理。
   
2. **目录反向代理**：将不同的服务放在`mydomain.com`的不同目录下，并通过反向代理配置将这些目录定向到各自的后端服务器。

此时我们需要一个反向代理服务器。

反向代理服务器将作为中介站在客户端和您的各种后端服务之间。当客户端发出请求时，反向代理服务器会根据请求的URL（特别是其目录部分）来决定将请求转发到哪个后端服务器。

例如，假设您有两个服务，一个是`mydomain.com/serviceA`，另一个是`mydomain.com/serviceB`。当反向代理服务器收到指向`/serviceA`的请求时，它会将这些请求转发到为`serviceA`配置的后端服务器；同理，`/serviceB`的请求也会被转发到对应的后端服务器。

反向代理服务器还可以提供其他的功能，如：

- **负载均衡**：当有多个后端服务器提供相同的服务时，反向代理可以均匀地将请求分配给这些服务器，以确保每个服务器的负载都保持在合理的范围内。
  
- **SSL/TLS 终结**：如果您的服务需要加密，您可以在反向代理服务器上配置SSL/TLS，让它处理所有与加密相关的事务，而后端服务器则可以处理未加密的请求。

- **缓存**：反向代理可以为经常被请求的内容提供缓存功能，从而加快响应速度。

常见的反向代理服务器软件有Nginx、Apache、HAProxy等，您可以根据自己的需要和熟悉程度选择合适的软件进行配置。

我们不准备使用apisix之类的，我们只想使用nginx，使问题变得简单。

Nginx 是一个功能强大且性能卓越的反向代理服务器，并且在实际应用中已经被广泛采用。使用 Nginx 作为反向代理确实可以简化配置并确保稳定性。

APIsix 是一个高性能、实时 API 网关，提供负载均衡、动态上游、灰度发布、服务熔断、身份认证、可观测性等众多功能。它基于 Nginx 与 etcd 构建，使用 Lua 语言来实现其核心功能。APIsix 是为了满足现代微服务、云原生等复杂场景设计的 API 网关，适用于需要高度定制和扩展的场合。但是我们的需求比较简单，仅仅需要基本的反向代理功能，那么使用 Nginx 就足够了。

## 反向代理Nginx-proxy设置

`nginx-proxy` 是一个受欢迎的 Docker 包，它为运行在 Docker 容器内的 web 应用提供自动的 Nginx 反向代理服务。这个项目利用 Docker 的 API 来自动发现需要代理的服务，并更新 Nginx 的配置。

使用 `nginx-proxy` 的主要优势：

1. **自动化**：只要为您的应用容器设置正确的环境变量，`nginx-proxy` 就会自动为您创建相应的反向代理配置。
2. **简洁**：您不再需要手动编辑 Nginx 的配置文件来为每个新的服务创建反向代理。
3. **Let's Encrypt 整合**：通过与 `letsencrypt-nginx-proxy-companion` 一同使用，`nginx-proxy` 可以自动为您的域名生成和续订 SSL 证书。
4. **适应性**：它非常适合动态变化的环境，如多阶段部署或者经常有新服务上线的环境。

基本的使用流程是：

1. 运行 `nginx-proxy` 容器。
2. 当您要运行一个新的 web 服务时，只需要在该容器的环境变量中设置 `VIRTUAL_HOST`（指定该服务的域名或子域名）。
3. `nginx-proxy` 会自动检测到新的容器，并更新其 Nginx 配置以提供相应的反向代理。

这个项目确实简化了在 Docker 环境中设置反向代理的过程，非常适合需要快速部署和扩展的场景。


以下是一个使用`nginx-proxy`的典型`docker-compose.yml`:

```yaml
version: '2'
services:
  nginx-proxy:
    image: nginxproxy/nginx-proxy
    container_name: nginx-proxy
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - /var/run/docker.sock:/tmp/docker.sock:ro
      - /srv/nginx-proxy/conf.d:/etc/nginx/conf.d
      - /srv/nginx-proxy/certs:/etc/nginx/certs
      - /srv/nginx-proxy/vhost.d:/etc/nginx/vhost.d
      - /srv/nginx-proxy/html:/usr/share/nginx/html

  whoami:
    image: jwilder/whoami
    expose:
      - "8000"
    environment:
      - VIRTUAL_HOST=whoami.local
      - VIRTUAL_PORT=8000

  nginx-proxy-acme:
    image: nginxproxy/acme-companion
    container_name: nginx-proxy-acme
    environment:
      - DEFAULT_EMAIL=[YOUR_EMAIL_HERE]
    volumes_from:
      - nginx-proxy
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /srv/nginx-proxy/acme:/etc/acme.sh

networks:
   default:
       external:
          name: mynginxgroup
```

请在 `[YOUR_EMAIL_HERE]` 处替换为您的邮箱地址或使用其他非敏感信息替代，以保证配置文件的完整性和功能性。

## Backend的服务器
当您要运行一个新的服务时，我们使用这个nginx-proxy作为前哨，后端只需要启动一组docker-compose，并设置好在该容器的`VIRTUAL_HOST``即可。以web服务为例，比如我们则可以启动另外一个docker-compose:

```yaml
version: '2'

services:

  web-service:
    image: nginx:alpine
    container_name: web-container
    environment:
      - VIRTUAL_PORT=80
      - VIRTUAL_HOST=[YOUR_DOMAIN_1],[YOUR_DOMAIN_2]
      - LETSENCRYPT_HOST=[YOUR_DOMAIN_1],[YOUR_DOMAIN_2]
      - LETSENCRYPT_EMAIL=[YOUR_EMAIL]
    volumes:
      - /srv/www.yourdomain/data:/usr/share/nginx/html

networks:
   default:
       external:
          name: mynginxgroup
```

您需要在 `[YOUR_DOMAIN_1]`, `[YOUR_DOMAIN_2]` 和 `[YOUR_EMAIL]` 的位置填入适当的信息。

此配置提供了一个通用的 `nginx:alpine` 基础的web服务，与Let's Encrypt集成以自动处理SSL证书。

您应该在 `[YOUR_DOMAIN_1]`, `[YOUR_DOMAIN_2]` 和 `[YOUR_EMAIL]` 的位置填入适当的信息。

现在解释一下您提供的 `docker-compose` 文件：

- **version**: 定义了 docker-compose 文件的版本，这里使用的是 '2'。

- **services**:
  - **web-service**: 这是一个服务定义的名称，该服务运行的是基于 `nginx:alpine` 的镜像。`nginx:alpine` 是一个使用 Alpine Linux 作为基础的轻量级 nginx 容器。
  
    - **container_name**: 定义了容器的名称。
    
    - **environment**: 定义了一系列的环境变量，用于配置容器。
    
      - `VIRTUAL_PORT`: 为该服务定义的端口。
      - `VIRTUAL_HOST`: 定义了此服务应该响应的域名。
      - `LETSENCRYPT_HOST`: 定义了需要 Let's Encrypt 为其提供 SSL 证书的域名。
      - `LETSENCRYPT_EMAIL`: 定义了用于 Let's Encrypt 证书注册和恢复的电子邮件地址。
      
    - **volumes**: 此处挂载了一个主机目录到容器的 nginx 静态文件目录，使得您可以直接在主机上编辑网站内容，而不需要重建或重启容器。

- **networks**:
  - **default**: 定义了一个网络设置。此处的 `external` 指明该网络在 Docker 外部已经存在，并且其名称是 `mynginxgroup`。

这个配置是为 web 服务准备的，基于 nginx 的 web 服务器，同时也为其配置了 Let's Encrypt SSL。

## 基于目录的反向代理

即便如此，我们需要把`mydomain.com/apps`反向到不同的后端的时候，只需要在`nginx-proxy`的`vhost.d`目录中设置相应的文件：

```yaml
location /apps/ {
    # 删除/app前缀
    rewrite ^/apps(/.*)$ $1 break;

    # 反向代理到目标域名
    proxy_pass http://apps.mysomedomain.cn;

    # 以下是其他反向代理的相关设置，可以根据需求进行调整
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
}

```
这个配置是一个经典的 `nginx` 反向代理设置。这在 `nginx-proxy` 的上下文中特别有用，因为它允许您为特定的路径设置自定义的代理行为。

下面解释一下这段配置：

1. **`location /apps/`**: 这表示所有以 `/apps/` 开头的请求都会进入这个配置块。

2. **`rewrite ^/apps(/.*)$ $1 break;`**: 这行代码的作用是去掉 URL 中的 `/apps` 前缀。例如，如果有一个请求的 URL 是 `mydomain.com/apps/somepath`，它会被重写为 `apps.mysomedomain.com/somepath`。

3. **`proxy_pass http://apps.mysomedomain.com;`**: 这行代码将请求转发到 `apps.mysomedomain.com`，这是后端服务器的地址。

4. **`proxy_set_header`**: 这些指令设置代理请求的 HTTP 头部信息。例如，`proxy_set_header Host $host;` 保证了原始请求的 `Host` 头部信息被传递到后端服务器。

这种配置非常有用，特别是当您希望将一个域名下的多个路径反向代理到不同的后端服务时。通过将特定路径（如 `/apps`）代理到另一个域名或服务，您可以轻松地在同一个域名下组织和管理多个服务。

## 跨节点的代理

如果我们在网关机A上装了nginx-proxy，在同一个网段上有个服务器B，在B上启用了docker-compose，设置了virtual_host，要是想让nginx-proxy把某些服务的backend设置成B上的这个docker-compose该如何做呢？

如果你想要在机器A（带有 nginx-proxy）上为机器B上的容器提供代理服务，那么你需要在机器A的nginx-proxy上进行扩展配置。你可以在 nginx-proxy 上手动添加一个配置，指向机器B上的容器IP地址和端口。

但是这种方法不会自动更新，除非你创建一个定制版本的 nginx-proxy 来远程连接到机器B并监听其 Docker 守护程序的事件。

在`/srv/nginx-proxy/conf.d`中建立`foo.conf`，它将被挂载在`nginx-proxy`的`/etc/nginx/conf.d`。在`foo.conf`中设置`upstream`和`proxy_pass`即可。

