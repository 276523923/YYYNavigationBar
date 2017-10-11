//
//  YYYNavigationManager.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/29.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 全局配置属性
 */
@interface YYYNavigationManager : NSObject

@property (nonatomic, strong) UIColor *navigationBarTintColor;
@property (nonatomic, strong) UIColor *navigationBarBarTintColor;
@property (nonatomic, strong) UIColor *navigationBarTitleColor;
@property (nonatomic, assign) CGFloat navigationBarAlpha;
@property (nonatomic, strong) UIColor *navigationBarShadowImageColor;
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIView *customBarBackgroundView;
@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic) BOOL hiddenNavigationBar;
@property (nonatomic) CGFloat navigationBarHeight;

+ (instancetype)manager;

@end
