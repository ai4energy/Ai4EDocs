# Tauri工具链设置

### 1. **安装Node.js免安装版本**

- 访问 [Node.js官网](https://nodejs.org/)，下载“Windows Binary (.zip)”版本的免安装包。
- 下载后将其解压到一个合适的目录，例如：`C:\NodeJS`。

#### 设置环境变量：

- 右键点击“此电脑”，选择 **属性**。
- 选择 **高级系统设置** > **环境变量**。
- 在“系统变量”中找到 **Path**，双击进入。
- 点击 **新建**，添加Node.js解压路径的 `bin` 目录，例如：`C:\NodeJS`。
- 确定并保存所有窗口。

#### 验证Node.js安装：

打开命令提示符，输入以下命令查看Node.js和npm的版本：

```bash
node -v
npm -v
```

如果看到版本号说明安装成功。

#### 使用npm安装yarn：

```bash
npm install -g yarn
```

安装完成后，通过以下命令验证：

```bash
yarn -v
```

### 2. **安装Rust并配置GNU工具链**

#### 安装MSYS2：

- 访问 [MSYS2官网](https://www.msys2.org/)，下载MSYS2的安装程序并运行。
- 完成安装后，打开 **MSYS2 MinGW 64-bit** 终端。

#### 安装GNU工具链：

在MSYS2终端中执行以下命令：

```bash
pacman -Syu
pacman -S mingw-w64-x86_64-toolchain
```

这将安装包括GCC、G++在内的工具。

#### 设置MinGW的环境变量：

- 打开 **系统属性**，选择 **高级系统设置** > **环境变量**。
- 在“系统变量”中找到 **Path**，双击并点击 **新建**。
- 添加路径：`C:\msys64\mingw64\bin`，确保系统可以识别这些工具。

#### 安装Rust：

- 访问 [Rust官网](https://www.rust-lang.org/)，下载 `rustup-init.exe`。
- 打开命令提示符，导航到下载目录，运行 `rustup-init.exe`：

```bash
rustup-init.exe
```

- 选择 `2) Customize installation`，并设置 `default host triple` 为 `x86_64-pc-windows-gnu`，使用GNU工具链。
- 安装完成后，运行以下命令查看Rust版本：

```bash
rustc -V
cargo -V
```

确保Rust和Cargo已正确安装。

### 3. **安装Julia 1.11免安装版本**

#### 下载Julia：

- 访问 [Julia官网](https://julialang.org/downloads/)，下载Windows的“Generic Binaries (.zip)”版本。
- 解压到一个合适的位置，例如：`C:\Julia-1.11`。

#### 设置环境变量：

- 打开 **系统属性** > **高级系统设置** > **环境变量**。
- 在“系统变量”中找到 **Path**，双击进入。
- 点击 **新建**，添加 `C:\Julia-1.11\bin` 路径。

#### 验证Julia安装：

打开命令提示符，输入以下命令查看Julia版本：

```bash
julia -v
```

#### 配置USTC镜像源：

- 在 `C:\Users\<你的用户名>\.julia\config\` 目录下找到或创建 `startup.jl` 文件。
- 打开文件并添加以下内容：

```julia
import Pkg
ENV["JULIA_PKG_SERVER"] = "https://mirrors.ustc.edu.cn/julia"
```

#### 验证镜像配置：

启动Julia并运行以下命令：

```julia
using Pkg
Pkg.status()
```

这会确认你使用了USTC的镜像。

### 总结：

在Windows 11下，我们已完成以下内容：
1. 安装Node.js免安装版并配置环境变量，安装yarn。
2. 安装MSYS2，配置GNU工具链，并使用Rust的GNU版本安装Rust。
3. 下载并配置Julia 1.11，并设置USTC镜像为包服务器。

接下来你可以开始使用这些工具进行项目开发了。