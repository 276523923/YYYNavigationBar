//
//  UINavigationController+YYYNavigationBar.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYNavigationManager.h"

@interface UINavigationController (YYYNavigationBar)

@property (nonatomic, weak, readonly) UIViewController *yyy_currentShowController;/**< 当前显示的VC */
@property (nonatomic, copy)  void(^yyy_viewControllerTransitionAnimationsBlock)(UIViewController *fromViewController,UIViewController *toViewController,CGFloat transitionDuration);
@property (nonatomic, copy) void(^yyy_transitionCompleteBlock)(UIViewController *toViewController);
@property (nonatomic, weak) id<UINavigationControllerDelegate> yyy_delegate;
@property (nonatomic, strong) YYYNavigationManager *yyy_manager;

@end 
