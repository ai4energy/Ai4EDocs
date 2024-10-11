# go-zero使用pg

### 1. **嵌入 PostgreSQL (pg) 到 Tauri 项目中**

首先，我们将在 Tauri 项目中使用免安装的 PostgreSQL，并通过 Rust 来启动和管理它。然后，通过 Go-Zero 和 goctl 工具生成与 pg 数据库交互的模型代码。

#### 步骤 1：下载 PostgreSQL 免安装版本

- 访问 PostgreSQL 官方 [下载页面](https://www.enterprisedb.com/download-postgresql-binaries)。
- 下载适合你的操作系统的 **免安装版本**。
- 解压缩 PostgreSQL 到项目目录的 `pg` 文件夹，例如 `projectdir/pg/`。

#### 步骤 2：启动 PostgreSQL 服务

在 Tauri 项目中，你可以使用 Rust 启动 PostgreSQL 服务。首先，创建一个 Rust 函数，使用 Tokio 异步启动 PostgreSQL。

```rust
use tokio::process::Command;
use std::path::PathBuf;

async fn start_postgres() -> Result<(), Box<dyn std::error::Error>> {
    let pg_bin_path = PathBuf::from("./pg/bin/postgres");
    let data_dir = PathBuf::from("./pg/data");

    // 初始化数据库目录
    Command::new(pg_bin_path.join("initdb"))
        .arg("-D")
        .arg(&data_dir)
        .spawn()?
        .wait()
        .await?;

    // 启动 PostgreSQL
    Command::new(pg_bin_path)
        .arg("-D")
        .arg(&data_dir)
        .spawn()?
        .wait()
        .await?;

    Ok(())
}
```

此代码将在项目目录的 `pg/data` 文件夹下初始化和启动 PostgreSQL 数据库。

#### 步骤 3：通过 Rust 启动 PostgreSQL

你可以在 Tauri 项目的 `main.rs` 中调用 `start_postgres`，确保 PostgreSQL 在应用启动时运行。

```rust
#[tokio::main]
async fn main() {
    start_postgres().await.expect("Failed to start PostgreSQL");
    tauri::Builder::default()
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
```

### 2. **使用 Go-Zero 通过 PostgreSQL 生成 Model 代码**

接下来，你可以使用 Go-Zero 的 `goctl` 工具从 PostgreSQL 中生成与数据库表交互的 Model 代码。

#### 步骤 1：配置 PostgreSQL 数据库

在你的 PostgreSQL 中创建一个新的数据库，假设名为 `mydb`：

```sql
CREATE DATABASE mydb;
```

然后，在你的数据库中创建所需的表：

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
```

#### 步骤 2：安装 `goctl`

如果你还没有安装 `goctl`，可以使用以下命令安装：

```bash
go install github.com/zeromicro/go-zero/tools/goctl@latest
```

#### 步骤 3：生成 Model 代码

使用 `goctl model` 工具从 PostgreSQL 数据库生成与表交互的 Model 代码：

```bash
goctl model pg datasource -url="postgres://username:password@localhost:5432/mydb?sslmode=disable" -table="users" -dir ./model
```

此命令会生成 `users` 表的 Go Model 代码，并保存在 `./model` 目录下。

### 3. **通过 Go-Zero 编译与 PostgreSQL 交互的服务**

生成模型代码后，你可以在 Go-Zero 中编写服务，使用模型与 PostgreSQL 进行交互。

在 `gozero-julia` 项目中的 `handler/usershandler.go` 中添加以下代码：

```go
package handler

import (
    "net/http"
    "projectdir/model"

    "github.com/zeromicro/go-zero/rest/httpx"
)

func CreateUserHandler(w http.ResponseWriter, r *http.Request) {
    var req model.Users
    if err := httpx.Parse(r, &req); err != nil {
        httpx.Error(w, err)
        return
    }

    // 通过模型与 PostgreSQL 交互
    err := model.UsersModel.Insert(req)
    if err != nil {
        httpx.Error(w, err)
    } else {
        httpx.OkJson(w, "User created successfully")
    }
}
```

### 4. **通过 Rust 启动 Go-Zero 服务**

通过 Tokio 在 Rust 中启动 Go-Zero 服务，与 PostgreSQL 进行交互：

```rust
async fn start_go_zero_service() -> Result<(), Box<dyn std::error::Error>> {
    let child = Command::new("go")
        .arg("run")
        .arg("./gozero-julia/main.go")
        .spawn()
        .expect("Failed to start Go-Zero service");

    tokio::time::sleep(tokio::time::Duration::from_secs(5)).await;

    Ok(())
}
```

你可以在 Tauri 项目的 `main.rs` 中调用 `start_postgres()` 和 `start_go_zero_service()`，以确保 PostgreSQL 和 Go-Zero 服务一起启动。

### 5. **通过 Vue 和 WebSocket 集成到 Tauri 项目中**

接下来，在前端通过 Vue.js 和 WebSocket 进行集成，调用 Go-Zero 服务。你可以像之前一样通过 WebSocket 调用 Go-Zero 中的 API：

```typescript
<script setup lang="ts">
import { ref } from "vue";

const userMsg = ref("");

// 创建用户的 WebSocket 请求
async function createUser(name: string, email: string) {
  try {
    const response = await fetch("http://localhost:19801/users", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ name, email }),
    });
    userMsg.value = await response.text();
  } catch (error) {
    userMsg.value = `Error: ${error}`;
  }
}
</script>

<template>
  <div>
    <h2>Create User</h2>
    <input placeholder="Name" v-model="name" />
    <input placeholder="Email" v-model="email" />
    <button @click="createUser(name, email)">Create User</button>
    <p>{{ userMsg }}</p>
  </div>
</template>
```

### 6. **整体流程总结**

1. **嵌入 PostgreSQL**：
   - 使用免安装的 PostgreSQL，配置并通过 Rust 启动数据库。
  
2. **使用 Go-Zero 生成 Model**：
   - 使用 `goctl` 工具从 PostgreSQL 中生成与表交互的 Model 代码。

3. **Go-Zero 服务**：
   - 编写 Go-Zero 服务，并通过模型与 PostgreSQL 进行数据交互。

4. **通过 Rust 启动 Go-Zero**：
   - 使用 Tokio 在 Rust 中启动 Go-Zero 服务，使其能够通过 HTTP 与前端交互。

5. **Vue 前端与 WebSocket 集成**：
   - 使用 Vue.js 和 WebSocket 与 Go-Zero 服务进行通信，实现前端操作和数据处理。

这样，你的 Tauri 项目就完整集成了 PostgreSQL、Go-Zero、Rust 和 Vue，并实现了数据库交互、服务启动和前后端通信。