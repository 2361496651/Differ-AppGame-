//
//  BaseModel.m
//  AGVideo
//
//  Created by Mao on 16/4/15.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "AGBaseModel.h"
#import "NSDate+AGExtension.h"
@interface AGBaseModel()

@end
@implementation AGBaseModel

+ (instancetype)objectWithoutDataWithObjectId:(NSString *)objectId {
    AGBaseModel* model = [[self alloc] init];
    model.objectId = objectId;
    model.dataUnavailable = YES;
    return model;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return
    [MTLValueTransformer transformerUsingForwardBlock:^(NSString *dateString,
                                                        BOOL *success,
                                                        NSError **error) {
        return [NSDate dateFromISO8601String:dateString];
    } reverseBlock:^(NSDate *date, BOOL *success, NSError **error) {
        return [date toISO8601String];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer {
    return
    [MTLValueTransformer transformerUsingForwardBlock:^(NSString *dateString,
                                                        BOOL *success,
                                                        NSError **error) {
        return [NSDate dateFromISO8601String:dateString];
    } reverseBlock:^(NSDate *date, BOOL *success, NSError **error) {
        return [date toISO8601String];
    }];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"objectId": @"objectId",
             @"createdAt": @"createdAt",
             @"updatedAt": @"updatedAt"
             };
}
- (NSUInteger)hash{
    return [self.objectId hash];
}
@end
