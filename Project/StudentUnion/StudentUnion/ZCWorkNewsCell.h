//
//  ZCWorkNewsCell.h
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/9.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCWorkNewsModel.h"

@interface ZCWorkNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitle;

@property (nonatomic, strong) ZCWorkNewsModel *model;

@end
