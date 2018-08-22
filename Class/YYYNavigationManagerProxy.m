//
//  YYYNavigationManagerProxy.m
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2018/8/21.
//  Copyright © 2018年 叶越悦. All rights reserved.
//

#import "YYYNavigationManagerProxy.h"
#import "YYYNavigationManager.h"

@implementation YYYNavigationManagerProxy

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[self alloc] initWithTarget:target];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    NSString *selectorString = NSStringFromSelector(selector);
    if ([selectorString hasSuffix:@":"] && [selectorString hasPrefix:@"set"] && ![selectorString isEqualToString:@"setIsShow:"]) {
        if (_target.isShow) {
            [_target performSelectorOnMainThread:@selector(reloadNavigationBarStyle) withObject:nil waitUntilDone:NO];
        }
    }
    return _target;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isProxy {
    return YES;
}

- (NSString *)description {
    return [_target description];
}

- (NSString *)debugDescription {
    return [_target debugDescription];
}

@end
