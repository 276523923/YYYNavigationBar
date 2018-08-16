//
//  UIViewController+YYYNavigationBar.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "UIViewController+YYYNavigationBar.h"
#import "UINavigationController+YYYNavigationBar.h"
#import "UINavigationBar+YYYNavigationBar.h"
#import "YYYNavigationHelper.h"
#import <objc/runtime.h>
#import "YYYNavigationManager.h"
#import "UINavigationController+YYYNavigationBar.h"

@implementation UIViewController (YYYNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapSEL(self, @selector(viewDidAppear:), @selector(yyy_viewDidAppear:));
        SwapSEL(self, @selector(viewDidDisappear:), @selector(yyy_viewDidDisappear:));
    });
}

- (YYYNavigationManager *)yyy_navigationManager {
    YYYNavigationManager *manger = objc_getAssociatedObject(self, @selector(yyy_navigationManager));
    if (!manger) {
        manger = [self.navigationController.yyy_defaultManager copy];
        objc_setAssociatedObject(self, @selector(yyy_navigationManager), manger, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manger;
}

- (BOOL)yyy_needUpdateNavigationBar {
    return self.navigationController.yyy_enabled && self.navigationController.navigationBar && self.yyy_navigationManager.isShow;
}

- (void)yyy_viewDidAppear:(BOOL)animated {
    [self yyy_viewDidAppear:animated];
    self.yyy_navigationManager.isShow = YES;
    if ([self yyy_needUpdateNavigationBar]) {
        [self.navigationController yyy_updateNavigationBarWithViewController:self];
    }
}

- (void)yyy_viewDidDisappear:(BOOL)animated {
    [self yyy_viewDidDisappear:animated];
    self.yyy_navigationManager.isShow = NO;
}

#pragma mark - get, set

- (UIColor *)yyy_navigationBarBarTintColor {
    return self.yyy_navigationManager.navigationBarBarTintColor;
}

- (void)setYyy_navigationBarBarTintColor:(UIColor *)yyy_navigationBarBarTintColor {
    if ([self yyy_needUpdateNavigationBar]) {
        [self.navigationController.navigationBar yyy_updateBarBarTintColor:yyy_navigationBarBarTintColor];
    }
    self.yyy_navigationManager.navigationBarBarTintColor = yyy_navigationBarBarTintColor;
}

- (UIColor *)yyy_navigationBarTintColor {
    return self.yyy_navigationManager.navigationBarTintColor;
}

- (void)setYyy_navigationBarTintColor:(UIColor *)yyy_navigationBarTintColor {
    if ([self yyy_needUpdateNavigationBar]) {
        [self.navigationController.navigationBar yyy_updateBarTintColor:yyy_navigationBarTintColor];
    }
    self.yyy_navigationManager.navigationBarTintColor = yyy_navigationBarTintColor;
}

- (UIColor *)yyy_navigationBarTitleColor {
    return self.yyy_navigationManager.navigationBarTitleColor;
}

- (void)setYyy_navigationBarTitleColor:(UIColor *)yyy_navigationBarTitleColor {
    if ([self yyy_needUpdateNavigationBar]) {
        [self.navigationController.navigationBar yyy_updateBarTitleColor:yyy_navigationBarTitleColor];
    }
    self.yyy_navigationManager.navigationBarTitleColor = yyy_navigationBarTitleColor;
}

- (CGFloat)yyy_navigationBarAlpha {
    return self.yyy_navigationManager.navigationBarAlpha;
}

- (void)setYyy_navigationBarAlpha:(CGFloat)yyy_navigationBarAlpha {
    self.yyy_navigationManager.navigationBarAlpha = yyy_navigationBarAlpha;
    if ([self yyy_needUpdateNavigationBar]) {
        [self.navigationController.navigationBar yyy_updateBarAlpha:yyy_navigationBarAlpha];
    }
}

- (UIStatusBarStyle)yyy_preferredStatusBarStyle {
    return self.yyy_navigationManager.statusBarStyle;
}

- (void)setYyy_preferredStatusBarStyle:(UIStatusBarStyle)yyy_preferredStatusBarStyle {
    if (self.yyy_preferredStatusBarStyle != yyy_preferredStatusBarStyle) {
        self.yyy_navigationManager.statusBarStyle = yyy_preferredStatusBarStyle;
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.yyy_preferredStatusBarStyle;
}

- (UIColor *)yyy_navigationBarShadowImageColor {
    return self.yyy_navigationManager.navigationBarShadowImageColor;
}

- (void)setYyy_navigationBarShadowImageColor:(UIColor *)yyy_navigationBarShadowImageColor {
    self.yyy_navigationManager.navigationBarShadowImageColor = yyy_navigationBarShadowImageColor;
    if ([self yyy_needUpdateNavigationBar]) {
        [self.navigationController.navigationBar yyy_updateBarShadowImageColor:yyy_navigationBarShadowImageColor];
    }
}

- (CGFloat)yyy_navigationBarHeight {
    return self.yyy_navigationManager.navigationBarHeight;
}

- (void)setYyy_navigationBarHeight:(CGFloat)yyy_navigationBarHeight {
    self.yyy_navigationManager.navigationBarHeight = yyy_navigationBarHeight;
    if ([self yyy_needUpdateNavigationBar]) {
        [self.navigationController.navigationBar yyy_updateBarHeight:yyy_navigationBarHeight];
    }
}

- (UIImage *)yyy_backgroundImage {
    return self.yyy_navigationManager.backgroundImage;
}

- (void)setYyy_backgroundImage:(UIImage *)yyy_backgroundImage {
    self.yyy_navigationManager.backgroundImage = yyy_backgroundImage;
    if (self.yyy_customBarBackgroundView && [self.yyy_customBarBackgroundView isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *) self.yyy_customBarBackgroundView;
        imageView.image = yyy_backgroundImage;
    } else {
        self.yyy_customBarBackgroundView = [[UIImageView alloc] initWithImage:yyy_backgroundImage];
    }
}

- (BOOL)yyy_hiddenNavigationBar {
    return self.yyy_navigationManager.hiddenNavigationBar;
}

- (void)setYyy_hiddenNavigationBar:(BOOL)yyy_hiddenNavigationBar {
    self.yyy_navigationManager.hiddenNavigationBar = yyy_hiddenNavigationBar;
    if ([self yyy_needUpdateNavigationBar] && self.navigationController.navigationBarHidden != yyy_hiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:yyy_hiddenNavigationBar];
    }
}

- (void)setYyy_customBarBackgroundView:(UIView *)yyy_customNavigationBarBackgroundView {
    self.yyy_navigationManager.customBarBackgroundView = yyy_customNavigationBarBackgroundView;
    if ([self yyy_needUpdateNavigationBar]) {
        [self.navigationController.navigationBar yyy_updateBackgroundView:yyy_customNavigationBarBackgroundView];
        if (yyy_customNavigationBarBackgroundView) {
            self.navigationController.navigationBar.yyy_backgroundEffectView.alpha = 0;
        } else {
            self.navigationController.navigationBar.yyy_backgroundEffectView.alpha = 1;
        }
    }
}

- (UIView *)yyy_customBarBackgroundView {
    return self.yyy_navigationManager.customBarBackgroundView;
}
@end


