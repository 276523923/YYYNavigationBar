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

- (void)yyy_updateBackgroundView:(UIView *)backgroundView;//会添加在yyy_UIBarBackgroundView；

- (__kindof UIView *)yyy_UIBarBackgroundView;/**< 要添加自定义背景的话，建议添加在这层上 */
- (__kindof UIView *)yyy_backgroundEffectView;
- (UIImageView *)yyy_backgroundImageView;
- (__kindof UIView *)yyy_customBackgroundView;
- (UIImageView *)yyy_shadowImageView;

@end
