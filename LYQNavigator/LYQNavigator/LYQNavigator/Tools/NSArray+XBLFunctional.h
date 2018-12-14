//
//  NSArray+functional.h
//  Nova
//
//  Created by dawei on 12/26/13.
//  Copyright (c) 2013 dianping.com. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^xblfEnumerateBlock)(NSInteger index, id obj);
typedef id (^xblfTransformBlock)(id obj);
typedef BOOL (^xblfValidationBlock)(id obj);
typedef id (^xblfAccumulationBlock)(id sum, id obj);

@interface NSArray (XBLFunctional)

/**
 *  enumerate each object in array with index
 *  @warning if index is not needed, prefer forin loop; consider map select reduce first
 *  @param block side effect logic
 */
- (void)xblf_eachWithIndex:(xblfEnumerateBlock)block;

/**
 *  functional map method
 *
 *  @param block specify mapping relation
 *
 *  @return mapped array
 */
- (NSArray *)xblf_map:(xblfTransformBlock)block;

/**
 *  function select method
 *
 *  @param block logic to specify which to select
 *
 *  @return new array with selectecd objects
 */
- (NSArray *)xblf_select:(xblfValidationBlock)block;

/**
 *  functional reject, similar with select
 *
 *  @param block specify which to reject
 *
 *  @return new array with filterd objects
 */
- (NSArray *)xblf_reject:(xblfValidationBlock)block;

/**
 *  functional reduce method
 *
 *  @param initial sum base
 *  @param block   add logic
 *
 *  @return sum
 */
- (id)xblf_reduce:(id)initial withBlock:(xblfAccumulationBlock)block;

/**
 *  take first n objects as array, if n > array length, return self
 *
 *  @param n number to take
 *
 *  @return array
 */
- (instancetype)xblf_take:(NSUInteger)n;

/**
 *  find the object match condition in array
 *
 *  @param block condition
 *
 *  @return matched object or nil
 */
- (id)xblf_find:(xblfValidationBlock)block;

/**
 *  check whether all objects in array match condition
 *
 *  @param block condition logic
 *
 *  @return allMatched
 */
- (BOOL)xblf_allObjectsMatched:(xblfValidationBlock)block;



/**
 *  check whether any object in array match condition
 *
 *  @param block condition logic
 *
 *  @return antMatvhed
 */
- (BOOL)xblf_anyObjectMatched:(xblfValidationBlock)block;

/**
 *  join array of string to a string
 *
 *  @param seperator join分隔符
 *
 *  @return string
 */
- (NSString *)xblf_join:(NSString *)seperator;

/**
 *  return the first matched object in array
 *
 *  @param block match logic
 *
 *  @return the first matched object, if not found, return nil
 */
- (id)xblf_match:(xblfValidationBlock)block;

/**
 *  check whether array contain matched object
 *
 *  @param block match logic
 *
 *  @return bool
 */
- (BOOL)xblf_existObjectMatch:(xblfValidationBlock)block;

/**
 *  check whether all objects in array match the validation
 *
 *  @param block validation
 *
 *  @return bool
 */
- (BOOL)xblf_allObjectMatch:(xblfValidationBlock)block;


- (NSArray *)xblf_groupBy:(xblfTransformBlock)block;

- (NSArray *)xblf_zip:(NSArray *)array;

- (NSString *)xblf_insertIntoPlaceHolderString:(NSString *)placeHolder;

@end
