//
//  LLNStorage.swift
//  LLNative
//
//  Created by Ruris on 02/02/2021.
//  Copyright (c) 2021 ZHK. All rights reserved.
//

import PromiseKit
import SQLite

public struct LLNStorage: LLNativable {
    
    static var supports: [LLWebViewBridgableBase.Type] {[
        setStorage.self,
        removeStorage.self,
        getStorage.self,
        clearStorage.self
    ]}

    static let storageDirectoryName: String = "Storage"
    
    static let storageName: String = "LLNative.sqlite"
    
    /// 检测模块完整的路径是否存在可用
    /// - Parameter promise: Promise 对象
    /// - Returns: 是否可用
    static func checkFullDirectory(resolver: Resolver<Any>) -> Bool {
        do {
            try checkAndCreateDirectories(components: [storageDirectoryName])
            return true
        } catch {
            resolver.fulfill(LLNResult.failed("操作失败: Storage 文件路径错误"))
            return false
        }
    }
    
    /// 移除缓存文件
    /// - Throws:  抛出异常
    /// - Returns: 操作是否成功
    static func removeCache() throws {
        let path = HomeDirectory + "/" + storageDirectoryName + "/" + storageName
        if FileManager.default.fileExists(atPath: path) {
            try FileManager.default.removeItem(atPath: path)
        }
    }
    
    struct MainStorage {
        
        static let table = Table("main")
        
        static let key = Expression<String>("key")
        
        static let content = Expression<Data>("content")
        
        static func database() throws -> Connection {
            let connect = try Connection(HomeDirectory + "/" + storageDirectoryName + "/" + storageName)
            /// Table 不存在就创建
            try connect.run(table.create(ifNotExists: true) { t in
                t.column(key, unique: true)
                t.column(content)
            })
            return connect
        }
        
        
        /// 替换或插入值
        /// - Parameters:
        ///   - key:     key
        ///   - content: 内容
        /// - Throws:    异常信息
        /// - Returns:   操作结果影响行数
        static func replace(key: String, content: Any) throws -> Int {
            let database = try self.database()
            var row: Int = 0
            try database.transaction {
                let data = try JSONSerialization.data(withJSONObject: [key : content], options: .fragmentsAllowed)
                /// 如果值已经存在, 做覆盖操作, 否则做插入操作
                if try database.scalar(table.filter(self.key == key).count) > 0 {
                    let alice = table.filter(MainStorage.key == key)
                    row = try database.run(alice.update(
                        self.content <- data
                    ))
                } else {
                    row = Int(try database.run(table.insert(
                        self.key <- key,
                        self.content <- data
                    )))
                }
            }
            return row
        }
        
        /// 移除指定 key 的值
        /// - Parameter key: key
        /// - Throws: 异常信息
        static func remove(key: String) throws {
            let database = try self.database()
            try database.transaction {
                let ailce = table.filter(self.key == key)
                try database.run(ailce.delete())
            }
        }
        
        /// 读取数据
        /// - Parameter key: key
        /// - Throws: 异常信息
        /// - Returns: 读取信息
        static func read(key: String) throws -> Any? {
            let database = try self.database()
            let result = try database.prepare(table.filter(self.key == key))
            guard let data = Array(result).first?[content],
                  let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else {
                return nil
            }
            return object[key]
        }
    }
}

public extension LLNStorage {
    
    /// 写缓存
    struct setStorage: LLWebViewBridgable {

        public typealias Data = [String : Any]
        
        public static func response(data: [String : Any], promise: Promise<Any?>) {
//            DispatchQueue.main.async {
//                guard LLNStorage.checkFullDirectory(promise: promise) else { return }
//                guard let key = data["key"] as? String,
//                      let value = data["value"] else {
//                    promise.fulfill(value: ["success": false])
//                    return
//                }
//                do {
//                    if try MainStorage.replace(key: key, content: value) > 0 {
//                        promise.fulfill(value: LLNResult.success())
//                    } else {
//                        promise.fulfill(value: LLNResult.failed("操作失败"))
//                    }
//                } catch {
//                    print(error)
//                    promise.fulfill(value: LLNResult.failed(error.localizedDescription))
//                }
//            }
        }
        
        public static func response(data: [String : Any]) -> Promise<Any> {
            return Promise<Any> { to in
                DispatchQueue.main.async {
                    guard LLNStorage.checkFullDirectory(resolver: to) else { return }
                    guard let key = data["key"] as? String,
                          let value = data["value"] else {
                        to.fulfill(["success": false])
                        return
                    }
                    do {
                        if try MainStorage.replace(key: key, content: value) > 0 {
                            to.fulfill(LLNResult.success())
                        } else {
                            to.fulfill(LLNResult.failed("操作失败"))
                        }
                    } catch {
                        to.fulfill(LLNResult.failed(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    /// 删除缓存
    struct removeStorage: LLWebViewBridgable {
  
        public typealias Data = [String : String]
        
        public static func response(data: [String : String], promise: Promise<Any?>) {
//            DispatchQueue.main.async {
//                guard LLNStorage.checkFullDirectory(promise: promise) else { return }
//                guard let key = data["key"] else {
//                    promise.fulfill(value: LLNResult.failed("key 的值不能为空"))
//                    return
//                }
//                do {
//                    try MainStorage.remove(key: key)
//                    promise.fulfill(value: LLNResult.success())
//                } catch {
//                    promise.fulfill(value: LLNResult.failed(error.localizedDescription))
//                }
//            }
        }
        
        public static func response(data: [String : String]) -> Promise<Any> {
            return Promise<Any> { to in
                DispatchQueue.main.async {
                    guard LLNStorage.checkFullDirectory(resolver: to) else { return }
                    guard let key = data["key"] else {
                        to.fulfill(LLNResult.failed("key 的值不能为空"))
                        return
                    }
                    do {
                        try MainStorage.remove(key: key)
                        to.fulfill(LLNResult.success())
                    } catch {
                        to.fulfill(LLNResult.failed(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    /// 读取缓存
    struct getStorage: LLWebViewBridgable {

        public typealias Data = [String : String]
        
        public static func response(data: [String : String], promise: Promise<Any?>) {
//            DispatchQueue.main.async {
//                guard LLNStorage.checkFullDirectory(promise: promise) else { return }
//                guard let key = data["key"] else {
//                    promise.fulfill(value: LLNResult.failed("key 的值不能为空"))
//                    return
//                }
//                do {
//                    if let result = try MainStorage.read(key: key) {
//                        promise.fulfill(value: LLNResult.success([
//                            "data" : result
//                        ]))
//                    } else {
//                        promise.fulfill(value: LLNResult.success())
//                    }
//                } catch {
//                    promise.fulfill(value: LLNResult.failed(error.localizedDescription))
//                }
//            }
        }
        
        public static func response(data: [String : String]) -> Promise<Any> {
            return Promise<Any> { to in
                DispatchQueue.main.async {
                    guard LLNStorage.checkFullDirectory(resolver: to) else { return }
                    guard let key = data["key"] else {
                        to.fulfill(LLNResult.failed("key 的值不能为空"))
                        return
                    }
                    do {
                        if let result = try MainStorage.read(key: key) {
                            to.fulfill(LLNResult.success([
                                "data" : result
                            ]))
                        } else {
                            to.fulfill(LLNResult.success())
                        }
                    } catch {
                        to.fulfill(LLNResult.failed(error.localizedDescription))
                    }
                }
            }
        }
    }
    
    /// 清除缓存
    struct clearStorage: LLWebViewBridgable {
        
        public typealias Data = Any?
        
        public static func response(data: Any?, promise: Promise<Any?>) {
//            DispatchQueue.main.async {
//                do {
//                    try LLNStorage.removeCache()
//                    promise.fulfill(value: LLNResult.success())
//                } catch {
//                    promise.fulfill(value: LLNResult.failed(error.localizedDescription))
//                }
//            }
        }
        
        public static func response(data: Any?) -> Promise<Any> {
            Promise<Any> { to in
                DispatchQueue.main.async {
                    do {
                        try LLNStorage.removeCache()
                        to.fulfill( LLNResult.success())
                    } catch {
                        to.fulfill(LLNResult.failed(error.localizedDescription))
                    }
                }
            }
        }
    }
}
