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

@interface UINavigationController () <UINavigationBarDelegate, UINavigationControllerDelegate>

@end

@implementation UINavigationController (YYYNavigationBar)

static CGFloat yyy_customFromViewAlpha = 0;
static CGFloat yyy_customToViewAlpha = 0;

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapSEL(self, NSSelectorFromString(@"_updateInteractiveTransition:"), @selector(yyy_updateInteractiveTransition:));
        SwapSEL(self, @selector(setNavigationBarHidden:animated:), @selector(yyy_setNavigationBarHidden:animated:));
        SwapSEL(self, NSSelectorFromString(@"_startCustomTransition:"), @selector(yyy_startCustomTransition:));
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.yyy_preferredStatusBarStyle;
}

- (void)yyy_updateInteractiveTransition:(CGFloat)percentComplete {
    if (self.yyy_enabled) {
      
        
        
        
        id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.transitionCoordinator;
        UIViewController *fromVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toVC = [self.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView *fromVCView = fromVC.view;
        UIView *toVCView = toVC.view;
        self.yyy_preferredStatusBarStyle = percentComplete > 0.7 ? toVC.preferredStatusBarStyle : fromVC.preferredStatusBarStyle;
        [self yyy_updateNavigationBarWithFromVC:fromVC toVC:toVC percent:percentComplete];
    }
    [self yyy_updateInteractiveTransition:percentComplete];
}

- (void)yyy_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [self yyy_setNavigationBarHidden:hidden animated:animated];
    if (self.yyy_enabled && self.topViewController.yyy_hiddenNavigationBar != hidden) {
        self.topViewController.yyy_hiddenNavigationBar = hidden;
    }
}

#pragma mark - UINavigationController Delegate

- (void)yyy_startCustomTransition:(id)transition {
    [self yyy_startCustomTransition:transition];
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.transitionCoordinator;
    if (!transitionCoordinator) {
        return;
    }
    
    UIView *containerView = [transitionCoordinator containerView];
    NSArray *subviews = containerView.subviews;
    UIView *toView = subviews.firstObject;
    UIView *_UIParallaxDimmingView = subviews[1];
    UIView *fromView = subviews[2];
    

    UIViewController *fromController = [transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    BOOL animated = [self.transitionCoordinator isAnimated];

    yyy_customFromViewAlpha = 0;
    yyy_customToViewAlpha = 0;
    if (fromController.yyy_customBarBackgroundView) {
        yyy_customFromViewAlpha = fromController.yyy_customBarBackgroundView.alpha;
    }

    if (toController.yyy_customBarBackgroundView) {
        yyy_customToViewAlpha = toController.yyy_customBarBackgroundView.alpha;
        
        UIView *toVCView = toController.yyy_customBarBackgroundView;
        UIView *fromVCView = fromController.yyy_customBarBackgroundView;
        if (fromVCView && fromVCView != toVCView) {
            toVCView.frame = fromVCView.frame;
            toVCView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [[self.navigationBar yyy_UIBarBackgroundView] insertSubview:toVCView belowSubview:fromVCView];
            toVCView.alpha = 0;
        } else {
            [self.navigationBar yyy_updateBackgroundView:toVCView];
        }
    }

    if (animated) {
        if (![transitionCoordinator initiallyInteractive]) {
            CGFloat duration = transitionCoordinator.transitionDuration;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (duration * 0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.yyy_preferredStatusBarStyle = toController.yyy_preferredStatusBarStyle;
            });

            UIView *fromVCView = fromController.yyy_customBarBackgroundView;
            UIView *toVCView = toController.yyy_customBarBackgroundView;
            if (fromVCView != toVCView) {
                toVCView.alpha = 0;
            }

            CGFloat toViewAlpha = yyy_customToViewAlpha;
            CGFloat effectViewAlpha = toVCView ? 0 : 1;
            UIColor *barTintColor = toController.yyy_navigationBarBarTintColor;
            UIColor *shadowColor = toController.yyy_navigationBarShadowImageColor;

            if (fromController.yyy_navigationBarAlpha == 0) {
                if (fromVCView != toVCView) {
                    fromVCView.alpha = 0;
                }
                self.navigationBar.yyy_backgroundEffectView.alpha = 0;
                [self.navigationBar yyy_updateBarBarTintColor:toController.yyy_navigationBarBarTintColor];
                [self.navigationBar yyy_updateBarShadowImageColor:toController.yyy_navigationBarShadowImageColor];
            }

            if (toController.yyy_navigationBarAlpha == 0) {
                effectViewAlpha = 0;
                toViewAlpha = 0;
                shadowColor = fromController.yyy_navigationBarShadowImageColor;
                barTintColor = fromController.yyy_navigationBarBarTintColor;
            }

            if (fromVCView && toVCView) {
                toVCView.frame = fromVCView.frame;
            } else if (toVCView) {
                barTintColor = fromController.yyy_navigationBarBarTintColor;
            } else if (fromVCView) {
                [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
            }

            [UIView animateWithDuration:duration animations:^{
                if (fromVCView != toVCView) {
                    fromVCView.alpha = 0;
                    toVCView.alpha = toViewAlpha;
                }
                self.navigationBar.yyy_backgroundEffectView.alpha = effectViewAlpha;
                [self.navigationBar yyy_updateBarAlpha:toController.yyy_navigationBarAlpha];
                [self.navigationBar yyy_updateBarTintColor:toController.yyy_navigationBarTintColor];
                [self.navigationBar yyy_updateBarTitleColor:toController.yyy_navigationBarTitleColor];
                [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
                [self.navigationBar yyy_updateBarShadowImageColor:shadowColor];
                if (self.yyy_viewControllerTransitionAnimationsBlock) {
                    self.yyy_viewControllerTransitionAnimationsBlock(fromController, toController, duration);
                }
            }                completion:^(BOOL finished) {
                [self.navigationBar yyy_updateBackgroundView:toVCView];
                fromVCView.alpha = yyy_customFromViewAlpha;
                toVCView.alpha = yyy_customToViewAlpha;
                if (self.yyy_transitionCompleteBlock) {
                    self.yyy_transitionCompleteBlock(toController);
                }
            }];
        } else {
            __weak typeof(self) weakSelf = self;
            if (@available(iOS 10.0, *)) {
                [transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id <UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
                    __strong typeof(weakSelf) self = weakSelf;
                    [self dealInteractionChanges:context];
                }];
            } else {
                [transitionCoordinator notifyWhenInteractionEndsUsingBlock:^(id <UIViewControllerTransitionCoordinatorContext> _Nonnull context) {
                    __strong typeof(weakSelf) self = weakSelf;
                    [self dealInteractionChanges:context];
                }];
            }
        }
    } else {
        self.yyy_preferredStatusBarStyle = toController.yyy_preferredStatusBarStyle;
    }

    if (self.navigationController.navigationBarHidden != toController.yyy_hiddenNavigationBar) {
        [self setNavigationBarHidden:toController.yyy_hiddenNavigationBar animated:animated];
    }
}

- (void)dealInteractionChanges:(id <UIViewControllerTransitionCoordinatorContext>)context {
    UIViewController *fromVC = nil;
    UIViewController *toVC = nil;
    CGFloat duration = 0;
    BOOL cancelled = [context isCancelled];
    if (cancelled) {
        fromVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        duration = [context transitionDuration] * [context percentComplete];
        CGFloat temp = yyy_customFromViewAlpha;
        yyy_customFromViewAlpha = yyy_customToViewAlpha;
        yyy_customToViewAlpha = temp;
    } else {
        fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        duration = [context transitionDuration] * (1 - [context percentComplete]);
    }
    UIView *fromVCView = fromVC.yyy_customBarBackgroundView;
    UIView *toVCView = toVC.yyy_customBarBackgroundView;
    CGFloat toViewAlpha = toVC.yyy_navigationBarAlpha == 0 ? 0 : yyy_customToViewAlpha;
    CGFloat effectViewAlpha = toVCView ? 0 : 1;
    UIColor *barTintColor = toVC.yyy_navigationBarBarTintColor;
    UIColor *shadowColor = toVC.yyy_navigationBarShadowImageColor;
    if (toVC.yyy_navigationBarAlpha == 0) {
        effectViewAlpha = 0;
        shadowColor = fromVC.yyy_navigationBarShadowImageColor;
        barTintColor = fromVC.yyy_navigationBarBarTintColor;
    }
    [UIView animateWithDuration:duration animations:^{
        if (fromVCView != toVCView) {
            fromVCView.alpha = 0;
            toVCView.alpha = toViewAlpha;
        }
        self.navigationBar.yyy_backgroundEffectView.alpha = effectViewAlpha;
        [self.navigationBar yyy_updateBarAlpha:toVC.yyy_navigationBarAlpha];
        [self.navigationBar yyy_updateBarTintColor:toVC.yyy_navigationBarTintColor];
        [self.navigationBar yyy_updateBarTitleColor:toVC.yyy_navigationBarTitleColor];
        [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
        [self.navigationBar yyy_updateBarShadowImageColor:shadowColor];
        if (self.yyy_viewControllerTransitionAnimationsBlock) {
            self.yyy_viewControllerTransitionAnimationsBlock(fromVC, toVC, duration);
        }
    }                completion:^(BOOL finished) {
        if (cancelled) {
            if (fromVCView != toVCView) {
                [fromVCView removeFromSuperview];
            }
        } else {
            if (self.yyy_transitionCompleteBlock) {
                self.yyy_transitionCompleteBlock(toVC);
            }
        }
        [self.navigationBar yyy_updateBackgroundView:toVCView];
        fromVCView.alpha = yyy_customFromViewAlpha;
        toVCView.alpha = yyy_customToViewAlpha;
    }];
}

#pragma mark - update

- (void)yyy_updateNavigationBarWithViewController:(UIViewController *)vc {
    [self.navigationBar yyy_updateBarShadowImageColor:vc.yyy_navigationBarShadowImageColor];
    [self.navigationBar yyy_updateBarAlpha:vc.yyy_navigationBarAlpha];
    [self.navigationBar yyy_updateBarTintColor:vc.yyy_navigationBarTintColor];
    [self.navigationBar yyy_updateBarTitleColor:vc.yyy_navigationBarTitleColor];
    [self.navigationBar yyy_updateBackgroundView:vc.yyy_customBarBackgroundView];
    [self.navigationBar yyy_updateBarBarTintColor:vc.yyy_navigationBarBarTintColor];
    if (vc.yyy_customBarBackgroundView) {
        self.navigationBar.yyy_backgroundEffectView.alpha = 0;
    } else {
        self.navigationBar.yyy_backgroundEffectView.alpha = 1;
    }
}

- (void)yyy_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC percent:(CGFloat)percent {
    NSLog(@"%@", NSStringFromCGRect(fromVC.view.frame));
    //_UIBarBackground alpha 背景透明度，不影响标题跟按钮
    if (fromVC.yyy_navigationBarAlpha != toVC.yyy_navigationBarAlpha) {
        CGFloat newBarBackgroundAlpha = MiddleValue(fromVC.yyy_navigationBarAlpha, toVC.yyy_navigationBarAlpha, percent);
        [self.navigationBar yyy_updateBarAlpha:newBarBackgroundAlpha];
    }

    //TintColor 按钮颜色
    if (![fromVC.yyy_navigationBarTintColor isEqual:toVC.yyy_navigationBarTintColor]) {
        UIColor *newTintColor = MiddleColor(fromVC.yyy_navigationBarTintColor, toVC.yyy_navigationBarTintColor, percent);
        [self.navigationBar yyy_updateBarTintColor:newTintColor];
    }

    //TitleColor 标题颜色
    if (![fromVC.yyy_navigationBarTitleColor isEqual:toVC.yyy_navigationBarTitleColor]) {
        UIColor *newTitleColor = MiddleColor(fromVC.yyy_navigationBarTitleColor, toVC.yyy_navigationBarTitleColor, percent);
        [self.navigationBar yyy_updateBarTitleColor:newTitleColor];
    }

    //ShadowImage 分割线的颜色
    if (![fromVC.yyy_navigationBarShadowImageColor isEqual:toVC.yyy_navigationBarShadowImageColor]) {
        UIColor *shadowColor = nil;
        if (fromVC.yyy_navigationBarAlpha == 0) {
            shadowColor = toVC.yyy_navigationBarShadowImageColor;
        } else if (toVC.yyy_navigationBarAlpha == 0) {
            shadowColor = fromVC.yyy_navigationBarShadowImageColor;
        } else {
            shadowColor = MiddleColor(fromVC.yyy_navigationBarShadowImageColor, toVC.yyy_navigationBarShadowImageColor, percent);
        }
//        [self.navigationBar yyy_updateBarShadowImageColor:shadowColor];
    }


    UIView *fromVCView = fromVC.yyy_customBarBackgroundView;
    UIView *toVCView = toVC.yyy_customBarBackgroundView;

    CGFloat toViewAlpha = yyy_customToViewAlpha * percent;
    CGFloat effectViewAlpha = 0;
    CGFloat fromViewAlpha = yyy_customFromViewAlpha * (1 - percent);

    UIColor *barTintColor = nil;
    if (fromVCView && toVCView) {
        effectViewAlpha = 0;
        toVCView.frame = fromVCView.frame;
    } else if (toVCView) {
        effectViewAlpha = 1 - percent;
        barTintColor = fromVC.yyy_navigationBarBarTintColor;
        [self.navigationBar yyy_updateBackgroundView:toVCView];
    } else if (fromVCView) {
        effectViewAlpha = percent;
        barTintColor = toVC.yyy_navigationBarBarTintColor;
    } else {
        effectViewAlpha = 1;
        barTintColor = MiddleColor(fromVC.yyy_navigationBarBarTintColor, toVC.yyy_navigationBarBarTintColor, percent);
    }

    if (fromVC.yyy_navigationBarAlpha == 0) {
        fromViewAlpha = 0;
        barTintColor = toVC.yyy_navigationBarBarTintColor;
    }

    if (toVC.yyy_navigationBarAlpha == 0) {
        toViewAlpha = 0;
        barTintColor = fromVC.yyy_navigationBarBarTintColor;
    }
    [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
    self.navigationBar.yyy_backgroundEffectView.alpha = effectViewAlpha;
    if (fromVCView != toVCView) {
        fromVCView.alpha = fromViewAlpha;
        toVCView.alpha = toViewAlpha;
    }

}

#pragma mark - get, set

- (void)setYyy_viewControllerTransitionAnimationsBlock:(void (^)(UIViewController *, UIViewController *, CGFloat))yyy_viewControllerTransitionAnimationsBlock {
    objc_setAssociatedObject(self, @selector(yyy_viewControllerTransitionAnimationsBlock), yyy_viewControllerTransitionAnimationsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (void (^)(UIViewController *, UIViewController *, CGFloat))yyy_viewControllerTransitionAnimationsBlock {
    return objc_getAssociatedObject(self, @selector(yyy_viewControllerTransitionAnimationsBlock));
}

- (void)setYyy_transitionCompleteBlock:(void (^)(UIViewController *))yyy_transitionCompleteBlock {
    objc_setAssociatedObject(self, @selector(yyy_transitionCompleteBlock), yyy_transitionCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIViewController *))yyy_transitionCompleteBlock {
    return objc_getAssociatedObject(self, @selector(yyy_transitionCompleteBlock));
}

- (YYYNavigationManager *)yyy_defaultManager {
    YYYNavigationManager *manager = objc_getAssociatedObject(self, @selector(yyy_defaultManager));
    if (!manager) {
        manager = [YYYNavigationManager newManager];
        self.yyy_defaultManager = manager;
    }
    return manager;
}

- (void)setYyy_defaultManager:(YYYNavigationManager *)yyy_defaultManager {
    if (![yyy_defaultManager isKindOfClass:[YYYNavigationManager class]]) {
        yyy_defaultManager = nil;
    }
    objc_setAssociatedObject(self, @selector(yyy_defaultManager), yyy_defaultManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yyy_enabled {
    NSNumber *enabled = objc_getAssociatedObject(self, _cmd);
    if (!enabled) {
        enabled = @(YES);
        self.yyy_enabled = YES;
    }
    return [enabled boolValue];
}

- (void)setYyy_enabled:(BOOL)yyy_enabled {
    objc_setAssociatedObject(self, @selector(yyy_enabled), @(yyy_enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

