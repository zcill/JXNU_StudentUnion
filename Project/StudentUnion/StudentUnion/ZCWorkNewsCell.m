//
//  ZCWorkNewsCell.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/9.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCWorkNewsCell.h"

@implementation ZCWorkNewsCell

- (void)setModel:(ZCWorkNewsModel *)model {
    _model = model;
    
//    self.newsTitle.text = [model valueForKey:@"title"];
    self.newsTitle.text = model.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
