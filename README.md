# 简介

WHU 2024 编译原理大作业

## How to build

打开项目
``` bash
mkdir build
cd build
cmake ..
make
```
如果构建成功，你会在 build 文件夹下找到 lexer 和 parser 可执行文件，用于对 Cminusf 文件进行词法和语法分析。

## 记录

yylval 是一个全局变量，用于在词法分析器(由 Flex 生成)和语法分析器(由 Bison 生成)之间传递词法单元的语义值。它的类型是 YYSTYPE，而 YYSTYPE 是由用户定义的一个宏，通常是一个联合体。yylval 就可以认为是 yacc 中 %union 定义的结构体(union 结构)。

## References

- [USTC 编译原理和技术 2023](https://ustc-compiler-principles.github.io/2023/)
