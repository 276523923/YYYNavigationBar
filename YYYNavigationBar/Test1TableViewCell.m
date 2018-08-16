//
//  Test1TableViewCell.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2018/3/26.
//  Copyright © 2018年 叶越悦. All rights reserved.
//

#import "Test1TableViewCell.h"

@implementation Test1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    size.height = 100;
    return size;
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize {
    return [super systemLayoutSizeFittingSize:targetSize];
}

- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
    return [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:horizontalFittingPriority verticalFittingPriority:verticalFittingPriority];
}

@end
