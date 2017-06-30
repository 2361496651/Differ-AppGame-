//
//  ecmSettingItem.m
//  ecmSetting
//
//  Created by zengchunjun on 16/12/2.
//  Copyright © 2016年 zengchunjun. All rights reserved.
//

#import "DifferSettingItem.h"

@implementation DifferSettingItem

-(instancetype)initWithIcon:(NSString *)icon title:(NSString *)title{
    if (self = [super init]) {
        self.icon = icon;
        self.title = title;
    }
    
    return self;
}
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title{
    return [[self alloc] initWithIcon:icon title:title];
}

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title vcClass:(Class)vcClass{
    DifferSettingItem *item = [self itemWithIcon:icon title:title];
    item.vcClass = vcClass;
    
    return item;
}

@end



@implementation DifferSettingArrowItem

@end

@implementation DifferSettingLabelItem

@end


@implementation DifferSettingSwitchItem

@end


@implementation DifferSettingImageItem

@end

@implementation DifferSettingCenterItem


@end


@implementation DifferSettingTextFiledItem


@end

