# 命令行界面（CLI）和环境变量

## 启动命令提示符
很多同学计算机方面一上来接触的就是Windows系统，很容易认为计算机就是拿鼠标点点点。即使学了编程入门的一些课程（如C语言、Fortran语言等），也只是在集成开发环境（IDE，Integrated Development Environment）上点点鼠标，难以理解系统是如何工作的。那我们就非常简要的介绍一下命令行界面（Command Line Interface，CLI）和图形用户界面（Graphical User Interface，GUI）。

我们刚接触计算机那会儿，微软的操作系统还是DOS系统，就是命令行界面。就是要做什么事都通过打一条命令告诉电脑。后来微软进一步开发了图形用户界面系统（Windows），此时看起来就很友好，并且很多事情可以通过鼠标点击来完成。实际上，Windows系统保留了对命令行界面的兼容，可以在开始菜单找到命令提示符（本质就是cmd.exe）。我们打开命令提示行程序，可以看到它长这样：

![图 1](../assets/csbase/cmd.png)

我们可以在这个界面里头输入dir回车，就会显示当前目录下的内容列表。我们可以用cd切换目录。我们可以用copy进行文件复制。具体这些都是DOS的基本命令，可以查看相应的手册获得更多的认识。在DOS时代，我们会区分内部命令和外部命令。内部命令常驻内存，而外部命令是一条单独的可执行文件。这样说来可能有点抽象。我们可以以一个例子来说明。我们平时使用的浏览器如Edge, 它本质是一个命令msedge.exe，这是一个文件提供的，在我的系统里是"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"。这可以认为是一个外部命令。而之前提到的dir、cd等可以认为是内部命令，就是有命令提示符自己就提供了的。那我们的外部写的程序实际上都可以通过命令行启动。如上面提到的msedge.exe，我们在命令提示符下输入msedge.exe回车。系统会提示找不到'msedge.exe'不是内部或外部命令。这是因为系统找不到msedge.exe这个文件。那我们可以给全路径，输入C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe 这个来定位，这里因为路径中有空格，我们再使用""把它包起来，输入"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"回车就启动了Edge浏览器。

我们的桌面上或者开始菜单里头有很多的快捷方式，供我们点它的时候启动对应的程序。实际上我们在这些快捷方式上右键，选择属性，在“目标”那里就可以看到具体的启动命令。

## PowerShell

新时代，Windows也在向Linux学习。它现在有了新的强大命令行工具，PowerShell。并且微软现在赋予了它强大的命令行下管理能力。很多修改电脑的设置都可以在PowerShell下使用命令来完成。比如说在Windows下安装WSL（Windows Subsystem for Linux）就可以用管理员打开PowerShell，通过wsl --install命令来完成。

另外，PowerShell可以 先以管理员执行Set-ExecutionPolicy RemoteSigned，再在配置文件中设置Set-PSReadLineOption -EditMode emacs来开启Emacs键绑定，从而可以使用ctrl+e等命令进行光标快速移动。这一点仅仅是可以提高输入效率，可以先忽略。

## Linux下的shell
在linux操作系统下，类似的也有命令行模式，而且是更常用的模式。尽管很多ubuntu用户首先接触到的是其gui界面，但是事实上cli更为常用一些。大多数的系统默认的是bash。操作系统内部管理文件、设备的是kernel。我们用户通过shell来跟kernel打交道。而这个bash就是shell的一种。跟Windows下的命令提示符类似，我们在shell的提示符下可以输入不同的命令来完成一些工作。比如ls是列出当前文件夹下的内容。cp是复制文件的命令。cd是改变目录的命令等等。具体这些内容可以参考linux入门书看一看，或者看一看linux cheatsheet。

## 环境变量

我们上面在命令提示符下输入msedge.exe时提示不是内部或者外部命令，而输入全路径（目录）的时候就没有问题。实际上，我们输入命令的时候，系统会在一些目录里去寻找是否有对应的命令。如果有就执行它，如果没有就冒出上面的提示。而如果输入全路径，则在给定的路径（目录）里去寻找对应的命令。这里说到的“一些目录”就是有系统的一个环境变量（PATH）所记录的目录。Windows下的PATH环境变量是以";"分割的若干个值，每个值是一个目录。Windows下的PATH环境变量可以通过"此电脑"->"属性"->"高级系统设置"->"环境变量"打开，选中Path，再点"编辑"就可以修改Path环境变量了。如果我们新建一条，把msedge.exe所在的目录加进去，然后确认退出。那再在命令提示符下就可以直接以msedge.exe启动浏览器了，而不需要再输入全路径。

Linux下的PATH环境变量是以":"分割的若干个值，每个值就是一个目录。如果使用的是bash，可以以export PATH=/new/directory:\$PATH命令临时修改PATH环境变量。也可以放在~/.bashrc里使得每次登录Linux的时候对PATH的修改都是有效。

linux下最重要的几个环境变量是PATH、INCLUDE_PATH 和 LD_LIBRARY_PATH。PATH决定命令到哪里去找（目录间有优先级哦，越靠近前面优先级越高），INCLUDE_PATH 决定编译程序的时候系统到哪里去找那些被包含的头文件，LD_LIBRARY_PATH 决定系统到哪里去找加载的共享链接库。Windows下类似。

关于环境变量可以参考[这里](./env_variable)获得更多的信息。