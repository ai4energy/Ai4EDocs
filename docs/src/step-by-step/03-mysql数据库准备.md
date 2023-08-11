# 数据库准备

## 关系数据库简介

关系型数据库是最广泛使用和最经典的一种数据库。以下是关系型数据库的简要介绍：

### 1. **定义**:
关系型数据库（RDBMS, Relational Database Management System）是基于关系模型来创建和管理的数据库。在这种数据库中，数据被组织成一个或多个表，这些表之间可以存在相关性。

### 2. **特点**:

- **表格结构**：数据存储在称为“表”的结构中，每个表具有唯一的名称。
  
- **行与列**：每个表由行（也称为记录或元组）和列（也称为字段或属性）组成。每列都有一个数据类型（如整数、字符串、日期等）。
  
- **主键**：每个表通常都有一个主键列，该列的值在表中是唯一的，用于唯一地标识每一行。
  
- **外键**：用于建立表与表之间的关系，确保数据之间的引用完整性。
  
- **标准化**：是一种设计技巧，用于最小化数据重复和避免数据异常。

### 3. **SQL**:
关系型数据库使用 SQL（Structured Query Language，结构化查询语言）进行查询。SQL 是用于定义、操作和查询数据的标准语言。

### 4. **事务**:
关系型数据库支持事务，确保数据库操作的完整性。事务是一系列操作，要么全部成功执行，要么全部不执行。

### 5. **优势**:

- 数据完整性和准确性。
  
- 灵活的查询能力。
  
- 数据安全性和备份恢复。
  
- 广泛的支持和成熟的技术。

### 6. **常见的关系型数据库系统**:

- MySQL
  
- PostgreSQL
  
- Oracle
  
- Microsoft SQL Server
  
- SQLite

### 7. **挑战**:

- 在处理非常大的数据集或需要高度可扩展性的场景时，关系型数据库可能不如某些非关系型数据库那么高效。
  
- 数据模式修改可能是困难和耗时的。

尽管现在有很多非关系型数据库（如 MongoDB、Cassandra 和 Redis）受到欢迎，但关系型数据库仍然是许多应用的核心，尤其是需要高度组织和关系完整性的应用。

## mysql(mariadb)简介

当我们谈到 MySQL，我们通常指的是一个广泛使用的开源关系型数据库管理系统。MariaDB 是 MySQL 的一个分支，由 MySQL 的原始开发者创建，作为对 Oracle 购买 Sun Microsystems（MySQL 的原始所有者）后可能存在的开源许可问题的回应。

以下是 MySQL 和 MariaDB 的简要介绍：

### MySQL:

1. **概述**: MySQL 是世界上最流行的开源关系型数据库之一。它的主要特点是可靠性、性能和易用性。

2. **特点**:
   - 使用 SQL 作为查询语言。
   - 提供了多种存储引擎，如 InnoDB、MyISAM、Memory 等。
   - 支持 ACID 事务，尤其是在使用 InnoDB 存储引擎时。
   - 支持外键、触发器、视图等功能。
   - 有一个活跃的社区和大量的在线资源。

3. **使用情境**: 从小型应用到大型企业解决方案，MySQL 都可以用作后端存储。它被广泛用于网站、电子商务平台和许多其他类型的应用。

### MariaDB:

1. **概述**: MariaDB 是 MySQL 的一个开源分支，由 MySQL 的原始开发者创建，旨在完全兼容 MySQL，同时提供新的特性和改进。

2. **特点**:
   - 完全的二进制级别兼容性与 MySQL。
   - 新的存储引擎，如 Aria 和 TokuDB。
   - 更好的性能和优化。
   - 对新功能的更快速和更开放的开发流程。
   - 包含更多的存储引擎和扩展功能。

3. **使用情境**: 因为 MariaDB 与 MySQL 完全兼容，所以它可以替代 MySQL 在任何应用中使用。

**最后的注意事项**: 尽管 MariaDB 旨在与 MySQL 保持兼容，但随着时间的推移，两者之间可能会出现一些差异。因此，如果你正在考虑从 MySQL 迁移到 MariaDB，或者在两者之间进行选择，建议你仔细研究两者之间的差异和考虑使用哪一个更适合你的特定需求。

## 使用docker-compose安装mariadb

使用 `docker-compose` 安装 MariaDB 相对简单且方便。下面是使用 `docker-compose` 安装 MariaDB 的步骤：

1. **创建 `docker-compose.yml` 文件**:
   
   在你选择的目录中，创建一个 `docker-compose.yml` 文件，并输入以下内容：

   ```yaml
   version: '3'

   services:
     mariadb:
       image: mariadb:latest
       container_name: my_mariadb
       environment:
         MYSQL_ROOT_PASSWORD: rootpassword   # 设置你的root密码
         MYSQL_DATABASE: mydatabase          # 你可以指定一个初始数据库名称
         MYSQL_USER: user                    # 可选: 创建一个用户
         MYSQL_PASSWORD: userpassword        # 用户的密码
       ports:
         - "3306:3306"
       volumes:
         - mariadb_data:/var/lib/mysql

   volumes:
     mariadb_data:
   ```

   这个配置将会拉取最新版本的 MariaDB 镜像，设置必要的环境变量，并绑定容器的 3306 端口到宿主机的 3306 端口。

2. **启动 MariaDB**:

   在包含 `docker-compose.yml` 文件的目录中，运行以下命令:

   ```bash
   docker-compose up -d
   ```

   这将会启动 MariaDB 服务。`-d` 参数使容器在后台模式运行。

3. **连接到 MariaDB**:

   你可以使用任何 MySQL/MariaDB 客户端来连接到数据库。使用上面的配置，你可以使用如下的连接参数：

   - **Host**: localhost (或你的 Docker 宿主机的 IP)
   - **Port**: 3306
   - **User**: root
   - **Password**: rootpassword (或你在 `docker-compose.yml` 文件中设置的密码)

4. **停止和启动服务**:

   如果你想停止 MariaDB 服务，可以使用以下命令：

   ```bash
   docker-compose down
   ```

   当你想再次启动服务时，只需再次运行 `docker-compose up -d`。

5. **数据持久化**:

   在上面的配置中，我们使用了一个命名的卷 `mariadb_data` 为 `/var/lib/mysql` 路径来持久化数据。这确保即使容器被删除，数据也会保持不变。

这就是使用 `docker-compose` 安装 MariaDB 的基本步骤。当然，你可以根据你的特定需求对 `docker-compose.yml` 文件进行进一步的配置和调整。

以下是一个典型的 `docker-compose.yml`：
```yaml

version: '3.2'

services:

  ai4e-things-mariadb:
    image: mariadb:10.6.14
    container_name: ai4e-things-mariadb
    environment:
      MYSQL_ROOT_PASSWORD: dlgcdxlgjzdsys
      MYSQL_DATABASE: ai4e_things
      MYSQL_USER: ai4e_things
      MYSQL_PASSWORD: 789612543Ab1234
      TZ: Asia/Shanghai
    ports:
      - "3306:3306"
    volumes:
       - ./deploy/data/mariadb:/var/lib/mysql
    restart: always
    networks:
      ai4e_net:
        ipv4_address: 172.20.0.116
```

这段 `docker-compose.yml` 配置详细描述了如何使用 Docker Compose 来部署一个 MariaDB 容器。

1. **version: '3.2'**

   这表示 `docker-compose.yml` 文件的版本为 3.2。每个版本都有其特定的特性和格式。版本 3 和其子版本为现代 Docker Compose 配置提供了许多新的功能。

2. **services:**

   这表示接下来的部分将描述要部署的服务。

3. **ai4e-things-mariadb:**

   这是你为 MariaDB 服务定义的名称。

4. **image: mariadb:10.6.14**

   这指示 Docker 从 Docker Hub 获取 `mariadb` 镜像，并使用特定的版本 `10.6.14`。

5. **container_name: ai4e-things-mariadb**

   这是容器实例的名称。每次你启动这个 `docker-compose` 配置时，都会创建或重用这个名称的容器。

6. **environment:**

   这是为容器设置的环境变量列表。

   - `MYSQL_ROOT_PASSWORD`: MariaDB 的 root 用户的密码。
   - `MYSQL_DATABASE`: 在首次启动容器时将创建的数据库名称。
   - `MYSQL_USER` & `MYSQL_PASSWORD`: 在首次启动时将创建的新用户及其密码。
   - `TZ`: 设置时区为 `Asia/Shanghai`。

7. **ports:**
   
   - `3306:3306`: 这表示将容器的 3306 端口映射到宿主机的 3306 端口。

8. **volumes:**

   - `./deploy/data/mariadb:/var/lib/mysql`: 这表示将宿主机的 `./deploy/data/mariadb` 目录映射到容器的 `/var/lib/mysql` 目录。这样，数据库的数据将被持久化保存在宿主机上，即使容器被删除，数据也不会丢失。

9. **restart: always**

   这表示如果容器因为某种原因停止了，Docker 会自动尝试重新启动它。

10. **networks:**

    这定义了容器连接的网络。

   - `ai4e_net`: 这是预先定义的网络名称。
     - `ipv4_address: 172.20.0.116`: 指定容器在这个网络上的 IP 地址为 `172.20.0.116`。

这份配置为你提供了一个具有持久化数据、特定网络配置和预定义的数据库设置的 MariaDB 容器。

## 使用adminer连接数据库

Adminer 是一个简单的、单文件的数据库管理工具，支持多种数据库系统，包括 MySQL/MariaDB、PostgreSQL、SQLite 等。它可以很容易地通过 Docker 运行。

以下是如何使用 `docker-compose` 与 Adminer 来连接到 MariaDB 数据库的步骤：

1. **在 `docker-compose.yml` 中加入 Adminer 服务**:

   在你现有的 `docker-compose.yml` 文件中，你可以添加一个新的服务来运行 Adminer：

   ```yaml
   version: '3.2'

   services:
     ai4e-things-mariadb:
       ... # 保持你的 MariaDB 配置不变

     adminer:
       image: adminer:latest
       container_name: adminer
       ports:
         - "8080:8080"

   networks:
     ai4e_net:
       ...
   ```

   在这里，我们将 Adminer 服务的 8080 端口映射到宿主机的 8080 端口。

2. **启动 Adminer 和 MariaDB**:

   在包含 `docker-compose.yml` 文件的目录中，运行以下命令:

   ```bash
   docker-compose up -d
   ```

3. **通过浏览器访问 Adminer**:

   打开你的浏览器并访问 `http://localhost:8080`。你应该能看到 Adminer 的登录界面。

4. **连接到你的 MariaDB 数据库**:

   在 Adminer 的登录界面：

   - **系统**：选择 `MySQL`
   - **服务器**：输入你 MariaDB 容器的名称或 IP 地址。如果 Adminer 和 MariaDB 在同一个 Docker Compose 网络中，你可以使用 MariaDB 服务的名称作为主机名，例如 `ai4e-things-mariadb`。
   - **用户名** 和 **密码**：使用你在 `docker-compose.yml` 文件中为 MariaDB 设置的用户名和密码，例如 `ai4e_things` 和 `789612543Ab1234`。
   - **数据库**：可以选择特定的数据库，如 `ai4e_things`，或留空以查看所有数据库。

点击登录，你应该能够看到你的 MariaDB 数据库并开始管理它。

注意：使用 Adminer（或任何其他数据库管理工具）时，请始终确保你的数据库设置是安全的，并且管理界面不对公众开放，以防止未经授权的访问。

## 使用datagrip连接数据库

[DataGrip](https://www.jetbrains.com/datagrip/) 是 JetBrains 出品的一个多数据库环境的 IDE。它支持多种数据库系统，并为用户提供了图形界面来执行查询、管理数据库结构等操作。

要使用 DataGrip 来连接到你通过 Docker 或其他方式运行的 MariaDB 数据库，请按照以下步骤操作：

1. **安装 DataGrip**:
   
   首先，如果你还没有安装 DataGrip，你需要从 JetBrains 的官方网站下载并安装它。

2. **启动 DataGrip**:

   打开 DataGrip 应用程序。

3. **创建新的数据源**:

   - 在欢迎屏幕上，选择 “New Project”。
   - 在左侧导航栏中，右键点击 “Database” 部分并选择 “New” -> “Data Source” -> “MySQL”。

4. **配置连接**:

   - **Host**: 输入你 MariaDB 容器的 IP 地址或主机名。如果你的数据库在本地运行，通常是 `localhost`。如果它在 Docker Compose 网络中，则可能是服务名称（例如 `ai4e-things-mariadb`）或分配给该服务的 IP 地址。
   - **Port**: 默认的 MariaDB 端口是 `3306`，除非你已更改。
   - **User**: 输入你为 MariaDB 设置的用户名，例如 `ai4e_things`。
   - **Password**: 输入相应的密码，例如 `789612543Ab1234`。
   - **Database**: 你可以选择特定的数据库，例如 `ai4e_things`，或留空以查看所有数据库。

   你也可以点击 “Test Connection” 按钮来确保你的设置是正确的。

5. **完成设置**:

   点击 “OK” 保存你的设置。现在，你应该能在 DataGrip 的界面左侧看到你的数据库连接。双击它将显示数据库的内容，你可以开始执行查询和其他操作。

6. **执行查询**:

   在 DataGrip 的主界面，你可以为所选的数据库打开一个新的查询窗口，并开始执行 SQL 语句。

注意：确保你的 MariaDB 数据库对 DataGrip 使用的 IP 地址和端口开放，并且用户名和密码正确。如果你使用 Docker Compose 启动数据库，并且 DataGrip 也在同一台机器上运行，通常你应该可以使用 `localhost` 作为主机名。如果有防火墙或网络策略，确保它们不会阻止 DataGrip 的连接请求。

## 使用vscode的数据库插件

Visual Studio Code（VSCode）是一个非常灵活的代码编辑器，拥有大量的插件，使其可以支持各种开发任务。当你想在 VSCode 中直接连接到数据库时，有很多插件可以选择。以下是如何使用其中的一个受欢迎的插件——`SQLTools` 来连接到 MariaDB 数据库的步骤：

1. **安装 SQLTools 插件**:
   
   打开 VSCode，转到扩展（Extensions）标签（或按 `Ctrl+Shift+X`），然后搜索 "SQLTools". 安装 "SQLTools - Database tools" 插件。

   为了连接到 MariaDB/MySQL 数据库，你还需要安装特定的驱动。搜索并安装 "SQLTools MySQL/MariaDB"。

2. **连接到数据库**:

   - 在 VSCode 的左侧侧边栏中，点击 SQLTools 的图标。
   - 点击 "Add New Connection"。
   - 选择 "MySQL/MariaDB"。
   - 填写连接信息：
     - **Name**: 给你的连接起个名字，例如 “MyMariaDB”。
     - **Driver**: 选择 "MySQL/MariaDB"。
     - **Server**: 输入你的 MariaDB 服务器的地址。如果你的数据库是在本地机器上运行的，这通常是 `localhost`。
     - **Port**: 默认的 MariaDB 端口是 `3306`，除非你已更改。
     - **Username**: 输入你为 MariaDB 设置的用户名，例如 `ai4e_things`。
     - **Password**: 输入相应的密码。
     - **Database**: 你可以选择特定的数据库，例如 `ai4e_things`。

   - 点击 "Test" 来验证连接设置，如果一切正常，然后点击 "Save"。

3. **浏览和查询数据库**:

   一旦连接建立，你就可以在 VSCode 内浏览你的数据库结构、执行查询等操作。

4. **断开连接**:

   如果你想断开数据库连接，只需在 SQLTools 的连接管理器中右键点击你的数据库连接，然后选择 "Disconnect"。

这就是在 VSCode 中使用 SQLTools 插件连接到 MariaDB 数据库的基本步骤。有许多其他数据库插件可供选择，因此你可能会发现其他插件更适合你的特定需求或工作流程。