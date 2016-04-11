//
//  MBProgressHUD+ZCShow.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/9.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "MBProgressHUD+ZCShow.h"

@implementation MBProgressHUD (ZCShow)

+ (void)showCheckmarkHudAddTo:(UIView *)view animated:(BOOL)animated text:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_checkmark"]];
    hud.customView = checkmark;
    hud.alpha = 0.6;
    [hud hide:YES afterDelay:2];
}

@end
