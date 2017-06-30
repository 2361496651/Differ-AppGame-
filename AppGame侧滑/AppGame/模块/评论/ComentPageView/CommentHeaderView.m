//
//  CommentHeaderView.m
//  AppGame
//
//  Created by chan on 17/5/10.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CommentHeaderView.h"

@implementation CommentHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [UIView new];
        [self addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        view.el_toSize(CGSizeMake(ScreenWidth, 10)).el_topToSuperView(0);
        view.backgroundColor = [UIColor ag_G5];
        
        UIView *view1 = [UIView new];
        [self addSubview:view1];
        view1.backgroundColor = [UIColor whiteColor];
        view1.el_toWidth(ScreenWidth).el_topToTop(self,10).el_bottomToSuperView(0);
        
        self.label = [UILabel new];
        [view1 addSubview:self.label];
        self.label.el_leftToSuperView(20).el_axisYToAxisY(view1,0);
        self.label.text = @"玩家评论";
        
        UIView *lineView = [UIView new];
        [view1 addSubview:lineView];
        lineView.el_toSize(CGSizeMake(80, 4)).el_bottomToSuperView(10).el_leftToSuperView(20);
        lineView.backgroundColor = [UIColor di_MAIN2];
    }
    
    return self;
}

@end
