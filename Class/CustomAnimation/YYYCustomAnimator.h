//
//  YYYCustomAnimator.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2018/8/22.
//  Copyright © 2018年 叶越悦. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YYYAnimatingPosition) {
    YYYAnimatingPositionStart,
    YYYAnimatingPositionEnd
};

@class YYYCustomAnimator;
@interface YYYAnimationItem : NSObject

@property (nonatomic, weak) id content;
@property (nonatomic, copy) NSString *keyPath;

@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;

@property (nonatomic, readonly, getter=isReversed) BOOL reversed;
@property (nonatomic, readonly) CGFloat percentComplete;

@property (nonatomic, strong, readonly) id middleValue;/**< get from middleValueBlock() */

@property (nonatomic, copy) id(^middleValueBlock)(id fromValue,id toValue,CGFloat fractionComplete);

@property (nonatomic, copy) void(^percentCompleteChangeBlock)(CGFloat fractionComplete, id middleValue);

@property (nonatomic, copy) void(^finishAnimantionBlock)(BOOL isReversed);

@property (nonatomic, copy) void(^contentUpdateBlock)(id content, id middleValue);

@property (nonatomic, copy) void(^completeBlock)(YYYAnimationItem *item);

+ (instancetype)animatorWithContent:(id)content keyPath:(NSString *)keyPath;

- (void)updateAnimationProgress:(CGFloat)percentComplete;

@end

@interface YYYCustomAnimator : NSObject

@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) CGFloat percentComplete;
@property (nonatomic, getter=isReversed) BOOL reversed;
@property (nonatomic, strong) NSMutableArray *animators;

- (void)addAnimatorItem:(YYYAnimationItem *)item;

/**
 finishAnimationAtPosition:YYYAnimatingPositionEnd
 */
- (void)finishAnimation;
- (void)finishAnimationAtPosition:(YYYAnimatingPosition)finalPosition;

@end
