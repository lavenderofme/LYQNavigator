//
//  LYQURLMapping.h
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYQURLMapping : NSObject

+ (instancetype)instance;
- (Class)obtainControllerWithHost:(NSString *)host;

@end

NS_ASSUME_NONNULL_END
