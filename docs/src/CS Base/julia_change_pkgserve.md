# Julia换源(更换国内镜像站)

!!! tip
    Contents：JuliaPkg

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

1. 打开julia的安装路径，找到文件夹 julia-1.x.x(如1.6.1) 如图
![在这里插入图片描述](https://img-blog.csdnimg.cn/303b28feddd74bbb97ea3ab07dd9183c.png)
2. 进入该文件夹找到etc
![在这里插入图片描述](https://img-blog.csdnimg.cn/5728ccd73bd14b27a1848b4d5291048f.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16)

3. 进入etc 再进入一个文件夹，有一个startup.jl
![在这里插入图片描述](https://img-blog.csdnimg.cn/5288a19b5c8445b78cddc8bd9bc6448d.png)
**这个startup.jl就很方便了，在启动julia的时候，会首先自动运行里面的内容**

所以，打开它，在里面输入一行
```python
ENV["JULIA_PKG_SERVER"]="https://mirrors.bfsu.edu.cn/julia/static"
```
就像这样
![在这里插入图片描述](https://img-blog.csdnimg.cn/72bcd148a3aa42d2926c57eb9af3a0ca.png)
保存就完事了。

ENV是julia的全局环境变量，能够直接在repl中修改环境变量，但不是永久的。所以放在startup.jl里。这样等价于永久改变了，因为每次启动都会repl自动执行它。

在repl中输入ENV如下：
![在这里插入图片描述](https://img-blog.csdnimg.cn/b2ff78c2cd40404bbc4ab667ae11c241.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16)

**妙啊！**

还有一些其它的比如LOAD_PATH 和DEPOT_PATH等等，这些都是环境变量。更多可以看[中文文档](https://docs.juliacn.com/latest/manual/environment-variables/)
![在这里插入图片描述](https://img-blog.csdnimg.cn/2c1e899b55884b6eb0b0afb7df788d5d.png?x-oss-process=image/watermark,type_ZHJvaWRzYW5zZmFsbGJhY2s,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16)

PS：这是北外的镜像站，目前julia的镜像站中最好用的一个，基本没有报错！
