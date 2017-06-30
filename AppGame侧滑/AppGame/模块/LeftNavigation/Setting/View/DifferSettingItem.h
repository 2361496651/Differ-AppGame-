//
//  ecmSettingItem.h
//  ecmSetting
//
//  Created by zengchunjun on 16/12/2.
//  Copyright © 2016年 zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>

//定义一个block,无返回值，也无参数
typedef void (^OperationBlock)();

@interface DifferSettingItem : NSObject

@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subTitle;

/**
 * 控制器的类型
 */
@property(nonatomic,assign)Class vcClass;


/**
 *  存储一个特殊的Block 操作
 *   block 使用copy
 */
@property(nonatomic,copy)OperationBlock operation;

// 专为twosegment类型的cell设定属性,暂时未使用
@property (nonatomic,strong)NSString *firstIndexTitle;
@property (nonatomic,strong)NSString *secondIndexTitle;


-(instancetype)initWithIcon:(NSString *)icon title:(NSString *)title;

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title;

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title vcClass:(Class)vcClass;
@end



@interface DifferSettingArrowItem : DifferSettingItem

@end

@interface DifferSettingLabelItem : DifferSettingItem

@end

@interface DifferSettingSwitchItem : DifferSettingItem

@end

@interface DifferSettingImageItem : DifferSettingItem


@end

// 文字居中，不需要设置图片，子标题。直接在operation里面执行对应操作即可
@interface DifferSettingCenterItem : DifferSettingItem

@end

@interface DifferSettingTextFiledItem : DifferSettingItem

@end
