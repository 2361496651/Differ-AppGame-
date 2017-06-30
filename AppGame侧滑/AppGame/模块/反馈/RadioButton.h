//
//  RadioButton.h
//  AppGame
//
//  Created by supozheng on 2017/5/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioButton : UIView
@property(nonatomic,strong)UIView *circleView;
@property(nonatomic,strong)UILabel *textLabel;
-(void)choose:(BOOL)isChoose;
@end
