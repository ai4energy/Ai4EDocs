# 文档（docs）编写方法

!!! tip
    Contents：文档编写方法介绍

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

## 文档结构

在包的根目录下，都有一个`/docs`文件夹，里面就是文档的所有内容。

`/docs`结构如下：

```powershell
docs/
├── src/
│   ├── index.md
│   ├── components/   
│   │   ├──MTKMPC.md
│   │   └──...
│   └── MyApp.jl
├── build/
│   ├── index.html
│   └── ...
├── .gitignore
├── Project.toml
└── make.jl
```

**/src**里包含了文档的内容，即很多markdown文件。对应关系如下：

![图 1](../assets/DocStructure-16-48-02.png)  

**.gitignore**里的内容是在git提交时忽略的内容。例如`/build`的内容就会全部忽略。

**Project.toml**是julia的环境文件，说明了docs环境中需要用到的包。

**make.jl**是生成的html页面的主文件。运行make.jl，则生成/build文件夹，在默认浏览器中打开`/build/index.html`就能看到文档，和网页版的一模一样。本质上也是一样的，Github部署也是部署的它。这是本地版，github提交时，会自动运行make.jl生成然后部署。所以`/build`不用上传。

## 编写方法

新添加文档只需要两步操作：

1. 创建新的文档(.md文件)
2. 在make.jl中链接文档路径

make.jl中的page链接了全部文档。
![图 2](../assets/DocStructure-16-59-55.png)  

图中的"Modeling"是子目录，在`/src`里可看到对应文件夹。

如果没有在make.jl中链接，就不会在html中显示。**没链接等于没写🤣🤣🤣**。

!!! note

    某些库会设计自动链接，如果自动链接了就不需要手动添加了。
