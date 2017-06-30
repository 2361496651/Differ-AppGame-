//
//  NSError+DfExtension.h
//  AppGame
//
//  Created by supozheng on 2017/6/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
static NSString * const DfErrorDomain = @"DfErrorDomain";
@interface NSError (DfExtension)
+ (NSError*)df_errorWithCode:(NSInteger)code description:(NSString*)description;
@end
