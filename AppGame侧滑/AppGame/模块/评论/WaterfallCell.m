//
//  WaterfallCell.m
//  AppGame
//
//  Created by chan on 17/5/3.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "WaterfallCell.h"
#import "GameModel.h"
#import "GameDetailViewController.h"
#import "UILabel+Extension.h"
#import "ViewFactory.h"
#import "UserModel.h"

@interface WaterfallCell()
@property(nonatomic,strong)UIImageView *icon;
@property(nonatomic,strong)UILabel *gameNameLB;
@property(nonatomic,strong)UILabel *contentLB;
@property(nonatomic,strong)UIButton *commentsBtn;
@property(nonatomic,strong)UIButton *tagsBtn;

@end

@implementation WaterfallCell


#pragma mark 懒加载--------------------------
-(UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        [self addSubview:_icon];
        _icon.layer.cornerRadius = 4;
        _icon.layer.masksToBounds = YES;
        _icon.backgroundColor = [UIColor blackColor];
    }
    return _icon;
}

-(UILabel *)gameNameLB{
    if (!_gameNameLB) {
        _gameNameLB = [UILabel new];
        [self addSubview:_gameNameLB];
        _gameNameLB.textColor = [UIColor blackColor];
        _gameNameLB.font = [UIFont systemFontOfSize:12];
    }
    return _gameNameLB;
}

-(UILabel *)contentLB{
    if (!_contentLB) {
        _contentLB = [UILabel new];
        [self addSubview:_contentLB];
        _contentLB.numberOfLines = 6;
        _contentLB.textColor = [UIColor ag_G1];
        _contentLB.font = [UIFont systemFontOfSize:12];
    }
    return _contentLB;
}

-(UIButton *)commentsBtn{
    if (!_commentsBtn) {
        _commentsBtn = [UIButton new];
        [self addSubview:_commentsBtn];
        [_commentsBtn setTitle:@"0" forState:UIControlStateNormal];
        [_commentsBtn setImage:[UIImage imageNamed:@"game_icon_comment_little"] forState:UIControlStateNormal];
        [_commentsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _commentsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _commentsBtn.titleLabel.alpha = 0.6;
    }
    return _commentsBtn;
}

-(UIButton *)tagsBtn{
    if (!_tagsBtn) {
        _tagsBtn = [UIButton new];
        [self addSubview:_tagsBtn];
        [_tagsBtn setTitle:@"0" forState:UIControlStateNormal];
        [_tagsBtn setImage:[UIImage imageNamed:@"game_icon_label"] forState:UIControlStateNormal];
        [_tagsBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _tagsBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _tagsBtn.titleLabel.alpha = 0.6;
    }
    return _tagsBtn;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];

    self.layer.cornerRadius = 3;
    self.layer.shadowOffset = CGSizeMake(2, 2);
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0.3;
    
    self.icon.el_toSize(CGSizeMake(20, 20)).el_topToSuperView(10).el_leftToSuperView(10);
    
    self.gameNameLB.el_leftToRight(self.icon,10).el_axisYToAxisY(self.icon,0).el_rightToSuperView(10);
    
    UIView *lineView = [ViewFactory createLineView:self];
    lineView.el_leftToSuperView(10).el_rightToSuperView(10).el_topToBottom(self.icon,10);
    
    
    self.commentsBtn.el_rightToSuperView(10).el_bottomToSuperView(10);
    
    self.tagsBtn.el_rightToLeft(self.commentsBtn,5).el_bottomToSuperView(10);
    
    //添加宽度约束，解决瀑布流布局问题
    self.contentLB.el_leftToSuperView(10).el_topToBottom(lineView,10).el_rightToSuperView(10).el_toWidth(self.width - 20);
    
    
    self.icon.userInteractionEnabled = YES;
    self.gameNameLB.userInteractionEnabled = YES;
    
    //设置标题点击进入游戏详情
    [self.icon bk_whenTapped:^{
        [self.delegate clickCellTitle:self.appraiseModel.game];
    }];
    [self.gameNameLB bk_whenTapped:^{
        [self.delegate clickCellTitle:self.appraiseModel.game];
    }];

    return  self;
}

-(void) setAppraiseModel:(AppraiseModel *)appraiseModel{
    _appraiseModel = appraiseModel;
    UserModel * userModel = appraiseModel.author;
    GameModel *gameModel = appraiseModel.game;
    [self.icon sd_setImageWithURL:gameModel.icon];
    self.gameNameLB.text = gameModel.game_name_cn;
    
    [self.contentLB setLabelLineSpace:appraiseModel.content spacing:3 withFont:[UIFont systemFontOfSize:12] userName:userModel.nickname];
    self.contentLB.lineBreakMode = NSLineBreakByTruncatingTail;

    [self.commentsBtn setTitle:appraiseModel.commented forState:UIControlStateNormal];
    [self.tagsBtn setTitle:appraiseModel.taged forState:UIControlStateNormal];

}

@end
