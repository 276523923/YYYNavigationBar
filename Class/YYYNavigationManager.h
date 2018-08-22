//
//  YYYNavigationManager.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/29.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYYNavigationManager : NSObject<NSCopying,NSMutableCopying>

@property (nonatomic, weak) UIViewController *viewController;

@property (nonatomic, strong) UIColor *navigationBarTintColor;/**< 影响按钮颜色 */
@property (nonatomic, strong) UIColor *navigationBarBarTintColor; /**< 影响背景色 */
@property (nonatomic, strong) UIColor *navigationBarTitleColor;/**< 标题颜色 */
@property (nonatomic, assign) CGFloat navigationBarAlpha;/**< 背景透明度，不影响标题按钮 */
@property (nonatomic, strong) UIColor *navigationBarShadowImageColor;/**< 分割线颜色 */
@property (nonatomic, strong) UIImage *backgroundImage;/**< 背景图片 */
@property (nonatomic, strong) UIView *customBarBackgroundView;/**< 自定义背景 */

@property (nonatomic) UIStatusBarStyle statusBarStyle;
@property (nonatomic) BOOL hiddenNavigationBar;
@property (nonatomic) CGFloat navigationBarHeight;

@property (nonatomic) BOOL isShow;

- (void)reloadNavigationBarStyle;

/**
 全局默认配置

 @return globalManager
 */
+ (instancetype)globalManager;

@end
