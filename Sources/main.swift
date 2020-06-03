//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
/*
 Perfect提供一系列代表请求和响应的对象组件，并允许在服务器上增加管理句柄用于产生页面内容。
 所有对象都是在服务器对象创建后开始工作。服务器对象会被执行配置，随后会根据配置绑定并监听特定端口。一旦出现连接，服务器会读取请求数据，请求数据读取完成后，服务器会将request object请求对象传递给请求过滤器。
 过滤器可能会根据需要修改查询请求。服务器会使用请求的URI路径检索routing请求／响应路由以获取处理该请求的具体句柄。如果找到了合适的处理句柄，服务器会传递给句柄对应的response object响应对象。当句柄反馈响应完成时，响应对象会被传递给响应过滤器。这些过滤器会根据需要修改最终输出的数据内容。最后响应结果数据会被推送给客户端浏览器，而客户端到服务器的连接或者被关闭、或者被拒绝维持HTTP持久连接、或者为后续请求和响应维持HTTP活动连接。
 
 
 HTTP请求/响应路由是用于决定在当前请求下，哪一个句柄去接收和响应。句柄可以是一个函数、过程或者方法，只要能够接收特定类型的请求并做出反应即可。路由主要依据请求的方法“HTTP request method”和请求内容包括的路径信息来决定的。
 路由：就是“HTTP method”方法、路径和句柄的组合
 路由变量：每个变量组件是通过一个块{ }声明的。在程序块中是变量名称。每个变量名称都可以使用出了括号}之外的任何字符。变量名有点像单功能通配符一样，这样就可以匹配任何符合变量模式的路径。匹配该模式的URL能够通过HTTPRequest.urlVariables字典查询变量值。该字典是[String:String]类型。URI变量是用于处理动态请求的好方法。比如，一个包含用户id的URL可以用该方法实现相关请求的用户管理。
 
 =====HTTPRequest请求对象==========
 当处理一个HTTP请求时，所有客户端的互动操作都是通过HTTPRequest请求对象和HTTPResponse响应对象实现的。
 
 HTTPRequest对象包含了客户端浏览器发过来的全部数据，包括请求消息头、查询参数、POST表单数据以及其它所有相关信息，比如客户IP地址和URL变量。
 
 HTTPRequest对象将采用application/x-www-form-urlencoded编码格式对客户请求进行解析解码。而如果请求中采用multipart/form-data“多段”编码方式，则HTTP请求可以把各种未处理的原始格式表单传输过来。当处理“多段”表单数据时，HTTPRequest对象会为请求上传的文件自动创建临时目录并执行解码。这些文件会在请求过程中一直保持直到请求处理完毕，随后自动被删除。
 
 以上涉及到的各种属性和函数都是HTTPRequest请求协议的部分内容。
 
 */
import Foundation
import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import cURL
//import PerfectRequestLogger

// Settings path vars.
#if os(Linux)
let FileRoot = "/home/ubuntu/settings/"
#else
let FileRoot = ""
//RequestLogFile.location = "/var/log/myLog.log"  //默认的服务器日志文件路径为/var/log/perfectLog.log
#endif

// base route for the API
let apiRoute = "/api/v1/"
// config for the server port
let httpPort = 8181
// fetch the token from the ApplicationConfiguration.json file
let apiToken = getToken()

// 创建HTTP服务器
let server = HTTPServer()

// 注册自定义路由和页面句柄
var routes = Routes()

routes.add(method: .get, uris: ["\(apiRoute)current/","/api/v1/current/{country}/{city}"], handler:{
    request, response in
    
    // set country and city from URI variables
    let country = request.urlVariables["country"] ?? "Canada"
    let city = request.urlVariables["city"] ?? "Newmarket"
    
    // Setting the response content type explicitly to application/json
    response.setHeader(.contentType, value: "application/json")
    // Setting the body response to the JSON list generated
    response.appendBody(string: Weather.getCurrent("\(country)/\(city)"))
    //Signalling that the request is completed
    response.completed()
}
)

routes.add(method: .get, uris: ["\(apiRoute)forecast","/api/v1/forecast/{country}/{city}"], handler:{
    request, response in
    
    // set country and city from URI variables
    let country = request.urlVariables["country"] ?? "Canada"
    let city = request.urlVariables["city"] ?? "Newmarket"

    // Setting the response content type explicitly to application/json
    response.setHeader(.contentType, value: "application/json")
    // Setting the body response to the JSON list generated
    response.appendBody(string: Weather.getForecast("\(country)/\(city)"))
    // Signalling that the request is completed
    response.completed()
}
)

//me
routes.add(method: .post, uris: ["HostMonitor/client/log/addLog"]){
    (request,response) in
    
    //解析请求数据
    let dic = request.params()[0]  //[(String,String)]:元组数组，解析拼接完整数据
    let strr = "\(dic.0)\(dic.1)"
    do {
        //String转json再转字典
        let decoded = try strr.jsonDecode() as? [String:Any]
        print(decoded!)
    } catch {
        print("Decode error: \(error)")
    }
    
    //设置响应数据
    // Setting the response content type explicitly to application/json
    response.setHeader(.contentType, value: "application/json")
    // Setting the body response to the JSON list generated
    response.appendBody(string: strr)   //此处是原数据返回
    // Signalling that the request is completed
    response.completed()
}

//页面句柄
routes.add(method: .get, uri: "/", handler: {
    request, response in
    response.appendBody(string: "<html><head><meta http-equiv='content-type' content='text/html;charset=utf-8'><title>你好，世界！</title></head><body>你好，世界！</body></html>")
    response.completed()
}
)

// 将路由注册到服务器
server.addRoutes(routes)

// 初始化一个日志记录器
//let myLogger = RequestLogger()        
// 增加过滤器
// 首先增加高优先级的过滤器
//server.setRequestFilters([(myLogger, .high)])
// 最后增加低优先级的过滤器
//server.setResponseFilters([(myLogger, .low)])

// 监听8181端口
server.serverPort = 8181   //UInt16(httpPort)

// 设置文档根目录。
// 这个操作是可选的，如果没有静态页面内容则可以忽略这一步。
// 设置文档根目录后，对于其他所有未经过滤器或已注册路由来说的其他路径“/**”，都会指向这个根目录下的文件。
server.documentRoot = "./webroot"

// 逐个检查命令行参数和服务器配置
// 如果用命令行执行带 --help 参数的服务器可执行程序，就可以看到所有可以选择的参数。
// 如果调用时在命令行参数，而且该参数在配置文件中也有说明，则命令行参数的值会取代配置文件。
//configureServer(server)

//启动服务奔溃文Cannot delete nova network - network address already in use (no active instance)
//解决办法：打开 Activity Monitor 搜索PerfectTemplate，强制退出该进程，重新run即可
do {
    // 启动HTTP服务器
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("网络异常： \(err) \(msg)")
}
