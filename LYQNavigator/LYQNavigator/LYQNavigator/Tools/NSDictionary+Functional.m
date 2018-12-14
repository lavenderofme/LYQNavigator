//
//  NSDictionary+Functional.m
//  Pods
//
//  Created by gupeng on 2017/6/17.
//
//

#import "NSDictionary+Functional.h"

@implementation NSDictionary (Functional)

- (instancetype)xbl_merge:(NSDictionary *)dic {
    NSMutableDictionary *ret = [self mutableCopy];
    for (id key in dic) {
        ret[key] = dic[key];
    }
    return (id)ret;
}

- (instancetype)xbl_removeNilParam {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *key in self) {
        if (self[key] == [NSNull null]) continue;
        dic[key] = self[key];
    }
    return dic;
}

- (NSDictionary *)xbl_map:(id(^)(id object))block{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:self.count];
    for (NSString *key in self) {
        if (self[key]) {
            dic[key] = block(self[key]);
        }
    }
    return [dic copy];
}

@end
