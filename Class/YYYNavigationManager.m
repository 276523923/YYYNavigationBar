//
//  YYYNavigationManager.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/29.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "YYYNavigationManager.h"

@implementation YYYNavigationManager
static YYYNavigationManager *manager__ = nil;

- (instancetype)init
{
    if (!manager__)
    {
        manager__ = [super init];
        manager__.navigationBarTintColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
        manager__.navigationBarBarTintColor = [UIColor colorWithWhite:0.97f alpha:0.8f];
        manager__.navigationBarTitleColor = [UIColor darkTextColor];
        manager__.navigationBarAlpha = 1;
        manager__.navigationBarShadowImageColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        manager__.hiddenNavigationBar = NO;
        manager__.backgroundImage = nil;
    }
    return manager__;
}

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager__ = [YYYNavigationManager new];
    });
    return manager__;
}

@end
