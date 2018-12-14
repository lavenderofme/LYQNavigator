
//
//  UIViewController+LYQNavigator.m
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import "UIViewController+LYQNavigator.h"
#import "LYQNavigationController.h"
#import <objc/runtime.h>
#import "LYQNavigatorViewControllerProtocal.h"

@implementation UIViewController (LYQNavigator)
- (void)openURL:(NSURL *)url {
    LYQURLAction *urlAction = [[LYQURLAction alloc] initWithUrl:url];
    [self openURLAction:urlAction];
}

- (void)openURLString:(NSString *)urlString {
    LYQURLAction *urlAction = [[LYQURLAction alloc] initWithUrlString:urlString];
    [self openURLAction:urlAction];
}

- (void)openURLAction:(LYQURLAction *)urlAction {
    UIViewController *navigator = (UIViewController *)[[UIApplication sharedApplication] keyWindow].rootViewController;
    if ([navigator isKindOfClass:[LYQNavigationController class]]) {
        [(LYQNavigationController *)navigator openURLAction:urlAction fromViewController:self];
    }
}

- (void)jumpURL:(NSURL *)url {
    LYQURLAction *urlAction = [[LYQURLAction alloc] initWithUrl:url];
    [self jumpURLAction:urlAction];
}

- (void)jumpURLString:(NSString *)urlString {
    LYQURLAction *urlAction = [[LYQURLAction alloc] initWithUrlString:urlString];
    [self jumpURLAction:urlAction];
}

- (void)jumpURLAction:(LYQURLAction *)urlAction {
    [self openURLAction:urlAction];
    
    UIViewController *viewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    if ([viewController isKindOfClass:[LYQNavigationController class]]) {
        LYQNavigationController *navigator = (LYQNavigationController *)viewController;
        NSMutableArray *array = [NSMutableArray arrayWithArray:navigator.viewControllers];
        if (array.count > 0) {
            [array removeObject:self];
        }
        [navigator setViewControllers:array animated:YES];
    }
}

- (BOOL)pop2Scheme:(NSString *)scheme {
    if (scheme.length) {
        return [self pop2AnyScheme:@[scheme]];
    }
    return NO;
}

- (BOOL)pop2AnyScheme:(NSArray *)schemeArray {
    if ([self.navigationController isKindOfClass:[LYQNavigationController class]]) {
        return [(LYQNavigationController *)self.navigationController pop2AnyScheme:schemeArray];
    }
    return NO;
}

- (void)backToPreviousViewController {
    BOOL isModalView = NO;
    if ([[self class] respondsToSelector:@selector(isModalView)]) {
        isModalView = [[self class] isModalView];
    }
    if (isModalView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (self.navigationController && !self.isGestureBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)gestureBackToPreviousViewController {
    self.isGestureBack = YES;
    [self backToPreviousViewController];
}

- (void)setIsGestureBack:(BOOL)isGestureBack {
    NSNumber *number = [NSNumber numberWithBool:isGestureBack];
    objc_setAssociatedObject(self, @selector(isGestureBack), number, OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)isGestureBack {
    NSNumber *number = objc_getAssociatedObject(self, @selector(isGestureBack));
    return [number boolValue];
}

- (void)setUrlAction:(LYQURLAction *)urlAction {
    objc_setAssociatedObject(self, @selector(urlAction), urlAction, OBJC_ASSOCIATION_RETAIN);
}

- (LYQURLAction *)urlAction {
    return objc_getAssociatedObject(self, @selector(urlAction));
}

@end

