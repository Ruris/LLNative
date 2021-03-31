//
//  LLNColor.swift
//  LLNative
//
//  Created by ZHK on 2021/2/4.
//  
//

import Foundation

struct LLNColor {
    
    /// 十六进制 -> 十进制映射表
    public static let hexSet: [Character : Int] = [
        "0": 0,
        "1": 1,
        "2": 2,
        "3": 3,
        "4": 4,
        "5": 5,
        "6": 6,
        "7": 7,
        "8": 8,
        "9": 9,
        "a": 10,
        "b": 11,
        "c": 12,
        "d": 13,
        "e": 14,
        "f": 15,
    ]
    
    /// 由 16 进制色值字符串转化为 UIColor
    /// - Parameter hex: 十六进制颜色字符串
    /// - Returns: UIColor 对象
    public static func color(_ hex: String?) -> UIColor? {
        guard let hexText = hex?.lowercased() else { return nil }
        let hexs = hexText.compactMap { LLNColor.hexSet[$0] }
        guard hexs.count >= 6 else { return nil }
        return UIColor(red:   CGFloat(hexs[0] * 16 + hexs[1]) / 255.0,
                       green: CGFloat(hexs[2] * 16 + hexs[3]) / 255.0,
                       blue:  CGFloat(hexs[4] * 16 + hexs[5]) / 255.0,
                       alpha: 1.0)
    }
}
