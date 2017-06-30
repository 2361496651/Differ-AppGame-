//
//  NSObject+AGExtension.m
//  AppGameSDK
//
//  Created by Mao on 16/2/23.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "NSObject+AGExtension.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (AGExtension)
- (void)ag_enumeratePropertiesUsingBlock:(void (^)(objc_property_t property, BOOL *stop))block {
    Class cls = self.class;
    BOOL stop = NO;
    
    while (!stop && ![cls isEqual:NSObject.class]) {
        unsigned count = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        
        cls = cls.superclass;
        if (properties == NULL) continue;
        for (unsigned i = 0; i < count; i++) {
            block(properties[i], &stop);
            if (stop) break;
        }
        free(properties);
    }
}
- (NSDictionary*)ag_toDictionary{
    NSMutableDictionary *propertiesInfo = [NSMutableDictionary dictionary];
    [self ag_enumeratePropertiesUsingBlock:^(objc_property_t property, BOOL *stop) {
        NSString *key = @(property_getName(property));
        id value = [self valueForKey:key];
        if (value) {
            propertiesInfo[key] = value;
        }else{
            propertiesInfo[key] = [NSNull null];
        }
    }];
    return propertiesInfo;
}
- (NSString*)ag_toJSONString{
    return [[NSString alloc] initWithData:[self ag_toJSONData] encoding:NSUTF8StringEncoding];
}
- (NSData*)ag_toJSONData{
    id object = nil;
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSDictionary class]]) {
        object = self;
    }else{
        object = [self ag_toDictionary];
    }
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"%@", error);
        return nil;
    }
    return data;
}
@end

void forceLoadCategory_BFTask_Private() {
    NSString *string = nil;
    [string description];
}
