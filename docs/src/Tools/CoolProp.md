# CoolProp使用介绍

!!! tip
    Contents：CoolProp

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

!!! note

    [CoolProp](http://www.coolprop.org/index.html)为开源物性包。
    [Unitful.jl](https://painterqubits.github.io/Unitful.jl/stable/)为计算单位的包


## CoolProp是什么

这是一个**开源的**调用物性包，通过几行代码就可以很容易的调用流体的物性，对于需要进行工程计算的小伙伴很有帮助！因为使用这个包之后，就可以可以省去大量查表的麻烦！

## Python使用CoolProp

### 1.CoolProp安装
打开cmd命令行，输入
```
pip install CoolProp
```
即可安装完成
![图1](https://img-blog.csdnimg.cn/0d44fcdf415e4ecfbffb7ca7284333a1.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2pha2U0ODQ=,size_16,color_FFFFFF,t_70#pic_center)
### 2. 使用示例
```python
import CoolProp.CoolProp as CP

a = CP.PropsSI('H','P',1.0E6,'T',500,'Water')

#H代表输出的需要查找的参数，H为焓
#P为压强，T为温度，第二个和第四个参数就是状态
#这个例子就是查询1MPa气压与500K的温度下，水蒸气的焓（如果是液体的话就是液体性质）

print(a)

```

查询时，输入任意两个参数，就能够查询第三个参数。
具体的属性为可以看下表

|状态量 | 参数名称 | 单位|
|--------|-----|-----|
|比焓  | H | J/kg|
|比熵  | S | J/mol/K|
|压强  | P | Pa|
|温度  | T | K|
|密度  | D |kg/m^3|

----
更多参数，可以查看[官网文档](http://www.coolprop.org/coolprop/HighLevelAPI.html#table-of-string-inputs-to-propssi-function)。

## Julia使用Coolprop

在2022的2月，Coolprop完成了Julia包的更新。可以直接在Julia中调用，而不需要通过python了！

```julia
using Pkg
Pkg.add("CoolProp")

using CoolProp
PropsSI("T", "P", 101325.0, "Q", 0.0, "Water")
373.1242958476844
```

在Julia中支持单位处理包——[Unitful](https://painterqubits.github.io/Unitful.jl/stable/)

```julia
using CoolProp
using Unitful: °C, Pa

PropsSI("P", "T", 100°C, "Q", 0.0, "Water")
101417.99665788244 Pa
```
