//
//  ZCNewsDetailCell.h
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCWorkNewsModel.h"

@interface ZCNewsDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView;

@property (nonatomic, strong) ZCWorkNewsModel *model;

@end
