# 以SAM为例实操

## SAM是什么
NREL (National Renewable Energy Laboratory) 的 SAM (System Advisor Model) 是一个广泛应用于可再生能源系统分析和评估的计算工具。SAM 可以帮助研究人员、工程师和政策制定者评估各种可再生能源项目的技术和经济可行性。

SAM 提供了一系列模块，涵盖了太阳能、风能、生物质能、地热能等多个可再生能源技术。使用 SAM，用户可以建立虚拟的可再生能源项目，并对其进行系统级的模拟和分析。

SAM 的主要功能包括：

1. 建模工具：SAM 提供了丰富的建模工具，可以创建和配置各种可再生能源系统。用户可以定义系统的组件、能源资源、电网连接等。

2. 技术性能模型：SAM 包含了各种可再生能源技术的技术性能模型，例如太阳能光伏电池板的发电模型、风力涡轮机的功率曲线等。这些模型基于广泛的实验数据和经验，并提供了高精度的技术性能预测。

3. 资金成本模型：SAM 还提供了成本模型，可以帮助用户估算可再生能源项目的资金成本。这些成本模型包括设备成本、建设成本、运营维护成本等。

4. 经济性分析：SAM 可以对可再生能源项目进行经济性分析，包括计算项目的净现值、内部收益率、年均收益等经济指标。这有助于评估项目的可行性和经济效益。

5. 市场分析：SAM 还提供了市场分析模块，可以评估可再生能源项目在不同市场条件下的竞争力和盈利潜力。用户可以模拟不同的电力市场、能源政策和投资条件，以了解项目在不同情景下的表现。

SAM的GitHub地址是：https://github.com/nrel/SAM

关于NREL和SAM的官方网站，您可以访问以下链接获取更多信息：

NREL官方网站：https://www.nrel.gov/

SAM官方网站：https://sam.nrel.gov/

总而言之，NREL 的 SAM 是一个功能强大的可再生能源系统分析工具，可以帮助用户评估和优化可再生能源项目的技术性能、经济可行性和市场前景。它在可再生能源领域的研究、工程设计和政策制定中发挥了重要作用。


## SAM的组件构成

SAM的组件构成主要包括以下几个部分：

1. SSC（SAM Simulation Core）：SSC是SAM的内核，是一个用C++编写的计算引擎。它提供了可再生能源系统模拟和分析的核心功能，包括模型计算、数据处理和结果生成等。SSC负责处理技术性能模型、成本模型、经济模型等方面的计算。

2. GUI（Graphical User Interface）：SAM的GUI是一个可视化界面，提供了图形化的用户界面，使用户可以通过交互方式创建、配置和分析可再生能源项目。GUI简化了输入参数的设置和结果的可视化，使用户更方便地使用SAM进行建模和分析。

3. SDK（Software Development Kit）：SDK是一个开发工具包，用于扩展SAM的功能和自定义模块。SDK提供了一组API和文档，使开发人员可以根据自己的需求开发新的模型、算法或工具，并与SAM进行集成。

4. Datasets：SAM还包括一系列数据集，用于提供输入参数和参考数据。这些数据集包括天气数据、设备性能数据、成本数据等，可以帮助用户进行准确的模拟和分析。

综上所述，SAM的核心是SSC，它提供了计算引擎和模型库，支持可再生能源系统的建模和分析。GUI提供了图形化界面，使用户可以通过可视化方式操作SAM。SDK则允许开发人员进行功能扩展和定制化开发。

## SAM的windows下的编译过程

当使用SAM进行编译时，以下是SAM的编译过程的基本步骤和解释：

1. 源代码收集：首先，需要获取SAM的源代码。您可以从SAM的GitHub存储库中获取源代码，并将其下载到本地计算机中。

2. 依赖项安装：在编译之前，需要安装SAM所需的依赖项和开发工具。这些依赖项可能包括编译器、构建工具、库文件等。您可以查阅SAM的文档或README文件，了解所需的依赖项和安装说明，并确保在编译之前正确安装它们。

3. 配置编译环境：为了成功编译SAM，您需要配置适当的编译环境。这可能包括设置编译器选项、环境变量、路径设置等。根据您的操作系统和编译工具，您可能需要执行一些特定的设置步骤。确保按照指南进行正确的环境配置。

4. 构建项目：一旦环境配置完成，您可以开始构建SAM项目。这通常涉及使用构建工具（如Makefile或CMake）执行构建命令。构建过程会编译源代码文件，并将它们转换为可执行文件或库文件。构建过程可能需要一些时间，具体取决于项目的规模和计算机的性能。

5. 编译错误解决：在编译过程中，可能会出现错误或警告。这些错误可能是由于缺少依赖项、语法错误、库文件问题等引起的。如果出现编译错误，您需要仔细阅读错误消息，并在代码中找到并修复问题。通常，错误消息会提供有关问题所在的线索，例如错误的行号或函数名称。

6. 构建成功：一旦编译过程成功完成，您将获得SAM的可执行文件或库文件。这些文件可以用于在您的计算机上运行SAM，并开始使用它的功能。确保验证编译的结果，并根据需要进行必要的配置和安装。

通过以上步骤，您可以通过SAM的编译过程理解程序编译的 step by step 流程。请注意，编译过程可能因操作系统、编译工具和项目的特定要求而有所差异。因此，建议您参考SAM的文档和指南，以获取针对SAM的具体编译说明和最佳实践。

[这里是Windows下如何编译SAM的官方说明](https://github.com/NREL/SAM/wiki/Windows-Build-Instructions)。

以下是其中文翻译：
Windows构建说明

这些说明适用于在您的计算机上设置构建SAM Windows版本所需的几个开源C++代码库。

更新于2022年7月

概述
构建工具
要构建SAM，您需要构建CMake、wxWidgets和Google Test：

CMake是一套用于构建软件的工具集：https://cmake.org/。

wxWidgets是一个用于开发用户界面的平台：https://www.wxwidgets.org。

Google Test是一个C++测试框架：https://github.com/google/googletest。

版本控制和协作
SAM的代码存储库存储在GitHub.com上，因此您需要使用Git进行工作的工具。这些说明假设您已经安装了Git并熟悉它。（如果您需要使用Git进行SAM的帮助，请参阅此基本教程。）

Git是版本控制和协作软件：https://git-scm.com/
源代码
构建SAM所需的C++和其他代码存储在GitHub.com上的LK、WEX、SSC和SAM存储库中：

LK是SAM的内置LK脚本语言：https://github.com/nrel/lk。

WEX包含了对wxWidgets的自定义用户界面增强功能：https://github.com/nrel/wex。

SSC是用于SAM性能和财务模型的代码：https://github.com/nrel/ssc。（SSC API和PySAM Python软件包提供了对SSC的访问权限，供其他软件应用程序使用。）

SAM是用于SAM用户界面的代码：https://github.com/nrel/SAM。

SAM-private存储库包含了SAM官方NREL版本的代码。只有在与NREL的SAM软件开发团队合作构建官方NREL版本的SAM时，才需要这些代码。

SAM-private是用于用户注册、欢迎页面、Web API密钥和其他SAM官方NREL版本的功能的代码：https://github.com/nrel/SAM-private。
开发和修补分支
每个存储库的Develop分支包含最新的代码。如果您要贡献代码，应从该分支开始工作。

每个存储库的Patch分支在发布新版本的SAM后的几个月内处于活动状态。在此期间，如果您要贡献代码以更新当前版本，应从Patch分支开始工作。（完成和批准工作后，应将Patch分支合并到Develop分支。）

GitHub.com上的默认分支为Develop，除了在更新期间，此时默认分支设置为Patch。

SAM版本的标签
要构建特定版本的SAM，可以检出该版本的标签。请参阅此标签列表，了解SAM、SSC、WEX和LK的不同版本。

总体构建步骤
整个设置和构建过程应该需要1到2个小时，具体取决于您选择每个步骤的选项和互联网下载速度。计算机设置完成后

，首次构建SAM可能需要几分钟时间。后续构建速度较快，具体取决于构建选项以及在构建之前修改的代码量。

1. 下载并安装Visual Studio Community 2022（10分钟，需要Microsoft账户和计算机重新启动）。

2. 下载并构建wxWidgets 3.2.0（10分钟）。

3. 下载并安装CMake 3.24或更高版本（5分钟）。

4. 克隆并构建Google Test（需要CMake）（5分钟）。

5. 克隆SAM代码存储库（根据互联网速度，可能需要10-20分钟）。

6. 设置环境变量（5分钟）。

7. 为Visual Studio生成SAM项目文件（需要CMake）（5分钟）。

8. 构建SAM（对于SAMOS的干净构建需要10分钟，构建所有项目需要更长时间）。

9. 测试构建结果。

   

   1.下载并安装Visual Studio Community 2022

   如果您的计算机上尚未安装Visual Studio Community 2022 (VS 2022)，请从https://visualstudio.microsoft.com/下载并安装。

使用VS 2022需要一个免费的Microsoft账户，当您首次启动程序时，系统会提示您创建或输入账户。

运行Visual Studio安装程序，并选择以下三个工作负载：

- C++桌面开发
- Python开发（用于SAM与Python的集成）
- C++ Linux和嵌入式开发（用于CMake）

如果您的计算机上安装了其他版本的Visual Studio，您可以与其他版本并存安装和运行VS 2022。

启动VS 2022并登录到您的Microsoft账户或创建一个新账户。



2. 下载并构建wxWidgets 3.2.0
SAM的用户界面使用的是wxWidgets 3.2.0，这是截至2022年7月7日的最新稳定版本。其他版本的wxWidgets可能与SAM兼容也可能不兼容。您可以从https://www.wxwidgets.org/downloads/下载不同版本的wxWidgets。在页面底部的"Other Downloads"下的GitHub Release Archive中，提供了以前的版本。

从https://github.com/wxWidgets/wxWidgets/releases/tag/v3.2.0下载Windows源代码，可以选择ZIP或7Z文件。将文件解压到计算机上的一个文件夹中，例如c:/wxWidgets-3.2.0。

启动VS 2022并打开c:/wxWidgets-3.2.0/build/msw/wx_vc17.sln解决方案文件。该目录中有适用于其他版本的Visual Studio的项目文件，因此请确保打开vc17文件。vc17解决方案适用于VS 2022。

构建64位的Debug和Release版本：在VS 2022的工具栏中，选择Release配置和x64平台，然后按F7键或从Build菜单中选择Build Solution。构建完成后，选择Debug x64并进行构建（24个项目都要构建）。

如果构建成功，您应该会看到构建了24个项目成功的消息。在c:/wxWidgets-3.2.0/build/msw中，您还应该看到vc_x64-mswu和vc_x64-mswud文件夹，每个文件夹中都有几个文件夹和.pch文件。



3. 下载并安装CMake
SAM需要CMake 3.24或更高版本来为Windows、Linux和Mac生成构建文件。

从https://cmake.org/download/下载最新版本的Windows x64安装程序。

运行安装程序，按照提示安装CMake，并勾选“将CMake添加到系统路径中”选项，可以选择单个用户或所有用户。

安装程序应自动将C:/Program Files/CMake/bin添加到Windows系统路径中。要验证，请在Windows开始菜单中输入"env"，打开"环境变量"窗口，双击系统变量下的Path变量。如果路径列表中没有该路径，您可以手动添加。

4.克隆并构建Google Test
SAM的代码存储库依赖于Google Test C++单元测试框架。

从https://github.com/google/googletest.git克隆Google Test。在命令窗口中执行以下命令：

```
cd path/to/my/repos
git clone https://github.com/google/googletest.git
```

在问题https://github.com/NREL/ssc/issues/806解决之前，切换到提交b85864c64758dec007208e56af933fc3f52044ee：

```
cd path/to/googletest
git checkout b85864c64758dec007208e56af933fc3f52044ee
```

这样就会显示HEAD is now at b85864c6 Eliminate the legacy GTEST_COMPILE_ASSERT_ macro.（这个问题如果已经解决，则不需要进行上述步骤，文件会直接被完整克隆下来）

进入包含ci、docs、googlemock和googletest的顶级googletest文件夹，并创建一个build文件夹（也可以通过鼠标在对应位置创建文件夹）：

```
mkdir path/to/googletest/build
```

进入刚创建的build文件夹（建议创建文件夹的位置与示例相同，如果不同，进行命令行操作时，注意要输入与之相对应的正确路径）：

cd path/to/googletest/build
运行CMake生成Visual Studio项目文件：

请注意，在CMake命令的末尾使用两个句点..，以确保命令能够找到父文件夹中的CMakeLists.txt文件。

```
cmake -G "Visual Studio 17 2022" -DCMAKE_CONFIGURATION_TYPES="Release;Debug" -Dgtest_force_shared_crt=ON ..
```

如果CMake成功，您应该会看到path/to/googletest/build/googletest/gtest.sln文件。

在VS 2022中打开gtest.sln文件，并构建x64的Debug和Release配置（步骤同第二步wxWidgets的配置）。

如果构建成功，您应该会在path/to/googletest/build/lib中看到包含gtest.lib等文件的Release和Debug文件夹。


5. 克隆SAM代码存储库
创建一个父文件夹来存储这些存储库，例如path/to/sam_dev：

```
mkdir path/to/sam_dev
```

将每个存储库克隆到父文件夹中。

```
cd path/to/sam_dev
```

```
git clone https://github.com/nrel/lk
```

```
git clone https://github.com/nrel/wex
```

```
git clone https://github.com/nrel/ssc
```

```
git clone https://github.com/nrel/sam
```

如果您可以访问SAM-private存储库以构建官方的NREL版本的SAM，请选择使用Web浏览器身份验证方式验证您的GitHub.com账户是否有权访问该存储库：

```
git clone https://github.com/nrel/sam-private
```


6. 设置环境变量
SAM的构建工具使用Windows环境变量来确定它所需文件在计算机上的存储位置。

关闭任何打开的命令窗口以及正在运行的VS 2022。

打开Windows系统属性窗口，在"高级"选项卡上，点击"环境变量"，或在Windows搜索栏中输入"env"并点击"编辑系统环境变量"。

在用户变量列表中，点击"新建"，并为下表中的每一项输入变量名和值。

例如，如果您将LK存储库放在c:/sam_dev/lk中，您将把环境变量的名称设置为"LKDIR"，其值设置为"c:/sam_dev/lk"（不需要输入引号）。

| LKDIR        | path/to/sam_dev/lk  |
| ------------ | :------------------ |
| WEXDIR       | path/to/sam_dev/wex |
| SSCDIR       | path/to/sam_dev/ssc |
| SAMNTDIR     | path/to/sam_dev/sam |
| RAPIDJSONDIR | path/to/sam_dev/ssc |

*RAPIDJSONDIR是一个单独的环境变量，用于支持不依赖于SSC的WEX构建。

如果您可以访问SAM-private存储库以构建官方的NREL版本的SAM：

| SAMNRELDIR | path/to/sam_dev/SAM-private |
| ---------- | --------------------------- |

创建以下用户变量，指向Google Test、wxWidgets和CMake的文件夹：

| GTDIR         | path/to/googletest      |
| ------------- | ----------------------- |
| WXMSW3        | path/to/wxWidgets-3.2.0 |
| CMAKEBUILDDIR | path/to/sam_dev/build   |

关闭系统属性窗口。



7. 生成 SAM Visual Studio 2022 项目文件
这一步是在首次构建 SAM 以及从 LK、WEX、SSC 或 SAM 存储库中添加或移除 .cpp 源文件后所需的。

使用文本编辑器在 SAM 的父文件夹中创建一个名为 CMakeLists.txt 的 "总体 CMake 文件"（在我们的例子中为 path/to/sam_dev/CMakeLists.txt），其内容如下：

```cmake
cmake_minimum_required(VERSION 3.24)

set(CMAKE_OSX_DEPLOYMENT_TARGET "10.15" CACHE STRING "Minimum OS X deployment version")
if (UNIX AND NOT CMAKE_C_COMPILER)
    set(CMAKE_C_COMPILER gcc)
    set(CMAKE_CXX_COMPILER g++)
endif()

if(MSVC)
    set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Debug and Release Builds Configured" FORCE)
endif()

project(system_advisor_model)

option(SAMPRIVATE "Release build of SAM" OFF)

add_subdirectory(lk)
add_subdirectory(wex)
add_subdirectory(ssc)
add_subdirectory(sam)
if (SAMPRIVATE)
    add_subdirectory(SAM-private)
    add_subdirectory(SAM-private/webupd)
endif()
```

打开一个终端窗口，并在 SAM 的父文件夹中创建一个名为 build 的文件夹（path/to/sam_dev/build）。

```bash
cd path/to/sam_dev
mkdir build
```

如果这不是你第一次构建 SAM，而且你想删除旧的构建（除非你在构建过程中遇到问题或重新运行 cmake 后添加了 .cpp 文件到其中一个存储库，否则不需要删除旧的构建）：

```bash
cd path/to/sam_dev
rmdir /Q/S build
mkdir build
```

现在，你应该有一个 SAM 的目录结构，它看起来像这样（对于我们的示例，这将是 path/to/sam_dev 的内容）：

```
build
lk
sam
ssc
wex
CMakeLists.txt
```

进入你上面创建的 build 文件夹。

```bash
cd path/to/sam_dev/build
```

运行 CMake 以生成 Visual Studio 解决方案和项目文件。该命令为 SAM 的开源版本构建了 Debug 和 Release 文件，这对于大多数开发任务足够了。如果要构建官方的 NREL 版本的 SAM，并/或者生成用于 PySAM 的 API 文件，请选择下面描述的适当的 CMake 选项。

请注意，CMake 命令的末尾有两个句点 ..，以确保运行你在父文件夹中创建的 CmakeLists.txt 文件。

```bash
cmake -G "Visual Studio 17 2022" -DCMAKE_CONFIGURATION_TYPES="Debug;Release" -DSAM_SKIP_AUTOGEN=1 -DSAMAPI_EXPORT=0 -DSAMPRIVATE=0 -DCMAKE_SYSTEM_VERSION=10.0 ..
```

当 CMake 完成后，你应该在 path/to/sam_dev/build/ 文件夹中看到 system_advisor_model.sln Visual Studio 解决方案文件以及支持文件、Debug 和 Release 文件夹，以及分别包含 SAM、

SSC、WEX 和 LK 的文件夹等其他文件和文件夹。

如果出现有关缺少文件的构建错误，请检查环境变量以确保它们被正确命名并指向正确的文件夹。

CMake 选项:

请注意，每个选项在 cmake 命令中的前面都有字母 "D"。

- CMAKE*CONFIGURATION*TYPES


​       构建调试、发布版本或两个版本的选项。

```
"Debug" = 为调试版本构建文件。如果你打算使用 VS 2022 的调试工具，请选择此选项。 
"Release" = 为发布版本构建文件。选择此选项可在不使用 VS 2022 的调试工具的情况下运行 SAM。
"Debug;Release" = 为调试和发布版本构建文件。
```

-  SAM*SKIP*AUTOGEN


​       跳过从 export_config 自动生成 SAMAPI 文件。SAMAPI 文件用于 PySAM    Python 包。

```
1 = 跳过 SAMAPI 文件的生成。当不需要生成 SAMAPI 文件时，使用此选项可以加快构建时间。
0 = 重新生成文件。如果你正在向 SSC 的 Develop 或 Patch 分支提交添加、删除或修改输入或输出变量，或添加或删除计算模块的代码，请使用此选项。 
```

- SAMAPI_EXPORT

​       将 SSC 二进制文件导出到 SAM*api 文件夹。这些文件用于 PySAM Python 包。（Unix 还会编译 SAM*API 的库文件）。

```
1 = 导出二进制文件。如果你正在向 SSC 的 Develop 或 Patch 分支提交添加、删除或修改输入或输出变量，或添加或删除计算模块的代码，请使用此选项。
0 = 不导出。当不需要构建 PySAM 文件时，使用此选项可以加快构建时间。
```

-  SAMPRIVATE

​        为官方的 NREL 发行版本的 SAM 构建解决方案文件。

```
1 = 在解决方案中包括私有 (SAM) 和开源 (SAMOS) 项目。如果你正在构建官方的 NREL 发行版本并且可以访问私有的 SAM-private 存储库，请使用此选项。
0 = 在解决方案中只包括开源 (SAMOS) 项目。如果你正在构建 SAM 的开源版本，请使用此选项。
```

-  CMAKE*SYSTEM*VERSION CMake 版本号。

（可选，但推荐）：在 path/to/sam_dev 文件夹中添加一个 .editorconfig 文件，以确保你的代码与项目标准一致的格式化。



8. 构建 SAM
启动 VS 2022，打开上一步中的 system_advisor_model.sln 解决方案文件。

在大多数情况下，你只需要构建 SAMOS 项目：

- 在解决方案资源管理器中选择 SAMOS 项目（如果看不到解决方案资源管理器，请按 Ctrl+; 显示它）。


- 从窗口顶部的工具栏中选择 Release 或 Debug。


- 从“生成”菜单中选择“构建 SAMOS”（或按 Ctrl+B）。这将从 SAM、SSC、WEX 和 LK 以及其他依赖项目构建出 SAM 的可执行版本。


构建解决方案中的所有项目比仅构建 SAMOS 需要更长时间，会创建 SDKtoool 和 TCSconsole 的可执行文件，并生成大量用于 PySAM 的 API 文件，你可能不需要。

如果你有权限构建官方 NREL 版本的 SAM，并在上面的 cmake 命令中使用了 SAMPRIVATE = 1 选项，将会有两个 SAM 项目：SAMOS 是 SAM 的开源版本，而 SAM 是官方 NREL 版本的 SAM。构建 SAMOS 来测试官方版本特定的功能。

官方版本（SAM）需要注册密钥才能运行，并包括从 SAM 用户界面下载 NSRDB 天气文件、URDB 电费数据和 Cambium 市场价格数据等功能。

开源版本（SAMOS）可以在没有注册密钥的情况下运行。如果你想在 SAMOS 中使用下载功能，请修改 path/to/samdev/sam/src/private.h 添加有效的 API 密钥。

默认情况下，VS 2022 的启动项目设置为 ALL_BUILD。如果你想在 VS 2022 中从“调试”菜单运行 SAM，或者按 Ctrl+F5 或 F5 键而不构建不必要的其他项目，可以将启动项目更改为 SAMOS（或 SAM，如果是官方 NREL 版本的 SAM）。要更改启动项目，请在解决方案资源管理器中右键单击项目名称（SAMOS 或 SAM），然后单击“设置为启动项目”。

如果你的代码贡献涉及添加或更改输入的默认值，你应该在构建中包含 export_config 和 SAM_api，以更新用于 PySAM 的文件中的默认值。这需要在上面的 cmake 命令中使用 -DSAM_SKIP_AUTOGEN=0 和 -DSAMAPI_EXPORT=1，以便这些项目在你的 Visual Studio 解决方案中可用。为了避免同时运行两个作业时的冲突，你只需要构建一个 Release 版本即可。（对于此目的来说，构建调试和发布版本是多余的，例如，没有 export_configd.exe。）

你还可以使用批量构建来选择要构建的项目：在“生成”菜单中，点击“批量生成”。



9. 测试构建
在构建解决方案后，通过启动 SAM 并运行模拟来

测试构建。可执行文件取决于你构建的版本：

对于 SAM 的开源版本，请转到 path/to/sam_dev/SAM/deploy/x64 并运行 SAMOS.exe。

对于 SAM 的官方 NREL 版本，请转到 path/to/sam_dev/SAM-private/build_windows/deploy/x64 并运行 SAM.exe。

调试版本位于相同的文件夹中，但文件名中包含 "d"：SAMOSd.exe 和 SAMd.exe。

进行基本功能测试：

SAM 启动后，在 SAM 的欢迎页面上，点击“开始新项目”。

选择“光伏”、“详细光伏模型”和“分布式”、“住宅业主”。

在 SAM 窗口左下方点击“模拟”。SAM 应该运行模拟并显示结果。

在“模拟”按钮下方点击“宏”，选择其中一个宏名称，然后点击“运行宏”或“查看代码”。你应该看到宏代码，表示 LK 构建正确。

在“位置和资源”页面上，点击“查看数据”。一个 DView 窗口应该打开，表示 WEX 项目的 DView 构建正确。（SAM 还使用 DView 在“结果”页面上显示数据。）

如果你正在测试官方 NREL 版本，请在“位置和资源”和“电费”页面上测试下载功能。

## 小结

如果不明白，请查看前面6条内容。ssc实际编译完就是ssc.dll这个动态链接库。sam额外加了gui壳，以方便用户使用。lk只是sam提供的一个脚本语言，忽略它。

## 写在最后

如果对git不懂，请参考我们系列文档的git介绍。对cmake不懂请参考我们的make和makefile介绍。仍然不明白，请自行借助网络搜索引擎。编译完之后，把前面讲过的内容再想一想，体会一下。每一步大概都是在干啥，为什么。