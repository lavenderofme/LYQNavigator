//
//  UINavigationController+LYQNavigator.h
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYQURLAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (LYQNavigator)

/**
 在当前的NVNavigator栈中打开新的URL
 简写方法是: NVOpenURLAction(NVURLAction *urlAction)
 
 可以向NVURLAction中传入制定的参数，参数可以为integer, double, string, NVObject四种类型
 bool的参数可以用0和1表示
 如果希望传入任意对象，可以使用setAnyObject:forKey:方法
 
 URL中附带的参数和setXXX:forKey:所设置的参数等价，
 例如下面两种写法是等价的：
 NVURLAction *a = [NVURLAction actionWithURL:@"xbl://shop?id=1"];
 和
 NVURLAction *a = [NVURLAction actionWithURL:@"xbl://shop"];
 [a setInteger:1 forKey:@"id"]
 
 在获取参数时，调用[a integerForKey:@"id"]，返回值均为1
 */

- (void)openURLString:(NSString *)urlString fromViewController:(UIViewController *)controller;

- (void)openURL:(NSURL *)url fromViewController:(UIViewController *)controller;

- (void)openURLAction:(LYQURLAction *)urlAction fromViewController:(UIViewController *)controller;

- (BOOL)pop2Scheme:(NSString *)scheme;

- (BOOL)pop2AnyScheme:(NSArray *)schemeArray;

@end

NS_ASSUME_NONNULL_END
