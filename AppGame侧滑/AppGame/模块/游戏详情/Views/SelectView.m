//
//  SelectView.m
//  AppGame
//
//  Created by chan on 17/5/12.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "SelectView.h"

@interface SelectView ()

@property(nonatomic,strong) UILabel *detailLB;
@property(nonatomic,strong) UILabel *commentLB;
/** 底部滑动的动画条 */
@property (nonatomic, strong) UIView *slideLineView;
//记录当前被选中的按钮
@property (nonatomic, weak) UILabel *nowSelectedLB;

@end

@implementation SelectView

-(UILabel *)detailLB{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.text = @"详情";
        _detailLB.textAlignment = NSTextAlignmentCenter;
        _detailLB.font = [UIFont boldSystemFontOfSize:17];
        _detailLB.userInteractionEnabled = YES;
    }
    return _detailLB;
}

-(UILabel *)commentLB{
    if (!_commentLB) {
        _commentLB = [[UILabel alloc] init];
        _commentLB.text = @"评价";
        _commentLB.textAlignment = NSTextAlignmentCenter;
        _commentLB.font = [UIFont boldSystemFontOfSize:17];
        _commentLB.userInteractionEnabled = YES;
    }
    return _commentLB;
}

-(UIView *)slideLineView{
    if (!_slideLineView) {
        _slideLineView = [[UIView alloc] init];
        [self addSubview:_slideLineView];
        _slideLineView.backgroundColor = [UIColor di_MAIN2];
    }
    return _slideLineView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
//        self.layer.shadowOpacity = 0.1;
//        self.layer.shadowOffset = CGSizeMake(0, 2);
        
        [self addSubview:self.detailLB];
        self.detailLB.tag = 0;
        [self addSubview:self.commentLB];
        self.commentLB.tag = 1;
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [self.detailLB addGestureRecognizer:tap];
        [self.commentLB addGestureRecognizer:tap1];
        
        [self addSubview:self.slideLineView];
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, ScreenWidth, 0.5)];
        view.backgroundColor = [UIColor blackColor];
        view.alpha = 0.1;
        [self addSubview:view];
        
    }
    return  self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    //这里需要判断下是否显示commentBtn,抓不到数据，暂时先不显示，如果需要显示就给也设置frame
    CGFloat viewH = self.bounds.size.height;
    CGFloat viewW = self.bounds.size.width;
    CGFloat btnW = viewW * 0.25;
    CGFloat btnH = viewH;
    //计算间距
//    CGFloat margin = (viewW - btnW * (self.subviews.count - 1)) / self.subviews.count;
    CGFloat margin = self.bounds.size.width/4;

    self.detailLB.frame = CGRectMake(margin, 0, btnW, btnH);
    self.commentLB.frame = CGRectMake(margin + btnW , 0, btnW, btnH);
    self.slideLineView.frame = CGRectMake(margin, viewH - 4, btnW, 4);
}

-(void)viewClick:(UITapGestureRecognizer *)recognizer{
    if (self.nowSelectedLB == recognizer.view) return;
    
    //通知代理点击
    if ([self.delegate respondsToSelector:@selector(selectView:didSelectedButtonFrom:to:)]) {
        [self.delegate selectView:self didSelectedButtonFrom:self.nowSelectedLB.tag to:recognizer.view.tag];
    }
    
    //给滑动小条做动画
    CGRect rect = self.slideLineView.frame;
    rect.origin.x = recognizer.view.frame.origin.x;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slideLineView.frame = rect;
    }];
    
    self.nowSelectedLB = (UILabel *)recognizer.view;
}


- (void)lineToIndex:(NSInteger)index{
    switch (index) {
        case 0:
            if ([self.delegate respondsToSelector:@selector(selectView:didChangeSelectedView:)]) {
                [self.delegate selectView:self didChangeSelectedView:0];
            }
            self.nowSelectedLB = self.detailLB;
            break;
        case 1:
            if ([self.delegate respondsToSelector:@selector(selectView:didChangeSelectedView:)]) {
                [self.delegate selectView:self didChangeSelectedView:1];
            }
            self.nowSelectedLB = self.commentLB;
            break;
        default:
            break;
    }
    
    CGRect rect = self.slideLineView.frame;
    rect.origin.x = self.nowSelectedLB.frame.origin.x;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.slideLineView.frame = rect;
    }];
}

@end
