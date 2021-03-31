//
//  LLNResult.swift
//  LLNative
//
//  Created by ZHK on 2021/2/4.
//  
//

import Foundation


struct LLNResult {
    
    /// 操作成功
    /// - Returns: 返回结果
//    static func success() -> Any { ["success" : true] }
    
    /// 执行成功并返回结果
    /// - Parameter data: 执行结果数据
    /// - Returns: 返回结果
    static func success(_ data: [String : Any]? = nil) -> Any {
        var result: [String : Any] = ["success" : true]
        if let data = data {
            result.merge(data, uniquingKeysWith: { first, _ in return first })
        }
        return result
    }
    
    /// 操作/执行 失败
    /// - Parameter message: 错误信息
    /// - Returns: 返回结果
    static func failed(_ message: String) -> Any { ["success" : false, "message" : message] }
}
