# 动态链接库(DLL)的生成与调用实操

!!! tip
    Contents：Julia调用Dll

    Contributor: 杨月宝

    Email:812987139@qq.com

    如有错误，请批评指正。

## 问题的产生与解决过程概述
我们试图使用Julia来调用热流问题数值计算课程的代码。这些代码是在2003年重新整理的Fortran代码。

第一步：我们生成了Fortran动态链接库（dll），并尝试使用C语言调用该dll。

第二步：接着，我们尝试使用C++来调用该dll，并试图使用Julia来调用它。

第三步：我们配置了VS2013，生成了64位的dll，并使用64位的Julia来调用该dll。

## 工作环境

- Julia版本：Julia 1.7.0-beta2
- 使用的Fortran编译器：Intel.Visual.Fortran.Composer.XE.2013-SP1，这是在VS2013中的Fortran编译器。
- 开发环境：VSCode（Visual Studio Code）

## 实践过程
<!-- 
1.使用Fortran生成dll

2.使用VS2013开发人员命令提示查看dll位数

3.使用C++调用dll

4.使用Julia调用dll -->

### 使用Fortran生成dll

新建一个Fortran动态链接库项目

![1](../assets/新建Fortran动态链接库项目.png)

在Resource Files中添加一个f90文件，并输入如下内容

```Fortran
SUBROUTINE OUTPUT(a, b, sum)
    !MS$ ATTRIBUTES DLLEXPORT::OUTPUT
    !声明本函数为输出函数
    IMPLICIT NONE
    INTEGER a, b, sum
    sum = a + b
END SUBROUTINE OUTPUT
```

这段Fortran代码定义了一个名为"OUTPUT"的子程序（SUBROUTINE），它接受三个参数：a、b和sum。代码的解释如下：

- `!MS$ ATTRIBUTES DLLEXPORT::OUTPUT`：这是一个特定于编译器的注释（directive），用于指示将该函数声明为输出函数（export function），以便其他程序或语言可以调用它。

- `IMPLICIT NONE`：这是一个编译器指令，用于禁用隐式类型声明。它要求所有变量都必须显式地声明其类型。

- `INTEGER a, b, sum`：这是变量声明的部分，它指定了a、b和sum都是整数类型的变量。

- `sum = a + b`：这一行将a和b的值相加，并将结果赋给变量sum。这行代码的作用是计算a和b的和，并将结果存储在sum变量中。

因此，这段代码定义了一个名为"OUTPUT"的子程序，它接受两个整数参数a和b，并计算它们的和，并将结果存储在sum变量中。通过`!MS$ ATTRIBUTES DLLEXPORT::OUTPUT`的声明，该子程序可以被导出为一个可供其他程序或语言调用的函数。

Fortran通过下句表示dll输出函数

```Fortran
!MS$ ATTRIBUTES DLLEXPORT::OUTPUT
```

配置编译器属性，选择64位的编译器来生成64位的dll

![1](../assets/配置管理器.png)
![1](../assets/配置活动解决方案平台.png)
![1](../assets/选择64位平台.png)
![1](../assets/配置完毕.png)

编译文件后生成项目，就可以在.\x64\Debug文件夹下找到生成的dll文件

### 使用VS2013开发人员命令提示查看dll位数

VS2013的工具路径在安装目录下

```txt
.\Microsoft Visual Studio 12.0\Common7\Tools\Shortcuts
```

选择VS2013开发人员命令提示，可以使用dumpbit命令获得dll信息

```txt
dumpbin /headers 路径
```

读取上段生成dll，部分结果：

![1](../assets/查看dll位数.png)

以下是更多的参考：

在Windows下，可以使用以下方法来查看DLL文件的位数：

1. 打开文件资源管理器（Windows资源管理器）。
2. 导航到包含所需DLL文件的目录。
3. 右键单击DLL文件，然后选择"属性"。
4. 在属性对话框中，切换到"详细信息"选项卡。
5. 在"属性"部分中，查找"位数"或"架构"相关的信息。通常会显示为"32位"或"64位"。
6. 查看该信息以确定DLL文件的位数。

另外，您还可以使用命令行来查看DLL文件的位数：

1. 打开命令提示符（CMD）或PowerShell。
2. 使用`cd`命令导航到包含DLL文件的目录。
3. 运行以下命令来查看DLL文件的位数：
   ```
   dumpbin /headers <DLL文件名>
   ```
   将 `<DLL文件名>` 替换为实际的DLL文件名。
4. 在输出中查找 "x86" 表示32位，"x64" 表示64位。

通过这些方法，您可以方便地查看DLL文件的位数，以确定其兼容性和与其他程序的配合情况。

### 使用C++调用dll

这里采用动态调用方法，根据网上找到的资料和Fortran程序设计课程讲义，我重新整理了C++代码。

这部分代码把那几个冒号去了就是C的代码（就是说实质是c语言代码）。

调试或启动exe文件前，请将dll文件放于EXE文件所在的Debug文件夹内。我的是在E:\Programs\program VS2013\HF_first\ForDllCreat\x64\Debug

我的解决方案名和Fortran生成dll的方案同名了，请不要混淆。

```C++
#include <stdio.h>
#include <windows.h> // 调用 WINDOWS API 函数所需的头文件

typedef void(*Func)(int *, int *, int *);//定义一个函数指针类型，这个指针类型与被调用函数的输入类型要一一对应

int main()
{
 int a = 1, b = 2, sum;

 //宏定义函数指针类型
 HMODULE hLibrary = ::LoadLibrary(L"ForDLLCreat.dll"); //加载动态库文件，dll名前不加L会报错
 if (hLibrary == NULL)
 {
  printf("No DLL file exist!\n");
  return -1;
 }
 Func dllPro = (Func)::GetProcAddress(hLibrary, "OUTPUT");
 //获得 Fortran 导出函数的地址
 if (dllPro == NULL)
 {
  printf("Can not fine the address of the function!\n");
  return -2;
 }
 dllPro(&a, &b, &sum);
 printf("%d + %d = %d\n", a, b, sum);
 FreeLibrary(hLibrary); //卸载动态库文件
 return 0;
}
```

这段代码是一个使用C语言调用动态链接库（DLL）中函数的示例代码，其解释如下：

- `#include <stdio.h>`：包含了标准输入输出函数的头文件。
- `#include <windows.h>`：包含了调用Windows API函数所需的头文件。
- `typedef void(*Func)(int *, int *, int *);`：定义了一个函数指针类型`Func`，该指针类型与被调用函数的输入类型一一对应，即接受三个`int`型指针作为参数且没有返回值。
- `int main()`：主函数的入口。
- `int a = 1, b = 2, sum;`：声明整型变量`a`、`b`和`sum`，并分别初始化`a`和`b`的值。
- `HMODULE hLibrary = ::LoadLibrary(L"ForDLLCreat.dll");`：加载名为"ForDLLCreat.dll"的动态库文件。`LoadLibrary`函数返回一个句柄（`HMODULE`），用于后续操作。
- `if (hLibrary == NULL)`：检查动态库文件是否加载成功，如果返回的句柄为空，则说明加载失败，打印错误信息并退出程序。
- `Func dllPro = (Func)::GetProcAddress(hLibrary, "OUTPUT");`：通过`GetProcAddress`函数获取动态库中名为"OUTPUT"的函数的地址，并将其赋给函数指针变量`dllPro`。
- `if (dllPro == NULL)`：检查函数地址是否获取成功，如果返回的地址为空，则说明获取失败，打印错误信息并退出程序。
- `dllPro(&a, &b, &sum);`：通过函数指针调用函数，将`a`、`b`和`sum`的地址作为参数传递给被调用函数。
- `printf("%d + %d = %d\n", a, b, sum);`：打印计算结果。
- `FreeLibrary(hLibrary);`：卸载动态库文件，释放资源。
- `return 0;`：程序正常结束返回值。

总体而言，该代码加载了一个名为"ForDLLCreat.dll"的动态库文件，并通过函数指针调用了其中的"OUTPUT"函数，将`a`和`b`的值作为输入，计算它们的和并将结果存储在`sum`中，最后打印出计算结果。

### 使用Julia调用dll

Julia官方文档地址：[Calling C and Fortran Code](https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/)

在开始前，请务必确认Julia的位数与所用dll位数相同，否则会报错dll不是一个可用的Win32应用。

ForDllCreate.dll与ForDllCreate.64.dll内部包含和前文相同的函数，区别是前者是32位，后者是64位。
在64位REPL上载入32位dll会报错。

```
ERROR: LoadError: could not load library "e:\yyb\HF_first\ForDllCreat.dll"
%1 is not a valid Win32 application.
Stacktrace:
 [1] top-level scope
   @ e:\yyb\HF_first\test.jl:15
in expression starting at e:\yyb\HF_first\test.jl:15
```
如果你想在Julia中使用`ccall`函数来调用DLL中的函数，你可以按照以下步骤进行操作：

1. 假设你有一个名为"example.dll"的DLL文件，其中包含一个名为"add_numbers"的函数，用于将两个整数相加。

2. 在Julia中，使用`ccall`函数来加载和调用DLL中的函数。以下是一个示例：

```julia
# 调用ccall函数加载DLL文件
const lib = "example.dll"
const handle = ccall((:LoadLibraryA, lib), Ptr{Cvoid}, (Cstring,), lib)

# 定义要调用的函数的签名
const add_numbers = ccall((:add_numbers, lib), Cint, (Cint, Cint))

# 调用函数并获取结果
result = add_numbers(5, 3)
println(result)  # 输出 8

# 卸载DLL
ccall((:FreeLibrary, lib), Cint, (Ptr{Cvoid},), handle)
```

在上面的示例中，我们首先使用`ccall`函数加载名为"example.dll"的DLL文件。通过指定函数名称和DLL文件的句柄，我们可以获取要调用的函数的指针。

然后，我们定义了一个名为`add_numbers`的Julia函数，并使用`ccall`函数将其与DLL中的`add_numbers`函数关联起来。

最后，我们调用`add_numbers`函数，并将参数5和3传递给它。返回的结果存储在`result`变量中，并打印到控制台。

最后，我们使用`ccall`函数卸载DLL文件，以释放资源。

请注意，示例中的函数签名和参数类型可能需要根据DLL中的实际函数进行调整。确保使用正确的参数类型和返回类型。

使用`ccall`函数直接调用DLL函数时，需要小心处理内存管理和类型匹配，确保传递正确的参数和返回类型。

以下是我们针对自己生成的dll的调用的例子：

```julia
#error
a = [1]
b = [2]
c = [0]
ccall((:OUTPUT, ".\\ForDllCreat.dll"), Cvoid, (Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), pointer_(a), pointer(b), pointer(c))
print(c)

#work
a = [1]
b = [2]
c = [0]
ccall((:OUTPUT, ".\\ForDllCreat64.dll"), Cvoid, (Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), pointer_from_objref(a) + 0x40, pointer_from_objref(b) + 0x40, pointer_from_objref(c) + 0x40)
print(c)
```

解释：
- 在第一段代码中，使用了名为`ForDllCreat.dll`的 DLL 文件来执行函数调用。函数名称为`OUTPUT`，该函数接受三个整型指针作为参数，并将结果存储在指针`c`指向的位置。通过`ccall`函数来调用 DLL 中的函数，并传递指针参数。最后打印出指针`c`所指向的值。
- 在第二段代码中，使用了名为`ForDllCreat64.dll`的 DLL 文件来执行函数调用。其他部分与第一段代码类似，但是在传递指针参数时，对每个指针都进行了偏移，即将指针从对象引用中提取后加上`0x40`的偏移量。最后同样打印出指针`c`所指向的值。

请注意，这段代码中的部分函数和对象引用是特定于编程语言的，并且需要正确配置和具备相应的 DLL 文件才能正常运行。

Julia可用通过ccall函数调用C和Fortran编译的dll文件，输入格式为

```txt
  ccall((function_name, library), returntype, (argtype1, ...), argvalue1, ...)
  ccall(function_name, returntype, (argtype1, ...), argvalue1, ...)  
  ccall(function_pointer, returntype, (argtype1, ...), argvalue1, ...)
```

这里通过第一种调用方法来调用我们编译的ForDllCreat64.dll，

function_name是调用的函数名称。引用时即可以用:OUTPUT表示，也可以用"OUTPUT"表示。

C语言与Fortran输出dll时函数名不变，C++输出函数有命名粉碎，自制dll尽量采用C输出，一定要确定被调用函数的名字才能成功引用。[可看此视频](https://www.bilibili.com/video/BV1dW411G7hL)

library是被调用dll的路径，用字符串表示。调用C标准库中的函数时，library可以略去。

```julia
#调用C标准库函数，不用写引用
t = ccall(:clock, Int32, ())
```

returntype是被调函数的返回类型。Fortran的subroutine返回类型是空，即void，在Julia中表示为Cvoid。数据类型对应的表格可以参考下文表格，也可以查看官方文档。

(argtype1, ...)是一个tuple，与被调函数的输入变量类型要一一对应，类似在C++中定义一个与被调函数输入变量类型一一对应的函数原型。

argvalue1, ...  这部分是输入变量，类型要与(argtype1, ...)一一对应，并与被调函数对应。输入变量不用tuple表示。

不同语言间调用dll，最重要的就是数据类型的匹配。下表是[从Julia官方文档中复制的数据类型对应表](https://docs.juliacn.com/latest/manual/calling-c-and-fortran-code/)。更多细节请查看官方文档。

![图 1](../assets/Creat_and_Call_dll-18_05_04.png)  

### 更多julia的信息
**Julia中指针的用法** （以下内容暂时不用那么细，先忽略，需用到时查julia的官方文档。）

数组类型基本上通过指针传递。

Julia中，指针有两种，Ptr{T}与Ref{T}

Ptr表示的是从变量获得的地址，这类地址是否被销毁不由Julia管理，一般是“危险的”（unsafe)。

Ref是由Julia分配的地址，这类地址的任何更改都由Julia进行，因此是“安全的”。

但是Ref能用的方法似乎不多，目前为止我没学明白这个怎么用。

Julia中获得变量地址的函数有pointer和pointer_form_objref，他们获得的指针都是Ptr型的
pointer获得的地址被标明了数据类型，并且总比pointer_form_objref的返回值多出一个数据类型的bit数；pointer_form_objref获得的地址是无数据类型的。
在官方文档中，pointer_from_objref是对C提供接口的方法([C_Interface](https://docs.julialang.org/en/v1/base/c/))

```julia
a="大家好"
b=pointer(a)
c=pointer_from_objref(a)
println(b)
println(c)
println(b-c)

println("a[1]的字节数是",sizeof(typeof(a[1])))#UInt8的字节数是1,但是Char类型的字节数是4
```
由地址获得值的方法是unsafe_pointer_to_objref，这个函数也是官方文档中C接口的函数。

对一个Ptr指针，用pointer获得的指针要减去一个数据类型的bit数才能获得指针内的值。

```julia
a=[1.23]

b=pointer(a)
c=pointer_from_objref(a)

d=unsafe_pointer_to_objref(b-0x40)
e=unsafe_pointer_to_objref(c)

println("d=",d)
println("e=",e)
```