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

@implementation UIViewController (YYYNavigationBar)

- (BOOL)yyy_needUpdateNavigationBar
{
    return self.navigationController.navigationBar && self.navigationController.yyy_currentShowController == self;
}

- (YYYNavigationManager *)yyy_manager
{
    if (self.navigationController.yyy_manager)
    {
        return self.navigationController.yyy_manager;
    }
    return [YYYNavigationManager manager];
}

#pragma mark - get,set
- (UIColor *)yyy_navigationBarBarTintColor
{
    UIColor *color = objc_getAssociatedObject(self, @selector(yyy_navigationBarBarTintColor));
    if (!color)
    {
        color = self.yyy_manager.navigationBarBarTintColor;
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
        color = self.yyy_manager.navigationBarTintColor;
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
        color = self.yyy_manager.navigationBarTitleColor;
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
        alpha = @(self.yyy_manager.navigationBarAlpha);
        objc_setAssociatedObject(self, @selector(yyy_navigationBarAlpha), alpha, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return [alpha floatValue];
}

- (void)setYyy_navigationBarAlpha:(CGFloat)yyy_navigationBarAlpha
{
    yyy_navigationBarAlpha = MAX(MIN(yyy_navigationBarAlpha, 1), 0);
    if ([self yyy_needUpdateNavigationBar])
    {
        [self.navigationController.navigationBar yyy_updateBarAlpha:yyy_navigationBarAlpha];
    }
    objc_setAssociatedObject(self, @selector(yyy_navigationBarAlpha), @(yyy_navigationBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIStatusBarStyle)yyy_preferredStatusBarStyle
{
    NSNumber *style = objc_getAssociatedObject(self, @selector(yyy_preferredStatusBarStyle));
    if (!style)
    {
        style = @(self.yyy_manager.statusBarStyle);
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
        color = self.yyy_manager.navigationBarShadowImageColor;
        objc_setAssociatedObject(self, @selector(yyy_navigationBarShadowImageColor), color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
    if (self.yyy_customBarBackgroundView && [self.yyy_customBarBackgroundView isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = (UIImageView *)self.yyy_customBarBackgroundView;
        return imageView.image;
    }
    else
    {
        return nil;
    }
}

- (void)setYyy_backgroundImage:(UIImage *)yyy_backgroundImage
{
    if (self.yyy_customBarBackgroundView && [self.yyy_customBarBackgroundView isKindOfClass:[UIImageView class]])
    {
        UIImageView *imageView = (UIImageView *)self.yyy_customBarBackgroundView;
        imageView.image = yyy_backgroundImage;
    }
    else
    {
        self.yyy_customBarBackgroundView = [[UIImageView alloc]initWithImage:yyy_backgroundImage];
    }
}

- (BOOL)yyy_hiddenNavigationBar
{
    return [objc_getAssociatedObject(self, @selector(yyy_hiddenNavigationBar)) doubleValue];
}

- (void)setYyy_hiddenNavigationBar:(BOOL)yyy_hiddenNavigationBar
{
    objc_setAssociatedObject(self, @selector(yyy_hiddenNavigationBar), @(yyy_hiddenNavigationBar), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self yyy_needUpdateNavigationBar] && self.navigationController.navigationBarHidden != yyy_hiddenNavigationBar)
    {
        [self.navigationController setNavigationBarHidden:yyy_hiddenNavigationBar];
    }
}

- (void)setYyy_customBarBackgroundView:(UIView *)yyy_customNavigationBarBackgroundView
{
    objc_setAssociatedObject(self, @selector(yyy_customBarBackgroundView), yyy_customNavigationBarBackgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if ([self yyy_needUpdateNavigationBar])
    {
        [self.navigationController.navigationBar yyy_updateBackgroundView:yyy_customNavigationBarBackgroundView];
        if (yyy_customNavigationBarBackgroundView)
        {
            self.navigationController.navigationBar.yyy_backgroundEffectView.alpha = 0;
        }
        else
        {
            self.navigationController.navigationBar.yyy_backgroundEffectView.alpha = 1;
        }
    }
}

- (UIView *)yyy_customBarBackgroundView
{
    UIView *view =  objc_getAssociatedObject(self, @selector(yyy_customBarBackgroundView));
    if (!view)
    {
        if (self.yyy_manager.customBarBackgroundView)
        {
            view = self.yyy_manager.customBarBackgroundView;
            self.yyy_customBarBackgroundView = view;
        }
    }
    return view;
}
@end


