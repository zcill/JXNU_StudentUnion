//
//  ZCTeamNameCell.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/25.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCTeamNameCell.h"
#import "ZCTeamDetailModel.h"

@implementation ZCTeamNameCell

- (void)setModel:(ZCTeamDetailModel *)model {
    _model = model;
    
    self.teamNameLabel.text = model.teamName;
}

@end
