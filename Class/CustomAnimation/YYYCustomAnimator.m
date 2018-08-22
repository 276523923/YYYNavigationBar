//
//  YYYCustomAnimator.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2018/8/22.
//  Copyright © 2018年 叶越悦. All rights reserved.
//

#import "YYYCustomAnimator.h"

NS_INLINE CGFloat YYY_Navigation_MiddleFloat(CGFloat fromValue,CGFloat toValue,CGFloat percent) {
    return fromValue + (toValue - fromValue) * percent;
}

NS_INLINE UIColor *YYY_Navigation_MiddleColor(UIColor *fromColor,UIColor *toColor,CGFloat percent) {
    CGFloat fromRed = 0;
    CGFloat fromGreen = 0;
    CGFloat fromBlue = 0;
    CGFloat fromAlpha = 0;
    [fromColor getRed:&fromRed green:&fromGreen blue:&fromBlue alpha:&fromAlpha];
    
    CGFloat toRed = 0;
    CGFloat toGreen = 0;
    CGFloat toBlue = 0;
    CGFloat toAlpha = 0;
    [toColor getRed:&toRed green:&toGreen blue:&toBlue alpha:&toAlpha];
    
    CGFloat newRed = YYY_Navigation_MiddleFloat(fromRed,toRed,percent);
    CGFloat newGreen = YYY_Navigation_MiddleFloat(fromGreen,toGreen,percent);
    CGFloat newBlue = YYY_Navigation_MiddleFloat(fromBlue,toBlue,percent);
    CGFloat newAlpha = YYY_Navigation_MiddleFloat(fromAlpha,toAlpha,percent);
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:newAlpha];
}

NS_INLINE NSNumber *YYY_Navigation_MiddleNumber(NSNumber *fromNum,NSNumber *toNum,CGFloat percent) {
    return @(YYY_Navigation_MiddleFloat(fromNum.doubleValue, toNum.doubleValue, percent));
}

@interface YYYAnimationItem ()

@property (nonatomic, readwrite, getter=isReversed) BOOL reversed;

@end

@implementation YYYAnimationItem

+ (instancetype)animatorWithContent:(id)content keyPath:(NSString *)keyPath {
    YYYAnimationItem *animation = [self new];
    animation.content = content;
    animation.keyPath = keyPath;
    return animation;
}

- (id)middleValue {
    if (self.fromValue && self.percentComplete == 0) {
        return self.fromValue;
    }
    
    if (self.toValue && self.percentComplete == 1) {
        return self.toValue;
    }
    
    if (self.middleValueBlock) {
        return self.middleValueBlock(self.fromValue,self.toValue,self.percentComplete);
    }
    
    if (self.fromValue && self.toValue) {
        if ([self.fromValue isKindOfClass:[UIColor class]] &&
            [self.toValue isKindOfClass:[UIColor class]]) {
            return YYY_Navigation_MiddleColor(self.fromValue, self.toValue, self.percentComplete);
        }
        if ([self.fromValue isKindOfClass:[NSNumber class]] &&
            [self.toValue isKindOfClass:[NSNumber class]]) {
            return YYY_Navigation_MiddleNumber(self.fromValue, self.toValue, self.percentComplete);
        }
    }
    return nil;
}

- (void)updateAnimationProgress:(CGFloat)percentComplete {
    _percentComplete = percentComplete;
    if (self.percentCompleteChangeBlock) {
        self.percentCompleteChangeBlock(percentComplete, self.middleValue);
    }
    if (self.contentUpdateBlock) {
        self.contentUpdateBlock(self.content, self.middleValue);
    }
    if (self.content && self.keyPath && [self.content respondsToSelector:NSSelectorFromString(self.keyPath)] && self.middleValue) {
        [self.content setValue:self.middleValue forKey:self.keyPath];
    }
}

@end

@implementation YYYCustomAnimator

- (void)finishAnimation {
    [self finishAnimationAtPosition:YYYAnimatingPositionEnd];
}

- (void)finishAnimationAtPosition:(YYYAnimatingPosition)finalPosition {
    self.reversed = finalPosition == YYYAnimatingPositionStart;
    if (self.animators.count == 0) {
        return;
    }
    CGFloat duration = self.duration;
    CGFloat percentComplete = self.percentComplete;
    if (self.isReversed) {
        duration = duration * percentComplete;
        percentComplete = 0;
    } else {
        duration = duration * (1 - percentComplete);
        percentComplete = 1;
    }
    NSArray *animators = self.animators.copy;
    [UIView animateWithDuration:duration animations:^{
        for (YYYAnimationItem *item in animators) {
            item.reversed = self.reversed;
            [item updateAnimationProgress:percentComplete];
            if (item.finishAnimantionBlock) {
                item.finishAnimantionBlock(self.isReversed);
            }
        }
    }completion:^(BOOL finished) {
        for (YYYAnimationItem *item in animators) {
            if (item.completeBlock) {
                item.completeBlock(item);
            }
        }
    }];
}

- (void)addAnimatorItem:(YYYAnimationItem *)item {
    if ([item isKindOfClass:[YYYAnimationItem class]]) {
        [self.animators addObject:item];
    }
}

- (void)percentCompleteDidChange {
    NSArray *animators = self.animators.copy;
    for (YYYAnimationItem *item in animators) {
        [item updateAnimationProgress:self.percentComplete];
    }
}

#pragma mark - get,set
- (NSMutableArray *)animators {
    if (!_animators) {
        _animators = [NSMutableArray array];
    }
    return _animators;
}

- (void)setPercentComplete:(CGFloat)percentComplete {
    if (_percentComplete != percentComplete) {
        _percentComplete = percentComplete;
        [self percentCompleteDidChange];
    }
}

@end
