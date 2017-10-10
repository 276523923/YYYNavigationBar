//
//  UIViewController+YYYNavigationBar.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YYYNavigationBar)

@property (nonatomic, strong) UIColor *yyy_navigationBarTintColor;
@property (nonatomic, strong) UIColor *yyy_navigationBarBarTintColor;
@property (nonatomic, strong) UIColor *yyy_navigationBarTitleColor;
@property (nonatomic, assign) CGFloat yyy_navigationBarAlpha;
@property (nonatomic, assign) UIStatusBarStyle yyy_preferredStatusBarStyle;
@property (nonatomic, strong) UIColor *yyy_navigationBarShadowImageColor;
@property (nonatomic) CGFloat yyy_navigationBarHeight;
@property (nonatomic, strong) UIImage *yyy_backgroundImage;
@property (nonatomic) BOOL yyy_hiddenNavigationBar;

@property (nonatomic, strong) UIView *yyy_customBarBackgroundView;

@end
