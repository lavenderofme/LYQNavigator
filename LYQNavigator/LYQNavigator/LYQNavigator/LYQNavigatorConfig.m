//
//  LYQNavigatorConfig.m
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import "LYQNavigatorConfig.h"

@interface LYQNavigatorConfig()

@property (nonatomic, copy) URLMappingFilterBlock mappingFilterBlock;

@end

@implementation LYQNavigatorConfig

+ (instancetype)instance {
    static LYQNavigatorConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[LYQNavigatorConfig alloc] init];
    });
    return config;
}

- (void)setURLMappingFilterBlock:(URLMappingFilterBlock)block {
    _mappingFilterBlock = block;
}

- (NSString *)URLMappingFilter:(NSString *)scheme {
    if (_mappingFilterBlock) {
        return _mappingFilterBlock(scheme);
    } else {
        return nil;
    }
}


@end
