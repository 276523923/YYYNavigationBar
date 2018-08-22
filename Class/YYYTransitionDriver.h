//
//  YYYTransitionDriver.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2018/8/17.
//  Copyright © 2018年 叶越悦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYYTransitionDriver : NSObject

@property(nonatomic, strong, readonly) id <UIViewControllerTransitionCoordinator> transitionCoordinator;
@property (nonatomic, weak, readonly) UINavigationController *navigationController;

@property(nonatomic) CGFloat percentComplete;
- (instancetype) initWithNavigationController:(UINavigationController *)navigationController
                        transitionCoordinator:(id <UIViewControllerTransitionCoordinator>) transitionCoordinator;

@end

NS_ASSUME_NONNULL_END
