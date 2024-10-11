接下来，我们可以一步步实现你的需求：通过 **Go-Zero** 构建一个可执行的程序，并通过 **Tokio** 启动它，同时使用 **WebSocket** 在 Go-Zero 中调用 **Julia** 后端（并改为使用 **Oxygen.jl** 作为Julia的相关代码）。

### 1. **使用 Go-Zero 构建可执行程序**

首先，我们需要构建一个基于 Go-Zero 的 WebSocket 服务，它能够与 Julia 的 Oxygen.jl 进行交互。Go-Zero 提供了简便的方式来创建基于 Go 的微服务，首先你需要安装 Go-Zero：

```bash
go install github.com/zeromicro/go-zero/tools/goctl@latest
```

#### 创建 Go-Zero 项目

1. 创建 Go-Zero 项目目录：
   ```bash
   mkdir gozero-julia
   cd gozero-julia
   ```

2. 使用 `goctl` 工具生成服务的代码模板：
   ```bash
   goctl api new juliaws
   ```

3. 在生成的 `juliaws` 目录下，修改生成的 API 定义文件 `juliaws.api`，增加 WebSocket 路由：
   ```yaml
   type WebSocketRequest {
     message string
   }

   @handler websocketHandler
   get /ws websocket(WebSocketRequest)
   ```

4. 运行以下命令生成代码：
   ```bash
   goctl api go -api juliaws.api -dir .
   ```

生成后，`websocketHandler` 处理 WebSocket 请求。

### 2. **在 Go-Zero 中通过 WebSocket 调用 Julia 后端**

接下来，我们修改生成的 `websocketHandler`，使其通过 WebSocket 接收到消息后，调用 Julia 后端执行代码。

在 `handler/websockethandler.go` 中添加以下逻辑：

```go
package handler

import (
    "fmt"
    "log"
    "net/http"

    "github.com/gorilla/websocket"
    "github.com/zeromicro/go-zero/rest/httpx"
    "os/exec"
)

var upgrader = websocket.Upgrader{
    ReadBufferSize:  1024,
    WriteBufferSize: 1024,
}

func websocketHandler(w http.ResponseWriter, r *http.Request) {
    conn, err := upgrader.Upgrade(w, r, nil)
    if err != nil {
        log.Println("Failed to set websocket upgrade:", err)
        return
    }
    defer conn.Close()

    for {
        messageType, p, err := conn.ReadMessage()
        if err != nil {
            log.Println("Read error:", err)
            return
        }

        // 在这里调用 Julia 后端
        output, err := callJulia(string(p))  // p 是从 WebSocket 接收到的消息
        if err != nil {
            log.Println("Failed to call Julia:", err)
            conn.WriteMessage(messageType, []byte("Failed to call Julia"))
            continue
        }

        // 将 Julia 的结果返回给客户端
        conn.WriteMessage(messageType, []byte(output))
    }
}

func callJulia(message string) (string, error) {
    cmd := exec.Command("julia", "--project=../src-julia", "../src-julia/julia-server.jl", message)
    output, err := cmd.CombinedOutput()
    if err != nil {
        return "", err
    }
    return string(output), nil
}
```

该代码通过 WebSocket 接收来自客户端的消息，然后调用 Julia 的脚本处理请求，最后将结果返回给客户端。

### 3. **使用 Tokio 启动 Go-Zero 服务**

接下来，我们需要通过 **Tokio** 启动 Go-Zero 服务。你可以通过以下方式在 Rust 中启动 Go-Zero 可执行程序。

在 Rust 中使用 `tokio::process::Command` 启动 Go-Zero 服务，并保持它运行。

#### 修改 Rust 代码：

```rust
use tokio::process::Command;

async fn start_go_zero_service() -> Result<(), Box<dyn std::error::Error>> {
    let child = Command::new("go")
        .arg("run")
        .arg("./gozero-julia/main.go")  // 你的 Go-Zero 项目路径
        .spawn()
        .expect("Failed to start Go-Zero service");

    // 等待 Go-Zero 服务启动
    tokio::time::sleep(tokio::time::Duration::from_secs(5)).await;

    Ok(())
}
```

该函数会启动 Go-Zero 的 WebSocket 服务，稍后可以通过 Julia 进行交互。

### 4. **更新 Julia 后端以使用 Oxygen.jl**

现在你需要将 Julia 的后端代码改为使用 **Oxygen.jl**。假设你已经安装了 **Oxygen.jl**，你可以在 `julia-server.jl` 中引入并使用它。

#### 修改 `julia-server.jl`：

```julia
using Oxygen

# 定义一个简单的函数，通过 WebSocket 传递参数并使用 Oxygen 计算
function process_message(message::String)
    # 假设 message 是一个 JSON 字符串，我们可以解析并使用 Oxygen.jl 进行计算
    input = parse(Float64, message)  # 简单示例，实际场景会更复杂

    # 使用 Oxygen.jl 进行一些科学计算
    result = input + 42  # 假设我们做一些简单的计算
    return result
end

# 从命令行接收参数
if length(ARGS) > 0
    message = ARGS[1]
    result = process_message(message)
    println(result)  # 将结果返回到标准输出
end
```

通过这种方式，你的 Julia 代码使用了 **Oxygen.jl** 进行计算，并将计算结果通过 Go-Zero 返回到前端。

### 5. **整体工作流程总结**

1. **Go-Zero 服务**：
   - 在 Go-Zero 中创建 WebSocket 服务，接收前端消息。
   - 通过 WebSocket 将消息发送到 Julia 后端进行处理。

2. **Tokio 启动 Go-Zero 服务**：
   - 通过 Tokio 的异步功能，Rust 可以启动 Go-Zero 服务并保持其运行。

3. **Julia 使用 Oxygen.jl**：
   - Julia 后端通过接收参数并使用 Oxygen.jl 进行科学计算，最终将结果返回给 WebSocket 客户端。

这个架构使得 Go-Zero、Rust、Julia（Oxygen.jl） 形成了一个完整的、可扩展的系统，并可以通过 WebSocket 高效地交互和调用。