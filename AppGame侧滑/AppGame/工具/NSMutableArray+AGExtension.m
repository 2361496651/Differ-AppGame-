//
//  NSMutableArray+AGExtension.m
//  AGJointOperationSDK
//
//  Created by 猎人 on 2016/11/3.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "NSMutableArray+AGExtension.h"

@implementation NSMutableArray (AGExtension)

- (NSArray *)insertAnObject:(NSObject *)object atIndex:(NSInteger)index withMaxCount:(int)maxCount {
    if (self.count >= maxCount) {
        [self removeLastObject];
    }
    [self insertObject:object atIndex:index];
    return self;
}
@end
