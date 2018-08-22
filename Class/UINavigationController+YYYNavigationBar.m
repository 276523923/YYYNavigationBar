//
//  UINavigationController+YYYNavigationBar.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/15.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#import "UINavigationController+YYYNavigationBar.h"
#import "UIViewController+YYYNavigationBar.h"
#import "UINavigationBar+YYYNavigationBar.h"
#import "YYYNavigationHelper.h"
#import "YYYTransitionDriver.h"

@interface UINavigationController () <UINavigationBarDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) YYYTransitionDriver *transitionDriver;

@end

@implementation UINavigationController (YYYNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapSEL(self, NSSelectorFromString(@"_updateInteractiveTransition:"), @selector(yyy_updateInteractiveTransition:));
        SwapSEL(self, @selector(setNavigationBarHidden:animated:), @selector(yyy_setNavigationBarHidden:animated:));
        SwapSEL(self, NSSelectorFromString(@"_startCustomTransition:"), @selector(yyy_startCustomTransition:));
        SwapSEL(self, NSSelectorFromString(@"navigationTransitionView:didEndTransition:fromView:toView:"), @selector(yyy_navigationTransitionView:didEndTransition:fromView:toView:));
        SwapSEL(self, NSSelectorFromString(@"_navigationTransitionView:didCancelTransition:fromViewController:toViewController:wrapperView:"), @selector(yyy_navigationTransitionView:didCancelTransition:fromViewController:toViewController:wrapperView:));

    });
}

- (void)yyy_updateInteractiveTransition:(CGFloat)percentComplete {
    [self yyy_updateInteractiveTransition:percentComplete];
    if (self.yyy_navigation_enabled) {
        self.transitionDriver.percentComplete = percentComplete;
    }
}

- (void)yyy_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [self yyy_setNavigationBarHidden:hidden animated:animated];
    if (self.yyy_navigation_enabled && self.topViewController.yyy_navigationManager.hiddenNavigationBar != hidden) {
        self.topViewController.yyy_navigationManager.hiddenNavigationBar = hidden;
    }
}

#pragma mark - UINavigationController Delegate
- (void)yyy_startCustomTransition:(id)transition {
    [self yyy_startCustomTransition:transition];
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.transitionCoordinator;
    if (!transitionCoordinator) {
        return;
    }
    self.transitionDriver = [[YYYTransitionDriver alloc] initWithNavigationController:self transitionCoordinator:transitionCoordinator];
}

- (void)yyy_navigationTransitionView:(id)transitionView didCancelTransition:(NSInteger)transition fromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController wrapperView:(UIView *)wrapperView {
    self.transitionDriver = nil;
    [self yyy_updateNavigationBarWithViewController:fromViewController];
    [self yyy_navigationTransitionView:transitionView didCancelTransition:transition fromViewController:fromViewController toViewController:toViewController wrapperView:wrapperView];
}

- (void)yyy_navigationTransitionView:(id)transitionView didEndTransition:(NSInteger)transition fromView:(UIView *)fromView toView:(UIView *)toView {
    self.transitionDriver = nil;
    [self yyy_updateNavigationBarWithViewController:self.topViewController];
    if (self.transitionCoordinator) {
        UIViewController *fromViewController = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        fromViewController.yyy_navigationManager.isShow = NO;
    }
    [self yyy_navigationTransitionView:transitionView didEndTransition:transition fromView:fromView toView:toView];
}

#pragma mark - update
- (void)yyy_updateNavigationBarWithViewController:(UIViewController *)vc {
    YYYNavigationManager *manager = vc.yyy_navigationManager;
    manager.isShow = YES;
    [self.navigationBar yyy_updateBarShadowImageColor:manager.navigationBarShadowImageColor];
    [self.navigationBar yyy_updateBarAlpha:manager.navigationBarAlpha];
    [self.navigationBar yyy_updateBarTintColor:manager.navigationBarTintColor];
    [self.navigationBar yyy_updateBarTitleColor:manager.navigationBarTitleColor];
    [self.navigationBar yyy_updateBackgroundView:manager.customBarBackgroundView];
    [self.navigationBar yyy_updateBarBarTintColor:manager.navigationBarBarTintColor];
    if (self.navigationBar.isTranslucent) {
        if (manager.customBarBackgroundView) {
            self.navigationBar.yyy_backgroundEffectView.alpha = 0;
        } else {
            self.navigationBar.yyy_backgroundEffectView.alpha = 1;
        }
    }
}

#pragma mark - get, set

- (BOOL)yyy_navigation_enabled {
    NSNumber *enabled = objc_getAssociatedObject(self, @selector(yyy_navigation_enabled));
    if (!enabled) {
        enabled = @(YES);
        self.yyy_navigation_enabled = YES;
    }
    return [enabled boolValue];
}

- (void)setYyy_navigation_enabled:(BOOL)yyy_navigation_enabled {
    objc_setAssociatedObject(self, @selector(yyy_navigation_enabled), @(yyy_navigation_enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YYYTransitionDriver *)transitionDriver {
    return objc_getAssociatedObject(self, @selector(transitionDriver));
}

- (void)setTransitionDriver:(YYYTransitionDriver *)transitionDriver {
    objc_setAssociatedObject(self, @selector(transitionDriver), transitionDriver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

