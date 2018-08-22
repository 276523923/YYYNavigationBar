//
//  YYYTransitionDriver.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2018/8/17.
//  Copyright © 2018年 叶越悦. All rights reserved.
//

#import "YYYTransitionDriver.h"
#import "YYYNavigationManager.h"
#import "UIViewController+YYYNavigationBar.h"
#import "UINavigationBar+YYYNavigationBar.h"
#import "YYYNavigationHelper.h"

#import "YYYCustomAnimator.h"

@interface YYYTransitionDriver ()

@property (nonatomic, weak, readonly) UIViewController *fromViewController;
@property (nonatomic, weak, readonly) UIViewController *toViewController;
@property (nonatomic, weak, readonly) YYYNavigationManager *fromManager;
@property (nonatomic, weak, readonly) YYYNavigationManager *toManager;
@property (nonatomic, readonly) NSTimeInterval transitionDuration;

@property (nonatomic, strong) YYYCustomAnimator *animator;

@end

@implementation YYYTransitionDriver

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController
                       transitionCoordinator:(id<UIViewControllerTransitionCoordinator>)transitionCoordinator {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        _transitionCoordinator = transitionCoordinator;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.animator = [YYYCustomAnimator new];
    self.animator.duration = self.transitionDuration;
    [self setupStatusBarStyle];
    [self setupBarAlpha];
    [self setupBarTintColor];
    [self setupBarTitleColor];
    [self setupBarBarTintColor];
    [self setupShadowImageColor];
    [self setupCustomView];
    
    if (self.transitionCoordinator.isInteractive) {
        __weak typeof(self) weakSelf = self;
        void(^block)(id <UIViewControllerTransitionCoordinatorContext>context) = ^(id <UIViewControllerTransitionCoordinatorContext>context) {
            BOOL isCancelled = [context isCancelled];
            __strong typeof(weakSelf) self = weakSelf;
            YYYAnimatingPosition positon = isCancelled? YYYAnimatingPositionStart:YYYAnimatingPositionEnd;
            [self.animator finishAnimationAtPosition:positon];
        };
        if (@available(iOS 10.0, *)) {
            [self.transitionCoordinator notifyWhenInteractionChangesUsingBlock:block];
        } else {
            [self.transitionCoordinator notifyWhenInteractionEndsUsingBlock:block];
        }
    } else {
        [self.animator finishAnimation];
    }
    
    if (self.navigationController.navigationBarHidden != self.toManager.hiddenNavigationBar) {
        [self.navigationController setNavigationBarHidden:self.toManager.hiddenNavigationBar animated:self.transitionCoordinator.animated];
    }
}

- (void)percentCompleteDidChange {
    self.animator.percentComplete = self.percentComplete;
}

/**
 状态栏颜色
 */
- (void)setupStatusBarStyle {
    if (self.fromManager.statusBarStyle == self.toManager.statusBarStyle) {
        return;
    }
    
//    YYYViewAnimating *animation = [YYYViewAnimating new];
//    animation.duration = self.transitionDuration;
//    __weak __typeof(self) weakSelf = self;
//    [animation setFractionCompleteChangeBlock:^(CGFloat fractionComplete) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        if (!strongSelf) {
//            return ;
//        }
//        if (fractionComplete > 0.7) {
//            strongSelf.navigationController.yyy_preferredStatusBarStyle = strongSelf.toManager.statusBarStyle;
//        } else {
//            strongSelf.navigationController.yyy_preferredStatusBarStyle = strongSelf.fromManager.statusBarStyle;
//        }
//    }];
//    
//    [animation setFinishAnimantionBlock:^(BOOL isReversed) {
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        if (!strongSelf) {
//            return ;
//        }
//        if (isReversed) {
//            strongSelf.navigationController.yyy_preferredStatusBarStyle = strongSelf.fromManager.statusBarStyle;
//        } else {
//            strongSelf.navigationController.yyy_preferredStatusBarStyle = strongSelf.toManager.statusBarStyle;
//        }
//    }];
}

/**
 分割线颜色
 */
- (void)setupShadowImageColor {
    if ([self.fromManager.navigationBarShadowImageColor isEqual:self.toManager.navigationBarShadowImageColor]) {
        return;
    }
    UIView *shadowimageView = [self.navigationController.navigationBar yyy_shadowImageView];
    
    YYYAnimationItem *animation = [YYYAnimationItem animatorWithContent:shadowimageView keyPath:@"yyy_custom_backgroundColor"];
    animation.fromValue = self.fromManager.navigationBarShadowImageColor;
    animation.toValue = self.toManager.navigationBarShadowImageColor;
    [self.animator addAnimatorItem:animation];
}

/**
 背景透明度
 */
- (void)setupBarAlpha {
    if (self.fromManager.navigationBarAlpha == self.toManager.navigationBarAlpha) {
        return;
    }
    UIView *content = [self.navigationController.navigationBar yyy_UIBarBackgroundView];
    YYYAnimationItem *animation = [YYYAnimationItem animatorWithContent:content keyPath:@"yyy_custom_alpha"];
    animation.fromValue = @(self.fromManager.navigationBarAlpha);
    animation.toValue = @(self.toManager.navigationBarAlpha);
    [self.animator addAnimatorItem:animation];
}

/**
 背景色
 */
- (void)setupBarBarTintColor {
    UIView *barTintColorView = nil;
    if (self.navigationController.navigationBar.isTranslucent) {
        UIView *effview = [self.navigationController.navigationBar yyy_backgroundEffectView];
        if (effview && effview.subviews.count == 3) {
            barTintColorView = effview.subviews.lastObject;
        }
    }
    if (!barTintColorView) {
        barTintColorView = [self.navigationController.navigationBar yyy_UIBarBackgroundView];
    }
    
    YYYAnimationItem *animation = [YYYAnimationItem animatorWithContent:barTintColorView keyPath:@"yyy_custom_backgroundColor"];
    animation.fromValue = self.fromManager.navigationBarBarTintColor;
    animation.toValue = self.toManager.navigationBarBarTintColor;
    [self.animator addAnimatorItem:animation];
}

/**
 按钮颜色
 */
- (void)setupBarTintColor {
    if ([self.fromManager.navigationBarTintColor isEqual:self.toManager.navigationBarTintColor]) {
        return;
    }
    
    YYYAnimationItem *animation = [YYYAnimationItem animatorWithContent:self.navigationController.navigationBar keyPath:@"tintColor"];
    animation.fromValue = self.fromManager.navigationBarTintColor;
    animation.toValue = self.toManager.navigationBarTintColor;
    [self.animator addAnimatorItem:animation];
}

/**
 标题颜色
 */
- (void)setupBarTitleColor {
    if ([self.fromManager.navigationBarTitleColor isEqual:self.toManager.navigationBarTitleColor]) {
        return;
    }
    
    YYYAnimationItem *animation = [YYYAnimationItem new];
    animation.fromValue = self.fromManager.navigationBarTitleColor;
    animation.toValue = self.toManager.navigationBarTitleColor;
    animation.content = self.navigationController.navigationBar;
    [animation setContentUpdateBlock:^(UINavigationBar *content, id middleValue) {
        [content yyy_updateBarTitleColor:middleValue];
    }];
    [self.animator addAnimatorItem:animation];
}

/**
 自定义视图
 */
- (void)setupCustomView {
    if (self.fromManager.customBarBackgroundView == self.toManager.customBarBackgroundView) {
        return;
    }
    if (self.navigationController.navigationBar.isTranslucent) {
        UIView *effectView = [self.navigationController.navigationBar yyy_backgroundEffectView];
        if (effectView) {
            CGFloat fromValue = effectView.alpha;
            CGFloat toValue = self.toManager.customBarBackgroundView? 0:1;
            if (fromValue != toValue) {
                YYYAnimationItem *animation = [YYYAnimationItem animatorWithContent:effectView keyPath:@"yyy_custom_alpha"];
                animation.fromValue = @(fromValue);
                animation.toValue = @(toValue);
                [self.animator addAnimatorItem:animation];
            }
        }
    }
    
    if (self.fromManager.customBarBackgroundView) {
        UIView *customView = self.fromManager.customBarBackgroundView;
        YYYAnimationItem *animation = [YYYAnimationItem animatorWithContent:customView keyPath:@"alpha"];
        animation.fromValue = @(customView.alpha);
        animation.toValue = @(0);
        [animation setCompleteBlock:^(YYYAnimationItem *item) {
            if (!item.isReversed) {
                UIView *view = item.content;
                [view removeFromSuperview];
                view.alpha = [item.fromValue doubleValue];
            }
        }];
        [self.animator addAnimatorItem:animation];
    }
    
    if (self.toManager.customBarBackgroundView) {
        UIView *customView = self.toManager.customBarBackgroundView;
        YYYAnimationItem *animation = [YYYAnimationItem animatorWithContent:customView keyPath:@"alpha"];
        animation.fromValue = @(0);
        animation.toValue = @(customView.alpha);
        customView.alpha = 0;
        [animation setCompleteBlock:^(YYYAnimationItem *item) {
            if (item.isReversed) {
                UIView *view = item.content;
                [view removeFromSuperview];
                view.alpha = [item.toValue doubleValue];
            }
        }];
        [self.animator addAnimatorItem:animation];

        if (self.fromManager.customBarBackgroundView) {
            UIView *fromView = self.fromManager.customBarBackgroundView;
            customView.frame = fromView.frame;
            customView.autoresizingMask = fromView.autoresizingMask;
            [[self.navigationController.navigationBar yyy_UIBarBackgroundView] insertSubview:customView belowSubview:fromView];
        } else {
            [self.navigationController.navigationBar yyy_updateBackgroundView:customView];
        }
    }
}

#pragma mark - ,get,set

- (NSTimeInterval)transitionDuration {
    return self.transitionCoordinator.animated? self.transitionCoordinator.transitionDuration:0;
}

- (UIViewController *)fromViewController {
    return [self.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
}

- (UIViewController *)toViewController {
    return [self.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
}

- (YYYNavigationManager *)toManager {
    return self.toViewController.yyy_navigationManager;
}

- (YYYNavigationManager *)fromManager {
    return self.fromViewController.yyy_navigationManager;
}

- (void)setPercentComplete:(CGFloat)percentComplete {
    if (_percentComplete != percentComplete) {
        _percentComplete = percentComplete;
        [self percentCompleteDidChange];
    }
}

@end
