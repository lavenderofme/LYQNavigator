//
//  LYQURLAction.m
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import "LYQURLAction.h"
#import "NSURL+Ext.h"
#import "NSDictionary+Functional.h"
#import "NSString+Ext.h"
#import "LYQNavigatorConfig.h"

typedef NS_ENUM(NSInteger,LYQUrlJumpType) {
    LYQUrlJumpDefault = 0,
    LYQUrlJumpNative = 1,
    LYQURlJumpWeb = 2,
    LYQURlJumpWebEcode = 3
};

@interface LYQURLAction ()

@property (nonatomic,strong) NSMutableDictionary *params;

@end

@implementation LYQURLAction

- (instancetype)initWithUrl:(NSURL *)url {
    self = [super init];
    if (self) {
        _url = [self defaultDealUrl:url];
        _params = [NSMutableDictionary dictionary];
        NSDictionary *dic = [_url parseQuery];
        for (NSString *key in [dic allKeys]) {
            _params[[key lowercaseString]] = [dic valueForKey:key];
        }
    }
    return self;
}

- (instancetype)initWithUrlString:(NSString *)urlString {
    return [self initWithUrl:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithUrl:(NSURL *)url completionHandler:(LYQNavigatorCompletionHandler)completionHandler {
    self = [self initWithUrl:url];
    self.completionHandler = completionHandler;
    return self;
}

- (NSURL *)defaultDealUrl:(NSURL *)url {
    if (!url || url.absoluteString.length == 0) {
        return url;
    }
    LYQUrlJumpType defaultJumpType = [self defaultJumpTypeWithURl:url];
    switch (defaultJumpType) {
        case LYQUrlJumpDefault:
            return url;
        case LYQUrlJumpNative:
            return [self nativeJumpWithUrl:url.absoluteString];
        case LYQURlJumpWeb:
            return [self webJumpWithUrl:[url.absoluteString urlEncode]];
        case LYQURlJumpWebEcode:
            return [self webJumpWithUrl:url.absoluteString];
        default:
            return url;
    }
}

- (NSURL *)nativeJumpWithUrl:(NSString *)urlString {
    NSString *scheme = [LYQNavigatorConfig instance].scheme;
    scheme = scheme.length > 0 ? scheme : @"lyq";
    NSString* url = [NSString stringWithFormat:@"%@://%@",scheme,urlString];
    return [NSURL URLWithString:url];
}

- (NSURL *)webJumpWithUrl:(NSString *)urlString {
    NSString *scheme = [LYQNavigatorConfig instance].scheme;
    scheme = scheme.length > 0 ? scheme : @"lyq";
    NSString* url = [NSString stringWithFormat:@"%@://web?url=%@",scheme,urlString];
    return [NSURL URLWithString:url];
}

- (LYQUrlJumpType)defaultJumpTypeWithURl:(NSURL *)url {
    LYQUrlJumpType jumpType = LYQUrlJumpDefault;
    NSString *scheme = [url.scheme lowercaseString];
    NSString *absoluteString = [url.absoluteString lowercaseString];
    if (scheme.length != 0) {
        if (![scheme isEqualToString:@"http"] && ![scheme isEqualToString:@"https"]) {
            jumpType = LYQUrlJumpDefault;
        } else {
            jumpType = LYQURlJumpWeb;
        }
    } else {
        if (![absoluteString hasPrefix:@"http"]  && ![absoluteString hasPrefix:@"https"]) {
            jumpType = LYQUrlJumpNative;
        } else {
            jumpType = LYQURlJumpWebEcode;
        }
    }
    return jumpType;
}

- (void)setInteger:(NSInteger)intValue forKey:(NSString *)key {
    [_params setValue:[NSNumber numberWithInteger:intValue] forKey:[key lowercaseString]];
}

- (void)setDouble:(double)doubleValue forKey:(NSString *)key {
    [_params setValue:[NSNumber numberWithDouble:doubleValue] forKey:[key lowercaseString]];
}

- (void)setBoolean:(BOOL)boolValue forKey:(NSString *)key {
    [_params setValue:[NSNumber numberWithBool:boolValue]forKey:[key lowercaseString]];
}

- (void)setString:(NSString *)stringValue forKey:(NSString *)key {
    if (stringValue.length > 0) {
        [_params setValue:stringValue forKey:[key lowercaseString]];
    }
}

- (void)setAnyObject:(id)object forKey:(NSString *)key {
    [_params setValue:object forKey:[key lowercaseString]];
}

- (NSInteger)integerForKey:(NSString *)key{
    id value = [_params valueForKey:[key lowercaseString]];
    if (value) {
        if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value integerValue];
        } else if ([value isKindOfClass:[NSNumber class]]){
            return [(NSNumber *)value integerValue];
        }
    }
    return 0;
}

- (double)doubleForKey:(NSString *)key {
    id value = [_params objectForKey:[key lowercaseString]];
    if(value) {
        if ([value isKindOfClass:[NSString class]]) {
            return [value doubleValue];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value doubleValue];
        }
    }
    return .0;
}

- (BOOL)boolForKey:(NSString *)key{
    id value = [_params objectForKey:[key lowercaseString]];
    if(value) {
        if ([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value boolValue];
        } else if ([value isKindOfClass:[NSString class]]) {
            return [(NSString *)value boolValue];
        }
    }
    return NO;
}

- (NSString *)stringForKey:(NSString *)key{
    NSString *value = [_params objectForKey:[key lowercaseString]];
    if(value) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        }
    }
    return nil;
}

- (id)anyObjectForKey:(NSString *)key{
    return [_params objectForKey:[key lowercaseString]];
}

- (NSDictionary *)queryDictionary{
    return [self.params copy];
}

- (NSString *)description {
    if([_params count]) {
        NSMutableArray *paramsDesc = [NSMutableArray arrayWithCapacity:_params.count];
        for(NSString *key in [_params keyEnumerator]) {
            id value = [_params objectForKey:[key lowercaseString]];
            if ([value isKindOfClass:[NSString class]]) {
                [paramsDesc addObject:[NSString stringWithFormat:@"%@=%@", [key lowercaseString], [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
            } else {
                [paramsDesc addObject:[NSString stringWithFormat:@"%@=%@", [key lowercaseString], value]];
            }
        }
        NSString *urlString = [_url absoluteString];
        NSRange range = [urlString rangeOfString:@"?"];
        if (range.location != NSNotFound) {
            NSString *pureURLStirng = [urlString substringToIndex:range.location];
            return [pureURLStirng stringByAppendingFormat:@"?%@",[paramsDesc componentsJoinedByString:@"&"]];
        } else {
            return [urlString stringByAppendingFormat:@"?%@",[paramsDesc componentsJoinedByString:@"&"]];
        }
    } else {
        return [_url absoluteString];
    }
}


@end
