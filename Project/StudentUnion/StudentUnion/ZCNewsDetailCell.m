//
//  ZCNewsDetailCell.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/4/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCNewsDetailCell.h"

@implementation ZCNewsDetailCell

- (void)setModel:(ZCWorkNewsModel *)model {
    _model = model;
    
    self.newsTitleLabel.text = [model valueForKey:@"title"];
    self.contentTextView.text = [model valueForKey:@"content"];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
