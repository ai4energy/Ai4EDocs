# MIDACO

## 简介

MIDACO是一个用于解决数值优化问题的求解器。它可以应用于连续型（NLP）、离散/整数型（IP）和混合整数型（MINLP）问题，支持单目标和[**多目标**](http://midaco-solver.com/index.php/more/multi-objective)（MO）优化。问题可以包含平等约束和/不平等约束，适用于具有数千个变量或数百个目标的问题。MIDACO采用无导数的进化混合算法，将问题视为黑盒，可以处理非凸性、不连续性或随机噪声等关键函数特性。对于耗时的应用程序，MIDACO提供了高效的[并行化](http://midaco-solver.com/index.php/more/parallelization)策略。该软件支持多种编程语言，包括[Excel](http://midaco-solver.com/index.php/download)、[VBA](http://midaco-solver.com/index.php/download)、[Java](http://midaco-solver.com/index.php/download)、[C#](http://midaco-solver.com/index.php/download)、[Matlab](http://midaco-solver.com/index.php/download)、[Octave](http://midaco-solver.com/index.php/download)、[Python](http://midaco-solver.com/index.php/download)、[R](http://midaco-solver.com/index.php/download)、[Julia](http://midaco-solver.com/index.php/download)、[C/C++](http://midaco-solver.com/index.php/download)和[Fortran](http://midaco-solver.com/index.php/download)。

## 特点

1. MIDACO是一个用于全局优化问题的求解器
   - 支持单目标和多目标优化
   - 支持连续型、离散/组合型和混合整数型变量
   - 可以处理有约束和无约束的问题

2. 采用进化混合算法（结合了进化算法和其他优化技术）
   - 基于蚁群优化（ACO）的元启发式算法
   - 内部混合了回溯线搜索，以实现快速局部收敛
   - 目标和约束可以是线性或非线性的（不要求可微性）
   - 黑盒求解器：目标和约束函数可以是未知的

3. 大规模数据处理能力
   - 可解决具有多达100,000个变量的问题
   - 可处理数千个约束和数百个目标

4. 并行化运算
   - 能够进行大规模并行化，利用数千个核心/线程（包括GPGPU）

5. 简洁普适的代码
   - 支持多种编程语言，如Excel、VBA、Java、C#、R、Matlab、Octave、Python、Julia、C/C++、Fortran等
   - 超轻量级（最小约200kb）
   - 完全自包含的源代码（无第三方依赖）
   - 在所有平台上编译和运行，包括Win/Mac/Unix和Web服务器
   - 易于使用和嵌入

## 应用场景

以下是一些常见的使用MIDACO的情况：

1. 数学建模和优化问题：MIDACO可用于解决数学建模和优化问题，如线性规划、非线性规划、整数规划、多目标优化等。它能够处理具有大规模变量和约束的问题，并提供高效的求解能力。
2. 工程设计和优化：MIDACO可用于工程领域中的设计和优化问题，例如结构优化、工艺优化、参数优化等。它能够帮助工程师在设计过程中找到最佳解决方案，以满足特定的性能指标或约束条件。
3. 仿真和模拟优化：对于黑盒函数、模拟器或复杂仿真模型，MIDACO可以通过最小化或最大化目标函数来优化参数设置。它能够在优化过程中调用模拟器，并通过评估输出结果来指导参数搜索，以获得最佳性能或结果。
4. 多目标和多约束问题：MIDACO可以处理具有多个目标函数和多个约束条件的问题。它能够在多个目标之间寻找平衡解，并在满足多个约束条件的情况下找到最优解。
5. 科学研究和实验设计：对于需要进行大量试验和参数调整的科学研究，MIDACO可以帮助自动化参数搜索过程，并加速实验设计。它能够帮助研究人员更快地找到最佳参数组合，以获得准确的结果。

综上所述，如果您面临复杂的优化问题，无论是数学建模、工程设计、仿真优化还是科学研究，MIDACO可能是一个有用的工具。它具有处理大规模问题、多目标和多约束问题的能力，并且适用于各种编程语言和平台，使其成为解决复杂问题的有效选择。

## 安装与使用

访问MIDACO的[官方网站](https://www.midaco-solver.com/)，在[下载页面](http://midaco-solver.com/index.php/download)选择适合您的版本，并按照相应的提示进行安装。

下面以C++语言为例介绍MIDACO的安装与使用：

1. 首先，您可以下载[midaco.c](http://midaco-solver.com/data/c/midaco.c)文件，该文件包含了算法的实现和相关函数。您也可以复制文件的全部内容，使用记事本生成名为"midaco.c"的文件（注意文件后缀名为.c）。

2. 将下载的midaco.c文件与您的应用层面文件放置在同一个目录下。在下载页面上，您可以找到一些示例文件，例如[example_NLP.cpp](http://midaco-solver.com/data/c/example_NLP.cpp)、[example_NLPc.cpp](http://midaco-solver.com/data/c/example_NLPc.cpp)等。

3. 打开命令行界面，并使用gcc编译器分别将midaco.c文件和应用层面的文件（例如example_MINLPc.c）编译为.o目标文件。

   ```
   rCopy codegcc -c example_MINLPc.c
   gcc -c midaco.c
   ```

4. 将生成的目标文件与数学库（libm）一起链接，生成最终的可执行文件"run.exe"。

   ```
   arduinoCopy code
   gcc -o run example_MINLPc.o midaco.o -lm
   ```

5. 运行可执行文件"run.exe"，即可生成包含优化方案的文档"MIDACO_SCREEN.TXT"和"MIDACO_SOLUTION.TXT"。

除了在命令行中进行编译，您还可以选择在集成开发环境（IDE）中进行编译。更详细的信息请参考MIDACO的官方文档。如果您使用Fortran语言，可以采用类似的方法进行编译和使用。

以Julia语言为例介绍另一种使用方式：

1. 首先，您可以下载[midaco.jl](http://midaco-solver.com/data/julia/midaco.jl)文件和对应的动态链接库（例如64位Windows系统的[midacoJL.dll](http://midaco-solver.com/data/julia/win64/midacoJL.dll)）。
2. 将下载的midaco.jl文件、动态链接库以及您的应用层面文件（例如example_NLP.jl）放置在同一个目录下。
3. 运行您的应用层面文件，即可使用MIDACO求解优化问题。

对于Python语言，您可以采用类似的方法进行安装和使用MIDACO。



## 代码编写格式

所有代码文件都包含以下几个部分：设置问题的维度、边界、起始点、停止准则和打印选项；定义问题和求解选项；调用MIDACO求解器解决问题。

通过执行源代码文件中的MIDACO求解器，并将结果存储在`solution`变量中。解包括目标值（`solution["f"]`）、约束值（`solution["g"]`）和变量值（`solution["x"]`）。

不同编程语言的具体格式要求略有不同，请参考官方文档或提供的示例。

下面以Julia语言为例介绍如何使用MIDACO：

1. 定义问题函数

```julia
function problem_function(x)
  f = Array{Float64, 1}(undef, 1) # 初始化目标函数数组 F(X) 
  # 目标函数 F(X)
  f[1] = (x[1] - 1)^2 + 
         (x[2] - 2)^2 + 
         (x[3] - 3)^2 + 
         (x[4] - 4)^2 + 1.23456789
  # 约束
  g = 0
  return f, g
end
```

2. 授权

```julia
key = "MIDACO_LIMITED_VERSION___[CREATIVE_COMMONS_BY-NC-ND_LICENSE]"
```

这一行定义了一个名为`key`的字符串变量，并将其赋值为"MIDACO_LIMITED_VERSION___[CREATIVE_COMMONS_BY-NC-ND_LICENSE]"。它是用于授权的密钥，用于限制MIDACO版本的使用。

3. 定义问题和求解选项

```julia
problem = Dict()
option = Dict()
```

这两行创建了两个空字典变量`problem`和`option`，用于存储问题定义和求解选项。

4. 设置问题的类型

```julia
problem["o"] = 1  # 目标函数数量 
problem["n"] = 4  # 总变量数
problem["ni"] = 0  # 整数变量数量（0 <= ni <= n） 
problem["m"] = 0  # 总约束条件数
problem["me"] = 0  # 等式约束条件数量（0 <= me <= m）
```

这几行设置了问题的维度和约束条件。其中，`o`表示目标函数的数量（本例中为1），`n`表示变量的总数（本例中为4），`ni`表示整数变量的数量（本例中为0），`m`表示约束条件的数量（本例中为0），`me`表示等式约束条件的数量（本例中为0）。

5. 定义问题的变量边界

```julia
problem["xl"] = [1, 1, 1, 1]
problem["xu"] = [4, 4, 4, 4]
```

这两行定义了问题的变量边界。`xl`表示下界，`xu`表示上界。在本例中，变量的下界为[1, 1, 1, 1]，上界为[4, 4, 4, 4]。

```julia
problem["x"] = problem["xl"]
```

这一行设置了问题的起始点。在本例中，起始点被设置为下界`xl`。

6. 设置停止准则

```julia
option["maxeval"] = 10000     # 最大函数评估次数（例如1000000） 
option["maxtime"] = 60 * 60 * 24  # 最大时间限制（秒）（例如1天 = 60 * 60 * 24）
```

这两行设置了停止准则。`maxeval`表示最大函数评估次数，本例中设置为10000次。`maxtime`表示最大时间限制，本例中设置为1天。

7. 设置打印选项

```julia
option["printeval"] = 1000  # 当前最佳解的打印频率（例如1000） 
option["save2file"] = 1     # 是否将结果保存到TXT文件（0=否/1=是）
```

这两行设置了打印选项。`printeval`表示当前最佳解的打印频率，本例中设置为每1000次评估打印一次。`save2file`表示是否将结果保存到TXT文件，本例中设置为保存（1）。

8. 设置并行化选项

```julia
option["parallel"] = 0  # 有关Julia的并行化，请参考MIDACO网站
```

这一行设置了并行化选项。在本例中，设置为禁用并行化（0）。

9. 调用文件

```julia
include("midaco.jl")
```

这一行通过包含`midaco.jl`文件将其导入到当前上下文中，以便后续调用其中的函数。

10. 求解

```julia
solution = midaco(problem, option, key)
```

这一行调用`midaco`函数，将问题定义、求解选项和密钥作为参数传递给该函数，并将返回的解存储在`solution`变量中。

## 小结

安装与使用过程涉及程序的编译、链接和调用链接库。与其他求解器相比，MIDACO统一规范了模型的编写格式，使用者只需根据不同优化问题的示例编写自己的代码。在MIDACO中，底层运算逻辑已经编写完成，使用者只需调用相应库并为problem、option和key进行赋值，从而实现优化问题的求解。黑盒优化中的"黑盒"指的是我们要研究的模型或问题，其中我们不知道其内部结构，但可以通过给定输入获取输出。MIDACO通过为模型提供输入并获取输出来进行优化。它将问题视为黑盒，其中目标函数和约束函数是未知的。