//
//  ZCWorkNewsModel.h
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCWorkNewsModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *newsType;
@property (nonatomic, strong) NSDate *postTime;

+ (instancetype)modelWithAVObject:(AVObject *)object;

@end
