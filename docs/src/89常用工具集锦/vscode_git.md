# VScode中使用Git

!!! tip
    Contents：VScode,Git

    Contributor: YJY

    Email:522432938@qq.com

    如有错误，请批评指正。

本篇介绍在vscode中使用git的方法(以码云为例，githup是同样的操作)

## 初始化仓库

如图所示，等价于git init

![在这里插入图片描述](https://img-blog.csdnimg.cn/02c975fb229d43ba9d5496ca38e2f250.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_11,color_FFFFFF,t_70,g_se,x_16)

## 生成公钥

```powershell
ssh-keygen -t rsa -C "xxxxxx@qq.com"
```

一路回车，有y/n则y。在红框中的文件夹中去找公钥文件。

![在这里插入图片描述](https://img-blog.csdnimg.cn/f970f5adca28474f9292bec5ef0a377b.png)

**id_rsa是私钥，id_rsa.pub是公钥**

![在这里插入图片描述](https://img-blog.csdnimg.cn/6df63877a7584b01b129eb5d8c3d86aa.png)

使用公钥私钥匹配就可以免去登录验证

## 配置公钥

githup与gitee是同样的方式，将id_rsa.pub的乱码复制到下图的地方。

![在这里插入图片描述](https://img-blog.csdnimg.cn/fa0867d301ee415fa4713a2196e22373.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16)

## VScode中添加远程仓库

首先复制地址，选ssh

![在这里插入图片描述](https://img-blog.csdnimg.cn/e879311fa58e44a8b4873d88bcc487ed.png)

添加远程仓库

![在这里插入图片描述](https://img-blog.csdnimg.cn/8fb6995cd9774423a2c2a1c87bc826ee.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16)

在框中输入复制过来的ssh地址，点击从URL添加远程仓库

![在这里插入图片描述](https://img-blog.csdnimg.cn/c7376bf75bcf40bdbcd705aafd0d9993.png)

输入仓库名字，指的是在vscode的仓库名字，随意填
![在这里插入图片描述](https://img-blog.csdnimg.cn/f645de8f06614fafa75c0528bca0cdfe.png)

## 提交与推送

先暂存更改

![在这里插入图片描述](https://img-blog.csdnimg.cn/139ddf3f7ef24059affae9f673a5cf02.png)

在...中可以进行一系列操作，本质上就是有一个图形化的git操作界面，

![在这里插入图片描述](https://img-blog.csdnimg.cn/18ab8c5ec0dd4a898a1dac91be564da5.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBAamFrZTQ4NA==,size_20,color_FFFFFF,t_70,g_se,x_16)

一般选择拉取自，或推送到

![在这里插入图片描述](https://img-blog.csdnimg.cn/62b0e3debec0446aba41e43444ab3836.png)
