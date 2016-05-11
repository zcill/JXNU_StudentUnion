//
//  ZCStudentNotiCell.m
//  StudentUnion
//
//  Created by 朱立焜 on 16/5/10.
//  Copyright © 2016年 朱立焜. All rights reserved.
//

#import "ZCStudentNotiCell.h"
#import "ZCWorkNewsModel.h"

@implementation ZCStudentNotiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ZCWorkNewsModel *)model {

    _model = model;

    self.titleLabel.text = [model valueForKey:@"title"];

}

@end
