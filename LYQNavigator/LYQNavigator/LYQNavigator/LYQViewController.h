//
//  LYQViewController.h
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYQNavigatorViewControllerProtocal.h"
#import "UIViewController+LYQNavigator.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYQViewController :UIViewController <LYQNavigatorViewControllerProtocal>

+ (BOOL)isSingleton;
+ (BOOL)isModalView;

- (BOOL)handleWithURLAction:(LYQURLAction *)urlAction;

- (BOOL)canSlideBack;


@end

NS_ASSUME_NONNULL_END
