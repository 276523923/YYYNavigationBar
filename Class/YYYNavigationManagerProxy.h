//
//  YYYNavigationManagerProxy.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2018/8/21.
//  Copyright © 2018年 叶越悦. All rights reserved.
//

#import <Foundation/Foundation.h>
@class YYYNavigationManager;
@interface YYYNavigationManagerProxy : NSProxy

@property (nullable, nonatomic, strong, readonly) YYYNavigationManager *target;

- (instancetype)initWithTarget:(id)target;

+ (id)proxyWithTarget:(id)target;

@end
