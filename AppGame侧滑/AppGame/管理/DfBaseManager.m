//
//  DfBaseManager.m
//  LittleGame
//
//  Created by Mao on 14-8-13.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import "DfBaseManager.h"
#import "DfServiceManager.h"
@implementation DfBaseManager
+ (instancetype)sharedInstance{
    return [[DfServiceManager sharedInstance] serviceInstanceForClass:self];
}
@end
