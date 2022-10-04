# Ai4EDocs

## **腾飞杯招募**

### 腾飞杯项目简介信息

自我介绍：能动研二杨景懿，感兴趣的研究方向是：系统的建模、仿真、优化与控制。[个人主页](https://jake484.github.io/myhomepage/)。QQ：522432938

目前已有核心开发人员3名，指导老师1名。

#### 主题

云仿真平台（具体名字待定），简单理解为：网页版Simulink（或者网页版AspenPlus，网页版gproms，网页版modelica，本质都一样）

暂定赛道：科技发明制作A类

#### 技术框架

前后端分离。前端VUE3，后端Julia，通过json交互。

#### 已有进展

**所有代码、文档**可在Github上自行查看。

* 我们的Ai4Energy开源组织：https://github.com/ai4energy
* 模型库[Ai4EComponentLib.jl](https://ai4energy.github.io/Ai4EComponentLib.jl/dev/)，现在已有的有可压缩组件库（空压系统），不可以压缩组件库（管道系统），电化学库（光伏、电解槽、电池等），热力循环库（各类循环等）
* json解析器：[Ai4EMetaPSE.jl](https://ai4energy.github.io/Ai4EMetaPSE.jl/dev/)
* [Ai4ELab](https://ai4energy.github.io/Ai4ELab/dev/)，Julia的web框架。但是灵活性不够高，希望用VUE3开发。
* 求解器采用开源求解器。
* 前端页面参考：https://github.com/yaolunmao/vue-webtopo-svgeditor

总结：高可拓展性的后端框架**已经完成**，完整作品的上线测试运行**只差前端**。

#### 招募队员

招募2-3名队员。

负责内容：基于[该VUE实现](https://github.com/yaolunmao/vue-webtopo-svgeditor)做开发，打造自己的作品。
要求：专业不限，年级不限。动手能力强，具有钻研精神。热爱程序设计。**能投入**。

有兴趣的同学联系+QQ：522432938

!!! tip

    * 基于上述介绍，我们是踏实严肃的且有货的开发团队，不鸽不水。
    * 本网页是我们开放的文档库，可自行学习浏览。
    * 我们的目的是打造作品，只要东西能做出来，队长、队员重要程度什么的都好商量。
  
    最后，腾飞杯只是一个展示平台。比赛过后，我们的组织依旧会传承与发展，我们的目标是星辰大海~
    抛开比赛，欢迎有热情、有激情的同学加入，共同学习、成长与开发。

![图 4](assets/index_picture.png)  

!!! tip

    * [智慧能源系统导论](https://ai4energy.github.io/enpo811203/)
    * [OptControl.jl](https://ai4energy.github.io/OptControl.jl/dev/)
    * [Ai4ELab](https://ai4energy.github.io/Ai4ELab/dev/)
    * [Ai4EComponentLib.jl](https://ai4energy.github.io/Ai4EComponentLib.jl/dev/)
    * [Ai4EMetaPSE.jl](https://ai4energy.github.io/Ai4EMetaPSE.jl/dev/)

## Ai4EDocs简介

Ai4EDocs是Ai4E小组在学习中整理的一些可操作案例。案例的核心主要与建模仿真优化控制相关。文档主要特点为：

* 既有数学层面的探究，也包含了应用层面的案例。
* 包含大量Julia生态中软件包的使用
* 兼顾建模仿真优化控制核心与拓展
* 分享对理论抽象问题的认识
* 分享软件使用过程中的技巧
* 分享学习的心路历程与对库使用的理解
* Ai4Energy组的合作开发流程

供学习参考。

![Stable](https://img.shields.io/badge/Docs-Updating...-blue.svg?style=flat-square)

欢迎贡献文档！

![Stable](https://img.shields.io/badge/Articles-Total_31-green.svg?style=flat-square)

## Julia资源传送门

1. [Julia中文文档](https://cn.julialang.org/)
2. [Julia官方文档](https://julialang.org/)
3. [Sciml总站](https://sciml.ai/)
4. [ModelingToolkit.jl](https://mtk.sciml.ai/stable/)（符号建模包）
5. [DifferentialEquations.jl](https://diffeq.sciml.ai/dev/)（常微分方程求解包）
6. [NeuralPDE.jl](https://neuralpde.sciml.ai/stable/)（偏微分方程求解包）
7. [Symbolics.jl](https://symbolics.juliasymbolics.org/dev/)（MTK依赖的符号求解包）
8. [JuMP.jl](https://jump.dev/JuMP.jl/stable/)（优化求解器包）
9. [DiffEqParamEstim.jl](https://diffeqparamestim.sciml.ai/dev/)（基于DE的参数辨识包）
10. [Plots.ji](https://docs.juliaplots.org/dev/)（可视化包）
11. [CSV.jl](https://csv.juliadata.org/stable/)
12. [DataFrames.jl](https://dataframes.juliadata.org/stable/)（大规模数据批量处理包）
13. [Unitful](https://painterqubits.github.io/Unitful.jl/stable/)（单位计算包）
14. [Optimization.jl](https://optimization.sciml.ai/stable/)(Sciml优化包)
15. [SymPy.jl](https://docs.juliahub.com/SymPy/KzewI/1.0.31/) 符号计算包（可求方程解析解），与Matlab中的符号工具包类似
16. [EquationsSolver](https://jake484.github.io/EquationsSolver.jl/) 自制的小型方程（组）求解器
17. [Flux.jl](https://fluxml.ai/Flux.jl/stable/) Julia机器学习包(The Julia Machine Learning Library)
18. [OptControl.jl](https://ai4energy.github.io/OptControl.jl/dev/) 对MTK中ODESystem的最优控制支持包，**由Ai4自主开发**。
19. [Geine.jl and Stipple.jl](https://www.genieframework.com/) Geine和Stipple的文档
20. [Pkg.jl](https://pkgdocs.julialang.org/v1/) 包管理

## 其它资源传送门

1. [CoolProp](http://www.coolprop.org/index.html)
2. [APMonitor-github](https://github.com/APMonitor/)
3. [APMonitor](http://apmonitor.com/)
4. [Greet](https://greet.es.anl.gov/)
5. [Mqtt系列教程](https://www.hangge.com/blog/cache/detail_2347.html)
6. [Mixed Integer Distributed Ant Colony Optimization(midaco-solver)](http://www.midaco-solver.com/)
7. [Python的GUI开发工具PYQT](https://github.com/PyQt5/PyQt/)
8. [Mathematica](https://tiebamma.github.io/InstallTutorial/#mathematica-1301/)

## 文档内容

```@eval
dirs = ["Modeling","Simulation","Optimization","Control","CS Base","Tools","WorkFlow"]

"总篇数：$(sum(map(file -> length(readdir(joinpath(@__DIR__,"..","src",file))), dirs)))"
```

### 建模

```@contents
Pages = map(file -> joinpath("Modeling", file), readdir("Modeling"))
```

### 仿真

```@contents
Pages = map(file -> joinpath("Simulation", file), readdir("Simulation"))
```

### 优化

```@contents
Pages = map(file -> joinpath("Optimization", file), readdir("Optimization"))
```

### 控制

```@contents
Pages = map(file -> joinpath("Control", file), readdir("Control"))
```

### 基础知识

```@contents
Pages = map(file -> joinpath("CS Base", file), readdir("CS Base"))
```

### 工具集

```@contents
Pages = map(file -> joinpath("Tools", file), readdir("Tools"))
```

### 工作流程

```@contents
Pages = map(file -> joinpath("WorkFlow", file), readdir("WorkFlow"))
```