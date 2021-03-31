//
//  LLNDevice.Battery.swift
//  LLNative
//
//  Created by ZHK on 2021/2/3.
//  
//

import PromiseKit

extension LLNDevice {
    
    /// 获取电量信息
    struct getBatteryInfo: LLWebViewBridgable {

        typealias Data = Any?
        
        static func response(data: Any?, promise: Promise<Any?>) {
            DispatchQueue.main.async {
                /// 判断 isBatteryMonitoringEnabled, 如果未开启, 则开启
//                let original = UIDevice.current.isBatteryMonitoringEnabled
//                if original == false {
//                    UIDevice.current.isBatteryMonitoringEnabled = true
//                }
//                promise.fulfill(value: LLNResult.success([
//                    "level" : "\(Int(UIDevice.current.batteryLevel * 100))",
//                    "isCharging" : UIDevice.current.batteryState == .charging
//                ]))
//                /// 恢复原始值
//                UIDevice.current.isBatteryMonitoringEnabled = original
            }
        }
        
        static func response(data: Any?) -> Promise<Any> {
            return Promise<Any> {
                /// 判断 isBatteryMonitoringEnabled, 如果未开启, 则开启
                let original = UIDevice.current.isBatteryMonitoringEnabled
                if original == false {
                    UIDevice.current.isBatteryMonitoringEnabled = true
                }
                $0.fulfill(LLNResult.success([
                    "level" : "\(Int(UIDevice.current.batteryLevel * 100))",
                    "isCharging" : UIDevice.current.batteryState == .charging
                ]))
                /// 恢复原始值
                UIDevice.current.isBatteryMonitoringEnabled = original
            }
        }
    }
}
