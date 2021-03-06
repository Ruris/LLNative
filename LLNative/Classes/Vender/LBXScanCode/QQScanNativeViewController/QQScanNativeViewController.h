//
//  SubLBXScanViewController.h
//
//  github:https://github.com/MxABC/LBXScan
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXScanNativeViewController.h"

@class LBXScanResult;
typedef void(^LBXScanResultBlock)(UIViewController *viewController, NSArray <LBXScanResult *> *results);

#pragma mark - 模仿qq界面
//继承LBXScanViewController,在界面上绘制想要的按钮，提示语等
@interface QQScanNativeViewController : LBXScanNativeViewController

/**
 @brief  扫码区域上方提示文字
 */
@property (nonatomic, strong) UILabel *topTitle;

#pragma mark --增加拉近/远视频界面

@property (nonatomic, assign) BOOL isVideoZoom;

/// 是够允许从相册获取二维码
@property (nonatomic, assign) BOOL isPhotoEnable;

// 是否允许开启闪光灯
@property (nonatomic, assign) BOOL isFlashEnable;

#pragma mark - 底部几个功能：开启闪光灯、相册、我的二维码
//底部显示的功能项
@property (nonatomic, strong) UIView *bottomItemsView;

//相册
@property (nonatomic, strong) UIButton *btnPhoto;

//闪光灯
@property (nonatomic, strong) UIButton *btnFlash;

/// 扫描结果回调
@property (nonatomic, copy) LBXScanResultBlock resultCallback;

@end
