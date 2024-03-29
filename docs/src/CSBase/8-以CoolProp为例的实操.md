# 以CoolProp为例的实操

## 引言

热力学图表是所有能动学生都会要用到的工具。通常是在学习工程热力学时发的热力学图表。图表主要是用来查水的物性，焓、熵等。水会发生相变。热力学图表的知识参考工程热力学教材。现在学生们都用纸本的，远远落后于时代。我们要是能做个网页，可以在网页上查看不同的图多酷啊，要是还能导出相应的数值就更好了，而且提供api调用就完美了。

理解从背后计算到前台漂亮的页面是如何实现的，这是我们此篇文档的目的。至于物性到底如何计算，那则是能动学院科研工作之一。

## RefProp是什么
Refprop 是一个流体物性计算程序，用于计算和估算各种流体的热力学和传输性质。它由美国国家标准技术研究所（NIST）开发，旨在提供精确和可靠的流体物性数据。

Refprop 可以计算多种流体的性质，包括气体、液体和超临界流体。它可以计算的性质包括密度、压力、温度、比热容、粘度、导热系数、表面张力等。这些性质对于工程领域中的设计和分析非常重要，特别是在化学工程、能源系统和制冷空调等领域。

Refprop 使用的基础是经过验证和广泛接受的热力学模型和实验数据。它包含了大量的流体物性数据，可以用于估算各种温度、压力和组分条件下的性质。用户可以通过输入流体的组分、温度和压力等参数，获得所需的物性计算结果。

Refprop 还提供了一个用户友好的界面，使用户能够轻松地进行输入和输出。它支持多种编程语言，如Fortran、C++、Python等，可以与其他软件和模拟工具集成使用。

需要注意的是，Refprop 是一款商业软件，需要购买和许可才能使用。NIST 提供了关于 Refprop 的详细文档和支持，帮助用户正确使用和理解软件的功能和限制。

总而言之，Refprop 是一款流体物性计算程序，可用于计算和估算各种流体的热力学和传输性质。它是工程领域中重要的工具，用于设计和分析化学工程、能源系统和制冷空调等领域的应用。

## CoolProp又是什么

CoolProp 是一个开源的流体物性计算库，用于计算和估算各种流体的热力学和传输性质。它由一组开发者在多个国家合作开发，旨在提供高精度、可靠且易于使用的流体物性数据。

与 Refprop 不同，CoolProp 是一个免费的开源软件，可以在各种操作系统上使用，包括 Windows、Linux 和 macOS。它支持多种编程语言，如Python、C++、Matlab 等，可以与其他软件和模拟工具进行集成。

CoolProp 提供了广泛的流体物性计算功能，可以计算包括气体、液体、超临界流体在内的多种流体的性质。它可以计算的性质包括密度、压力、温度、比热容、粘度、导热系数、表面张力等。除了常见的单组分流体，CoolProp 还支持混合物和多组分流体的计算。

CoolProp 的优势之一是它提供了多种流体物性模型和方程式，以适应不同流体和应用的需求。它包括了广泛验证的热力学模型和实验数据，以提供准确的计算结果。此外，CoolProp 还提供了适用于不同工程领域的专用函数和接口，简化了复杂流体系统的建模和分析过程。

CoolProp 的开源特性使得用户可以自由地使用、修改和分享代码。同时，它也有一个活跃的社区，用户可以通过论坛和邮件列表获取支持和交流。

总结起来，CoolProp 是一个免费的开源流体物性计算库，用于计算和估算各种流体的热力学和传输性质。它提供了广泛的计算功能和模型选择，并支持多种编程语言和操作系统。CoolProp 在工程领域中被广泛应用于化学工程、能源系统、制冷空调等领域的设计和分析。

## Step by Step

1. 找本工程热力学书看一看，找一本热力学图表看一看，理解一下热力学图表。

2. 看一看[这里](https://learncheme.com/simulations/thermodynamics/thermo-1/pressure-volume-diagram-for-water/), 看看网页形式如何呈现。

3. 看一看CoolProp的在线接口https://ibell.pythonanywhere.com/， 了解如何通过网页查取相应的数据。

4. 编译RefProp，生成相应的dll。（此篇覆盖）

5. 使用julia安装一下CoolProp，使用一下其julia界面。（此篇不覆盖）

6. 使用http.jl把coolprop封装成一个服务。（此篇不覆盖）

7. 用JavaScript做个前端页面。（此篇不覆盖）

## 编译RefProp生成dll
### 获取RefProp安装包
**获取RefProp的安装包。（通过baidu搜索）**

Refprop 是一款商业软件，需要购买和许可才能获取安装包。您可以通过以下步骤获取 Refprop 的安装包：

1. 访问美国国家标准技术研究所（NIST）的网站：https://www.nist.gov/srd/refprop

2. 在 NIST 网站上，您可以找到关于 Refprop 的详细信息和文档。阅读相关信息，了解软件的功能、价格和许可方式。

3. 在 NIST 网站上选择 "Order Refprop" 或类似的选项，该选项将引导您到购买页面。

4. 根据您的需求选择合适的许可类型（例如个人、教育或商业许可）和版本（例如 Windows 或 Linux），然后点击 "Add to Cart"（添加到购物车）。

5. 跟随购买流程，提供所需的信息，并完成支付。购买后，您将收到许可证和相关的安装文件。

请注意，购买 Refprop 是需要支付费用的，具体费用和许可方式可能因版本和许可类型而有所不同。建议在购买前仔细阅读 NIST 网站上的相关信息，确保了解软件的使用限制和许可条款。

如果您需要更详细的购买指南或有其他问题，建议直接与 NIST 或 Refprop 的官方联系，以获取准确的购买信息和支持。
### 安装RefProp

安装 Refprop 需要购买该商业软件并获得许可证。一旦您购买了 Refprop 的许可证，并收到了安装文件，可以按照以下步骤安装 Refprop：

1. 下载安装文件：从获得许可证的来源（通常是 NIST）下载 Refprop 的安装文件。确保下载与您的操作系统兼容的版本。

2. 解压安装文件：将下载的安装文件解压缩到您选择的目标位置。这将创建一个包含 Refprop 安装所需文件的文件夹。

3. 运行安装程序：进入解压后的文件夹，并找到安装程序。根据您的操作系统，可能是一个可执行文件（.exe）或脚本文件。双击运行该程序。

4. 跟随安装向导：安装程序会启动一个安装向导，引导您完成安装过程。按照屏幕上的指示逐步进行，选择安装选项、目标文件夹和其他配置选项。

5. 完成安装：安装程序将复制所需的文件并配置系统设置。完成安装后，您将收到安装成功的确认消息。

6. 激活许可证：根据您的许可证要求，可能需要在安装过程中或安装完成后激活许可证。按照提供的指南和说明进行操作，确保许可证被正确激活。

请注意，Refprop 是一款专业的流体物性计算软件，使用前需要购买合法的许可证。确保遵守相关许可协议和使用条款。如果您在安装过程中遇到问题或需要更多支持，请联系 Refprop 的官方渠道或与购买许可证的机构进行联系。

### RefProp如何使用？

Refprop提供了基于图形用户界面（GUI）的安装程序，用于在Windows系统上使用。

以下是使用Refprop GUI界面的一般步骤：

1. 安装Refprop：按照之前提到的步骤购买和安装Refprop软件。确保您选择了适合您操作系统的版本。

2. 启动Refprop GUI：安装完成后，在您的计算机上找到Refprop安装目录。在该目录中，您应该能够找到一个可执行文件（.exe），通常命名为Refprop.exe。双击运行该文件以启动Refprop GUI。

3. 导入或输入数据：在Refprop GUI中，您可以通过导入数据文件或手动输入数据来定义要计算的流体和条件。根据Refprop的界面设计，提供相关的输入框、下拉菜单和按钮等，以便您输入组分、温度、压力等参数。

4. 运行计算：配置完输入数据后，通过点击运行按钮或相关选项启动计算。Refprop将使用您提供的输入数据进行流体物性计算。

5. 查看和分析结果：一旦计算完成，Refprop GUI将提供计算结果的可视化和分析选项。您可以查看计算得到的物性数据、图表或其他结果。

请注意，Refprop GUI的界面和操作方式可能会因不同版本和更新而有所不同。确保参考Refprop的文档、帮助文件或相关指南，以了解如何使用特定版本的GUI界面。

如果您在使用Refprop GUI过程中遇到任何问题，我建议您查阅Refprop的文档、联系Refprop的支持团队或查找相关的用户社区和论坛，以获取更详细的指导和支持。

### RefProp的编程语言调用接口

Refprop 提供了几种编程语言的调用接口，使开发者能够在自己的程序中集成和调用 Refprop 的功能。以下是一些常用的编程语言调用接口：

1. C/C++ 接口：Refprop 提供了 C/C++ 的接口，允许开发者使用 C/C++ 语言调用 Refprop 的函数和子程序。这种接口允许直接的编程访问和控制 Refprop 的计算过程。

2. Fortran 接口：Refprop 还提供了 Fortran 的接口，允许开发者使用 Fortran 语言调用 Refprop 的子程序。这个接口与 Fortran 语言的特性和调用约定相匹配，方便 Fortran 开发者集成 Refprop。

3. MATLAB 接口：Refprop 还提供了用于 MATLAB 的接口。这个接口允许 MATLAB 用户在 MATLAB 环境中直接调用 Refprop 的函数和计算物性。

4. Python 接口：Refprop 提供了用于 Python 的接口，允许开发者使用 Python 调用 Refprop。这个接口使用了 Python 的 C API，并提供了 Pythonic 的接口风格，方便 Python 开发者进行流体物性计算。

5. Excel 接口：Refprop 还提供了用于 Excel 的接口，使用户能够在 Excel 中使用自定义的函数和公式来调用 Refprop 进行计算。

这些接口提供了调用 Refprop 功能的便捷方式，使开发者能够在自己的程序中利用 Refprop 的流体物性计算能力。通过使用这些接口，开发者可以按照自己的需要调用 Refprop 的函数，传递输入参数并获取计算结果。

具体使用每种编程语言的接口时，需要参考 Refprop 的官方文档和相关的编程指南，以了解接口的具体用法和调用方法。

请注意，不同的编程语言接口可能有所不同，并且在使用这些接口之前，您需要确保正确配置和连接 Refprop 的库和头文件，并遵循相应的调用约定和接口规范。

**[参考这里获得官方的例子](https://github.com/usnistgov/REFPROP-wrappers)**

### RefProp的编译

[官方的说明在这里](https://github.com/usnistgov/REFPROP-cmake)。

我们进入REFPROP安装目录，可以看到有个FORTRAN文件夹， 这里就是RefProp的源代码。看到有个REFPROP.EXE，这就是RefProp的可执行文件。还有个refprop.dll，这就是计算内核，是一个动态链接库。还有个REFPRP64.DLL是64位的动态链接库。我们编译RefProp就是从fortran源文件生成这个dll。至于想学它的fortran代码是如何写的，可以打开FORTRAN 文件夹中的文件，研究一下。

RefProp的编译流程如下：

1. 克隆 REFPROP-cmake 仓库：通过执行以下命令来克隆 REFPROP-cmake 仓库到本地：
```
git clone --recursive https://github.com/usnistgov/REFPROP-cmake.git
```

2. 复制 REFPROP 安装目录下的 FORTRAN 文件夹：将 REFPROP 安装目录下的 FORTRAN 文件夹复制到克隆的代码库的根目录中。

3. 打开命令行终端：在克隆的代码库根目录下打开命令行终端。

4. 创建 build 目录：执行以下命令创建一个名为 build 的目录：
```
mkdir build
```

5. 进入 build 目录：执行以下命令进入 build 目录：
```
cd build
```

6. 配置 CMake 构建系统：执行以下命令配置 CMake 构建系统：
```
cmake .. -DCMAKE_BUILD_TYPE=Release
```
这将使用 Release 模式配置 CMake 构建系统，生成 Release 版本的库。

7. 构建 RefProp：执行以下命令开始构建 RefProp 库：
```
cmake --build .
```
这将根据 CMake 配置文件开始构建 RefProp，并生成相应的库文件。

完成上述步骤后，将生成的共享库文件放置在操作系统能够找到的位置。在 Windows 上，可以将库文件添加到 PATH 环境变量中。在 macOS 上，可以放置在默认的共享库位置之一。

请注意，在不同的操作系统上可能会有一些特定的配置步骤和注意事项。如果遇到问题，建议查阅 RefProp 的官方文档和相关的编译指南，以获取更详细的指导和解决方案。

### 到底如何调用呢？

我们写的文档已经说过了如何调用dll，这个问题逻辑上已经解决。而且RefProp官方提供了不同的语言调用的例子。

**[再说一次，参考这里获得官方的例子](https://github.com/usnistgov/REFPROP-wrappers)**

## 最后再多说一句

我们发现好多东西都在[github](https://github.com/)上啊。请自行学习github是啥，如何使用。