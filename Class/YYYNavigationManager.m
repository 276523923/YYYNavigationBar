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
    self = [super init];
    if (self) {
        self.navigationBarTintColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];
        self.navigationBarBarTintColor = [UIColor colorWithWhite:0.97f alpha:0.8f];
        self.navigationBarTitleColor = [UIColor darkTextColor];
        self.navigationBarAlpha = 1;
        self.navigationBarShadowImageColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3f];
        self.hiddenNavigationBar = NO;
        self.backgroundImage = nil;
        self.customBarBackgroundView = nil;
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *style = [info valueForKey:@"UIStatusBarStyle"];
        if ([style isEqualToString:@"UIStatusBarStyleLightContent"])
        {
            self.statusBarStyle = UIStatusBarStyleLightContent;
        }
        else
        {
            self.statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    return self;
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
