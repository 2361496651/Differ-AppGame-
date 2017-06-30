//
//  GameCollectionCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameCollectionCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"
#import "CategoryModel.h"
#import "TagsModel.h"
#import "CountView.h"

@interface GameCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *gameImage;

@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;

@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (weak, nonatomic) IBOutlet UILabel *gameIntroduce;

@property (weak, nonatomic) IBOutlet UIImageView *gameFromIcon;


@property (weak, nonatomic) IBOutlet UILabel *gameFrom;
@property (weak, nonatomic) IBOutlet UILabel *gameMark;

@property (weak, nonatomic) IBOutlet UILabel *gameCategoryOne;

@property (weak, nonatomic) IBOutlet UILabel *gameCategoryTwo;

@property (weak, nonatomic) IBOutlet UILabel *gameCategoryThree;

@property (nonatomic,strong)CountView *countView;

@end


@implementation GameCollectionCell

- (CountView *)countView
{
    if (_countView == nil) {
        _countView = [[CountView alloc]init];
//        _countView.bounds = self.gameMark.bounds;
        
        [_countView buildView:50.0 height:50.0];
        
    }
    return _countView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"GameCollectionCell" owner:nil options:nil]firstObject];
    }
    self.frame = frame;
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIColor *color = [UIColor colorWithRed:33/255.0 green:184/255.0 blue:184/255.0 alpha:1/1.0];
    
    self.gameMark.layer.borderColor = color.CGColor;
    self.gameMark.layer.borderWidth = 1.0;
    
    self.gameCategoryOne.layer.borderColor = color.CGColor;
    self.gameCategoryOne.layer.borderWidth = 0.3;
    self.gameCategoryTwo.layer.borderColor = color.CGColor;
    self.gameCategoryTwo.layer.borderWidth = 0.3;
    self.gameCategoryThree.layer.borderColor = color.CGColor;
    self.gameCategoryThree.layer.borderWidth = 0.3;
    
}

- (void)setGame:(GameModel *)game
{
    _game = game;
    
    [self.gameImage sd_setImageWithURL:game.cover placeholderImage:nil options:kNilOptions];
    [self.gameIcon sd_setImageWithURL:game.icon placeholderImage:[UIImage imageNamed:@"mobile_icon"]];
    self.gameName.text = game.game_name_cn;
    
//    NSString *mark = [NSString stringWithFormat:@"%.1f",game.avg_appraise_star.floatValue];
//    self.gameMark.text = nil;
    
    [self addSubview:self.countView];
//    self.countView.center = self.gameMark.center;
    self.countView.el_axisXToAxisX(self.gameMark,0).el_axisYToAxisY(self.gameMark,0).el_toSize(CGSizeMake(44, 44));
//    self.countView.el_centreTo(self.gameMark,self.gameMark.center).el_toSize(CGSizeMake(50, 50));
    self.countView.percent = game.avg_appraise_star.floatValue / 10.f;
    [self.countView show];
    
    self.gameIntroduce.text = game.recommend_reason;
    
    NSString *nickName = game.user.nickname;
    if (nickName == nil || [nickName isEqualToString:@""]) {
        nickName = @"未知作者";
    }
    self.gameFrom.text = [NSString stringWithFormat:@"%@",nickName];
    
    [self.gameFromIcon sd_setImageWithURL:game.user.avatar];
    
    // 游戏的分类展示
    for (int i = 0; i < game.tags.count; i++) {
    
        TagsModel *tag = game.tags[i];
        if (i == 0) {
            self.gameCategoryOne.text = [NSString stringWithFormat:@"  %@  ",tag.tagName];
        }else if (i == 1){
            self.gameCategoryTwo.text = [NSString stringWithFormat:@"  %@  ",tag.tagName];
        }else if (i == 2){
            self.gameCategoryThree.text = [NSString stringWithFormat:@"  %@  ",tag.tagName];
            
        }
    }
    
    
    
}

@end
