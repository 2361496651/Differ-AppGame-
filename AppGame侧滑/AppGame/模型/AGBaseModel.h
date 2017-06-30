//
//  BaseModel.h
//  AGVideo
//
//  Created by Mao on 16/4/15.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "MTLModel.h"

@interface AGBaseModel : MTLModel<MTLJSONSerializing>
@property (nonatomic, assign, getter=isDataUnavailable) BOOL dataUnavailable;
@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSDate *updatedAt;
+ (instancetype)objectWithoutDataWithObjectId:(NSString*)objectId;
@end
