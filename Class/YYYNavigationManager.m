//
//  YYYNavigationManager.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/29.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "YYYNavigationManager.h"
#import "YYYNavigationManagerProxy.h"
#import "UINavigationController+YYYNavigationBar.h"

@implementation YYYNavigationManager
static YYYNavigationManager *manager__ = nil;

- (instancetype)init {
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
        if ([style isEqualToString:@"UIStatusBarStyleLightContent"]) {
            self.statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            self.statusBarStyle = UIStatusBarStyleDefault;
        }
    }
    return self;
}

+ (instancetype)globalManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager__ = [YYYNavigationManager new];
    });
    return manager__;
}

- (void)reloadNavigationBarStyle {
    if (self.isShow && self.viewController && self.viewController.navigationController.navigationBar &&
        self.viewController.navigationController != self.viewController) {
        [self.viewController.navigationController yyy_updateNavigationBarWithViewController:self.viewController];
        NSLog(@"after %@",@(self.navigationBarAlpha));
    }
}

#pragma mark - NSCopying, NSMutableCopying
- (id)copyWithZone:(NSZone *)zone {
    YYYNavigationManager *manager = [[self.class allocWithZone:zone] init];
    manager.navigationBarTintColor = manager__.navigationBarTintColor;
    manager.navigationBarBarTintColor = manager__.navigationBarBarTintColor;
    manager.navigationBarTitleColor = manager__.navigationBarTitleColor;
    manager.navigationBarAlpha = manager__.navigationBarAlpha;;
    manager.navigationBarShadowImageColor = manager__.navigationBarShadowImageColor;
    manager.hiddenNavigationBar = manager__.hiddenNavigationBar;
    manager.backgroundImage = manager__.backgroundImage;
    manager.customBarBackgroundView = manager__.customBarBackgroundView;
    manager.statusBarStyle = manager__.statusBarStyle;
    return [YYYNavigationManagerProxy proxyWithTarget:manager];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [self copyWithZone:zone];
}

#pragma mark - set, get

- (void)setNavigationBarAlpha:(CGFloat)navigationBarAlpha {
    _navigationBarAlpha = MAX(MIN(navigationBarAlpha, 1), 0);
}

#if DEBUG
- (NSString *)description {
    return [NSString stringWithFormat:
            @"%@:{\n\
            navigationBarTintColor:%@\n\
            navigationBarBarTintColor:%@\n\
            navigationBarTitleColor:%@\n\
            navigationBarAlpha:%@\n\
            navigationBarShadowImageColor:%@\n\
            backgroundImage:%@\n\
            customBarBackgroundView:%@\n\
            statusBarStyle:%@\n\
            hiddenNavigationBar:%@\n\
            navigationBarHeight:%@\n}",
            self.class,
            self.navigationBarTintColor,
            self.navigationBarBarTintColor,
            self.navigationBarTitleColor,
            @(self.navigationBarAlpha),
            self.navigationBarShadowImageColor,
            self.backgroundImage,
            self.customBarBackgroundView,
            @(self.statusBarStyle),
            @(self.hiddenNavigationBar),
            @(self.navigationBarHeight)
            ];
}

- (NSString *)debugDescription {
    return [self description];
}
#endif

@end
