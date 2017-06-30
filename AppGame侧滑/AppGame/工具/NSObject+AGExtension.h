//
//  NSObject+AGExtension.h
//  AppGameSDK
//
//  Created by Mao on 16/2/23.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AGExtension)
- (NSDictionary*)ag_toDictionary;
- (NSString*)ag_toJSONString;
- (NSData*)ag_toJSONData;
@end

extern void forceLoadCategory_BFTask_Private();