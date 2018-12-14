//
//  NSArray+functional.m
//  Nova
//
//  Created by dawei on 12/26/13.
//  Copyright (c) 2013 dianping.com. All rights reserved.
//

#import "NSArray+XBLFunctional.h"

@implementation NSArray (XBLFunctional)

- (void)xblf_eachWithIndex:(xblfEnumerateBlock)block {
    NSInteger index = 0;
    for (id obj in self) {
        block(index, obj);
        index++;
    }
}

- (NSArray *)xblf_map:(xblfTransformBlock)block{
    NSParameterAssert(block != nil);
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:self.count];
    for (id obj in self) {
        [ret addObject:block(obj)];
    }
    return ret;
}

- (NSArray *)xblf_select:(xblfValidationBlock)block{
    NSParameterAssert(block != nil);
	return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return block(obj);
	}]];
}

- (NSArray *)xblf_reject:(xblfValidationBlock)block{
    NSParameterAssert(block != nil);
	
	return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return !block(obj);
	}]];
}

- (id)xblf_reduce:(id)initial withBlock:(xblfAccumulationBlock)block {
	NSParameterAssert(block != nil);
	id result = initial;
    
    for (id obj in self) {
        result = block(result, obj);
    }
	return result;
}

- (instancetype)xblf_take:(NSUInteger)n {
    if ([self count] <= n) return self;
    return [self subarrayWithRange:NSMakeRange(0, n)];
}

- (id)xblf_find:(xblfValidationBlock)block {
    for (id obj in self) {
        if (block(obj)) {
            return obj;
        }
    }
    return nil;
}

- (id)xblf_match:(xblfValidationBlock)block {
    for (id object in self) {
        if (block(object)) {
            return object;
        }
    }
    return nil;
}

- (BOOL)xblf_allObjectsMatched:(xblfValidationBlock)block {
    for (id obj in self) {
        if (!block(obj)) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)xblf_anyObjectMatched:(xblfValidationBlock)block {
    for (id obj in self) {
        if (block(obj)) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)xblf_join:(NSString *)seperator {
    NSMutableString *string = [NSMutableString string];
    [self xblf_eachWithIndex:^(NSInteger index, id obj) {
        if (index != 0) {
            [string appendString:seperator];
        }
        [string appendString:obj];
    }];
    return string;
    
}

- (BOOL)xblf_existObjectMatch:(xblfValidationBlock)block {
    return [self xblf_match:block] != nil;
}

- (BOOL)xblf_allObjectMatch:(xblfValidationBlock)block {
    return [self xblf_match:^BOOL(id obj) {
        return !block(obj);
    }] == nil;
}

- (NSArray *)xblf_groupBy:(xblfTransformBlock)block {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (id obj in self) {
        NSString *key = block(obj);
        if (dic[key] == nil) {
            dic[key] = [NSMutableArray array];
        }
        [dic[key] addObject:obj];
    }
    return [dic allValues];
}

- (NSArray *)xblf_zip:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray array];
    [self xblf_eachWithIndex:^(NSInteger index, id obj) {
        [result addObject:obj];
        if (index >= array.count) return;
        [result addObject:array[index]];
    }];
    return result;
}

- (NSString *)xblf_insertIntoPlaceHolderString:(NSString *)placeHolder {
    NSArray *components = [placeHolder componentsSeparatedByString:@"%%"];
    if ([components count] < 2) return placeHolder;
    return [[components xblf_zip:self] xblf_join:@""];
}

@end
