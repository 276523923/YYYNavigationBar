 //
//  UINavigationBar+YYYNavigationBar.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/18.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "UINavigationBar+YYYNavigationBar.h"
#import "YYYNavigationHelper.h"

@interface UIView(YYYNavigationBar)

@property (nonatomic, strong) UIColor *yyy_custom_backgroundColor;
@property (nonatomic, strong) NSNumber *yyy_custom_alpha;

@end

@implementation UIView (YYYNavigationBar)

+ (void)load
{
    SwapSEL(self, @selector(setBackgroundColor:), @selector(yyy_setBackgroundColor:));
    SwapSEL(self, @selector(setAlpha:), @selector(yyy_setAlpha:));
}

- (void)yyy_setBackgroundColor:(UIColor *)backgroundColor
{
    if (self.yyy_custom_backgroundColor)
    {
        [self yyy_setBackgroundColor:self.yyy_custom_backgroundColor];
    }
    else
    {
        [self yyy_setBackgroundColor:backgroundColor];
    }
}

- (void)yyy_setAlpha:(CGFloat)alpha
{
    if (self.yyy_custom_alpha)
    {
        [self yyy_setAlpha:self.yyy_custom_alpha.doubleValue];
    }
    else
    {
        [self yyy_setAlpha:alpha];
    }
}

- (UIColor *)yyy_custom_backgroundColor
{
    return objc_getAssociatedObject(self, @selector(yyy_custom_backgroundColor));
}

- (void)setYyy_custom_backgroundColor:(UIColor *)yyy_custom_backgroundColor
{
    objc_setAssociatedObject(self, @selector(yyy_custom_backgroundColor), yyy_custom_backgroundColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.backgroundColor = yyy_custom_backgroundColor;
}

- (NSNumber *)yyy_custom_alpha
{
    return objc_getAssociatedObject(self, @selector(yyy_custom_alpha));
}

- (void)setYyy_custom_alpha:(NSNumber *)yyy_custom_alpha
{
    objc_setAssociatedObject(self, @selector(yyy_custom_alpha), yyy_custom_alpha, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.alpha = yyy_custom_alpha.doubleValue;
}

@end

//@interface UINavigationBar ()
//
//@property (nonatomic) CGFloat customHeight;
//
//@end

@implementation UINavigationBar (YYYNavigationBar)

+ (void)load
{
    
}

- (void)yyy_updateBarAlpha:(CGFloat)barBackgroundAlpha
{
    UIView *barBackgroundView = [self yyy_UIBarBackgroundView];
    barBackgroundView.yyy_custom_alpha = @(barBackgroundAlpha);
}

- (void)yyy_updateBarHeight:(CGFloat)height
{
    //    CGRect frame = self.navigationBar.frame;
    //    frame.size.height = height;
    //    self.navigationBar.customHeight = height;
    //    self.navigationBar.frame = frame;
    //    CGFloat aaa=  [self.navigationBar.topItem.rightBarButtonItem backgroundVerticalPositionAdjustmentForBarMetrics:UIBarMetricsDefault];
    //    [self.navigationBar.topItem.rightBarButtonItem setBackgroundVerticalPositionAdjustment:20 forBarMetrics:UIBarMetricsDefault];
    //
    //
    //    UIView *view = self.navigationBar.subviews.firstObject;
    //    frame = view.frame;
    //    frame.size.height = height - frame.origin.y;
    //    view.frame = frame;
    //    LayoutView(self.navigationBar);
    
    //    self.navigationBar.frame = frame;
    //
    //    [self.navigationBar layoutIfNeeded];
    //    [self.navigationBar setNeedsLayout];
    
}

- (void)yyy_updateBarTintColor:(UIColor *)tintColor
{
    self.tintColor = tintColor;
}

- (void)yyy_updateBarTitleColor:(UIColor *)titleColor
{
    if (!titleColor)
    {
        return;
    }
    
    NSDictionary *titleTextAttributes = [self titleTextAttributes];
    if (titleTextAttributes == nil)
    {
        self.titleTextAttributes = @{NSForegroundColorAttributeName:titleColor};
    }
    else
    {
        NSMutableDictionary *newTitleTextAttributes = [titleTextAttributes mutableCopy];
        newTitleTextAttributes[NSForegroundColorAttributeName] = titleColor;
        self.titleTextAttributes = newTitleTextAttributes;
    }
    
    //滑动过程中会有两个标题，所以得一起改
    Class cls = nil;
    if (@available(iOS 11.0, *))
    {
        cls = NSClassFromString(@"_UINavigationBarContentView");
    }
    else
    {
        cls = NSClassFromString(@"UINavigationItemView");
    }
    for (UIView *view in self.subviews)
    {
        if ([view isMemberOfClass:cls])
        {
            for (UILabel *lbl in view.subviews)
            {
                if ([lbl isMemberOfClass:[UILabel class]])
                {
                    lbl.textColor = titleColor;
                }
            }
        }
    }
}

- (void)yyy_updateBarBarTintColor:(UIColor *)barTintColor
{
    self.barTintColor = barTintColor;
    if (self.translucent)
    {
        UIView *effview = [self yyy_backgroundEffectView];
        if (effview)
        {
            if (effview.subviews.count == 3)
            {
                UIView *view = effview.subviews.lastObject;
                view.yyy_custom_backgroundColor = barTintColor;
            }
        }
    }
    else
    {
        [self yyy_UIBarBackgroundView].backgroundColor = barTintColor;
    }
}

- (void)yyy_updateBarShadowImageColor:(UIColor *)shadowColor
{
    [self yyy_shadowImageView].yyy_custom_backgroundColor = shadowColor;
}

- (void)yyy_updateBackgroundImage:(UIImage *)image
{
    self.yyy_backgroundImageView.image = image;
}

- (void)yyy_updateBackgroundView:(UIView *)backgroundView
{
    UIView *view = self.yyy_customBackgroundView;
    if (view == backgroundView)
    {
        return;
    }
    if (view)
    {
        [view removeFromSuperview];
    }
    objc_setAssociatedObject(self, @selector(yyy_customBackgroundView), backgroundView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (backgroundView)
    {
        backgroundView.frame = [self yyy_UIBarBackgroundView].bounds;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        if (backgroundView.superview)
        {
            if (backgroundView.superview == [self yyy_UIBarBackgroundView])
            {
                [[self yyy_UIBarBackgroundView] sendSubviewToBack:backgroundView];
            }
            else
            {
                [backgroundView removeFromSuperview];
                [[self yyy_UIBarBackgroundView] insertSubview:backgroundView atIndex:0];
            }
        }
        else
        {
            [[self yyy_UIBarBackgroundView] insertSubview:backgroundView atIndex:0];
        }
    }
}

#pragma mark - 获取相应的View
- (UIView *)yyy_UIBarBackgroundView
{
    Class cls = nil;
    if (@available(iOS 10.0, *))
    {
        cls = NSClassFromString(@"_UIBarBackground");
    }
    else
    {
        cls = NSClassFromString(@"_UINavigationBarBackground");
    }
    for (UIView *view in self.subviews)
    {
        if ([view isMemberOfClass:cls])
        {
            return view;
        }
    }
    return nil;
}

- (UILabel *)yyy_TitleViewLabel
{
    Class cls = nil;
    if (@available(iOS 11.0, *))
    {
        cls = NSClassFromString(@"_UINavigationBarContentView");
    }
    else
    {
        cls = NSClassFromString(@"UINavigationItemView");
    }
    for (UIView *view in self.subviews)
    {
        if ([view isMemberOfClass:cls])
        {
            for (UILabel *lbl in view.subviews)
            {
                if ([lbl isMemberOfClass:[UILabel class]])
                {
                    return lbl;
                }
            }
        }
    }
    return nil;
}

- (UIView *)yyy_backgroundEffectView
{
    UIView *view = nil;
    Class cls = nil;
    if (@available(iOS 10.0, *))
    {
        cls = [UIVisualEffectView class];
    }
    else
    {
        cls = NSClassFromString(@"_UIBackdropView");
    }
    for (UIView *subview in [self yyy_UIBarBackgroundView].subviews)
    {
        if ([subview isMemberOfClass:cls])
        {
            view = subview;
            break;
        }
        
    }
    return view;
}

- (UIImageView *)yyy_shadowImageView
{
    UIImageView *shadowImageView = nil;
    UIView *backgroundView = [self yyy_UIBarBackgroundView];
    for (UIView *view in backgroundView.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]] && CGRectGetHeight(view.frame) == 0.5)
        {
            shadowImageView = (UIImageView *)view;
            break;
        }
    }
    return shadowImageView;
}

- (UIImageView *)yyy_backgroundImageView
{
    UIImageView *imageView = self.yyy_customBackgroundView;
    if (!imageView || ![imageView isKindOfClass:[UIImageView class]])
    {
        imageView = [UIImageView new];
        [self yyy_updateBackgroundView:imageView];
    }
    return imageView;
}

- (__kindof UIView *)yyy_customBackgroundView
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
