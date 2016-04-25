//
//  ZCTeamIntroCell.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/25.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCTeamIntroCell.h"
#import "ZCTeamDetailModel.h"

@implementation ZCTeamIntroCell

- (void)setModel:(ZCTeamDetailModel *)model {
    _model = model;
    
    self.teamIntroLabel.text = model.teamIntro;
}

@end
