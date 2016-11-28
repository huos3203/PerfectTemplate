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
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// Settings path vars.
#if os(Linux)
let FileRoot = "/home/ubuntu/settings/"
#else
let FileRoot = ""
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



//页面句柄
routes.add(method: .get, uri: "/", handler: {
    request, response in
    response.appendBody(string: "<html><head><meta http-equiv='content-type' content='text/html;charset=utf-8'><title>你好，世界！</title></head><body>你好，世界！</body></html>")
    response.completed()
}
)

// 将路由注册到服务器
server.addRoutes(routes)

// 监听8181端口
server.serverPort = 8181   //UInt16(httpPort)

// 设置文档根目录。
// 这个操作是可选的，如果没有静态页面内容则可以忽略这一步。
// 设置文档根目录后，对于其他所有未经过滤器或已注册路由来说的其他路径“/**”，都会指向这个根目录下的文件。
server.documentRoot = "./webroot"

// 逐个检查命令行参数和服务器配置
// 如果用命令行执行带 --help 参数的服务器可执行程序，就可以看到所有可以选择的参数。
// 如果调用时在命令行参数，而且该参数在配置文件中也有说明，则命令行参数的值会取代配置文件。
configureServer(server)

do {
    // 启动HTTP服务器
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("网络异常： \(err) \(msg)")
}
