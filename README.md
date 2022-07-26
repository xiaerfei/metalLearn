# metalLearn

## Metal Document
[Metal Document](https://developer.apple.com/documentation/metal?language=objc)

## Metal 学习资料参考

[Metal框架详细解析（三十一） —— 在视图中混合Metal和OpenGL渲染（一）](https://www.jianshu.com/p/3288a18173ed)

[Metal入门资料001-Metal framework介绍](https://www.jianshu.com/p/2517ad248935)

[Metal框架详细解析（四十二） —— Metal编程指南之图形渲染：渲染命令编码器之Part 2（七）](https://www.jianshu.com/p/72447db4bff8)
https://github.com/zhangfangtaozft/Metal-Tutorial

[AR 学习之路整理：我看过的那些 Metal 与数学书籍](https://juejin.cn/post/7030422353788010504)


[LearnMetal](https://github.com/xiaerfei/LearnMetal)

[Metal入门教程（一）图片绘制](https://www.jianshu.com/p/cddf73c6c05e)

[MetalByTutorials](https://github.com/dreamerwings/MetalByTutorials)

## Metal Debug 相关

[Capturing GPU Command Data Programmatically](https://developer.apple.com/documentation/metal/debugging_tools/capturing_gpu_command_data_programmatically?language=objc)
[Viewing Your GPU Workload with the Metal Debugger](https://developer.apple.com/documentation/metal/debugging_tools/viewing_your_gpu_workload_with_the_metal_debugger?language=objc)

## 出现莫名其妙的 crash
堆栈如下：

```
thread #127, queue = 'xxxQueue', stop reason = EXC_BAD_ACCESS (code=1, address=0x0)
    frame #0: 0x000000010e979307 libMTLCapture.dylib`___lldb_unnamed_symbol1930$$libMTLCapture.dylib + 145
    frame #1: 0x000000010e8f57de libMTLCapture.dylib`___lldb_unnamed_symbol468$$libMTLCapture.dylib + 48
    frame #2: 0x000000010e8f654b libMTLCapture.dylib`___lldb_unnamed_symbol474$$libMTLCapture.dylib + 176
    frame #3: 0x000000010e9c1bc4 libMTLCapture.dylib`___lldb_unnamed_symbol3310$$libMTLCapture.dylib + 255
    frame #4: 0x00007ff80afb0542 CoreVideo`CVMTLTextureCreate + 256
    frame #5: 0x00007ff80afb03df CoreVideo`CVPixelBufferMetalTextureBacking::createTexture(CVImageBuffer*) + 563
```

一些参考资料：

[GLKView.display() method sometimes causes crash. EXC_BAD_ACCESS](https://stackoverflow.com/questions/46722455/glkview-display-method-sometimes-causes-crash-exc-bad-access?rq=1)
[iOS 11 beta 4 presentRenderbuffer crash](https://stackoverflow.com/questions/45319215/ios-11-beta-4-presentrenderbuffer-crash/45375569#45375569)

## Core Image Document

[Core Image Document](https://developer.apple.com/documentation/coreimage?language=objc)