//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "QQScanNativeViewController.h"
#import "LBXScanVideoZoomView.h"
#import "LBXPermission.h"
#import "UIImage+LBXScan.h"

@interface QQScanNativeViewController ()

@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;

@property (nonatomic, assign) CGFloat maxVideoScale;

@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation QQScanNativeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor blackColor];
    
    // 设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
    
    [self setupUI];
}

#pragma mark -

- (void)scanResults:(NSArray<LBXScanResult *> *)array {
    if (array.count <= 0) { return; }
    if (_resultCallback) {
        _resultCallback(self, array);
    }
}

#pragma mark - Action

- (void)back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UI

- (void)setupUI {
    self.title = @"扫码";
    [self.view insertSubview:self.topTitle atIndex:3];
    if (_isPhotoEnable || _isFlashEnable) {
        [self.view addSubview:self.bottomItemsView];
        [_bottomItemsView addSubview:self.stackView];
        
        if (_isPhotoEnable) {
            [_stackView addArrangedSubview:self.btnPhoto];
        }
        if (_isFlashEnable) {
            [_stackView addArrangedSubview:self.btnFlash];
        }
    }
    self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage lbx_imageNamed:@"qrcode_scan_titlebar_back_pressed"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    _topTitle.bounds = CGRectMake(0, 0, 145, 60);
    _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
    
    CGFloat height = 100 ;
    if (@available(iOS 11.0, *)) {
        height += self.view.safeAreaInsets.bottom;
    }
    _bottomItemsView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.view.bounds) - height,
                                        CGRectGetWidth(self.view.bounds),
                                        height);
    _stackView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 100.0);
    
        
    CGRect frame = self.view.frame;
    
    int XRetangleLeft = self.style.xScanRetangleOffset;
    
    CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
    
    if (self.style.whRatio != 1) {
        CGFloat w = sizeRetangle.width;
        CGFloat h = w / self.style.whRatio;
        
        NSInteger hInt = (NSInteger)h;
        h  = hInt;
        
        sizeRetangle = CGSizeMake(w, h);
    }
    
    //扫码区域Y轴最小坐标
    CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    
    CGFloat zoomw = sizeRetangle.width + 40;
    _zoomView.frame = CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18);
}

- (void)cameraInitOver {
    if (self.isVideoZoom) {
        [self zoomView];
    }
}

- (void)setVideoMaxScale:(CGFloat)maxScale {
    if (_isVideoZoom) {
        self.maxVideoScale = maxScale;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self zoomView];
        });
    }
}

- (void)tap {
    _zoomView.hidden = !_zoomView.hidden;
}

#pragma mark - 底部功能项

//打开相册
- (void)openPhoto {
    __weak __typeof(self) weakSelf = self;
    [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        if (granted) {
            [weakSelf openLocalPhoto:NO];
        } else if (!firstTime ) {
            [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:@"提示" msg:@"没有相册权限，是否前往设置" cancel:@"取消" setting:@"设置"];
        }
    }];
}

//开关闪光灯
- (void)openOrCloseFlash {
    [super openOrCloseFlash];
    if (self.isOpenFlash) {
        [_btnFlash setImage:[UIImage lbx_imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    } else {
        [_btnFlash setImage:[UIImage lbx_imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
    }
}

#pragma mark - Getter

- (UIStackView *)stackView {
    if (_stackView == nil) {
        self.stackView = [[UIStackView alloc] init];
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.distribution = UIStackViewDistributionFillProportionally;
    }
    return _stackView;
}

- (LBXScanVideoZoomView*)zoomView {
    if (!_zoomView) {
        
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1) {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:self.maxVideoScale/2];
        
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value) {
            [weakSelf.scanObj setVideoScale:value];
        };
        
        [self.view insertSubview:_zoomView atIndex:3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
    
}

- (UILabel *)topTitle {
    if (_topTitle == nil) {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 ) {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准识别区域即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
    }
    return _topTitle;
}

- (UIButton *)btnFlash {
    if (_btnFlash == nil) {
        CGSize size = CGSizeMake(65, 87);
        self.btnFlash = [[UIButton alloc]init];
        _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
        _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2, CGRectGetHeight(_bottomItemsView.frame)/2);
         [_btnFlash setImage:[UIImage lbx_imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
        [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnFlash;
}

- (UIButton *)btnPhoto {
    if (_btnPhoto == nil) {
        self.btnPhoto = [[UIButton alloc]init];
        _btnPhoto.bounds = _btnFlash.bounds;
        _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/4, CGRectGetHeight(_bottomItemsView.frame)/2);
        [_btnPhoto setImage:[UIImage lbx_imageNamed:@"qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
        [_btnPhoto setImage:[UIImage lbx_imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
        [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnPhoto;
}

- (UIView *)bottomItemsView {
    if (_bottomItemsView == nil) {
        self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds) - 100, CGRectGetWidth(self.view.bounds), 100)];
        _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
#if TARGET_IPHONE_SIMULATOR
        _bottomItemsView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
#endif
    }
    return _bottomItemsView;
}

@end
