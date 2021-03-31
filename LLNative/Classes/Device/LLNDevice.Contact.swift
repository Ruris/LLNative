//
//  LLDevice.Contact.swift
//  LLNative
//
//  Created by ZHK on 2021/2/3.
//  
//

import PromiseKit

extension LLNDevice {
    
    /// 写通讯录
    struct addPhoneContact: LLWebViewBridgable {
        
        typealias Data = [String : String]
        
        static func response(data: [String : String], promise: Promise<Any?>) {
            
        }
        
        static func response(data: [String : String]) -> Promise<Any> {
            return Promise<Any> {
                $0.fulfill(LLNResult.success())
            }
        }
    }
}
