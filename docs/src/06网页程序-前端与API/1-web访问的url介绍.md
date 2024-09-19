# web的在开发综合能源系统平台时，理解Web的基础知识非常重要，特别是URL格式以及GET和POST请求。

### 1. **Web的URL格式**
URL（统一资源定位符）是用于标识互联网上资源的地址。它的基本格式如下：

```
protocol://hostname:port/path?query#fragment
```

- **protocol**: 传输协议，通常是 `http` 或 `https`。
- **hostname**: 服务器的域名或IP地址，比如 `example.com`。
- **port**: 服务器的端口号（默认情况下，HTTP为80，HTTPS为443），通常可以省略。
- **path**: 资源的路径，指向服务器上的具体资源。例如 `/api/v1/devices`。
- **query**: 查询参数部分，通常以键值对形式存在，并且多个参数用 `&` 分隔。例如 `?id=123&name=abc`。
- **fragment**: 锚点，通常用于指示页面内的位置，URL末尾的 `#` 之后的内容。

### 2. **GET 和 POST 请求**
在前后端分离的架构中，前端通过HTTP请求与后端进行通信，最常用的请求方式是GET和POST。

- **GET 请求**:
  - 用于从服务器获取数据。
  - 参数通常以查询字符串的形式添加在URL中，例如 `/api/v1/devices?id=123`。
  - GET请求是幂等的，也就是说同样的请求多次执行会得到相同的结果。
  - **示例**:
    ```http
    GET /api/v1/devices?id=123 HTTP/1.1
    Host: example.com
    ```

- **POST 请求**:
  - 用于向服务器提交数据（比如创建一个新资源）。
  - 参数通常在请求的主体（body）中发送，而不是在URL中。
  - POST请求不是幂等的，多次提交同样的数据可能会导致多次创建资源。
  - **示例**:
    ```http
    POST /api/v1/devices HTTP/1.1
    Host: example.com
    Content-Type: application/json

    {
      "name": "new_device",
      "type": "sensor"
    }
    ```

简单来说，GET用于“获取”，POST用于“提交”。