//
//  NSDictionary+Functional.h
//  Pods
//
//  Created by gupeng on 2017/6/17.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Functional)

- (instancetype)xbl_merge:(NSDictionary *)dic;

- (instancetype)xbl_removeNilParam;

- (NSDictionary *)xbl_map:(id(^)(id object))block;

@end
