# PowerShell和Windows Terminal
## PowerShell初印象
新时代，Windows也在向Linux学习。它现在有了新的强大命令行工具，PowerShell。并且微软现在赋予了它强大的命令行下管理能力。很多修改电脑的设置都可以在PowerShell下使用命令来完成。比如说在Windows下安装WSL（Windows Subsystem for Linux）就可以用管理员打开PowerShell，通过`wsl --install`命令来完成。

另外，PowerShell可以 先以管理员执行`Set-ExecutionPolicy RemoteSigned`，再在配置文件中设置`Set-PSReadLineOption -EditMode emacs`来开启Emacs键绑定，从而可以使用ctrl+e等命令进行光标快速移动。这一点仅仅是可以提高输入效率，可以先忽略。

## PowerShell简介
PowerShell 是一种强大的命令行工具和脚本语言，由 Microsoft 开发并广泛用于管理和自动化 Windows 系统和任务。与传统的命令提示符（CMD）相比，PowerShell 提供了更丰富的功能和更直观的语法，使系统管理员和开发人员能够更高效地管理和操作计算机系统。

以下是一些 PowerShell 的特点和功能：

1. 对象导向：PowerShell 基于对象导向的编程模型，可以使用和操作.NET Framework 中的对象。这使得在 PowerShell 中处理数据和执行操作更加灵活和直观。

2. 强大的命令和模块：PowerShell 提供了大量的内置命令，称为 cmdlet，用于执行各种系统管理任务。这些 cmdlet 具有一致的命名约定和参数结构，使得编写和执行命令更加简单和可预测。此外，PowerShell 还支持模块化，您可以导入和使用其他人编写的模块来扩展其功能。

3. 脚本和自动化：PowerShell 是一种脚本语言，可以编写和执行脚本文件以自动化重复的任务或进行批量操作。使用 PowerShell 脚本，您可以创建复杂的工作流程，处理和转换数据，访问系统资源，管理用户和权限等。

4. 远程管理：PowerShell 提供了强大的远程管理功能，可以通过网络远程管理其他计算机或服务器。您可以在本地计算机上使用 PowerShell 命令来执行远程计算机上的任务，访问远程计算机的文件和注册表，或者执行远程会话。

5. 跨平台支持：除了 Windows 系统外，PowerShell 还提供了跨平台支持，可以在 macOS、Linux 和其他操作系统上运行。这使得使用 PowerShell 进行系统管理和自动化成为跨平台环境中的一种强大工具。

PowerShell 是一项功能强大且灵活的技术，可以用于各种任务，从简单的命令执行到复杂的系统管理和自动化。它是系统管理员、开发人员和 IT 专业人员的重要工具之一，提供了更高效、一致和可编程的方式来管理计算机系统。

## 如何打开PowerShell
在 Windows 操作系统中，有几种方式可以打开 PowerShell。以下是其中一些常见的方法：

1. 使用开始菜单：
   - 单击桌面左下角的 Windows 图标来打开开始菜单。
   - 在开始菜单中，找到 "Windows PowerShell" 或 "PowerShell" 的文件夹。在该文件夹中，您将找到不同版本的 PowerShell，如 PowerShell、PowerShell 7、PowerShell 5.1 等。
   - 点击所需的 PowerShell 版本，将打开 PowerShell 窗口。

2. 使用快捷键：
   - 按下 `Windows 键 + R` 组合键，将打开 "运行" 对话框。
   - 在 "运行" 对话框中，键入 "powershell"（不包括引号）并按下回车键，将打开 PowerShell 窗口。

3. 使用 CMD 启动 PowerShell：
   - 打开命令提示符（CMD）窗口。您可以按下 `Windows 键 + R`，然后键入 "cmd"（不包括引号）并按下回车键，或者按照我之前所述的步骤在开始菜单中找到并打开命令提示符。
   - 在命令提示符窗口中，键入 "powershell"（不包括引号）并按下回车键，将从 CMD 切换到 PowerShell。

无论您选择哪种方法，都将打开一个 PowerShell 窗口，您可以在其中输入和执行 PowerShell 命令、编写和运行 PowerShell 脚本，以及进行系统管理和自动化任务。

## PowerShell可以执行Windows管理任务吗？
PowerShell 是一种功能强大的工具，可以执行大部分 Windows 系统管理任务，但并不是所有任务都可以完全由 PowerShell 完成。大多数 Windows 管理任务都可以通过 PowerShell 来实现，因为它提供了广泛的系统管理 cmdlet 和功能。

以下是 PowerShell 可以执行的常见任务：

1. 文件和文件夹操作：PowerShell 可以创建、复制、移动和删除文件和文件夹，以及管理文件和文件夹的权限和属性。

2. 进程和服务管理：PowerShell 可以列出、启动、停止和监控正在运行的进程和服务。

3. 注册表操作：PowerShell 可以读取、修改和删除 Windows 注册表中的键值。

4. 网络配置和管理：PowerShell 可以配置网络适配器、查看和修改网络设置，以及执行网络诊断任务。

5. 用户和组管理：PowerShell 可以创建、修改和删除用户账户和组，管理用户权限和访问控制。

6. 远程管理：PowerShell 提供了强大的远程管理功能，可以通过网络远程管理其他计算机或服务器。

7. 脚本编写和自动化：PowerShell 是一种脚本语言，可以编写脚本来自动化重复的任务，批量操作和工作流程。

尽管 PowerShell 能够处理大多数 Windows 管理任务，但仍有一些特定任务可能需要使用其他工具或界面。一些特定的系统配置、管理工具或应用程序可能具有自己的命令行界面或API，需要使用专门的工具或命令来执行相关任务。

综上所述，PowerShell 是一个非常强大和全面的工具，能够执行大部分 Windows 系统管理任务。但对于某些特定的任务，您可能需要使用其他工具或结合多种工具来实现所需的功能。

## Windows Terminal简介
Windows Terminal 是一款新一代的命令行工具，由 Microsoft 开发并在 Windows 操作系统中提供。它为用户提供了一个现代化、高度可定制的命令行界面，使得同时使用多个命令行工具和 Shell 变得更加方便和强大。

下面是 Windows Terminal 的一些特点和功能：

1. 多标签和分屏：Windows Terminal 支持多个标签页和分屏布局，您可以在同一个窗口中同时打开多个命令行会话，方便同时进行多个任务或操作。

2. 支持多种 Shell：Windows Terminal 可以同时运行多个不同的 Shell，如 PowerShell、命令提示符（CMD）、Windows Subsystem for Linux (WSL)、Azure Cloud Shell 等。这使得用户可以根据需要选择不同的 Shell，而无需切换窗口或应用程序。

3. 高度可定制：Windows Terminal 允许用户自定义外观、颜色主题、字体、快捷键等，以满足个人偏好和风格需求。用户可以根据自己的喜好创建和应用自定义配置文件，定制 Terminal 的外观和行为。

4. 支持 Unicode 和 Emoji：Windows Terminal 全面支持 Unicode 字符和 Emoji 表情符号，使得在命令行界面中可以正确显示和处理各种语言字符和图形符号。

5. GPU 加速和图形效果：Windows Terminal 基于 Windows 的 Universal Windows Platform (UWP) 技术，可以利用 GPU 加速和硬件加速，提供流畅的滚动、动画效果和图形渲染。

6. 快速启动和分层渲染：Windows Terminal 采用了快速启动机制和分层渲染技术，使得打开和切换会话更加迅速和高效。

7. 扩展性和开放性：Windows Terminal 是开源项目，允许开发人员通过扩展来增加新的功能和定制选项。用户可以从社区贡献的插件和扩展中获益，或者自己开发和分享自定义的扩展。

总体而言，Windows Terminal 是一个现代化、可定制化和功能丰富的命令行工具，为用户提供了更好的命令行体验和更高效的工作环境。它是 Windows 平台上命令行操作的新选择，可以满足开发人员、系统管理员和技术爱好者对于命令行工具的需求。

## 如何安装Windows Terminal

要安装 Windows Terminal，您可以按照以下步骤进行操作：

1. 打开 Microsoft Store：在 Windows 10 操作系统中，可以通过点击任务栏上的 "Microsoft Store" 图标来打开 Microsoft Store 应用商店。

2. 搜索 Windows Terminal：在 Microsoft Store 的搜索框中输入 "Windows Terminal"，然后按下回车键或点击搜索按钮。

3. 选择 Windows Terminal 应用：在搜索结果中，找到 Windows Terminal 应用，并点击它的图标以打开应用页面。

4. 安装 Windows Terminal：在 Windows Terminal 应用页面上，点击 "获取"（或 "安装"）按钮。系统会开始下载和安装 Windows Terminal 应用。

5. 启动 Windows Terminal：安装完成后，您可以在开始菜单或任务栏中找到 Windows Terminal 图标。点击图标即可启动 Windows Terminal。

注意：为了安装 Windows Terminal，您的计算机必须运行 Windows 10 1903 或更高版本。如果您的操作系统版本较旧，请考虑更新到最新版本以获得更好的兼容性和功能支持。

另外，Windows Terminal 也可以从 GitHub 上的源代码进行构建和安装，这需要更高级的技术知识和步骤。如果您对此感兴趣，可以访问 Windows Terminal 的 GitHub 仓库（https://github.com/microsoft/terminal）获取更多详细信息和指南。

## 如何使用PowerShell的emacs键绑定？ 

`Set-PSReadLineOption` 是 PowerShell 的一个命令，用于设置和自定义 PowerShell 的交互式命令行编辑器 PSReadLine 的选项。

PSReadLine 是一个用于 PowerShell 的增强型命令行编辑器，提供了更强大的命令行编辑和自动完成功能。`Set-PSReadLineOption` 命令允许您配置和调整 PSReadLine 的各种选项，以适应个人偏好和需求。

以下是一些常用的 `Set-PSReadLineOption` 命令的选项和用法示例：

1. 更改提示符样式：

   ```powershell
   Set-PSReadLineOption -Prompt 'PS> '
   ```

   这将将 PowerShell 的提示符更改为 'PS> '。

2. 启用语法高亮显示：

   ```powershell
   Set-PSReadLineOption -Colors @{Command = 'Green'}
   ```

   这将启用命令的绿色语法高亮显示。

3. 启用自动完成：

   ```powershell
   Set-PSReadLineOption -PredictionSource HistoryAndFileSystem
   ```

   这将启用从历史记录和文件系统中自动完成命令和路径的功能。

4. 修改键绑定：

   ```powershell
   Set-PSReadLineKeyHandler -Key Tab -Function Complete
   ```

   这将将 Tab 键绑定到自动完成功能。

这只是一些 `Set-PSReadLineOption` 命令的示例，您可以根据需要使用其他选项来自定义和配置 PSReadLine。

请注意，`Set-PSReadLineOption` 命令只会影响当前 PowerShell 会话中的 PSReadLine 设置。如果您希望在每次启动 PowerShell 时自动应用这些设置，可以将它们添加到 PowerShell 配置文件（`$PROFILE`）中。

`Set-PSReadLineOption -EditMode` 是用于设置 PowerShell PSReadLine 编辑模式的命令。

在 PowerShell 中，PSReadLine 提供了多种编辑模式，用于自定义命令行的编辑行为。通过 `Set-PSReadLineOption -EditMode` 命令，您可以指定所需的编辑模式。

以下是一些常见的 PSReadLine 编辑模式：

1. `Emacs` 模式：这是默认的 PSReadLine 编辑模式，它基于 Emacs 文本编辑器的键绑定方式。

2. `Windows` 模式：该模式模仿了 Windows 命令行的键绑定方式，类似于 CMD 的编辑行为。

3. `Vi` 模式：该模式模仿了 Vi/Vim 文本编辑器的键绑定方式，允许您使用 Vi 风格的编辑命令。

要设置 PSReadLine 的编辑模式，请使用以下命令示例：

```powershell
# 设置为 Emacs 模式
Set-PSReadLineOption -EditMode Emacs

# 设置为 Windows 模式
Set-PSReadLineOption -EditMode Windows

# 设置为 Vi 模式
Set-PSReadLineOption -EditMode Vi
```

通过运行上述命令中的任何一个，您可以在当前 PowerShell 会话中设置 PSReadLine 的编辑模式。请注意，这只会影响当前会话，不会在其他会话中生效。如果您希望每次启动 PowerShell 时都使用特定的编辑模式，请将相应的命令添加到 PowerShell 配置文件（`$PROFILE`）中。

## 我碰到了执行策略不允许的错误
`Set-ExecutionPolicy` 命令用于设置 PowerShell 脚本的执行策略。执行策略是一种安全措施，用于限制 PowerShell 脚本的执行，以防止恶意脚本的运行。

具体而言，`Set-ExecutionPolicy` 命令中的参数 `RemoteSigned` 是一种执行策略级别。当执行策略设置为 `RemoteSigned` 时，意味着在本地计算机上的脚本必须由信任的发布者签名，但在远程计算机上执行的脚本不需要签名。

设置执行策略为 `RemoteSigned` 的目的是增加 PowerShell 脚本的安全性，确保只有经过签名的脚本或本地编写的脚本可以在本地计算机上执行。这样可以减少潜在的恶意脚本或未经授权的脚本对系统的影响。

需要注意的是，执行策略是一个系统级别的设置，适用于整个计算机。因此，更改执行策略可能需要管理员权限。在执行 `Set-ExecutionPolicy RemoteSigned` 命令之前，您需要以管理员权限运行 PowerShell 会话。

请注意，执行策略仅提供了一层基本的安全保护，并不能完全阻止所有潜在的安全风险。在运行任何脚本之前，仍然需要审查和确保脚本的来源和内容是可信的。
## EditMode的emacs键绑定有什么好处？
在 Windows Terminal 中，`EditMode` 是一个配置选项，用于设置 PowerShell 的 PSReadLine 编辑模式。当 `EditMode` 设置为 "emacs" 时，Windows Terminal 将使用 Emacs 键绑定来提供编辑功能。

Emacs 键绑定是基于 Emacs 文本编辑器的经典键盘快捷键，它提供了丰富的命令和编辑操作，使您可以更高效地编辑和处理文本。

下面是一些常用的 Emacs 键绑定示例：

- 移动光标：
  - `Ctrl + B`：向后移动一个字符（相当于箭头左键）。
  - `Ctrl + F`：向前移动一个字符（相当于箭头右键）。
  - `Ctrl + P`：向上移动一行（相当于箭头上键）。
  - `Ctrl + N`：向下移动一行（相当于箭头下键）。
  - `Ctrl + A`：移到行首。
  - `Ctrl + E`：移到行尾。
  - `Alt + B`：向后移动一个单词。
  - `Alt + F`：向前移动一个单词。

- 编辑操作：
  - `Ctrl + D`：删除光标处的字符。
  - `Ctrl + K`：删除光标到行尾的内容。
  - `Ctrl + Y`：粘贴删除的文本。
  - `Ctrl + W`：删除光标前的单词。
  - `Ctrl + T`：交换光标前后的字符。

- 撤销和重做：
  - `Ctrl + /`：撤销上一次操作。
  - `Ctrl + _`：撤销上一次操作（类似于撤销）。
  - `Ctrl + Shift + -`：重做上一次操作。

这只是一小部分 Emacs 键绑定的示例，Windows Terminal 中的 Emacs 编辑模式提供了更多的键盘快捷键，以及其他类似于 Emacs 的编辑命令和操作。

通过在 Windows Terminal 中设置 `EditMode` 为 "emacs"，您可以在 PowerShell 会话中使用这些 Emacs 键绑定来进行编辑和操作，提高您的命令行效率和体验。

## Linux下的shell
在linux操作系统下，类似的也有命令行模式，而且是更常用的模式。尽管很多ubuntu用户首先接触到的是其gui界面，但是事实上cli更为常用一些。大多数的系统默认的是bash。操作系统内部管理文件、设备的是kernel。我们用户通过shell来跟kernel打交道。而这个bash就是shell的一种。跟Windows下的命令提示符类似，我们在shell的提示符下可以输入不同的命令来完成一些工作。比如ls是列出当前文件夹下的内容。cp是复制文件的命令。cd是改变目录的命令等等。具体这些内容可以参考linux入门书看一看，或者看一看linux cheatsheet。