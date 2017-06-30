//
//  ToolBarView.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BtnClickCallBack)(NSInteger index);

@interface ToolBarView : UIView

- (instancetype)initToolBarWithFrame:(CGRect)frame textfieldDelegate:(id)delegate;

- (void)becomFirstResponseWithPlaceHolder:(NSString *)placeHolder;

- (void)registFirstResponseWithPlaceHolder:(NSString *)placeHolder;

@property (nonatomic,strong)BtnClickCallBack callBack;

@end
