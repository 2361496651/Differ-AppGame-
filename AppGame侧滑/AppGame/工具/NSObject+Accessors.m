//
//  NSObject+Accessors.m
//  AGVideo
//
//  Created by Mao on 16/1/15.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "NSObject+Accessors.h"
@implementation NSObject (Accessors)
@end
@implementation NSObject (NSDictionary_Accessors)
- (BOOL)isKindOfClass:(Class)aClass forKey:(NSString *)key
{
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary*)self;
        id value = [dic objectForKey:key];
        return [value isKindOfClass:aClass];
    }
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass forKey:(NSString *)key
{
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary*)self;
        id value = [dic objectForKey:key];
        return [value isMemberOfClass:aClass];
    }
    return NO;
}

- (BOOL)isArrayForKey:(NSString *)key
{
    return [self isKindOfClass:[NSArray class] forKey:key];
}

- (BOOL)isDictionaryForKey:(NSString *)key
{
    return [self isKindOfClass:[NSDictionary class] forKey:key];
}

- (BOOL)isStringForKey:(NSString *)key
{
    return [self isKindOfClass:[NSString class] forKey:key];
}

- (BOOL)isNumberForKey:(NSString *)key
{
    return [self isKindOfClass:[NSNumber class] forKey:key];
}

- (NSArray *)arrayForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    return nil;
}

- (NSDictionary *)dictionaryForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    }
    return nil;
}

- (NSString *)stringForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(description)]) {
        return [value description];
    }
    return nil;
}

- (NSNumber *)numberForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return nil;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        return [nf numberFromString:value];
    }
    return nil;
}

- (double)doubleForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return 0.0;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value doubleValue];
    }
    return 0;
}

- (float)floatForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return 0.0;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value floatValue];
    }
    return 0;
}

- (int)intForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return 0;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value intValue];
    }
    return 0;
}

- (unsigned int)unsignedIntForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return 0;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntValue];
    }
    return 0;
}

- (NSInteger)integerForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return 0;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }
    return 0;
}

- (NSUInteger)unsignedIntegerForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return 0;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedIntegerValue];
    }
    return 0;
}

- (long long)longLongForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return 0;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (unsigned long long)unsignedLongLongForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return 0;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    return 0;
}

- (BOOL)boolForKey:(NSString *)key
{
    NSDictionary *dic = [self isKindOfClass:[NSDictionary class]] ? (NSDictionary*)self : nil;
    if (!dic) {
        return NO;
    }
    id value = [dic objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    }
    return NO;
}
@end
