//
//  LLNDevice.Screen.swift
//  LLNative
//
//  Created by ZHK on 2021/2/3.
//  
//

import PromiseKit
import UIKit

extension LLNDevice {
    
    /// 设置屏幕亮度
    struct setScreenBrightness: LLWebViewBridgable {
        
        typealias Data = [String : CGFloat]
        
        static func response(data: [String : CGFloat], promise: Promise<Any?>) {
//            guard let brightness = data["value"] else {
//                promise.fulfill(value: LLNResult.failed("value 只能为数字类型, 且不能为空"))
//                return
//            }
//            UIScreen.main.brightness = brightness
//            promise.fulfill(value: LLNResult.success())
        }
        
        static func response(data: [String : CGFloat]) -> Promise<Any> {
            return Promise<Any> {
                guard let brightness = data["value"] else {
                    $0.fulfill(LLNResult.failed("value 只能为数字类型, 且不能为空"))
                    return
                }
                UIScreen.main.brightness = brightness
                $0.fulfill(LLNResult.success())
            }
        }
    }
    
    /// 读取屏幕亮度
    struct getScreenBrightness: LLWebViewBridgable {

        typealias Data = Any?
        
        static func response(data: Any?, promise: Promise<Any?>) {
//            promise.fulfill(value: LLNResult.success([
//                "value" : UIScreen.main.brightness
//            ]))
        }
        
        static func response(data: Any?) -> Promise<Any> {
            return Promise<Any> {
                $0.fulfill(LLNResult.success([
                    "value" : UIScreen.main.brightness
                ]))
            }
        }
    }
    
    /// 设置屏幕是否常亮
    struct setKeepScreenOn: LLWebViewBridgable {

        typealias Data = [String : Bool]
        
        static func response(data: [String : Bool], promise: Promise<Any?>) {
//            guard let keep = data["keepScreenOn"] else {
//                promise.fulfill(value: LLNResult.failed("keepScreenOn 只能为 Boolean 类型且不能为空"))
//                return
//            }
//            UIApplication.shared.isIdleTimerDisabled = keep
//            promise.fulfill(value: LLNResult.success())
        }
        
        static func response(data: [String : Bool]) -> Promise<Any> {
            return Promise<Any> {
                guard let keep = data["keepScreenOn"] else {
                    $0.fulfill(LLNResult.failed("keepScreenOn 只能为 Boolean 类型且不能为空"))
                    return
                }
                UIApplication.shared.isIdleTimerDisabled = keep
                $0.fulfill(LLNResult.success())
            }
        }
    }
    
    
}
