//
//  ZCTeamDetailModel.h
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/25.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCTeamDetailModel : NSObject

@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *teamIntro;

+ (ZCTeamDetailModel *)modelWithAVObject:(AVObject *)object;

@end
