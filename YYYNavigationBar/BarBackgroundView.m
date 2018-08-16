//
//  BarBackgroundView.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/30.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "BarBackgroundView.h"

@implementation BarBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
        UIColor *fromColor = [UIColor colorWithRed:251/255.f green:38/255.f blue:105/255.f alpha:1];
        UIColor *toColor = [UIColor colorWithRed:255/255.f green:95/255.f blue:50/255.f alpha:1];
        gradientLayer.colors = @[(__bridge id)fromColor.CGColor,(__bridge id)toColor.CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
    }
    return self;
}

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

@end
