//
//  LYQNavigatorViewControllerProtocal.h
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import "LYQURLAction.h"
#import <Foundation/Foundation.h>

@protocol LYQNavigatorViewControllerProtocal <NSObject>

@optional

/**
 页面是否是单例（即在导航堆栈中只会保留一个页面，当跳转到该页面的时候会将其堆栈之上的页面都pop掉）
 默认是NO
 */
+ (BOOL)isSingleton;

/**
 设置该页面是不是modal方式的展示模式
 默认是NO
 */
+ (BOOL)isModalView;

/**
 导航控制器将要显示页面前，会调用handleWithURLAction:方法
 */
- (BOOL)handleWithURLAction:(LYQURLAction *)urlAction;

@end
