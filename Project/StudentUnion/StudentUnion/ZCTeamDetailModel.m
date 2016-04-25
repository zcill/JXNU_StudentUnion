//
//  ZCTeamDetailModel.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/25.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCTeamDetailModel.h"

@implementation ZCTeamDetailModel

+ (ZCTeamDetailModel *)modelWithAVObject:(AVObject *)object {
    
    ZCTeamDetailModel *model = [[ZCTeamDetailModel alloc] init];
    
    model.teamName = [object valueForKey:@"teamName"];
    model.teamIntro = [object valueForKey:@"teamIntro"];
    
    return model;
}

@end
