//
//  ecmSettingGroup.h
//  ecmSetting
//
//  Created by zengchunjun on 16/12/2.
//  Copyright © 2016年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DifferSettingGroup : NSObject

/**
 *  组的头部标题
 */
@property(nonatomic,copy)NSString *headerTitle;

/**
 *  组的尾部标题
 */
@property(nonatomic,copy)NSString *footerTitle;


/**
 *  组的每一行数据模型
 */
@property(nonatomic,strong)NSArray *differSettingItems;

@end
