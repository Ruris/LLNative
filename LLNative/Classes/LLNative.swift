//
//  LLNative.swift
//  LLNative
//
//  Created by Ruris on 02/02/2021.
//  Copyright (c) 2021 ZHK. All rights reserved.
//

import WKWebViewJavascriptBridge

public extension WKWebViewJavascriptBridge {
    
    /// 模块列表
    private var components: [LLNativable.Type] {[
        LLNUI.self,             // UI模块
        LLNStorage.self,        // 缓存模块
        LLNDevice.self          // 设备模块
    ]}
    
    /// 注册初始化 LLNative
    /// - Parameter identifier: 页面标识符 
    func registerLLNative(_ identifier: String) {
        components.forEach { $0.register(bridge: self) }
    }
    
}
