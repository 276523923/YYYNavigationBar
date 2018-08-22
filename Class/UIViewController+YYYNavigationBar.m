//
//  UIViewController+YYYNavigationBar.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "UIViewController+YYYNavigationBar.h"
#import <objc/runtime.h>
#import "YYYNavigationManager.h"

@implementation UIViewController (YYYNavigationBar)

- (YYYNavigationManager *)yyy_navigationManager {
    YYYNavigationManager *manager = objc_getAssociatedObject(self, @selector(yyy_navigationManager));
    if (!manager) {
        if ([self isKindOfClass:[UINavigationController class]]) {
            manager = [[YYYNavigationManager globalManager] copy];
        } else {
            manager = [self.navigationController.yyy_navigationManager copy];
        }
        manager.viewController = self;
        objc_setAssociatedObject(self, @selector(yyy_navigationManager), manager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return manager;
}

@end


