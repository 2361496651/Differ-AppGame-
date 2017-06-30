//
//  NSMutableArray+AGExtension.h
//  AGJointOperationSDK
//
//  Created by 猎人 on 2016/11/3.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (AGExtension)

/**
 实现一个简单的队列
 
 @param object 要插入的对象
 @param index 插入的位置
 @param maxCount 队列的最大长度
 @return 以数组的形式返回
 */
- (NSArray *)insertAnObject:(NSObject *)object atIndex:(NSInteger)index withMaxCount:(int)maxCount;

@end
