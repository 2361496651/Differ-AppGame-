//
//  NSObject+Accessors.h
//  AGVideo
//
//  Created by Mao on 16/1/15.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Accessors)

@end

@interface NSObject (NSDictionary_Accessors)
- (BOOL)isKindOfClass:(Class)aClass forKey:(NSString *)key;
- (BOOL)isMemberOfClass:(Class)aClass forKey:(NSString *)key;
- (BOOL)isArrayForKey:(NSString *)key;
- (BOOL)isDictionaryForKey:(NSString *)key;
- (BOOL)isStringForKey:(NSString *)key;
- (BOOL)isNumberForKey:(NSString *)key;

- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;
- (float)floatForKey:(NSString *)key;
- (int)intForKey:(NSString *)key;
- (unsigned int)unsignedIntForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;
- (long long)longLongForKey:(NSString *)key;
- (unsigned long long)unsignedLongLongForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
@end
