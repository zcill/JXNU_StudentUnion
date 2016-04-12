//
//  UIImage+ZCOriginal.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "UIImage+ZCOriginal.h"

@implementation UIImage (ZCOriginal)

+ (UIImage *)imageWithOriginalImageNamed:(NSString *)imageName {
    
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
