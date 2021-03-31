//
//  LLNDevice.swift
//  LLNative
//
//  Created by Ruris on 02/02/2021.
//  Copyright (c) 2021 ZHK. All rights reserved.
//

import PromiseKit

struct LLNDevice: LLNativable {
    
    static var supports: [LLWebViewBridgableBase.Type] {[
        getBatteryInfo.self,
        addPhoneContact.self,
        setClipboardData.self,
        getClipboardData.self,
        setScreenBrightness.self,
        getScreenBrightness.self,
        setKeepScreenOn.self,
        vibrateShort.self,
        vibrateLong.self,
        scanCode.self
    ]}

}
