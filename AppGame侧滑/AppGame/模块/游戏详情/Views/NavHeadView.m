//
//  NavHeadView.m
//  AppGame
//
//  Created by chan on 17/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "NavHeadView.h"
@interface NavHeadView()
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIButton *queryBtn;
@property(nonatomic,strong)UILabel *titleLB;
@end
@implementation NavHeadView
-(UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [self addSubview:_backBtn];
    }
    return _backBtn;
}

//-(UIButton *)shareBtn{
//    if (!_shareBtn) {
//        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_shareBtn setImage:[UIImage imageNamed:@"home_Recommend_ic"] forState:UIControlStateNormal];
//        [self addSubview:_shareBtn];
//    }
//    return _shareBtn;
//}

-(UIButton *)queryBtn{
    if (!_queryBtn) {
        _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_queryBtn setImage:[UIImage imageNamed:@"icon_feedback_w_pre"] forState:UIControlStateNormal];
        [self addSubview:_queryBtn];
    }
    return _queryBtn;
}

-(UILabel *)titleLB{
    if (!_titleLB) {
        _titleLB = [UILabel new];
        [self.bgView addSubview:_titleLB];
        _titleLB.font = [UIFont systemFontOfSize:16];
        _titleLB.textColor = [UIColor whiteColor];
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.el_axisYToSuperView(10).el_axisXToSuperView(0).el_toWidth(200);
    }
    return _titleLB;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:self.bgView];
        self.bgView.backgroundColor = [UIColor ag_G1];
        self.bgView.alpha = 0;
        
        self.backBtn.el_toSize(CGSizeMake(44, 44)).el_axisYToSuperView(10);
        self.backBtn.alpha = 1;
        [self.backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
//        self.shareBtn.el_toSize(CGSizeMake(35, 44)).el_rightToSuperView(10).el_axisYToSuperView(10);
//        [self.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.queryBtn.el_toSize(CGSizeMake(35, 44)).el_rightToSuperView(10).el_axisYToSuperView(10);
        [self.queryBtn addTarget:self action:@selector(queryBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    self.titleLB.text = title;
}

//事件回调
-(void)backBtnClick{
    if ([_delegate respondsToSelector:@selector(navHeadBack)] ) {
        [_delegate navHeadBack];
    }
}

-(void)shareBtnClick{
    if ([_delegate respondsToSelector:@selector(navHeadShare)] ) {
        [_delegate navHeadShare];
    }
}

-(void)queryBtnClick{
    if ([_delegate respondsToSelector:@selector(navHeadQuery)] ) {
        [_delegate navHeadQuery];
    }
}
@end
