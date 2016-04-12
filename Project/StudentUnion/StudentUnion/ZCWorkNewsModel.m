//
//  ZCWorkNewsModel.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCWorkNewsModel.h"

@implementation ZCWorkNewsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

+ (instancetype)modelWithAVObject:(AVObject *)object {
    
    ZCWorkNewsModel *model = [[ZCWorkNewsModel alloc] init];
    model.title = [object valueForKey:@"title"];
    model.content = [object valueForKey:@"content"];
    model.newsType = [object valueForKey:@"newsType"];
    model.postTime = [object valueForKey:@"postTime"];
    
    return model;
}

@end
