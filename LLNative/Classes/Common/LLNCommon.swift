//
//  LLNCommon.swift
//  LLNative
//
//  Created by Ruris on 02/02/2021.
//  Copyright (c) 2021 ZHK. All rights reserved.
//

import WKWebViewJavascriptBridge
//import coswift
import PromiseKit

let HomeDirectory = NSHomeDirectory() + "/Library/LLNative"

protocol LLNativable {
    
    /// 模块提供的功能接口列表 (实际上是 struct 的类型)
    static var supports: [LLWebViewBridgableBase.Type] { get }
    
    /// 把接口注册到 bridge
    /// - Parameter bridge: WKWebViewJavascriptBridge 对象
    static func register(bridge: WKWebViewJavascriptBridge)
}

extension LLNativable {
    
    /// 把接口注册到 bridge
    /// - Parameter bridge: WKWebViewJavascriptBridge 对象
    static func register(bridge: WKWebViewJavascriptBridge) {
        supports.forEach { $0.register(bridge: bridge) }
    }
    
    /// 检测文件夹是否存在, 不存在则创建
    /// - Parameter components: 路径分级目录列表
    /// - Throws: 异常抛出
    static func checkAndCreateDirectories(components: [String]) throws {
        var path = HomeDirectory
        try checkAndCreateDirectories(path)
        try components.forEach { component in
            path += "/\(component)"
            try checkAndCreateDirectories(path)
        }
    }
    
    /// 检测指定路肩的文件夹是否存在, 不存在则创建
    /// - Parameter atPath: 文件夹
    /// - Throws: 异常抛出
    static func checkAndCreateDirectories(_ atPath: String) throws {
        var isDirectory: ObjCBool = false
        let isExists = FileManager.default.fileExists(atPath: atPath, isDirectory: &isDirectory)
        if isExists == false || isDirectory.boolValue == false {
           try FileManager.default.createDirectory(atPath: atPath, withIntermediateDirectories: true, attributes: [:])
        }
    }
}

public protocol LLWebViewBridgableBase {
    
    static func register(bridge: WKWebViewJavascriptBridge)
}

public protocol LLWebViewBridgable: LLWebViewBridgableBase {
    
    associatedtype Data
    
    /// 注册接口的名称
    static var name: String { get }
    
    /// 数据处理以及相应方法
    /// - Parameters:
    ///   - data:    传入数据
    ///   - promise: Promise 对象
//    static func response(data: Data, promise: Promise<Any?>)
    
    /// 数据处理以及相应方法
    /// - Parameter data: 传入数据
    static func response(data: Data) -> Promise<Any>
}

extension LLWebViewBridgable {
    
    /// 注册接口的名称 (默认为当前 结构体/类 的名称)
    public static var name: String { "\(Self.self)" }
    
    /// 注册方法
    /// - Parameter bridge: WKWebViewJavascriptBridge 对象
    public static func register(bridge: WKWebViewJavascriptBridge) {
        bridge.register(handlerName: name) { (data, callback) in
            guard let jsData = data?["data"] as? Data else {
                callback?(LLNResult.failed("参数类型错误"))
                return
            }
            firstly {
                response(data: jsData)
            }.done {
                callback?($0)
            }.catch {
                callback?(LLNResult.failed($0.localizedDescription))
            }
        }
    }
}
