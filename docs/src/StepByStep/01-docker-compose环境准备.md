# docker-compose环境准备

## 安装wsl

1. **启用 WSL**

   作为管理员打开 PowerShell  (右键点击 Windows 徽标 -> Windows PowerShell (管理员))，并执行以下命令：
   ```powershell
   wsl --install
   ```
   该命令将安装 WSL 和默认 Linux 发行版（通常是 Ubuntu）。

2. **启用虚拟机平台**

   同样在管理员权限的 PowerShell 中，执行以下命令：
   ```powershell
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

3. **下载 Linux 内核更新包**

   如果在前面的步骤中没有自动完成，您需要手动下载并安装 Linux 内核更新包。

   [点击此处下载最新的 WSL2 Linux 内核更新包](https://aka.ms/wsl2kernel)

   下载后，按照提示完成安装。

4. **设置 WSL 默认版本为 2**

   再次打开管理员权限的 PowerShell 并执行以下命令：
   ```powershell
   wsl --set-default-version 2
   ```

5. **安装 Linux 发行版**

   如果您在第一步中已经使用 `wsl --install` 命令，您应该已经有了一个默认的 Linux 发行版（如 Ubuntu）。如果没有，您可以从 Microsoft Store 中选择并安装一个 Linux 发行版，例如 Ubuntu, Debian, Fedora Remix 等。

6. **初始化 Linux 发行版**

   打开你所选择的 Linux 发行版应用程序，它将提示您设置新的用户名和密码。

完成以上步骤后，WSL 2 应该已经在您的 Windows 11 计算机上安装并正确配置了。您可以通过打开命令行或 PowerShell 并输入 `wsl` 命令来使用它。

## 安装docker和docker-compose

在 WSL 2 下安装 Docker 和 Docker Compose 的过程相对简单，尤其是考虑到 WSL 2 提供了完整的 Linux 内核支持。以下是步骤：

1. **安装 Docker**

   在你的 WSL 2 终端里 (比如说 Ubuntu)，执行以下命令来安装 Docker：

   ```bash
   sudo apt update
   sudo apt install docker.io
   ```

   启动 Docker 服务：

   ```bash
   sudo service docker start
   ```

   还可以将 Docker 设置为开机启动：

   ```bash
   sudo systemctl enable docker
   ```

2. **安装 Docker Compose**

   首先，使用以下命令下载最新版本的 Docker Compose：

   ```bash
   sudo apt update
   sudo apt install docker-compose
   ```

   现在，你可以通过输入 `docker-compose --version` 来检查其版本。

此外，请确保你的 Windows 防火墙允许 Docker 进行通信，尤其是当你需要与外部资源进行交互时。

## docker简介

**Docker** 是一个开源平台，它允许开发者和系统管理员构建、部署和运行应用程序在容器内。容器允许开发者将他们的应用程序与其它所有依赖项打包到一起，确保应用程序在任何环境中都能以相同的方式运行。以下是 Docker 的一些核心概念和特点：

1. **容器化**：
   - **容器** 是轻量级、独立的、可执行的软件包，其中包含了运行某个应用所需的一切：代码、运行时、系统工具、系统库和设置。这确保了应用在任何环境中的一致性。

2. **镜像**：
   - Docker 使用 **镜像** 来打包应用及其依赖项。一旦创建了镜像，你就可以在任何 Docker 环境中使用这个镜像来创建容器。
   - 镜像是分层的，这意味着每次修改都会创建一个新的层，这样可以提高存储效率并加速部署。

3. **Docker Hub**：
   - 是一个公开的注册中心，开发者可以在上面分享和存储他们的应用镜像。也有私有注册中心可用于企业或私人使用。

4. **声明式的设置**：
   - Docker 允许用户通过 `Dockerfile`（一个文本文件）声明性地定义应用的环境。这意味着不需要手动设置或配置环境。

5. **隔离**：
   - Docker 提供应用级的隔离。每个容器在自己独立的空间中运行，并有自己的网络接口、文件系统和依赖项。这使得容器互不干扰，增加了安全性。

6. **集成和自动化**：
   - 由于 Docker 容器的一致性和可移植性，它们非常适合持续集成和持续部署 (CI/CD) 流程。

7. **轻量级和快速**：
   - 与传统的虚拟机相比，Docker 容器启动得更快，占用的资源更少，因为它们共享相同的 OS 内核，而不是每个都有自己的操作系统副本。

简而言之，Docker 提供了一种方法，使得开发者和运维团队可以确保他们的应用程序和服务在任何环境中都能如预期般稳定地运行，从而消除了“在我机器上是可以运行的”这种情况。

## docker-compose简介

`docker-compose` 是一个用于定义和运行多容器 Docker 应用程序的工具。通过一个简单的 `docker-compose.yml` 文件，用户可以定义一个多容器应用的服务、网络和卷，然后使用单一的 `docker-compose` 命令来启动和停止整个堆栈。

以下是 `docker-compose` 的一些核心特点和概念：

1. **服务定义**：
   - 在 `docker-compose.yml` 文件中，你可以定义应用程序的各个服务，每个服务都会运行在其自己的容器中。你可以定义你想要的任何数量的服务，例如数据库、API 服务、前端应用程序等。

2. **网络和卷**：
   - `docker-compose` 允许你定义应用的网络和卷，这使得容器之间的通信和数据存储变得简单。

3. **一键部署**：
   - 通过简单地运行 `docker-compose up`，所有定义在 `docker-compose.yml` 文件中的服务、网络和卷都会被创建并启动。
   - 使用 `docker-compose down` 可以轻松地停止并删除所有组件。

4. **声明式配置**：
   - `docker-compose.yml` 文件提供了一种声明式的方式来定义你的应用组件和配置。这确保了环境的一致性和可重现性。

5. **环境变量和配置文件**：
   - `docker-compose` 支持使用环境变量和 `.env` 文件来参数化配置，这使得开发、测试和生产环境之间的转换更加轻松。

6. **本地开发和测试**：
   - `docker-compose` 是一个强大的工具，尤其对于本地开发和测试。开发者可以在他们的机器上定义和运行与生产环境相似的复杂应用，无需安装任何额外的服务或依赖。

7. **与 Docker CLI 相集成**：
   - `docker-compose` 使用与 Docker 命令行相似的语法和结构，这使得从 Docker 过渡到 `docker-compose` 变得容易。

简而言之，`docker-compose` 提供了一个简单而高效的方法来定义、运行和管理多容器应用，无论是在本地、测试环境还是生产环境。

