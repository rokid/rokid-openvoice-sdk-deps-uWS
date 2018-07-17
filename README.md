# uWebSockets修改版

以开源uWebSockets为基础，做了一些小修改以规避实际使用中遇到的问题。

## 编译依赖

* cmake 3.2以上
* openssl
* [cmake-modules](https://github.com/Rokid/aife-cmake-modules.git)

## 编译命令

```
./config \
    --build-dir=${build目录} \  # cmake生成的makefiles目录, 编译生成的二进制文件也将在这里
    --cmake-modules=${cmake_modules目录} \  # 指定cmake-modules所在目录
    --openssl=${openssl目录}  # 指定openssl头文件及动态库所在目录。如果在/usr下能找到openssl，则不需要指定此选项
cd ${build目录}
make
make install
```

## 交叉编译

```
./config \
    --build-dir=${build目录} \
    --cmake-modules=${cmake_modules目录} \
    --toolchain=${工具链目录} \
    --cross-prefix=${工具链命令前缀} \   # 如arm-openwrt-linux-gnueabi-
    --find-root-path=${rootpath}
cd ${build目录}
make
make install
    
* 注: 交叉编译时，不能在/usr下寻找目标平台的依赖动态链接库及头文件。
     因此使用--find-root-path指定路径，在${rootpath}/usr下查找openssl库及头文件
```

#### 其它config选项

```
--prefix=${prefixPath}  指定安装路径
--debug  使用调试模式编译
```