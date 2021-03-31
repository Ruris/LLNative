//
//  LLNDevice.Vibrate.swift
//  LLNative
//
//  Created by ZHK on 2021/2/3.
//  
//

import PromiseKit
import AudioToolbox

extension LLNDevice {
    
    struct vibrateShort: LLWebViewBridgable {

        typealias Data = [String : String]
        
        static func response(data: [String : String], promise: Promise<Any?>) {
//            guard let type = data["type"], let style = ShortStyle(rawValue: type)?.feedback else {
//                promise.fulfill(value: LLNResult.failed("未提供的震动类型"))
//                return
//            }
//            let generator = UIImpactFeedbackGenerator(style: style)
//            generator.prepare()
//            generator.impactOccurred()
//            promise.fulfill(value: LLNResult.success())
        }
        
        static func response(data: [String : String]) -> Promise<Any> {
            return Promise<Any> {
                guard let type = data["type"], let style = ShortStyle(rawValue: type)?.feedback else {
                    $0.fulfill(LLNResult.failed("未提供的震动类型"))
                    return
                }
                let generator = UIImpactFeedbackGenerator(style: style)
                generator.prepare()
                generator.impactOccurred()
                $0.fulfill(LLNResult.success())
            }
        }
        
        enum ShortStyle: String {
            
            case light  = "light"
            case medium = "medium"
            case heavy  = "heavy"
            
            var feedback: UIImpactFeedbackGenerator.FeedbackStyle {
                switch self {
                case .light: return .light
                case .medium: return .medium
                case .heavy: return .heavy
                }
            }
        }
    }
    
    /// 长震动
    struct vibrateLong: LLWebViewBridgable {
        
        typealias Data = Any?

        static func response(data: Any?, promise: Promise<Any?>) {
//            let generator = UINotificationFeedbackGenerator()
//            generator.prepare()
//            generator.notificationOccurred(.error)
//            promise.fulfill(value: LLNResult.success())
        }
        
        static func response(data: Any?) -> Promise<Any> {
            return Promise<Any> {
                let generator = UINotificationFeedbackGenerator()
                generator.prepare()
                generator.notificationOccurred(.error)
                $0.fulfill(LLNResult.success())
            }
        }
    }
}
