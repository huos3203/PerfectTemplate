//
//  Package.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 4/20/16.
//	Copyright (C) 2016 PerfectlySoft, Inc.
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
/*
 SPM:软件包管理器编译项目
    https://github.com/PerfectlySoft/PerfectDocs/blob/master/guide.zh_CN/buildingWithSPM.md
 在Perfect Template项目模板中，您可以找到两个很重要的文件：
 
 其中 Sources 目录包含了所有Perfect项目的Swift源程序文件
 还有一个名为“Package.swift”的SPM文件管理清单，包含了整个项目对其它库函数的依存关系
 所有的SPM项目至少要包括一个 Sources 目录和一个 Package.swift 文件。而项目模板中目前只有一个依存关系：Perfect-HTTPServer服务器项目
  name:// 当前项目的目标名称，可执行文件的名字也会按照这个名称进行编译。
  dependencies[]:依存关系清单。该内容说明了您的应用程序需要的所有子项目列表，在这个数组中其中每一个条目都包含了一个“.Package”软件包，及其来源URL和版本。
 
 SPM提供以下命令用于编译项目，并且清理旧的编译结果：
 swift build :命令能够自动下载需要的依存文件，如果全部依存关系都已经成功获取到本地计算机，则开始项目编译工作
 .build/debug/PerfectTemplate 启动服务器
 
 swift build -c release :编译一个用于发行的版本, 默认情况下编译出的是一个用于调试的版本
 .build/release/:运行后可发行版本的可执行程序被放在了

 swift build --clean  : 删除.build目录，然后重新开始一个全新的编译
 swift build --clean=dist  ：.build目录和Packages目录都会被删除。能够重新下载所有依存关系以获得最新版本对项目的支持。
 
 swift package generate-xcodeproj ：在同一目录下生成xcode项目，该项目允许编译和调试
 最好不要在这个Xcode项目上直接编辑或增加文件。如果需要更多的依存关系，或者需要下载更新的版本，您需要重新生成这个Xcode项目。因此，在之前您做的任何修改都会被Xcode覆盖。
 */
import PackageDescription

let package = Package(
	name: "PerfectTemplate", // 当前项目的目标名称，可执行文件的名字也会按照这个名称进行编译。
	targets: [],
	dependencies: [
		.Package(url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
        .Package(url: "https://github.com/PerfectlySoft/Perfect-CURL.git", majorVersion: 2, minor: 0),
		.Package(url: "https://github.com/iamjono/JSONConfig.git", majorVersion: 0, minor: 1),
		.Package(url: "https://github.com/PerfectlySoft/Perfect-libcurl.git", majorVersion: 2, minor: 0)
    ]
)
