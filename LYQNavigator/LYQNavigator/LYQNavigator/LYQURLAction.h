//
//  LYQURLAction.h
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LYQNavigatorCompletionHandler)(NSDictionary *returnParams);

NS_ASSUME_NONNULL_BEGIN

@interface LYQURLAction : NSObject

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) LYQNavigatorCompletionHandler completionHandler;

- (instancetype)initWithUrl:(NSURL *)url;
- (instancetype)initWithUrlString:(NSString *)urlString;
- (instancetype)initWithUrl:(NSURL *)url completionHandler:(LYQNavigatorCompletionHandler)completionHandler;

- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key;
- (void)setDouble:(double)doubleValue forKey:(NSString *)key;
- (void)setBoolean:(BOOL)boolValue forKey:(NSString *)key;
- (void)setString:(NSString *)stringValue forKey:(NSString *)key;
- (void)setAnyObject:(id)object forKey:(NSString *)key;

- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;

/**
 如果参数不为4中基本类型，可以使用anyObject进行传递
 不建议使用该方法
 anyObject不支持在URL中进行传递
 */
- (id)anyObjectForKey:(NSString *)key;

- (NSDictionary *)queryDictionary;

@end

NS_ASSUME_NONNULL_END
