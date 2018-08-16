//
//  YYYNavigationManager.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/29.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYNavigationManager : NSObject<NSCopying,NSMutableCopying>

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

@property (nonatomic) BOOL isShow;


/**
 全局默认配置

 @return globalManager
 */
+ (instancetype)globalManager;


/**
 globalManager copy

 @return manager
 */
+ (instancetype)newManager;

@end
