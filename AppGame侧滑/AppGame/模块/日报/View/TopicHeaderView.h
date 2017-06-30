//
//  TopicHeaderView.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TopicModel;

@interface TopicHeaderView : UIView

@property (nonatomic,strong)TopicModel *topic;

@property (nonatomic,copy)NSString *textColor;

@end
