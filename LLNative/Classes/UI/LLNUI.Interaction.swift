//
//  LLNUI.Interaction.swift
//  LLNative
//
//  Created by ZHK on 2021/2/3.
//  
//

import PromiseKit
import QMUIKit

extension LLNUI {
    
    /// 显示 Toast
    struct showToast: LLWebViewBridgable {
        
        typealias Data = [String : Any]
        
        static func response(data: [String : Any], promise: Promise<Any?>) {
//            guard let keyWindow = UIApplication.findCurrendKeyWindow() else {
//                promise.fulfill(value: LLNResult.failed("未知错误"))
//                return
//            }
//            guard let title = data["title"] as? String else {
//                promise.fulfill(value: LLNResult.failed("title 只能是 string 类型, 且不为空"))
//                return
//            }
//            /// QMUITips 初始化
//            let tips = QMUITips.createTips(to: keyWindow)
//            let iconName = data["icon"] as? String ?? "none"
//            /// duration 不传的话就默认不消失
//            let delay = data["duration"] as? TimeInterval ?? 999999
//            /// 根据 Icon 展示不同样式类型
//            switch Icon(rawValue: iconName) {
//            case .success:
//                tips.showSucceed(title, hideAfterDelay: delay)
//            case .error:
//                tips.showError(title, hideAfterDelay: delay)
//            case .loading:
//                tips.showLoading(title, hideAfterDelay: delay)
//            default:
//                tips.show(withText: title, hideAfterDelay: delay)
//            }
//            promise.fulfill(value: LLNResult.success())
        }
        
        static func response(data: [String : Any]) -> Promise<Any> {
            return Promise<Any> {
                guard let keyWindow = UIApplication.findCurrendKeyWindow() else {
                    $0.fulfill(LLNResult.failed("未知错误"))
                    return
                }
                guard let title = data["title"] as? String else {
                    $0.fulfill(LLNResult.failed("title 只能是 string 类型, 且不为空"))
                    return
                }
                /// QMUITips 初始化
                let tips = QMUITips.createTips(to: keyWindow)
                let iconName = data["icon"] as? String ?? "none"
                /// duration 不传的话就默认不消失
                let delay = data["duration"] as? TimeInterval ?? 999999
                /// 根据 Icon 展示不同样式类型
                switch Icon(rawValue: iconName) {
                case .success:
                    tips.showSucceed(title, hideAfterDelay: delay)
                case .error:
                    tips.showError(title, hideAfterDelay: delay)
                case .loading:
                    tips.showLoading(title, hideAfterDelay: delay)
                default:
                    tips.show(withText: title, hideAfterDelay: delay)
                }
                $0.fulfill(LLNResult.success())
            }
        }
        
        enum Icon: String {
            case success    = "success"
            case error      = "error"
            case loading    = "loading"
            case none       = "none"
        }
    }
    
    /// 隐藏所有 Loading 包括 Toast
    struct hideToast: LLWebViewBridgable {
        
        typealias Data = Any?
        
        static func response(data: Data, promise: Promise<Any?>) {
//            QMUITips.hideAllTips()
//            promise.fulfill(value: LLNResult.success())
        }
        
        static func response(data: Any?) -> Promise<Any> {
            return Promise<Any> {
                QMUITips.hideAllTips()
                $0.fulfill(LLNResult.success())
            }
        }
    }
    
    /// 显示 Loading
    struct showLoading: LLWebViewBridgable {
        
        typealias Data = [String : Any]
        
        static func response(data: [String : Any], promise: Promise<Any?>) {
//            guard let keyWindow = UIApplication.findCurrendKeyWindow() else {
//                promise.fulfill(value: LLNResult.failed("未知错误"))
//                return
//            }
//            guard let title = data["title"] as? String else {
//                promise.fulfill(value: LLNResult.failed("title 只能是 string 类型, 且不为空"))
//                return
//            }
////            let mask = data["mask"] as? Bool ?? false
//            QMUITips.showLoading(title, in: keyWindow)
//            promise.fulfill(value: LLNResult.success())
        }
        
        static func response(data: [String : Any]) -> Promise<Any> {
            return Promise<Any> {
                guard let keyWindow = UIApplication.findCurrendKeyWindow() else {
                    $0.fulfill(LLNResult.failed("未知错误"))
                    return
                }
                guard let title = data["title"] as? String else {
                    $0.fulfill(LLNResult.failed("title 只能是 string 类型, 且不为空"))
                    return
                }
    //            let mask = data["mask"] as? Bool ?? false
                QMUITips.showLoading(title, in: keyWindow)
                $0.fulfill(LLNResult.success())
            }
        }
    }
    
    /// 隐藏所有 Loading 包括 Toast
    struct hideLoading: LLWebViewBridgable {
        
        typealias Data = Any?
        
        static func response(data: Any?, promise: Promise<Any?>) {
//            QMUITips.hideAllTips()
//            promise.fulfill(value: LLNResult.success())
        }
        
        static func response(data: Any?) -> Promise<Any> {
            return Promise<Any> {
                QMUITips.hideAllTips()
                $0.fulfill(LLNResult.success())
            }
        }
    }
    
    /// 显示弹窗
    struct showModal: LLWebViewBridgable {
        
        typealias Data = [String : Any]
        
        static func response(data: [String : Any], promise: Promise<Any?>) {
//           let alertController =  QMUIAlertController(title: data["title"] as? String,
//                                                      message: data["content"] as? String,
//                                                      preferredStyle: .alert)
//            
//            /// showCancel 为 true 并且 cancelText 不为空时候显示 "取消" 按钮
//            if let cancelText = data["cancelText"] as? String {
//                let cancelAction = QMUIAlertAction(title: cancelText, style: .cancel) { (_, _) in
//                    promise.fulfill(value: LLNResult.success([
//                        "confirm" : false,
//                        "cancel" : true
//                    ]))
//                }
//                cancelAction.titleColorHexText = data["cancelColor"] as? String
//                alertController.addAction(cancelAction)
//            }
//            
//            /// 确定按钮
//            if let confirmText = data["confirmText"] as? String {
//                let confirmAction = QMUIAlertAction(title: confirmText, style: .default) { (_, _) in
//                    promise.fulfill(value: LLNResult.success([
//                        "confirm" : true,
//                        "cancel" : false
//                    ]))
//                }
//                confirmAction.titleColorHexText = data["confirmColor"] as? String
//                alertController.addAction(confirmAction)
//            }
//            alertController.showWith(animated: true)
        }
        
        static func response(data: [String : Any]) -> Promise<Any> {
            return Promise<Any> { to in
                let alertController =  QMUIAlertController(title: data["title"] as? String,
                                                           message: data["content"] as? String,
                                                           preferredStyle: .alert)
                 
                 /// showCancel 为 true 并且 cancelText 不为空时候显示 "取消" 按钮
                 if let cancelText = data["cancelText"] as? String {
                     let cancelAction = QMUIAlertAction(title: cancelText, style: .cancel) { (_, _) in
                         to.fulfill(LLNResult.success([
                             "confirm" : false,
                             "cancel" : true
                         ]))
                     }
                     cancelAction.titleColorHexText = data["cancelColor"] as? String
                     alertController.addAction(cancelAction)
                 }
                 
                 /// 确定按钮
                 if let confirmText = data["confirmText"] as? String {
                     let confirmAction = QMUIAlertAction(title: confirmText, style: .default) { (_, _) in
                         to.fulfill(LLNResult.success([
                             "confirm" : true,
                             "cancel" : false
                         ]))
                     }
                     confirmAction.titleColorHexText = data["confirmColor"] as? String
                     alertController.addAction(confirmAction)
                 }
                 alertController.showWith(animated: true)
            }
        }
    }
    
    ///  显示 ActionSheet
    struct showActionSheet: LLWebViewBridgable {
        
        typealias Data = [String : Any]
        
        static func response(data: [String : Any], promise: Promise<Any?>) {
//            let alertController = QMUIAlertController(title: data["alertText"] as? String,
//                                                    message: data["content"] as? String,
//                                             preferredStyle: .actionSheet)
//
//            /// cancelText 不为空时候显示 "取消" 按钮
//            if let cancelText = data["cancelText"] as? String {
//                let cancelAction = QMUIAlertAction(title: cancelText, style: .cancel, handler: nil)
//                cancelAction.titleColorHexText = data["cancelColor"] as? String
//                alertController.addAction(cancelAction)
//            }
//
//            /// 点击索引
//            var index = 0
//            /// item 颜色初始化
//            let itemColor = LLNColor.color(data["itemColor"] as? String)
//            /// 初始化 items
//            (data["itemList"] as? [String])?.forEach({ (title) in
//                /// 临时变量存储 index
//                let idx = index
//                index += 1
//                let action = QMUIAlertAction(title: title, style: .default) { (_, _) in
//                    promise.fulfill(value: LLNResult.success(["tapIndex" : idx]))
//                }
//                action.titleColor = itemColor
//                alertController.addAction(action)
//            })
//            alertController.showWith(animated: true)
        }
        
        static func response(data: [String : Any]) -> Promise<Any> {
            return Promise<Any> { to in
                let alertController = QMUIAlertController(title: data["alertText"] as? String,
                                                        message: data["content"] as? String,
                                                 preferredStyle: .actionSheet)
                 
                /// cancelText 不为空时候显示 "取消" 按钮
                if let cancelText = data["cancelText"] as? String {
                    let cancelAction = QMUIAlertAction(title: cancelText, style: .cancel, handler: nil)
                    cancelAction.titleColorHexText = data["cancelColor"] as? String
                    alertController.addAction(cancelAction)
                }
                 
                /// 点击索引
                var index = 0
                /// item 颜色初始化
                let itemColor = LLNColor.color(data["itemColor"] as? String)
                /// 初始化 items
                (data["itemList"] as? [String])?.forEach({ (title) in
                    /// 临时变量存储 index
                    let idx = index
                    index += 1
                    let action = QMUIAlertAction(title: title, style: .default) { (_, _) in
                        to.fulfill(LLNResult.success(["tapIndex" : idx]))
                    }
                    action.titleColor = itemColor
                    alertController.addAction(action)
                })
                alertController.showWith(animated: true)
            }
        }
    }
}

extension QMUIAlertAction {
    
    /// 标题颜色
    public var titleColor: UIColor? {
        set {
            var attributes = (buttonAttributes ?? [:])
            attributes[NSAttributedString.Key.foregroundColor] = newValue
            buttonAttributes = attributes
        }
        get {
            return buttonAttributes?[NSAttributedString.Key.foregroundColor] as? UIColor
        }
    }
    
    ///  标题颜色十六进制字符串
    public var titleColorHexText: String? {
        set {
            guard let titleColor = LLNColor.color(newValue) else { return }
            self.titleColor = titleColor
        }
        get { nil }
    }
}
