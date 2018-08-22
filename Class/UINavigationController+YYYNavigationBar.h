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

@property (nonatomic) BOOL yyy_navigation_enabled;/**< 控制是否启用，默认YES */

- (void)yyy_updateNavigationBarWithViewController:(UIViewController *)vc;

@end
