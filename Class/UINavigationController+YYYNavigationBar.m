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

@interface UINavigationController ()<UINavigationBarDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) id<UINavigationControllerDelegate> yyy_delegate;

@end


@implementation UINavigationController (YYYNavigationBar)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapSEL(self,NSSelectorFromString(@"_updateInteractiveTransition:"), @selector(yyy_updateInteractiveTransition:));
        SwapSEL(self, @selector(setDelegate:), @selector(yyy_setDelegate:));
    });
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.yyy_preferredStatusBarStyle;
}

- (void)yyy_updateInteractiveTransition:(CGFloat)percentComplete
{
    UIViewController *fromVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [self.topViewController.transitionCoordinator viewControllerForKey:UITransitionContextToViewControllerKey];
    self.yyy_preferredStatusBarStyle = percentComplete >0.7? toVC.preferredStatusBarStyle:fromVC.preferredStatusBarStyle;
    [self yyy_updateNavigationBarWithFromVC:fromVC toVC:toVC percent:percentComplete];
    [self yyy_updateInteractiveTransition:percentComplete];
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (animated)
    {
        id<UIViewControllerTransitionCoordinator> coor = [navigationController.topViewController transitionCoordinator];
        if (![coor initiallyInteractive])
        {
            self.yyy_preferredStatusBarStyle = viewController.preferredStatusBarStyle;
            UIViewController *fromVC = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = viewController;
        
            CGFloat duration = self.transitionCoordinator.transitionDuration;
            
            if (fromVC.yyy_navigationBarAlpha == 0)
            {
                [self.navigationBar yyy_updateBarBarTintColor:viewController.yyy_navigationBarBarTintColor];
            }
            
            void(^animationsBlock)(void) = ^(void) {
                [self.navigationBar yyy_updateBarShadowImageColor:viewController.yyy_navigationBarShadowImageColor];
                [self.navigationBar yyy_updateBarAlpha:viewController.yyy_navigationBarAlpha];
                [self.navigationBar yyy_updateBarTintColor:viewController.yyy_navigationBarTintColor];
                [self.navigationBar yyy_updateBarTitleColor:viewController.yyy_navigationBarTitleColor];
                [self.navigationBar yyy_updateBarHeight:viewController.yyy_navigationBarHeight];
                if (!viewController.yyy_backgroundImage)
                {
                    [self.navigationBar yyy_updateBarBarTintColor:viewController.yyy_navigationBarBarTintColor];
                }
            };
            
            void(^complete)(BOOL finish) = ^(BOOL finish) {
                [self yyy_updateNavigationBarWithViewController:self.topViewController];
            };
            
            
            if (fromVC.yyy_backgroundImage || toVC.yyy_backgroundImage)
            {
                if (fromVC.yyy_backgroundImage && toVC.yyy_backgroundImage)
                {
                    self.navigationBar.yyy_backgroundEffectView.alpha = 0;
                    self.navigationBar.yyy_backgroundImageView.image = fromVC.yyy_backgroundImage;
                    [UIView animateWithDuration:duration/2 animations:^{
                        self.navigationBar.yyy_backgroundImageView.alpha = 0;
                    } completion:^(BOOL finished) {
                        self.navigationBar.yyy_backgroundImageView.image = toVC.yyy_backgroundImage;
                        [UIView animateWithDuration:duration/2 animations:^{
                            self.navigationBar.yyy_backgroundImageView.alpha = 1;
                        }];
                    }];
                    
                    [UIView animateWithDuration:duration animations:animationsBlock completion:complete];
                }
                else
                {
                    UIImage *image = nil;
                    CGFloat imageViewAlpha = 0;
                    CGFloat effectViewAlpha = 0;
                    UIColor *barTintColor = nil;
                    
                    if (fromVC.yyy_backgroundImage)
                    {
                        barTintColor = toVC.yyy_navigationBarBarTintColor;
                        image = fromVC.yyy_backgroundImage;
                        imageViewAlpha = 0;
                        effectViewAlpha = 1;
                        if (fromVC.yyy_navigationBarAlpha == 0)
                        {
                            self.navigationBar.yyy_backgroundImageView.alpha = 0;
                        }
                    }
                    else
                    {
                        barTintColor = fromVC.yyy_navigationBarBarTintColor;
                        image = toVC.yyy_backgroundImage;
                        imageViewAlpha =  1;
                        effectViewAlpha = 0;
                        if (toVC.yyy_navigationBarAlpha == 0)
                        {
                            imageViewAlpha = 0;
                        }
                    }
                    self.navigationBar.yyy_backgroundImageView.image = image;
                    [UIView animateWithDuration:duration animations:^{
                        self.navigationBar.yyy_backgroundEffectView.alpha = effectViewAlpha;
                        self.navigationBar.yyy_backgroundImageView.alpha = imageViewAlpha;
                        [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
                        animationsBlock();
                    } completion:complete];
                }
            }
            else
            {
                [UIView animateWithDuration:duration animations:animationsBlock completion:complete];
            }

        }
        else
        {
            __weak typeof (self) weakSelf = self;
            if (@available(iOS 10.0, *))
            {
                [coor notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    __strong typeof (weakSelf) self = weakSelf;
                    [self dealInteractionChanges:context];
                }];
            }
            else
            {
                [coor notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
                    __strong typeof (weakSelf) self = weakSelf;
                    [self dealInteractionChanges:context];
                }];
            }
        }
    }
    
    if ([self.yyy_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)]) {
        [self.yyy_delegate navigationController:navigationController
                        willShowViewController:viewController
                                      animated:animated];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    self.yyy_preferredStatusBarStyle = viewController.preferredStatusBarStyle;
    self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.interactivePopGestureRecognizer.enabled = viewController != self.viewControllers.firstObject;
    self.yyy_currentShowController = viewController;
    [self yyy_updateNavigationBarWithViewController:viewController];
    
    if ([self.yyy_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.yyy_delegate navigationController:navigationController
                         didShowViewController:viewController
                                      animated:animated];
    }
}

- (UIInterfaceOrientationMask) :(UINavigationController *)navigationController
{
    
    if ([self.yyy_delegate respondsToSelector:@selector(navigationControllerSupportedInterfaceOrientations:)]) {
        return [self.yyy_delegate navigationControllerSupportedInterfaceOrientations:navigationController];
    }
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)navigationControllerPreferredInterfaceOrientationForPresentation:(UINavigationController *)navigationController
{
    
    if ([self.yyy_delegate respondsToSelector:@selector(navigationControllerPreferredInterfaceOrientationForPresentation:)]) {
        return [self.yyy_delegate navigationControllerPreferredInterfaceOrientationForPresentation:navigationController];
    }
    return UIInterfaceOrientationPortrait;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController
{
    if ([self.yyy_delegate respondsToSelector:@selector(navigationController:interactionControllerForAnimationController:)]) {
        return [self.yyy_delegate navigationController:navigationController
          interactionControllerForAnimationController:animationController];
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if ([self.yyy_delegate respondsToSelector:@selector(navigationController:animationControllerForOperation:fromViewController:toViewController:)]) {
        return [self.yyy_delegate navigationController:navigationController
                      animationControllerForOperation:operation
                                   fromViewController:fromVC
                                     toViewController:toVC];
    }
    return nil;
}

- (void)dealInteractionChanges:(id<UIViewControllerTransitionCoordinatorContext>)context
{
    NSLog(@"%s",__func__);
    if ([context isCancelled])
    {
        double cancelDuration = [context transitionDuration] * [context percentComplete];
        UIViewController *fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        [UIView animateWithDuration:cancelDuration animations:^{
            [self yyy_updateNavigationBarWithViewController:fromVC];
        } completion:^(BOOL finished) {
            self.yyy_currentShowController = fromVC;
        }];
    }
    else
    {
        // after that, finish the gesture of return
        double finishDuration = [context transitionDuration] * (1 - [context percentComplete]);
        UIViewController *toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        [UIView animateWithDuration:finishDuration animations:^{
            [self yyy_updateNavigationBarWithViewController:toVC];
        } completion:^(BOOL finished) {
            self.yyy_currentShowController = toVC;
        }];
    }
}

#pragma mark - update

- (void)yyy_updateNavigationBarWithViewController:(UIViewController *)vc
{
    [self.navigationBar yyy_updateBarShadowImageColor:vc.yyy_navigationBarShadowImageColor];
    [self.navigationBar yyy_updateBarAlpha:vc.yyy_navigationBarAlpha];
    [self.navigationBar yyy_updateBarTintColor:vc.yyy_navigationBarTintColor];
    [self.navigationBar yyy_updateBarTitleColor:vc.yyy_navigationBarTitleColor];
    [self.navigationBar yyy_updateBarHeight:vc.yyy_navigationBarHeight];
    
    if (vc.yyy_backgroundImage)
    {
        self.navigationBar.yyy_backgroundImageView.alpha = 1;
        self.navigationBar.yyy_backgroundImageView.image = vc.yyy_backgroundImage;
        
        self.navigationBar.yyy_backgroundEffectView.alpha = 0;
        [self.navigationBar yyy_updateBarBarTintColor:vc.yyy_navigationBarBarTintColor];
    }
    else
    {
        self.navigationBar.yyy_backgroundImageView.alpha = 0;
        self.navigationBar.yyy_backgroundImageView.image = vc.yyy_backgroundImage;

        [self.navigationBar yyy_updateBarBarTintColor:vc.yyy_navigationBarBarTintColor];
        self.navigationBar.yyy_backgroundEffectView.alpha = 1;
    }
}

- (void)yyy_updateNavigationBarWithFromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC percent:(CGFloat)percent
{
    //_UIBarBackground alpha 背景透明度，不影响标题跟按钮
    if (fromVC.yyy_navigationBarAlpha != toVC.yyy_navigationBarAlpha)
    {
        CGFloat newBarBackgroundAlpha = MiddleValue(fromVC.yyy_navigationBarAlpha, toVC.yyy_navigationBarAlpha, percent);
        [self.navigationBar yyy_updateBarAlpha:newBarBackgroundAlpha];
    }
    
    //TintColor 按钮颜色
    if (![fromVC.yyy_navigationBarTintColor isEqual:toVC.yyy_navigationBarTintColor])
    {
        UIColor *newTintColor = MiddleColor(fromVC.yyy_navigationBarTintColor, toVC.yyy_navigationBarTintColor, percent);
        [self.navigationBar yyy_updateBarTintColor:newTintColor];
    }
    
    //TitleColor 标题颜色
    if (![fromVC.yyy_navigationBarTitleColor isEqual:toVC.yyy_navigationBarTitleColor])
    {
        UIColor *newTitleColor = MiddleColor(fromVC.yyy_navigationBarTitleColor, toVC.yyy_navigationBarTitleColor, percent);
        [self.navigationBar yyy_updateBarTitleColor:newTitleColor];
    }
    
    //ShadowImage 分割线的颜色
    if (![fromVC.yyy_navigationBarShadowImageColor isEqual:toVC.yyy_navigationBarShadowImageColor])
    {
        UIColor *newShadowColro = MiddleColor(fromVC.yyy_navigationBarShadowImageColor, toVC.yyy_navigationBarShadowImageColor, percent);
        [self.navigationBar yyy_updateBarShadowImageColor:newShadowColro];
    }
    
    if (fromVC.yyy_backgroundImage || toVC.yyy_backgroundImage)
    {
        UIImage *image = nil;
        CGFloat imageViewAlpha = 0;
        CGFloat effectViewAlpha = 0;
        UIColor *barTintColor = nil;
        
        if (fromVC.yyy_backgroundImage && toVC.yyy_backgroundImage)
        {
            CGFloat alpha = ABS(1-percent * 2);
            image = percent < 0.5? fromVC.yyy_backgroundImage : toVC.yyy_backgroundImage;
            imageViewAlpha = alpha;
            effectViewAlpha = 0;
            barTintColor = toVC.yyy_navigationBarBarTintColor;
        }
        else
        {
            UIColor *color = nil;
            if (fromVC.yyy_backgroundImage)
            {
                color = toVC.yyy_navigationBarBarTintColor;
                image = fromVC.yyy_backgroundImage;
                imageViewAlpha = 1 - percent;
                effectViewAlpha = percent;
                if (fromVC.yyy_navigationBarAlpha == 0)
                {
                    imageViewAlpha = 0;
                }
            }
            else
            {
                color = fromVC.yyy_navigationBarBarTintColor;
                image = toVC.yyy_backgroundImage;
                imageViewAlpha =  percent;
                effectViewAlpha = 1 - percent;
                if (toVC.yyy_navigationBarAlpha == 0)
                {
                    imageViewAlpha = 0;
                }
            }
            barTintColor = color;
        }
        
        self.navigationBar.yyy_backgroundImageView.image = image;
        self.navigationBar.yyy_backgroundEffectView.alpha = effectViewAlpha;
        self.navigationBar.yyy_backgroundImageView.alpha = imageViewAlpha;
        [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
    }
    else
    {
        if (![fromVC.yyy_navigationBarBarTintColor isEqual:toVC.yyy_navigationBarBarTintColor])
        {
            UIColor *newBarTintColor = nil;
            if (fromVC.yyy_navigationBarAlpha == 0)
            {
                newBarTintColor = [toVC.yyy_navigationBarBarTintColor colorWithAlphaComponent:percent];
            }
            else
            {
                newBarTintColor = MiddleColor(fromVC.yyy_navigationBarBarTintColor, toVC.yyy_navigationBarBarTintColor, percent);
            }
            [self.navigationBar yyy_updateBarBarTintColor:newBarTintColor];
        }
    }
}

#pragma mark - get,set

- (id<UINavigationControllerDelegate>)delegate
{
    return self;
}

- (void)yyy_setDelegate:(id<UINavigationControllerDelegate>)delegate
{
    self.yyy_delegate = delegate;
}

- (id<UINavigationControllerDelegate>)yyy_delegate
{
    return objc_getAssociatedObject(self, @selector(yyy_delegate));
}

- (void)setYyy_delegate:(id<UINavigationControllerDelegate>)yyy_delegate
{
    if (self == yyy_delegate)
    {
        yyy_delegate = nil;
    }
    objc_setAssociatedObject(self, @selector(yyy_delegate), yyy_delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (UIViewController *)yyy_currentShowController
{
    UIViewController *vc = objc_getAssociatedObject(self, @selector(yyy_currentShowController));
    if (!vc)
    {
        vc = self.topViewController;
    }
    return vc;
}

- (void)setYyy_currentShowController:(UIViewController *)yyy_currentShowController
{
    objc_setAssociatedObject(self, @selector(yyy_currentShowController), yyy_currentShowController, OBJC_ASSOCIATION_ASSIGN);
}

@end

