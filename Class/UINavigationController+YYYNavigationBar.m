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

@end


@implementation UINavigationController (YYYNavigationBar)

static CGFloat yyy_customFromViewAlpha = 0;
static CGFloat yyy_customToViewAlpha = 0;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SwapSEL(self,NSSelectorFromString(@"_updateInteractiveTransition:"), @selector(yyy_updateInteractiveTransition:));
        SwapSEL(self, @selector(setDelegate:), @selector(yyy_setDelegate:));
        SwapSEL(self, @selector(setNavigationBarHidden:animated:), @selector(yyy_setNavigationBarHidden:animated:));
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

- (void)yyy_setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated
{
    [self yyy_setNavigationBarHidden:hidden animated:animated];
    if (self.topViewController.yyy_hiddenNavigationBar != hidden)
    {
        self.topViewController.yyy_hiddenNavigationBar = hidden;
    }
}

#pragma mark - UINavigationController Delegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    yyy_customFromViewAlpha  = 0;
    yyy_customToViewAlpha = 0;
    if (self.yyy_currentShowController.yyy_customBarBackgroundView)
    {
        yyy_customFromViewAlpha = self.yyy_currentShowController.yyy_customBarBackgroundView.alpha;
    }
   
    if (viewController.yyy_customBarBackgroundView)
    {
        yyy_customToViewAlpha = viewController.yyy_customBarBackgroundView.alpha;
        UIView *toVCView = viewController.yyy_customBarBackgroundView;
        UIView *fromVCView = self.navigationBar.yyy_customBackgroundView;
        if (fromVCView == toVCView)
        {
            fromVCView = nil;
        }
        if (fromVCView)
        {
            toVCView.frame = fromVCView.frame;
//            toVCView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [[self.navigationBar yyy_UIBarBackgroundView] insertSubview:toVCView belowSubview:fromVCView];
            toVCView.alpha = 0;
        }
        else
        {
            [self.navigationBar yyy_updateBackgroundView:toVCView];
        }
    }
    
    if (animated)
    {
        id<UIViewControllerTransitionCoordinator> coor = [navigationController.topViewController transitionCoordinator];
        if (![coor initiallyInteractive])
        {
            UIViewController *fromVC = [coor viewControllerForKey:UITransitionContextFromViewControllerKey];
            UIViewController *toVC = viewController;
            CGFloat duration = self.transitionCoordinator.transitionDuration;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration *0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.yyy_preferredStatusBarStyle = viewController.yyy_preferredStatusBarStyle;
            });
            
            UIView *fromVCView = fromVC.yyy_customBarBackgroundView;
            UIView *toVCView = toVC.yyy_customBarBackgroundView;
            toVCView.alpha = 0;
            
            CGFloat toViewAlpha = toVC.yyy_navigationBarAlpha == 0? 0:yyy_customToViewAlpha;
            CGFloat effectViewAlpha = toVCView? 0:1;
            UIColor *barTintColor = toVC.yyy_navigationBarBarTintColor;
            UIColor *shadowColor = toVC.yyy_navigationBarShadowImageColor;
            
            if (fromVC.yyy_navigationBarAlpha == 0)
            {
                fromVCView.alpha = 0;
                [self.navigationBar yyy_updateBarBarTintColor:toVC.yyy_navigationBarBarTintColor];
                [self.navigationBar yyy_updateBarShadowImageColor:toVC.yyy_navigationBarShadowImageColor];
            }
            
            if (toVC.yyy_navigationBarAlpha == 0)
            {
                effectViewAlpha = 0;
                shadowColor = fromVC.yyy_navigationBarShadowImageColor;
                barTintColor = fromVC.yyy_navigationBarBarTintColor;
            }
            
            if (fromVCView && toVCView)
            {
                toVCView.frame = fromVCView.frame;
                toVCView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
                [[self.navigationBar yyy_UIBarBackgroundView] insertSubview:toVCView aboveSubview:fromVCView];
            }
            else if (toVCView)
            {
                barTintColor = fromVC.yyy_navigationBarBarTintColor;
                [self.navigationBar yyy_updateBackgroundView:toVC.yyy_customBarBackgroundView];
            }
            else if (fromVCView)
            {
                [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
            }
            
            [UIView animateWithDuration:duration animations:^{
                fromVCView.alpha = 0;
                toVCView.alpha = toViewAlpha;
                self.navigationBar.yyy_backgroundEffectView.alpha = effectViewAlpha;
            
                [self.navigationBar yyy_updateBarAlpha:toVC.yyy_navigationBarAlpha];
                [self.navigationBar yyy_updateBarTintColor:toVC.yyy_navigationBarTintColor];
                [self.navigationBar yyy_updateBarTitleColor:toVC.yyy_navigationBarTitleColor];
                [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
                [self.navigationBar yyy_updateBarShadowImageColor:shadowColor];
                if (self.yyy_viewControllerTransitionAnimationsBlock)
                {
                    self.yyy_viewControllerTransitionAnimationsBlock(fromVC, toVC, duration);
                }
            } completion:^(BOOL finished) {
                [self.navigationBar yyy_updateBackgroundView:toVCView];
                fromVCView.alpha = yyy_customFromViewAlpha;
                toVCView.alpha = yyy_customToViewAlpha;
                if (self.yyy_transitionCompleteBlock)
                {
                    self.yyy_transitionCompleteBlock(toVC);
                }
            }];
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
    else
    {
        self.yyy_preferredStatusBarStyle = viewController.yyy_preferredStatusBarStyle;
    }
    
    if (self.navigationController.navigationBarHidden != viewController.yyy_hiddenNavigationBar)
    {
        [self setNavigationBarHidden:viewController.yyy_hiddenNavigationBar animated:animated];
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
    self.interactivePopGestureRecognizer.enabled = viewController != self.viewControllers.firstObject;
    self.yyy_currentShowController = viewController;
    [self yyy_updateNavigationBarWithViewController:viewController];

    if ([self.yyy_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)]) {
        [self.yyy_delegate navigationController:navigationController
                         didShowViewController:viewController
                                      animated:animated];
    }
}

- (UIInterfaceOrientationMask)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController
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
    UIViewController *fromVC = nil;
    UIViewController *toVC = nil;
    CGFloat duration = 0;
    BOOL cancelled = [context isCancelled];
    if (cancelled)
    {
        fromVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        toVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        duration = [context transitionDuration] * [context percentComplete];
        
        CGFloat temp = yyy_customFromViewAlpha;
        yyy_customFromViewAlpha = yyy_customToViewAlpha;
        yyy_customToViewAlpha = temp;
    }
    else
    {
        fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        duration = [context transitionDuration] * (1 - [context percentComplete]);
    }
    UIView *fromVCView = fromVC.yyy_customBarBackgroundView;
    UIView *toVCView = toVC.yyy_customBarBackgroundView;
    CGFloat toViewAlpha = toVC.yyy_navigationBarAlpha == 0? 0:yyy_customToViewAlpha;
    CGFloat effectViewAlpha = toVCView? 0:1;
    UIColor *barTintColor = toVC.yyy_navigationBarBarTintColor;
    UIColor *shadowColor = toVC.yyy_navigationBarShadowImageColor;
    if (toVC.yyy_navigationBarAlpha == 0)
    {
        effectViewAlpha = 0;
        shadowColor = fromVC.yyy_navigationBarShadowImageColor;
        barTintColor = fromVC.yyy_navigationBarBarTintColor;
    }
    [UIView animateWithDuration:duration animations:^{
        fromVCView.alpha = 0;
        toVCView.alpha = toViewAlpha;
        self.navigationBar.yyy_backgroundEffectView.alpha = effectViewAlpha;
        [self.navigationBar yyy_updateBarAlpha:toVC.yyy_navigationBarAlpha];
        [self.navigationBar yyy_updateBarTintColor:toVC.yyy_navigationBarTintColor];
        [self.navigationBar yyy_updateBarTitleColor:toVC.yyy_navigationBarTitleColor];
        [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
        [self.navigationBar yyy_updateBarShadowImageColor:shadowColor];
        if (self.yyy_viewControllerTransitionAnimationsBlock)
        {
            self.yyy_viewControllerTransitionAnimationsBlock(fromVC, toVC, duration);
        }
    } completion:^(BOOL finished) {
        if (cancelled)
        {
            [fromVCView removeFromSuperview];
        }
        else
        {
            if (self.yyy_transitionCompleteBlock)
            {
                self.yyy_transitionCompleteBlock(toVC);
            }
        }
        [self.navigationBar yyy_updateBackgroundView:toVCView];
        fromVCView.alpha = yyy_customFromViewAlpha;
        toVCView.alpha = yyy_customToViewAlpha;
        
    }];
}

#pragma mark - update

- (void)yyy_updateNavigationBarWithViewController:(UIViewController *)vc
{
    [self.navigationBar yyy_updateBarShadowImageColor:vc.yyy_navigationBarShadowImageColor];
    [self.navigationBar yyy_updateBarAlpha:vc.yyy_navigationBarAlpha];
    [self.navigationBar yyy_updateBarTintColor:vc.yyy_navigationBarTintColor];
    [self.navigationBar yyy_updateBarTitleColor:vc.yyy_navigationBarTitleColor];
    [self.navigationBar yyy_updateBackgroundView:vc.yyy_customBarBackgroundView];
    [self.navigationBar yyy_updateBarBarTintColor:vc.yyy_navigationBarBarTintColor];
    if (vc.yyy_customBarBackgroundView)
    {
        self.navigationBar.yyy_backgroundEffectView.alpha = 0;
    }
    else
    {
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
        UIColor *shadowColor = nil;
        if (fromVC.yyy_navigationBarAlpha == 0)
        {
            shadowColor = toVC.yyy_navigationBarShadowImageColor;
        }
        else if (toVC.yyy_navigationBarAlpha == 0)
        {
            shadowColor = fromVC.yyy_navigationBarShadowImageColor;
        }
        else
        {
            shadowColor = MiddleColor(fromVC.yyy_navigationBarShadowImageColor, toVC.yyy_navigationBarShadowImageColor, percent);
        }
        [self.navigationBar yyy_updateBarShadowImageColor:shadowColor];
    }
    
    
    UIView *fromVCView = fromVC.yyy_customBarBackgroundView;
    UIView *toVCView = toVC.yyy_customBarBackgroundView;
    
    CGFloat toViewAlpha = yyy_customToViewAlpha * percent;
    CGFloat effectViewAlpha = 0;
    CGFloat fromViewAlpha = yyy_customFromViewAlpha * (1 - percent);
    
    UIColor *barTintColor = nil;
    if (fromVCView && toVCView)
    {
        effectViewAlpha = 0;
        if (![[self.navigationBar yyy_UIBarBackgroundView].subviews containsObject:toVCView])
        {
            toVCView.frame = fromVCView.frame;
            toVCView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [[self.navigationBar yyy_UIBarBackgroundView] insertSubview:toVCView belowSubview:fromVCView];
            toVCView.alpha = 0;
        }
    }
    else if (toVCView)
    {
        effectViewAlpha = 1 - percent;
        barTintColor = fromVC.yyy_navigationBarBarTintColor;
        [self.navigationBar yyy_updateBackgroundView:toVCView];
    }
    else if (fromVCView)
    {
        effectViewAlpha = percent;
        barTintColor = toVC.yyy_navigationBarBarTintColor;
    }
    else
    {
        effectViewAlpha = 1;
        barTintColor = MiddleColor(fromVC.yyy_navigationBarBarTintColor, toVC.yyy_navigationBarBarTintColor, percent);
    }
    
    if (fromVC.yyy_navigationBarAlpha == 0)
    {
        fromViewAlpha = 0;
        barTintColor = toVC.yyy_navigationBarBarTintColor;
    }
    
    if (toVC.yyy_navigationBarAlpha == 0)
    {
        toViewAlpha = 0;
        barTintColor = fromVC.yyy_navigationBarBarTintColor;
    }
    
    [self.navigationBar yyy_updateBarBarTintColor:barTintColor];
    self.navigationBar.yyy_backgroundEffectView.alpha = effectViewAlpha;
    fromVCView.alpha = fromViewAlpha;
    toVCView.alpha = toViewAlpha;
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

- (void)setYyy_viewControllerTransitionAnimationsBlock:(void (^)(UIViewController *, UIViewController *, CGFloat))yyy_viewControllerTransitionAnimationsBlock
{
    objc_setAssociatedObject(self, @selector(yyy_viewControllerTransitionAnimationsBlock), yyy_viewControllerTransitionAnimationsBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);

}

- (void (^)(UIViewController *, UIViewController *, CGFloat))yyy_viewControllerTransitionAnimationsBlock
{
    return objc_getAssociatedObject(self, @selector(yyy_viewControllerTransitionAnimationsBlock));
}

- (void)setYyy_transitionCompleteBlock:(void (^)(UIViewController *))yyy_transitionCompleteBlock
{
    objc_setAssociatedObject(self, @selector(yyy_transitionCompleteBlock), yyy_transitionCompleteBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIViewController *))yyy_transitionCompleteBlock
{
    return objc_getAssociatedObject(self, @selector(yyy_transitionCompleteBlock));
}



@end

