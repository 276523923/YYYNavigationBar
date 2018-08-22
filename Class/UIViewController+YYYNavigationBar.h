//
//  UIViewController+YYYNavigationBar.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYYNavigationManager.h"

@interface UIViewController (YYYNavigationBar)

/**
 默认 yyy_navigationManager = [self.navigationController.yyy_navigationManager copy];
 */
@property (nonatomic, strong, readonly) YYYNavigationManager *yyy_navigationManager;

@end
