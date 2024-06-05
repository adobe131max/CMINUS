# 简介

[WHU 2024 编译原理大作业](https://github.com/adobe131max/CMINUS)

## 1 实验要求

### 1.1 识别词法错误

1. 识别八进制数与十六进制数
2. 识别指数形式的浮点数
3. 识别//和/**/注释

注意错误捕获：09不是合法的八进制数，但是会被认为是两个数0、9

### 1.2 识别语法错误

### 输入

文本文件输入

### 输出

若存在词法或语法错误则输出错误信息，格式：`Error type [错误类型] at Line [行号]: [说明文字].`

可能存在多个错误，但每行只有一个错误，需要输出所有错误，每行一个

若没有错误则输出语法树

## 2 How to build

### 2.1 Environment

``` bash
sudo apt install build-essential

# LLVM、Clang
sudo apt install clang llvm

# CMAKE
sudo apt install cmake
cmake --version # 3.25.5

# flex bison
sudo apt-get install flex bison

flex --version  # 2.6.4
bison --version # 3.7.6
```

### 2.2 Run

``` bash
mkdir build
cd build
cmake ..
make
```

## 3 How to run

构建成功后运行测试用例:

``` bash
./parser ../test/comment.c
./parser ../test/example1.c
./parser ../test/example2.c
./parser ../test/example3.c
./parser ../test/float.c
./parser ../test/int.c
```

## 4 记录

yylval 是一个全局变量，用于在词法分析器(由 Flex 生成)和语法分析器(由 Bison 生成)之间传递词法单元的语义值。它的类型是 YYSTYPE，而 YYSTYPE 是由用户定义的一个宏，通常是一个联合体。yylval 就可以认为是 yacc 中 %union 定义的结构体(union 结构)。

## 5 References

1. [USTC 编译原理和技术 2023](https://ustc-compiler-principles.github.io/2023/)
2. [miniob](https://github.com/oceanbase/miniob)
