//
//  CollectionViewTitleCell.m
//  AppGame
//
//  Created by supozheng on 2017/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CollectionHeadView.h"

@interface CollectionHeadView()
@end

@implementation CollectionHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    
    //根据美术资源得到的比例
    float ratio = 375 / 125;
    
    self.emptyView = [[UIView alloc] init];
    [self addSubview:self.emptyView];

    self.emptyView.el_toSize(CGSizeMake(ScreenWidth, ScreenWidth / ratio)).el_topToSuperView(0).el_leftToSuperView(0);
    self.emptyView.backgroundColor = [UIColor HEX:0xf2f2f2];

    //创建headview
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_empty"]];
    [self.emptyView addSubview:imageview];
    imageview.el_axisXToSuperView(-15).el_axisYToSuperView(0);
    
    UILabel *lable = [[UILabel alloc] init];
    [self.emptyView addSubview:lable];
    lable.text = @"空空如也";
    lable.textColor = [UIColor HEX:0x909090];
    lable.font = [UIFont systemFontOfSize:14];
    lable.el_axisYToSuperView(10).el_leftToRight(imageview,5);
    
    //名称
    UILabel *titleLable = [[UILabel alloc] init];
    [self addSubview:titleLable];
    self.titleLable = titleLable;
    self.titleLable.text = @"编辑推荐";
    self.titleLable.font = [UIFont boldSystemFontOfSize:16];
    
    self.titleLable.el_topToBottom(self.emptyView,10).el_leftToSuperView(10);
    
}
@end
