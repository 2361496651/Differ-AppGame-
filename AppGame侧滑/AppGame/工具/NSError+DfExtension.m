//
//  NSError+DfExtension.m
//  AppGame
//
//  Created by supozheng on 2017/6/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "NSError+DfExtension.h"

@implementation NSError (DfExtension)

+ (NSError*)df_errorWithCode:(NSInteger)code description:(NSString*)description{
    return [NSError errorWithDomain:DfErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey: description?description:@""}];
}
@end
