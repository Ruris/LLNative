//
//  UIImage+LBXScan.m
//  Pods
//
//  Created by ZHK on 2021/2/5.
//  
//

#import "UIImage+LBXScan.h"

static NSString *const kLBXImagePath = @"Frameworks/LBXScan.framework/CodeScan.bundle";

@implementation UIImage (LBXScan)

+ (UIImage *)lbx_imageNamed:(NSString *)name {
    return [UIImage imageNamed:[kLBXImagePath stringByAppendingPathComponent:name]];
}

@end
