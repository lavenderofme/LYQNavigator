//
//  UIViewController+LYQNavigator.h
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYQNavigationController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LYQNavigator)

@property (nonatomic, assign) BOOL isGestureBack;
@property (nonatomic, strong) LYQURLAction *urlAction;

- (void)openURL:(NSURL *)url;
- (void)openURLString:(NSString *)urlString;
- (void)openURLAction:(LYQURLAction *)urlAction;

- (void)jumpURL:(NSURL *)url;
- (void)jumpURLString:(NSString *)urlString;
- (void)jumpURLAction:(LYQURLAction *)urlAction;

- (BOOL)pop2Scheme:(NSString *)scheme;
- (BOOL)pop2AnyScheme:(NSArray *)schemeArray;

- (void)backToPreviousViewController;
- (void)gestureBackToPreviousViewController;

@end

NS_ASSUME_NONNULL_END
