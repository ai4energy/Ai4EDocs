# Tauri项目建立与开发


### 1. **访问Tauri官网**

首先，打开 [Tauri官网](https://tauri.app/zh-cn/start/) 以获取有关Tauri的相关信息和安装指南。

### 2. **使用Yarn创建Tauri项目**

在命令提示符或终端中执行以下命令，启动Tauri项目生成器：

```bash
yarn create tauri-app
```

这将启动交互式的项目创建流程，期间会要求你进行一些选择。我们将根据以下设置进行：

- **项目模板选择：** `Vue.js`。
- **是否使用TypeScript：** `Yes`。
- **包管理工具选择：** `Yarn`。

具体流程如下：

```bash
? What’s your project name? › my-tauri-app
? Which frontend framework would you like to use? › Vue.js
? Would you like to add TypeScript? › Yes
? Which package manager would you like to use? › Yarn
```

这会创建一个带有Vue和TypeScript支持的Tauri项目，使用Yarn作为包管理工具。

### 3. **进入项目目录**

项目创建完成后，进入新生成的项目目录。假设项目名称为 `my-tauri-app`，你可以运行以下命令：

```bash
cd my-tauri-app
```

### 4. **安装项目依赖**

进入项目目录后，使用Yarn来安装项目的所有依赖包。执行以下命令：

```bash
yarn
```

此命令会根据项目的 `package.json` 文件下载所有的依赖项。

### 5. **启动开发模式**

安装完成后，你可以启动Tauri的开发模式以进行实时调试。运行以下命令：

```bash
yarn tauri dev
```

这会打开Tauri应用窗口，并启动Vue的开发服务器，让你能够实时预览你的应用，并且在代码更新时进行热加载。

### 6. **修改Vue代码**

Tauri项目的前端代码位于 `src` 文件夹内。你可以根据项目需求修改 `src` 目录下的Vue和TypeScript文件。例如，修改 `src/App.vue` 来更新界面或添加新的功能。

### 7. **构建项目**

当开发完成并准备发布时，可以使用以下命令构建项目。这个命令会生成适用于Windows、macOS或Linux的桌面应用程序：

```bash
yarn tauri build
```

构建完成后，生成的可执行文件会放在 `src-tauri/target/release/` 目录下。你可以找到适合你操作系统的可执行文件。

### 8. **检查构建输出**

在 `src-tauri/target/release/` 目录下，你会看到一个应用程序文件。双击该文件可以运行已打包好的Tauri桌面应用。

### 总结

到此为止，你已经完成了以下步骤：
1. 使用Yarn创建了一个基于 **Vue.js** 和 **TypeScript** 的Tauri项目。
2. 通过Yarn安装了项目的所有依赖。
3. 进入开发模式，实时调试和查看你的Tauri应用。
4. 完成项目开发后，通过 `yarn tauri build` 打包生成可执行文件。



在使用Tauri项目时，由于选择了GNU工具链，你可能会遇到已知的 "ld too large" 错误。这是一个常见的问题，可以参考[Tauri的Issue #4794](https://github.com/tauri-apps/tauri/issues/4794)进行了解。

### 问题解决方案：

1. **切换到MSVC工具链**：
   这是最直接的解决方案，MSVC工具链通常不会出现这个问题。如果你选择切换到MSVC工具链，请按照以下步骤进行：

   - 安装MSVC工具链：
     打开命令提示符，执行以下命令安装MSVC工具链：
     ```bash
     rustup toolchain install stable-x86_64-pc-windows-msvc
     ```
   
   - 设置MSVC为默认工具链：
     ```bash
     rustup default stable-x86_64-pc-windows-msvc
     ```

2. **使用`--exclude-libs=all`选项**：
   如果你继续使用GNU工具链，可以通过设置 `RUSTFLAGS` 来解决此问题。在Windows PowerShell中执行以下命令：
   
   ```bash
   $env:RUSTFLAGS="-C link-arg=-Wl,--exclude-libs=ALL"
   yarn tauri dev
   ```

   这个命令通过设置 `RUSTFLAGS` 环境变量，告诉链接器排除所有库，解决 “ld too large” 问题。

### 选择方案：

你可以根据你的需求选择切换到MSVC工具链或者继续使用GNU工具链并添加 `--exclude-libs=all` 选项。

执行以上命令后，重新运行你的Tauri开发命令应该能够正常工作：

```bash
yarn tauri dev
```

你可以将 `$env:RUSTFLAGS="-C link-arg=-Wl,--exclude-libs=ALL"` 写入 PowerShell 的 profile 文件中，这样每次启动 PowerShell 时都会自动加载这个环境变量。

以下是如何将该环境变量写入 PowerShell 的 profile 文件的步骤：

### 1. **打开PowerShell**

首先，打开你的 PowerShell 终端。

### 2. **检查 PowerShell Profile 文件路径**

你可以使用以下命令来查看当前用户的 PowerShell profile 文件路径：

```powershell
$profile
```

这会显示 profile 文件的路径，通常是类似这样的路径：

```plaintext
C:\Users\<你的用户名>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

### 3. **编辑 PowerShell Profile 文件**

接下来，我们需要在该文件中添加 `RUSTFLAGS` 环境变量。

- 如果 profile 文件不存在，你可以创建它。执行以下命令：

```powershell
if (!(Test-Path -Path $profile)) {
    New-Item -Type File -Path $profile -Force
}
```

- 使用以下命令在编辑器中打开 profile 文件（你可以使用你喜欢的编辑器）：

```powershell
code $profile
```

### 4. **添加RUSTFLAGS环境变量到Profile文件**

在打开的 `Microsoft.PowerShell_profile.ps1` 文件中，添加以下行：

```powershell
$env:RUSTFLAGS="-C link-arg=-Wl,--exclude-libs=ALL"
```

保存并关闭文件。

### 5. **重启PowerShell**

完成之后，关闭并重新打开 PowerShell。然后可以通过以下命令验证 `RUSTFLAGS` 是否已经生效：

```powershell
echo $env:RUSTFLAGS
```

你应该能看到以下输出：

```plaintext
-C link-arg=-Wl,--exclude-libs=ALL
```

### 6. **继续Tauri项目开发**

现在，`RUSTFLAGS` 环境变量将会在每次打开 PowerShell 时自动加载，因此你可以继续使用以下命令进行开发：

```bash
yarn tauri dev
```

这将确保 `RUSTFLAGS` 选项自动应用，避免“ld too large”问题。
