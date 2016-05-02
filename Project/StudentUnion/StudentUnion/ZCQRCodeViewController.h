//
//  ZCQRCodeViewController.h
//  StudentUnion
//
//  Created by 朱立焜 on 16/5/2.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZCQRCodeViewControllerDelegate;

@interface ZCQRCodeViewController : UIViewController

@property (nonatomic, assign) id<ZCQRCodeViewControllerDelegate> delegate;

@end

@protocol ZCQRCodeViewControllerDelegate <NSObject>

- (void)didFinishedReadingQR:(NSString *)string;

@end
