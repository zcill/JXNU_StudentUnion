//
//  ZCStudentNotiCell.h
//  StudentUnion
//
//  Created by 朱立焜 on 16/5/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZCWorkNewsModel;

@interface ZCStudentNotiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;

@property (nonatomic, strong) ZCWorkNewsModel *model;

@end
