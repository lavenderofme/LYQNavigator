//
//  LYQNavigatorConfig.h
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString * (^URLMappingFilterBlock)(NSString *scheme);

NS_ASSUME_NONNULL_BEGIN

@interface LYQNavigatorConfig : NSObject

/**
 设置URL的协议
 */
@property (nonatomic, copy) NSString *protocol;

+ (instancetype)instance;

/**
针对mappingName可以换对应的路由控制器 (用与替换控制器，如项目中切换webView)
 */
- (void)setURLMappingFilterBlock:(URLMappingFilterBlock)block;

/**
 获取mappingName对应路由控制器的名称
 */
- (NSString *)URLMappingFilter:(NSString *)mappingName;

@end

NS_ASSUME_NONNULL_END
