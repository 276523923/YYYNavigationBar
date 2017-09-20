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

@implementation UIViewController (YYYNavigationBar)

- (BOOL)yyy_needUpdateNavigationBar
{
    return self.navigationController.navigationBar && self.navigationController.yyy_currentShowController == self;
}

#pragma mark - get,set
- (UIColor *)yyy_navigationBarBarTintColor
{
    UIColor *color = objc_getAssociatedObject(self, @selector(yyy_navigationBarBarTintColor));
    if (!color)
    {
        color = self.navigationController.navigationBar.barTintColor;
        objc_setAssociatedObject(self, @selector(yyy_navigationBarBarTintColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

- (void)setYyy_navigationBarBarTintColor:(UIColor *)yyy_navigationBarBarTintColor
{
    if ([self yyy_needUpdateNavigationBar])
    {
        [self.navigationController.navigationBar yyy_updateBarBarTintColor:yyy_navigationBarBarTintColor];
    }
    objc_setAssociatedObject(self, @selector(yyy_navigationBarBarTintColor), yyy_navigationBarBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)yyy_navigationBarTintColor
{
    UIColor *color = objc_getAssociatedObject(self, @selector(yyy_navigationBarTintColor));
    if (!color)
    {
        color = self.navigationController.navigationBar.tintColor;
        objc_setAssociatedObject(self, @selector(yyy_navigationBarTintColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

- (void)setYyy_navigationBarTintColor:(UIColor *)yyy_navigationBarTintColor
{
    if ([self yyy_needUpdateNavigationBar])
    {
        [self.navigationController.navigationBar yyy_updateBarTintColor:yyy_navigationBarTintColor];
    }
    objc_setAssociatedObject(self, @selector(yyy_navigationBarTintColor), yyy_navigationBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)yyy_navigationBarTitleColor
{
    UIColor *color = objc_getAssociatedObject(self, @selector(yyy_navigationBarTitleColor));
    if (!color)
    {
        NSDictionary *dic = self.navigationController.navigationBar.titleTextAttributes;
        if (dic)
        {
            color = dic[NSForegroundColorAttributeName];
        }
        else
        {
            color = [UIColor blackColor];
        }
        objc_setAssociatedObject(self, @selector(yyy_navigationBarTitleColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return color;
}

- (void)setYyy_navigationBarTitleColor:(UIColor *)yyy_navigationBarTitleColor
{
    if ([self yyy_needUpdateNavigationBar])
    {
        [self.navigationController.navigationBar yyy_updateBarTitleColor:yyy_navigationBarTitleColor];
    }
    objc_setAssociatedObject(self, @selector(yyy_navigationBarTitleColor), yyy_navigationBarTitleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)yyy_navigationBarAlpha
{
    NSNumber *alpha = objc_getAssociatedObject(self, @selector(yyy_navigationBarAlpha));
    if (!alpha)
    {
        alpha = @(1);
        self.yyy_navigationBarAlpha = 1;
    }
    return [alpha floatValue];
}

- (void)setYyy_navigationBarAlpha:(CGFloat)yyy_navigationBarAlpha
{
    yyy_navigationBarAlpha = MAX(MIN(yyy_navigationBarAlpha, 1), 0);
    if ([self yyy_needUpdateNavigationBar])
    {
        if ([self yyy_needUpdateNavigationBar])
        {
            [self.navigationController.navigationBar yyy_updateBarAlpha:yyy_navigationBarAlpha];
        }
    }
    objc_setAssociatedObject(self, @selector(yyy_navigationBarAlpha), @(yyy_navigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIStatusBarStyle)yyy_preferredStatusBarStyle
{
    NSNumber *style = objc_getAssociatedObject(self, @selector(yyy_preferredStatusBarStyle));
    if (!style)
    {
        style = @(UIStatusBarStyleDefault);
    }
    return [style integerValue];
}

- (void)setYyy_preferredStatusBarStyle:(UIStatusBarStyle)yyy_preferredStatusBarStyle
{
    if (self.yyy_preferredStatusBarStyle != yyy_preferredStatusBarStyle)
    {
        objc_setAssociatedObject(self, @selector(yyy_preferredStatusBarStyle), @(yyy_preferredStatusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.yyy_preferredStatusBarStyle;
}

- (UIColor *)yyy_navigationBarShadowImageColor
{
    UIColor *color = objc_getAssociatedObject(self, @selector(yyy_navigationBarShadowImageColor));
    if (!color)
    {
        for (UIView *view in self.navigationController.navigationBar.subviews.firstObject.subviews)
        {
            if ([view isKindOfClass:[UIImageView class]] && CGRectGetHeight(view.frame) == 0.5)
            {
                color = view.backgroundColor;
                objc_setAssociatedObject(self, @selector(yyy_navigationBarTintColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
    }
    return color;
}

- (void)setYyy_navigationBarShadowImageColor:(UIColor *)yyy_navigationBarShadowImageColor
{
    if ([self yyy_needUpdateNavigationBar])
    {
        [self.navigationController.navigationBar yyy_updateBarShadowImageColor:yyy_navigationBarShadowImageColor];
    }
    objc_setAssociatedObject(self, @selector(yyy_navigationBarShadowImageColor), yyy_navigationBarShadowImageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)yyy_navigationBarHeight
{
    NSNumber *height = objc_getAssociatedObject(self, @selector(yyy_navigationBarHeight));
    if (!height)
    {
        height = @(self.navigationController.navigationBar.frame.size.height);
        objc_setAssociatedObject(self, @selector(yyy_navigationBarHeight), height, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [height doubleValue];
}

- (void)setYyy_navigationBarHeight:(CGFloat)yyy_navigationBarHeight
{
    if ([self yyy_needUpdateNavigationBar])
    {
        [self.navigationController.navigationBar yyy_updateBarHeight:yyy_navigationBarHeight];
    }
    objc_setAssociatedObject(self, @selector(yyy_navigationBarHeight), @(yyy_navigationBarHeight), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)yyy_backgroundImage
{
    return objc_getAssociatedObject(self, @selector(yyy_backgroundImage));
}

- (void)setYyy_backgroundImage:(UIImage *)yyy_backgroundImage
{
    if ([self yyy_needUpdateNavigationBar])
    {
        [self.navigationController.navigationBar yyy_updateBackgroundImage:yyy_backgroundImage];
        if (yyy_backgroundImage)
        {
            self.navigationController.navigationBar.yyy_backgroundEffectView.alpha = 0;
            self.navigationController.navigationBar.yyy_backgroundImageView.alpha = 1;
        }
    }
    objc_setAssociatedObject(self, @selector(yyy_backgroundImage), yyy_backgroundImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


