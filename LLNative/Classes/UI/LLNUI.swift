//
//  LLNUI.swift
//  LLNative
//
//  Created by Ruris on 02/02/2021.
//  Copyright (c) 2021 ZHK. All rights reserved.
//

struct LLNUI: LLNativable {
    
    static var supports: [LLWebViewBridgableBase.Type] {[
        showToast.self,
        hideToast.self,
        showLoading.self,
        hideLoading.self,
        showModal.self,
        showActionSheet.self
    ]}
}

extension UIApplication {
    
    /// 查找当前的 keyWindow
    /// - Returns: 查找结果
    static func findCurrendKeyWindow() -> UIWindow? {
        if let keyWindow = UIApplication.shared.keyWindow {
            return keyWindow
        }
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes.lazy
                .filter { $0.activationState == .foregroundActive }
                .compactMap { $0 as? UIWindowScene }
                .first?.windows
                .first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
    }
}

extension UIWindow {
    
    public func findCurrentDisplayedViewController(controller: UIViewController?) -> UIViewController? {
        var viewController = controller
        /// 当前控制器模态出过视图控制器的情况
        if let presentedViewController = viewController?.presentedViewController {
            viewController = findCurrentDisplayedViewController(controller: presentedViewController)
        } else
        /// 当前控制器是 UITabBarController 或子类对象
        if let tabbarViewController = viewController as? UITabBarController {
            viewController = findCurrentDisplayedViewController(controller: tabbarViewController.selectedViewController)
        } else
        /// 当前控制器是 UINavigationController 或子类对象
        if let navigationController = viewController as? UINavigationController {
            viewController = findCurrentDisplayedViewController(controller: navigationController.topViewController)
        } else {
            viewController = rootViewController
        }
        return viewController
    }
}

