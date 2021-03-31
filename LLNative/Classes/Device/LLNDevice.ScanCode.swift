//
//  LLNDevice.ScanCode.swift
//  LLNative
//
//  Created by ZHK on 2021/2/4.
//  
//

import PromiseKit
import LBXScan

extension LLNDevice {
    
    struct scanCode: LLWebViewBridgable {
        
        typealias Data = [String : Any]
        
        static func response(data: [String : Any], promise: Promise<Any?>) {
//            guard let topViewController = UIApplication.findCurrendKeyWindow()?.findCurrentDisplayedViewController(controller: nil) else {
//                return
//            }
//            /// 扫码类型校验
//            guard let scanTypes = data["scanType"] as? [String] else {
//                promise.fulfill(value: LLNResult.failed("scanType 必须为 Array<string> 类型"))
//                return
//            }
//            /// 扫码类型处理
//            let types: [AVMetadataObject.ObjectType] = scanTypes.lazy
//                    .compactMap { ScanType(rawValue: $0)?.metadataTypes }
//                    .reduce([], +)
//
//            let scanViewController = QQScanNativeViewController()
//            scanViewController.title = "扫码"
//            scanViewController.style = scanViewStype
//            scanViewController.isVideoZoom = true
//            scanViewController.isFlashEnable = true
//            scanViewController.listScanTypes = nil
//            /// 是否允许从相册选择照片
//            scanViewController.isPhotoEnable = !(data["onlyFromCamera"] as? Bool ?? true)
//            scanViewController.resultCallback = { (viewController, results) in
//                viewController?.dismiss(animated: true, completion: nil)
//                if let result = results?.first, let string = result.strScanned {
//                    promise.fulfill(value: LLNResult.success([
//                        "result" : string,
//                        "rawData": string.data(using: .utf8)?.base64EncodedString() ?? "",
//    //                    "type"   : result.strBarCodeType ?? "",
//                    ]))
//                } else {
//                    promise.fulfill(value: LLNResult.failed("未识别到内容"))
//                }
//            }
//            let nav = UINavigationController(rootViewController: scanViewController)
//            nav.modalPresentationStyle = .fullScreen
//            topViewController.present(nav, animated: true, completion: nil)
        }
        
        static func response(data: [String : Any]) -> Promise<Any> {
            return Promise<Any> { to in
                DispatchQueue.main.async {
                    present(data: data) { to.fulfill($0) }
                }
            }
        }
        
        static func present(data: [String : Any], scanComplete: @escaping (Any) -> Void) {
            guard let topViewController = UIApplication.findCurrendKeyWindow()?.findCurrentDisplayedViewController(controller: nil) else {
                return
            }
            /// 扫码类型校验
            guard let scanTypes = data["scanType"] as? [String] else {
                scanComplete(LLNResult.failed("scanType 必须为 Array<string> 类型"))
                return
            }
            /// 扫码类型处理
            let types: [AVMetadataObject.ObjectType] = scanTypes.lazy
                    .compactMap { ScanType(rawValue: $0)?.metadataTypes }
                    .reduce([], +)
            
            let scanViewController = QQScanNativeViewController()
            scanViewController.title = "扫码"
            scanViewController.style = scanViewStyle
            scanViewController.isVideoZoom = true
            scanViewController.isFlashEnable = true
            scanViewController.listScanTypes = nil
            /// 是否允许从相册选择照片
            scanViewController.isPhotoEnable = !(data["onlyFromCamera"] as? Bool ?? true)
            scanViewController.resultCallback = { (viewController, results) in
                viewController?.dismiss(animated: true, completion: nil)
                if let result = results?.first, let string = result.strScanned {
                    scanComplete(LLNResult.success([
                        "result" : string,
                        "rawData": string.data(using: .utf8)?.base64EncodedString() ?? "",
    //                    "type"   : result.strBarCodeType ?? "",
                    ]))
                } else {
                    scanComplete(LLNResult.failed("未识别到内容"))
                }
            }
            let nav = UINavigationController(rootViewController: scanViewController)
            nav.modalPresentationStyle = .fullScreen
            topViewController.present(nav, animated: true, completion: nil)
        }
        
        /// 扫码控制器视图 UI 配置信息
        static var scanViewStyle: LBXScanViewStyle {
            //设置扫码区域参数
            let style = LBXScanViewStyle();

            //扫码框中心位置与View中心位置上移偏移像素(一般扫码框在视图中心位置上方一点)
            style.centerUpOffset = 44;

            //扫码框周围4个角的类型设置为在框的上面,可自行修改查看效果
            style.photoframeAngleStyle = .on;

            //扫码框周围4个角绘制线段宽度
            style.photoframeLineW = 6;

            //扫码框周围4个角水平长度
            style.photoframeAngleW = 24;

            //扫码框周围4个角垂直高度
            style.photoframeAngleH = 24;

            //动画类型：网格形式，模仿支付宝
            style.anmiationStyle = .lineMove;
            
            //动画图片:网格图片
            style.animationImage = UIImage.lbx_imageNamed("qrcode_scan_light_green")

            // 扫码框周围4个角的颜色
            style.colorAngle = UIColor(red: 65.0 / 255.0, green: 174.0 / 255.0, blue: 57.0 / 255.0, alpha: 1.0)

            //是否显示扫码框
            style.isNeedShowRetangle = true;
            
            // 扫码框颜色
            style.colorRetangleLine = UIColor(red: 247.0 / 255.0, green: 202.0 / 255.0, blue: 15.0 / 255.0, alpha: 1.0)

            //非扫码框区域颜色(扫码框周围颜色，一般颜色略暗)
            //必须通过[UIColor colorWithRed: green: blue: alpha:]来创建，内部需要解析成RGBA
            style.notRecoginitonArea = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6);
            
            return style
        }
        
        enum ScanType: String {
            case barCode    = "barCode"
            case qrCode     = "qrCode"
            case datamatrix = "datamatrix"
            case pdf417     = "pdf417"
            
            var metadataTypes: [AVMetadataObject.ObjectType] {
                switch self {
                case .barCode: return [.code39, .code93, .code128, .aztec, .ean8, .ean13, .itf14, .upce, .code39Mod43]
                case .qrCode: return [.qr]
                case .datamatrix: return [.dataMatrix]
                case .pdf417: return [.pdf417]
                }
            }
        }
    }
}
