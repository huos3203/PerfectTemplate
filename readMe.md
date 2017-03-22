## 新建一个Web应用

### 储存目录
新建一个文件夹用于保存项目文件：

```
mkdir MyAwesomeProject
cd MyAwesomeProject
```
把这个项目目录转化为git repo（代码资源文件夹）：

```
git init
touch README.md
git add README.md
git commit -m "Initial commit"
```

另外还推荐您参考[Swift的一个.gitignore文件模板（来源于Gitignore.io）](https://www.gitignore.io/api/swift)内容增加一个`.gitignore`文件（用于通知git资源库在本文件中列出的文件和文件夹都是本地临时文件，不需要上传到共享的git资源库）。

### 创建`Package.swift`文件 ：SPM（Swift软件包管理器）
这个文件是SPM（Swift软件包管理器）编译项目时必须要用到的文件。

``` swift
import PackageDescription

let package = Package(
name: "MyAwesomeProject",
dependencies: [
.Package(
url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
majorVersion: 2, minor: 0
)
]
)
```
### 创建`Sources`目录，用来保存源程序
接下来请创建一个名为`Sources`的文件夹用于保存源程序，然后在这个源程序文件夹下面创建一个`main.swift`文件，内容如下：

```
mkdir Sources
echo 'print("您好！")' >> Sources/main.swift
```

## 部署
现在项目就已经准备好，可以通过以下两个命令编译和运行：

```
swift build
.build/debug/MyAwesomeProject
```

*⚠️注意⚠️* 如果编译过程中有问题，那么请尝试用特定的一个工具集来编译，形式如下：
`/Library/Developer/Toolchains/swift-DEVELOPMENT-SNAPSHOT-2016-08-18-a.xctoolchain/usr/bin/swift build`

编译完成后运行，应该看到：

```
你好！！！
```

## Xcode中开发并调试web应用

Swift软件包管理器（SPM）能够创建一个Xcode项目，并且能够运行PerfectTemplate模板服务器，还能为您的项目提供完全的源代码编辑和调试。
在您的终端命令行内输入：

```
swift package generate-xcodeproj
```

然后打开产生的文件“PerfectTemplate.xcodeproj”，在”Library Search Paths“检索项目软件库中增加（不单单是编译目标）：

```
$(PROJECT_DIR) - Recursive
```

确定选择了可执行的目标文件，并选择在“我的Mac”运行。同样注意要选择正确的Swift toolchain工具集。现在您就可以在Xcode中运行调试您的服务器了！


### 测试：在Xcode中开发如下代码：
现在已经确认Swift工具包已经准备好了。下一步就可以实现一个Perfect的HTTPServer服务器啦！打开`Sources/main.swift`文件，把内容替换为以下程序：

``` swift
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// 创建HTTP服务器
let server = HTTPServer()

// 注册您自己的路由和请求／响应句柄
var routes = Routes()
routes.add(method: .get, uri: "/", handler: {
request, response in
response.setHeader(.contentType, value: "text/html")
response.appendBody(string: "<html><title>你好，世界！</title><body>你好，世界！</body></html>")
response.completed()
}
)

// 将路由注册到服务器上
server.addRoutes(routes)

// 监听8181端口
server.serverPort = 8181

do {
// 启动HTTP服务器
try server.start()
} catch PerfectError.networkError(let err, let msg) {
print("网络出现错误：\(err) \(msg)")
}
```

然后再次编译运行当前项目：

```
swift build
.build/debug/MyAwesomeProject
```

此时服务器就运行了，随时等待网络连接！🎉 从浏览器打开[http://localhost:8181/](http://127.0.0.1:8181/)就可以看到欢迎信息。在终端控制台上用组合键“control-c”可以随时停止服务器。

