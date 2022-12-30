# JuMP混合整数线性优化实例

!!! tip
    Contents：优化

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

## 问题简介

[Advent Of Code](https://adventofcode.com/2022/day/19)中有一个很有意思的问题，可用JuMP来求解。同时也是能源系统优化的一个缩影。

问题如下：

为了收获粘土，你需要专用的粘土收集机器人。要制造任何类型的机器人，你都需要矿石。收集矿石需要带大钻头的矿石收集机器人。幸运的是，你的背包中正好有一个矿石收集机器人，你可以使用它启动整个操作。

每个机器人**每分钟可以收集1个其资源类型**。机器人工厂（也在你的背包中）**构建任何类型的机器人也需要一分钟**，尽管它在构建开始时会消耗必要的可用资源，同时每分钟最多建造1个机器人。

机器人工厂有很多蓝图（问题的输入）你可以选择，但一旦你用蓝图配置好了，你就不能改变它。

```
蓝图1：
    制造一个矿石机器人（ore robot）消耗4矿石（ore）。
    制造一个粘土机器人（clay robot）消耗2矿石（ore）。
    制造一个黑曜石机器人（obsidian robot）消耗3块矿石（ore）和14块粘土（clay）。
    制造一个紫晶机器人（geode robot）消耗2个矿石（ore）和7个黑曜石（obsidian）。

蓝图2：
    制造一个矿石机器人消耗2矿石。
    制造一个粘土机器人消耗3矿石。
    制造一个黑曜石机器人消耗3块矿石和8块粘土。
    制造一个紫晶机器人消耗3个矿石和12个黑曜石。
```

优化问题为：**如何分配资源去建造机器人，在24分钟后获得最多的紫晶**。

蓝图1的最优方案为最多获得9个紫晶，具体操作过程为：

```
==第1分钟==
1台矿石收集机器人收集1个矿石；你现在有1个矿石。

==第2分钟==
1台矿石收集机器人收集1个矿石；你现在有2个矿石。

==第3分钟==
花2矿石开始建造一个粘土收集机器人。
1台矿石收集机器人收集1个矿石；你现在有1个矿石。

新的粘土收集机器人准备就绪；你现在有一个了。

==第4分钟==
1台矿石收集机器人收集1个矿石；你现在有2个矿石。
1个粘土收集机器人收集1个粘土；你现在有1个粘土。

==第5分钟==

花2矿石开始建造一个粘土收集机器人。
1台矿石收集机器人收集1个矿石；你现在有1个矿石。
1个粘土收集机器人收集1个粘土；你现在有2个粘土。

新的粘土收集机器人准备就绪；你现在有两个了。

==第6分钟==
1台矿石收集机器人收集1个矿石；你现在有2个矿石。
2个粘土收集机器人收集2个粘土；你现在有4块粘土。

==第7分钟==
花2矿石开始建造一个粘土收集机器人。
1台矿石收集机器人收集1个矿石；你现在有1个矿石。
2个粘土收集机器人收集2个粘土；你现在有6块粘土。

新的粘土收集机器人准备就绪；你现在有3个了。

==第8分钟==
1台矿石收集机器人收集1个矿石；你现在有2个矿石。
3个粘土收集机器人收集3个粘土；你现在有9块粘土。

==第9分钟==
1台矿石收集机器人收集1个矿石；你现在有3个矿石。
3个粘土收集机器人收集3个粘土；你现在有12块粘土。

==第10分钟==
1台矿石收集机器人收集1个矿石；你现在有4个矿石。
3个粘土收集机器人收集3个粘土；你现在有15块粘土。

==分钟11==
花3块矿石和14块粘土开始建造一个黑曜石收集机器人。
1台矿石收集机器人收集1个矿石；你现在有2个矿石。
3个粘土收集机器人收集3个粘土；你现在有4块粘土。

新的黑曜石收集机器人准备就绪；你现在有一个了。

==第12分钟==
花2矿石开始建造一个粘土收集机器人。
1台矿石收集机器人收集1个矿石；你现在有1个矿石。
3个粘土收集机器人收集3个粘土；你现在有7块粘土。
1个黑曜石收集机器人收集1颗黑曜岩；你现在有1个黑曜石。

新的粘土收集机器人准备就绪；你现在有4个。

==第13分钟==
1台矿石收集机器人收集1个矿石；你现在有2个矿石。
4个粘土收集机器人收集4个粘土；你现在有11块粘土。
1个黑曜石收集机器人收集1颗黑曜岩；你现在有2颗黑曜石。

==第14分钟==
1台矿石收集机器人收集1个矿石；你现在有3个矿石。
4个粘土收集机器人收集4个粘土；你现在有15块粘土。
1个黑曜石收集机器人收集1颗黑曜岩；你现在有3个黑曜石。

==第15分钟==
花3块矿石和14块粘土开始建造一个黑曜石收集机器人。
1台矿石收集机器人收集1个矿石；你现在有1个矿石。
4个粘土收集机器人收集4个粘土；你现在有5块粘土。
1个黑曜石收集机器人收集1颗黑曜岩；你现在有4颗黑曜石。

新的黑曜石收集机器人准备就绪；你现在有两个了。

==第16分钟==
1台矿石收集机器人收集1个矿石；你现在有2个矿石。
4个粘土收集机器人收集4个粘土；你现在有9块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有6颗黑曜石。

==第17分钟==
1台矿石收集机器人收集1个矿石；你现在有3个矿石。
4个粘土收集机器人收集4个粘土；你现在有13块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有8颗黑曜石。

==第18分钟==
花2颗矿石和7颗黑曜石开始建造一个紫晶机器人。
1台矿石收集机器人收集1个矿石；你现在有2个矿石。
4个粘土收集机器人收集4个粘土；你现在有17块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有3个黑曜石。

新的紫晶机器人准备就绪；你现在有一个了。

==第19分钟==
1台矿石收集机器人收集1个矿石；你现在有3个矿石。
4个粘土收集机器人收集4个粘土；你现在有21块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有5颗黑曜石。

1个紫晶机器人收集1个紫晶；你现在有一个紫晶。

==第20分钟==
1台矿石收集机器人收集1个矿石；你现在有4个矿石。
4个粘土收集机器人收集4个粘土；你现在有25块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有7颗黑曜石。

1个紫晶机器人收集1个紫晶；你现在有2个紫晶。

==第21分钟==
花2颗矿石和7颗黑曜石开始建造一个紫晶机器人。
1台矿石收集机器人收集1个矿石；你现在有3个矿石。
4个粘土收集机器人收集4个粘土；你现在有29块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有2颗黑曜石。
1个紫晶开裂机器人开裂1个大地洞；你现在有3个紫晶。

新的紫晶机器人准备就绪；你现在有两个了。

==第22分钟==
1台矿石收集机器人收集1个矿石；你现在有4个矿石。
4个粘土收集机器人收集4个粘土；你现在有33块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有4颗黑曜石。
2个紫晶机器人收集2个紫晶；你现在有5个紫晶。

==第23分钟==
1台矿石收集机器人收集1个矿石；你现在有5个矿石。
4个粘土收集机器人收集4个粘土；你现在有37块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有6颗黑曜石。
2个紫晶机器人收集2个紫晶；你现在有7个紫晶。

==第24分钟==
1台矿石收集机器人收集1个矿石；你现在有6个矿石。
4个粘土收集机器人收集4个粘土；你现在有41块粘土。
2个黑曜石收集机器人收集2个黑曜石；你现在有8颗黑曜石。
2个紫晶机器人收集2个紫晶；你现在有9个紫晶。
```

蓝图2最多获得12个紫晶。

对于以下蓝图，分别能获得的最多紫晶是多少？

```
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 17 clay. Each geode robot costs 4 ore and 20 obsidian.
Blueprint 2: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 17 clay. Each geode robot costs 3 ore and 8 obsidian.
Blueprint 3: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 7 clay. Each geode robot costs 4 ore and 13 obsidian.
Blueprint 4: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 10 clay. Each geode robot costs 3 ore and 14 obsidian.
Blueprint 5: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 17 clay. Each geode robot costs 3 ore and 16 obsidian.
Blueprint 6: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 16 clay. Each geode robot costs 2 ore and 15 obsidian.
Blueprint 7: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 15 clay. Each geode robot costs 2 ore and 15 obsidian.
Blueprint 8: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 19 clay. Each geode robot costs 2 ore and 18 obsidian.
Blueprint 9: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 7 clay. Each geode robot costs 2 ore and 19 obsidian.
Blueprint 10: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 6 clay. Each geode robot costs 3 ore and 16 obsidian.
Blueprint 11: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 8 clay. Each geode robot costs 3 ore and 19 obsidian.
Blueprint 12: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 19 clay. Each geode robot costs 2 ore and 12 obsidian.
Blueprint 13: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 4 ore and 17 obsidian.
Blueprint 14: Each ore robot costs 2 ore. Each clay robot costs 2 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 2 ore and 14 obsidian.
Blueprint 15: Each ore robot costs 2 ore. Each clay robot costs 2 ore. Each obsidian robot costs 2 ore and 10 clay. Each geode robot costs 2 ore and 11 obsidian.
Blueprint 16: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 13 clay. Each geode robot costs 3 ore and 11 obsidian.
Blueprint 17: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 19 clay. Each geode robot costs 3 ore and 10 obsidian.
Blueprint 18: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 2 ore and 17 obsidian.
Blueprint 19: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 11 clay. Each geode robot costs 4 ore and 12 obsidian.
Blueprint 20: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 7 clay. Each geode robot costs 3 ore and 10 obsidian.
Blueprint 21: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 13 clay. Each geode robot costs 3 ore and 7 obsidian.
Blueprint 22: Each ore robot costs 2 ore. Each clay robot costs 2 ore. Each obsidian robot costs 2 ore and 15 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 23: Each ore robot costs 3 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 3 ore and 18 obsidian.
Blueprint 24: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 18 clay. Each geode robot costs 4 ore and 8 obsidian.
Blueprint 25: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 4 ore and 15 obsidian.
Blueprint 26: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 3 ore and 9 obsidian.
Blueprint 27: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 5 clay. Each geode robot costs 3 ore and 7 obsidian.
Blueprint 28: Each ore robot costs 3 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 11 clay. Each geode robot costs 2 ore and 8 obsidian.
Blueprint 29: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 12 clay. Each geode robot costs 3 ore and 15 obsidian.
Blueprint 30: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 10 clay. Each geode robot costs 3 ore and 10 obsidian.
```

## 优化问题的数学表达

因为涉及到时间域上的状态改变（本质就是离散），所以需要在求解时间域上的每个时间点上设置一个变量。同时，每个不同种类的矿石也需要设置变量。

变量设置：

- 每个种类每个时间点矿石数量，整数
- 每个种类每个时间点机器人数量，整数
- 每个种类每个时间点是否建造，0或1

所以有：

```math

robots_{i,j}  \in N\\
isBuild_{i,j} \in \{0,1\}\\
obtains_{i,j} \in N\\
i \in \{ore, clay, obsidian, geode\}\\
j \in \{1,2,3...,23,24\}

```

优化目标为第24分钟，紫晶最多：

```math

\max obtains_{geode,24} 

```

约束：

- 矿石量等于上一周期的矿石量加上本周期的产出减去本周期的消耗。

!!! note
    costs的每一行是建造不同种机器人消耗的材料个数。

    ```math
    costs =  \begin{bmatrix}[4, 3, 2, 3] \\ [0, 0, 17, 0] \\ [0, 0, 0, 16] \\ [0, 0, 0, 0]\end{bmatrix}
    ```

    例如，第一行为建造4中不同的机器人，分别要消耗4，3，2，3个ore；第二行为建造4中不同的机器人,分别要消耗0，0，17，0个clay：

```math
obtains_{i,j} = obtains_{i,j-1}+robots_{i,j} - \sum_{k}^{} costs_{i,k} * isBulid_{k,j}
```

- 上一个周期结束，矿石足够才能在本周期建造机器人

```math
obtains_{i,j-1} \geqslant \sum_{k}^{} costs_{i,k} * isBulid_{k,j}
```

- 建造机器人，数量增加

```math
robots_{i,j} =  robots_{i,j-1}  + isBulid_{i,j-1}
```

- 一次只能建造一个机器人

```math
\sum_{k}^{} isBulid_{k,j} \leqslant 1
```

- 初值条件，没有材料且只有一台矿石机器人：

```math
isBulid_{i,1} = 0, i \in \{ore, clay, obsidian, geode\}\\
obtain_{i,1} = 0, i \in \{ clay, obsidian, geode\}\\
robots_{i,1} = 0, i \in \{ clay, obsidian, geode\}\\
obtain_{ore,1} = 1 \\
robots_{ore,1} = 1 \\
```

## JuMP求解代码

```@example solve
using JuMP
import HiGHS

inputs = """Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 17 clay. Each geode robot costs 4 ore and 20 obsidian.
Blueprint 2: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 17 clay. Each geode robot costs 3 ore and 8 obsidian.
Blueprint 3: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 7 clay. Each geode robot costs 4 ore and 13 obsidian.
Blueprint 4: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 10 clay. Each geode robot costs 3 ore and 14 obsidian.
Blueprint 5: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 17 clay. Each geode robot costs 3 ore and 16 obsidian.
Blueprint 6: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 16 clay. Each geode robot costs 2 ore and 15 obsidian.
Blueprint 7: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 15 clay. Each geode robot costs 2 ore and 15 obsidian.
Blueprint 8: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 19 clay. Each geode robot costs 2 ore and 18 obsidian.
Blueprint 9: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 7 clay. Each geode robot costs 2 ore and 19 obsidian.
Blueprint 10: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 6 clay. Each geode robot costs 3 ore and 16 obsidian.
Blueprint 11: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 8 clay. Each geode robot costs 3 ore and 19 obsidian.
Blueprint 12: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 19 clay. Each geode robot costs 2 ore and 12 obsidian.
Blueprint 13: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 4 ore and 17 obsidian.
Blueprint 14: Each ore robot costs 2 ore. Each clay robot costs 2 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 2 ore and 14 obsidian.
Blueprint 15: Each ore robot costs 2 ore. Each clay robot costs 2 ore. Each obsidian robot costs 2 ore and 10 clay. Each geode robot costs 2 ore and 11 obsidian.
Blueprint 16: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 13 clay. Each geode robot costs 3 ore and 11 obsidian.
Blueprint 17: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 19 clay. Each geode robot costs 3 ore and 10 obsidian.
Blueprint 18: Each ore robot costs 2 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 2 ore and 17 obsidian.
Blueprint 19: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 11 clay. Each geode robot costs 4 ore and 12 obsidian.
Blueprint 20: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 7 clay. Each geode robot costs 3 ore and 10 obsidian.
Blueprint 21: Each ore robot costs 3 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 13 clay. Each geode robot costs 3 ore and 7 obsidian.
Blueprint 22: Each ore robot costs 2 ore. Each clay robot costs 2 ore. Each obsidian robot costs 2 ore and 15 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 23: Each ore robot costs 3 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 3 ore and 18 obsidian.
Blueprint 24: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 18 clay. Each geode robot costs 4 ore and 8 obsidian.
Blueprint 25: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 4 ore and 15 obsidian.
Blueprint 26: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 2 ore and 20 clay. Each geode robot costs 3 ore and 9 obsidian.
Blueprint 27: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 4 ore and 5 clay. Each geode robot costs 3 ore and 7 obsidian.
Blueprint 28: Each ore robot costs 3 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 11 clay. Each geode robot costs 2 ore and 8 obsidian.
Blueprint 29: Each ore robot costs 4 ore. Each clay robot costs 4 ore. Each obsidian robot costs 2 ore and 12 clay. Each geode robot costs 3 ore and 15 obsidian.
Blueprint 30: Each ore robot costs 4 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 10 clay. Each geode robot costs 3 ore and 10 obsidian.
"""

inputs = IOBuffer(inputs)

function readData(path=inputs)
    rawData = readlines(path)
    rawData = split.(rawData, c -> c == '.' || c == ':')
    regs = [
        r"Blueprint (\d+)",
        r"costs (\d+) ore",
        r"costs (\d+) ore",
        r"costs (\d+) ore and (\d+) clay",
        r"costs (\d+) ore and (\d+) obsidian",
    ]
    d = Dict{Int,Vector{Vector{Int64}}}()
    for line in rawData |> eachindex
        c = map(x -> zeros(Int64, 4), 1:4)
        r = Vector{Int64}[]
        for i in 1:5
            m = match(regs[i], rawData[line][i]).captures
            m = map(x -> parse(Int64, x), m)
            push!(r, m)
        end
        c[1][1] = r[2][1]
        c[1][2] = r[3][1]
        c[1][3] = r[4][1]
        c[1][4] = r[5][1]
        c[2][3] = r[4][2]
        c[3][4] = r[5][2]
        d[r[1][1]] = c
    end
    return d
end


function solve_1(costs, periods)
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    names = ["ore", "clay", "obsidian", "geode"]
    # robots为每个机器人的数量，obtains为每个机器人每个周期的产出，isBuild为每个机器人每个周期是否建造
    @variable(model, robots[names, periods], Int)
    @variable(model, obtains[names, periods], Int)
    @variable(model, isBuild[names, periods], Bin)
    # 矿石量等于上一周期的矿石量加上本周期的产出减去本周期的消耗
    for (p1, p2) ∈ zip(periods[1:end-1], periods[2:end])
        @constraint(model, [ind = 1:4], obtains[names[ind], p2] == obtains[names[ind], p1] + robots[names[ind], p2] - sum(costs[ind] .* isBuild[:, p2]))
    end
    # 矿石足够才能建造机器人
    for (p1, p2) ∈ zip(periods[1:end-1], periods[2:end])
        @constraint(model, [ind = 1:4], obtains[names[ind], p1] >= sum(costs[ind] .* isBuild[:, p2]))
    end
    # 建造机器人
    for (p1, p2) ∈ zip(periods[1:end-1], periods[2:end])
        @constraint(model, [ind = 1:4], robots[names[ind], p2] == robots[names[ind], p1] + isBuild[names[ind], p1])
    end
    # 一次只能建造一个机器人
    @constraint(model, [i = periods], sum(isBuild[:, i]) <= 1)
    # 初始条件
    @constraint(model, [ind = 2:4], robots[names[ind], 1] == 0)
    @constraint(model, [ind = 1:1], robots[names[ind], 1] == 1)
    @constraint(model, [ind = 2:4], obtains[names[ind], 1] == 0)
    @constraint(model, [ind = 1:1], obtains[names[ind], 1] == 1)
    @constraint(model, [ind = 1:4], isBuild[names[ind], 1] == 0)
    # 目标函数
    @objective(model, Max, obtains["geode", lastindex(periods)])
    optimize!(model)
    return objective_value(model) |> Int
end

function solve_P1()
    d = readData()
    s = String[]
    for (i, c) in d
        res = solve_1(c, 1:24)
        push!(s,"第$(i)个结果:"*string(res))
    end
    return s
end

solve_P1()
```

## 小结

这个问题重要的特点为：

- 存在时域上的状态转移（能源系统中负荷的变化等等），以及如何用变量之间的关联体现状态转移的关系
- 包含整数与布尔变量（设备启停、满足最小需求的设备数量等等）
