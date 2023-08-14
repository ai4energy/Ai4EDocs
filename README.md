# Ai4EDocs

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ai4energy.github.io/Ai4EDocs/)

这是Ai4Energy的开放文档，介绍相关理论、理念与设计方法等等。

目的是为了结合实例，让大家更好的理解Ai4Energy的工作。同时作为组内开发者可以快速查阅的参考文档。

欢迎分享文档，成为贡献者。

[文档链接，供学习参考](https://ai4energy.github.io/Ai4EDocs/)

本地编译markdown文件到html请使用如下命令：
```shell
julia --project=docs/ -e 'using Pkg; Pkg.update(); Pkg.instantiate()'
julia --project=docs/ docs/make.jl
``` 

PS:`./src`中包含了文档中的一些代码与相关资源
