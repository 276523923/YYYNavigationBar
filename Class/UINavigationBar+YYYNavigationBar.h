//
//  UINavigationBar+YYYNavigationBar.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/18.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (YYYNavigationBar)

- (void)yyy_updateBarAlpha:(CGFloat)barBackgroundAlpha;
- (void)yyy_updateBarHeight:(CGFloat)height;
- (void)yyy_updateBarTintColor:(UIColor *)tintColor;
- (void)yyy_updateBarTitleColor:(UIColor *)titleColor;
- (void)yyy_updateBarBarTintColor:(UIColor *)barTintColor;
- (void)yyy_updateBarShadowImageColor:(UIColor *)shadowColor;
- (void)yyy_updateBackgroundImage:(UIImage *)image;


- (UIView *)yyy_UIBarBackgroundView;
- (UIImageView *)yyy_backgroundImageView;
- (UIView *)yyy_backgroundEffectView;

@end
