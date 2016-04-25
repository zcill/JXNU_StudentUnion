//
//  ZCTeamNameCell.h
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/25.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZCTeamDetailModel;

@interface ZCTeamNameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamNameLabel;

@property (nonatomic, strong) ZCTeamDetailModel *model;

@end
