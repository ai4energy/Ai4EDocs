# CVS.jl使用简介

!!! tip
    Contents：CSV文本读入

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

!!! note

    [CSV.jl](https://csv.juliadata.org/stable/)是一个快速灵活的纯 Julia包，用于处理带分隔符的文本文件。

在建立模型与模型计算的过程中，可以很好的解决数据导入问题，它能**自动辨识文本数据类型，并将数据分隔**。

它的应用场景是：使用数据之前的输入导入。

## 基本实现

文件内容：
```file
col1,col2,col3,col4,col5,col6,col7,col8
,1,1.0,1,one,2019-01-01,2019-01-01T00:00:00,true
,2,2.0,2,two,2019-01-02,2019-01-02T00:00:00,false
,3,3.0,3.14,three,2019-01-03,2019-01-03T00:00:00,true
```
使用以下代码导入文件
```julia
CSV.File("data.txt") #file为文件名，如"data.csv"、"data.txt"
```
默认情况下，CSV.File会自动检测这个文件的分隔符','，以及每列的类型。默认情况下，它将“空字段”视为missing（本示例中的整个第一列）。它还自动处理提升类型，例如第 4 列，其中前两个值为Int，但第 3 行具有Float64值 ( 3.14)。

## 自定义分隔符
文件内容：
```file
col1::col2
1::2
3::4
```
使用以下代码导入文件
```julia
CSV.File("data.txt"; delim="::")
```

## 无标题情况
文件内容：
```file
1,2,3
4,5,6
7,8,9
```
在没有标题的情况下，会默认把第一行当作标题，可以给定参数取消，使用以下代码导入文件
```julia
CSV.File("data.txt"; header=false) #取消标题
```
或者也可以手动给定标题
```julia
CSV.File("data.txt"; header=["col1", "col2", "col3"]) #手动给定标题
```

## 指定数据行数
文件内容：
```file
col1,col2,col3
metadata1,metadata2,metadata3
extra1,extra2,extra3
1,2,3
4,5,6
7,8,9
```
假如我们期望的内容是从第四行开始，可以使用以下代码
```julia
CSV.File("data.txt"; skipto=4) #从第四行开始
```
或者
```julia
CSV.File("data.txt"; datarow=4)
```

## 读取数据段
文件内容：
```file
col1,col2,col3
1,2,3
4,5,6
7,8,9
10,11,12
13,14,15
16,17,18
19,20,21
```
只需要读入某一段数据段
```julia
CSV.File("data.txt"; skipto=4，limit=1) #从第四行开始,读取1行
```
或者
```julia
CSV.File("data.txt"; skipto=4，footerskip=1) #从第四行开始,除去最后一行
```

## 转置

文件内容：
```file
col1,1,2,3
col2,4,5,6
col3,7,8,9
```
用如下代码导入
```julia
CSV.File("data.txt"; transpose=true) #从第四行开始,读取1行
```

## 数据操作

我们以一下文件输入为例：
```file
col1,col2,col3
1,2,3
4,5,6
7,8,9
10,11,12
13,14,15
16,17,18
19,20,21
```
用如下代码导入
```julia
data = CSV.File("data.txt") 
```
现在相当于把数据储存到变量data中了，data是CSV.File类型的数据，可以通过typeof函数来查看一下：
```julia
typeof(data)
```
现在调用某一列的数字：
```julia
println(data.col1) #显示第一列
println(data.col2) #显示第二列
println(data.col3) #显示第三列
```
它的结果是：
>[1, 4, 7, 10, 13, 16, 19]

>[2, 5, 8, 11, 14, 17, 20]

>[3, 6, 9, 12, 15, 18, 21]

查看一列的数据类型
```julia
typeof(data.col1)
```
它的结果是：
>Vector{Int64}
# 小结
可以发现，data是CSV.File类型，但是通过data调用的每一列数据是vector类型

说明可以把每一列当作平常的vector来处理，相关的方法都能够匹配。

比如：
```
sum(data.col1)
a = data.col1 .* data.col2
```

!!! tip
    推荐一个好用的数据展示包DataFrames，它一般与CSV.jl结合起来使用

    在julia的包模式下安装：

    ```julia
    add DataFrames
    ```

    将data漂亮的输出，只需要：

    ```julia
    using DataFrames
    display(DataFrame(data))
    ```
