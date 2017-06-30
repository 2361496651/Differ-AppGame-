//
//  TagsView.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TagsBtnView : UIView

- (instancetype)initTagsViewWithFrame:(CGRect)frame tags:(NSArray<UIButton *> *)tags commentsCount:(NSInteger)count;


@end
