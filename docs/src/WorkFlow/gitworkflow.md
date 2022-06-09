# Git工作流程

!!! tip
    Contents：Git

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

!!! note

    [Gitkraken](https://www.gitkraken.com/)为Git图形化软件。

## 开发流程简介

Github是一个非常流行的代码托管平台，上面有许许多多的前辈与“他们的牛逼代码”。为了充分与国际接轨，我们（Ai4Energy）组织也选择Github。

Ai4Energy组织可以视为一个大的代码仓库，每个人都可以向组织中贡献代码。Github基于Git，有完善且高效的多人协作的开发流程（所谓开发流程其实就是如何向Ai4Energy组织中提交代码做贡献）。下面将介绍富有Ai4Energy特色（特色就是**简单**🤣🤣🤣）的开发流程。

## 准备工作

1. Github注册账户
2. 下载[Gitkraken](https://www.gitkraken.com/)
3. 用Github账户登录Gitkraken（**重要**），然后建立Gitkraken的profile（个人形象，**不重要**）
4. 建立SSH登录验证方式（点击下面的绿色按钮，Gitkraken自动生成并且上传），如下图。

![图 3](../assets/gitworkflow-18-05.png)  

!!! tip
    如何稳定连接Github，大家各显神通吧！推荐一个免费加速器**Watt Toolkit**，在微软应用商店。

接下来是开发的逻辑介绍。

### 面向组织开发的逻辑

![图 2](../assets/gitworkflow-17-53.png)  

* Step1: Fork，Fork的意思是在自己的个人仓库建立一个一样的

![图 4](../assets/gitworkflow-18-22.png)  



![图 2](../assets/gitWorkFlow_1.gif)

拉取之后点击`Open Now`，我们就能看到操作页面。同时在左侧需要点击`Add`。GitKraken自动检测到我们Fork了一个包，它会认为你可能需要通过修改别人的代码然后上传到你自己的库里，所以它给了一个添加自己Fork的库的一个远程仓库。

中间的蓝色绿色圈是啥呢？是文件修改的记录。

![图 5](../assets/gitWorkFlow_2.gif)

* Step3: 本地对库进行内容编辑。

