//
//  LYQNavigationController.m
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import "LYQNavigationController.h"
@implementation LYQNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

@end
