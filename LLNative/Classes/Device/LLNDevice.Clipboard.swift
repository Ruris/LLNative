//
//  LLNDevice.Clipboard.swift
//  LLNative
//
//  Created by ZHK on 2021/2/3.
//  
//

import PromiseKit

extension LLNDevice {
    
    /// 设置剪切板数据
    struct setClipboardData: LLWebViewBridgable {

        typealias Data = [String : String]
        
        static func response(data: [String : String], promise: Promise<Any?>) {
//            guard let string = data["data"] else {
//                promise.fulfill(value: LLNResult.failed("内容只能为 stirng 类型, 且不能为空"))
//                return
//            }
//            UIPasteboard.general.string = string
//            promise.fulfill(value:  LLNResult.success())
        }
        
        static func response(data: [String : String]) -> Promise<Any> {
            return Promise<Any> {
                guard let string = data["data"] else {
                    $0.fulfill(LLNResult.failed("内容只能为 stirng 类型, 且不能为空"))
                    return
                }
                UIPasteboard.general.string = string
                $0.fulfill(LLNResult.success())
            }
        }
    }
    
    /// 读取剪切板文本
    struct getClipboardData: LLWebViewBridgable {

        typealias Data = Any?
        
        static func response(data: Any?, promise: Promise<Any?>) {
//            promise.fulfill(value: LLNResult.success([
//                "data" : UIPasteboard.general.string ?? ""
//            ]))
        }
        
        static func response(data: Any?) -> Promise<Any> {
            return Promise<Any> {
                $0.fulfill(LLNResult.success([
                    "data" : UIPasteboard.general.string ?? ""
                ]))
            }
        }
    }
}
