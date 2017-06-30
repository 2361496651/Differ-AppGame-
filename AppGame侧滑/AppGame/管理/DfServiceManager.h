//
//  AGServiceManager.h
//  AGVideo
//
//  Created by Mao on 15/8/25.
//  Copyright (c) 2015年 AppGame. All rights reserved.
//

#import "DfServiceManager.h"

@interface DfServiceManager : NSObject
+ (instancetype)sharedInstance;
- (id)serviceInstanceForClass:(Class)aClass;
@end
