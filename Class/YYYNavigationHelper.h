//
//  YYYNavigationHelper.h
//  YYYNavigationBar
//
//  Created by 叶越悦 on 2017/9/18.
//  Copyright © 2017年 叶越悦. All rights reserved.
//

#ifndef YYYNavigationHelper_h
#define YYYNavigationHelper_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static inline void SwapSEL(Class cls, SEL originSEL,SEL newSEL) {
    Method originMethod = class_getInstanceMethod(cls, originSEL);
    Method swizzledMethod = class_getInstanceMethod(cls, newSEL);
    method_exchangeImplementations(originMethod, swizzledMethod);
}

static inline UIView *ViewMatchingPredicate(UIView *view, NSPredicate *predicate) {
    if ([predicate evaluateWithObject:view]) {
        return view;
    }
    for (UIView *subview in view.subviews) {
        UIView *match = ViewMatchingPredicate(subview,predicate);
        if (match) return match;
    }
    return nil;
}

static inline __kindof UIView *ViewOfClass(UIView *view, Class viewClass) {
    if (!viewClass) {
        return nil;
    }
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, __unused NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:viewClass];
    }];
    return ViewMatchingPredicate(view, predicate);
}


static inline void LogSubview(UIView *view, NSString *pre){
    NSLog(@"%@:%p-%@-%@",pre,view,NSStringFromClass(view.class),view.backgroundColor);
    for (UIView *subView in view.subviews) {
        if (subView.subviews.count > 0) {
            LogSubview(subView,[pre stringByAppendingString:@"-"]);
        } else {
            NSLog(@"%@:%p-%@-%@",[pre stringByAppendingString:@"-"],subView,NSStringFromClass(subView.class),subView.backgroundColor);
        }
    }
}


#endif /* YYYNavigationHelper_h */
