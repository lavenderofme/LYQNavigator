
//
//  LYQURLMapping.m
//  路由
//
//  Created by 刘燕青 on 2018/12/14.
//  Copyright © 2018 刘燕青. All rights reserved.
//

#import "LYQURLMapping.h"
#import "LYQNavigatorConfig.h"

#define fileNamesOfURLMapping @"urlmapping"

@interface LYQURLMapping ()

@property (nonatomic, strong) NSMutableDictionary *urlMapping; // host与NVURLPattern的映射关系，host为key，NVURLPattern为value

@end

@implementation LYQURLMapping

+ (instancetype)instance {
    static LYQURLMapping *xblMapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xblMapping = [[LYQURLMapping alloc] init];
    });
    return xblMapping;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _urlMapping = [[NSMutableDictionary alloc] init];
        NSString *fileName = fileNamesOfURLMapping;
        NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        if (content) {
            NSArray *eachLine = [content componentsSeparatedByString:@"\n"];
            for (NSString *aString in eachLine) {
                if (aString.length < 1) {
                    // 空行
                    continue;
                }
                NSString *lineString = [aString stringByReplacingOccurrencesOfString:@" " withString:@""];
                if (lineString.length<1) {
                    // 空行
                    continue;
                }
                NSRange commentRange = [lineString rangeOfString:@"#"];
                if (commentRange.location == 0) {
                    // #在开头，表明这一行是注释
                    continue;
                }
                if (commentRange.location != NSNotFound) {
                    // 其后有注释，需要去除后面的注释
                    lineString = [lineString substringToIndex:commentRange.location];
                }
                NSRange tabRange = [lineString rangeOfString:@"\t"];
                BOOL isContainTabT = NO;
                if (tabRange.location != NSNotFound) {
                    isContainTabT = YES;
                    //过滤文本编辑器中\t\t\t\t\t
                    lineString = [lineString stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                }
                
                if ([lineString rangeOfString:@":"].location != NSNotFound) {
                    NSString *omitString = [lineString stringByReplacingOccurrencesOfString:@" " withString:@""];
                    NSArray *kv = [omitString componentsSeparatedByString:@":"];
                    if (kv.count == 2) {
                        // got it
                        NSString *host = [kv[0] lowercaseString];
                        NSString *className = kv[1];
                        // DEBUG check
#if defined(DEBUG)||defined(_DEBUG)
                        // check validate
                        NSAssert(host.length, @"[url mapping error] has no host!!!!");
                        NSAssert(className.length, @"[url mapping error] has no class name!!!!");
                        NSAssert(NSClassFromString(className) != NULL, @"[url mapping error] class:%@ not exist!!!!",className);
                        NSAssert(![self.urlMapping objectForKey:host], @"[url mapping error] host (%@) duplicate!!!!", host);
                        NSAssert(!isContainTabT, @"[url mapping error] host (%@) 中间空格包含 \\t\\t\\t\\t\\t 字符!!!!", host);
#endif
                        _urlMapping[host] = className;
                    }
                }
            }
        } else {
            NSLog(@"[url mapping error] file(%@) is empty!!!!", fileName);
        }
    }
    return self;
}

- (Class)obtainControllerWithHost:(NSString *)host {
    if (!host.length) {
        return NULL;
    }
    NSString *className = [[LYQNavigatorConfig instance] URLMappingFilter:host];
    if (!className.length) {
        className = [self.urlMapping valueForKey:[host lowercaseString]];
    }
    if (!className) {
        return NULL;
    }
    return NSClassFromString(className);
}

@end

