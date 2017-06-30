//
//  CorrelationGameCell.m
//  AppGame
//
//  Created by chan on 17/5/17.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CorrelationGameCell.h"
#import "GameModel.h"
#import "CategoryModel.h"
#import "StarView.h"
@interface CorrelationGameCell()
@property(nonatomic,strong)CategoryModel *categorModel;
@property(nonatomic,strong)UIView *lineView;

@property(nonatomic,strong)UIImageView *imageView1;
@property(nonatomic,strong)UILabel *gameNameLB1;
@property(nonatomic,strong)UILabel *gameTypeLB1;

@property(nonatomic,strong)UIImageView *imageView2;
@property(nonatomic,strong)UILabel *gameNameLB2;
@property(nonatomic,strong)UILabel *gameTypeLB2;
@property(nonatomic,strong)UIView *view2;
@end

@implementation CorrelationGameCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *titleLable =[UILabel new];
        [self addSubview:titleLable];
        titleLable.font = [UIFont boldSystemFontOfSize:18];
        titleLable.text = @"相关游戏";
        titleLable.textColor = [UIColor blackColor];
        titleLable.el_topToSuperView(10).el_leftToSuperView(20);
        self.lineView = [UIView new];
        [self addSubview:self.lineView];
        self.lineView.el_toHeight(2).el_leftToLeft(titleLable,0).el_rightToRight(titleLable,0).el_topToBottom(titleLable, 5);
        self.lineView.backgroundColor = [UIColor blackColor];
        
        CGFloat width = (ScreenWidth-50) / 2;
            UIView *view1 = [UIView new];
            [self addSubview:view1];
            view1.backgroundColor = [UIColor whiteColor];
            view1.layer.shadowOffset = (CGSizeMake(3, 3));
            view1.layer.shadowOpacity = 0.5;
            view1.layer.cornerRadius = 3;
            view1.el_toSize(CGSizeMake(width, width*1.2)).el_leftToSuperView(20).el_topToBottom(self.lineView,20);
            
            [view1 bk_whenTapped:^{
                if ([_delegate respondsToSelector:@selector(clickCorrelationGameCell:)]) {
                    [_delegate clickCorrelationGameCell:0];
                }
            }];
        
        CGFloat distance = 15;
        if (iPhone5) {
            distance = 10;
        }
        
            self.imageView1 = [UIImageView new];
            [view1 addSubview:self.imageView1];
            self.imageView1.el_leftToSuperView(0).el_topToSuperView(0).el_toSize(CGSizeMake(width, width*0.75));
        
            self.gameNameLB1 = [UILabel new];
            [view1 addSubview:self.gameNameLB1];
            self.gameNameLB1.el_leftToSuperView(10).el_rightToSuperView(10).el_topToBottom(self.imageView1,distance);
            self.gameNameLB1.font = [UIFont systemFontOfSize:16];

            self.gameTypeLB1 = [UILabel new];
            [view1 addSubview:self.gameTypeLB1];
            self.gameTypeLB1.el_leftToSuperView(10).el_bottomToSuperView(distance);
            self.gameTypeLB1.font = [UIFont systemFontOfSize:12];
            self.gameTypeLB1.textColor = [UIColor ag_G2];

            self.view2 = [UIView new];
            [self addSubview:self.view2];
            self.view2.backgroundColor = [UIColor whiteColor];
            self.view2.layer.shadowOffset = (CGSizeMake(3, 3));
            self.view2.layer.shadowOpacity = 0.5;
            self.view2.layer.cornerRadius = 3;
            self.view2.el_toSize(CGSizeMake(width, width*1.2)).el_rightToSuperView(20).el_topToBottom(self.lineView,20);
            
            [self.view2 bk_whenTapped:^{
                if ([_delegate respondsToSelector:@selector(clickCorrelationGameCell:)]) {
                    [_delegate clickCorrelationGameCell:1];
                }
            }];
            
            self.imageView2 = [UIImageView new];
            [self.view2 addSubview:self.imageView2];
            self.imageView2.el_leftToSuperView(0).el_topToSuperView(0).el_toSize(CGSizeMake(width, width*0.75));
        
            
            self.gameNameLB2 = [UILabel new];
            [self.view2 addSubview:self.gameNameLB2];
            self.gameNameLB2.el_leftToSuperView(10).el_rightToSuperView(10).el_topToBottom(self.imageView2,distance);
            self.gameNameLB2.font = [UIFont systemFontOfSize:16];
        
            
            self.gameTypeLB2 = [UILabel new];
            [self.view2 addSubview:self.gameTypeLB2];
            self.gameTypeLB2.el_leftToSuperView(10).el_bottomToSuperView(distance);
            self.gameTypeLB2.font = [UIFont systemFontOfSize:12];
            self.gameTypeLB2.textColor = [UIColor ag_G3];
    }
    return self;
}

-(void)setGameModelArr:(NSArray *)gameModelArr{
    if (gameModelArr != nil) {
        
       _gameModelArr = gameModelArr;
        if (gameModelArr.count < 2) {
            self.view2.hidden = YES;
        }
        
        for (int i  = 0; i < gameModelArr.count; i ++) {
            if (i == 0) {
                GameModel *gameModel = gameModelArr[i];
                [self.imageView1 sd_setImageWithURL:gameModel.cover];
                self.gameNameLB1.text = gameModel.game_name_cn;
                if (gameModel.categoryArray) {
                    self.categorModel = gameModel.categoryArray[0];
                    self.gameTypeLB1.text = self.categorModel.name;
                    [self drawStar:gameModel.avg_appraise_star.floatValue  leftOrRight:YES];
                }

            }else if (i == 1){
                GameModel *gameModel = gameModelArr[i];
                [self.imageView2 sd_setImageWithURL:gameModel.cover];
                self.gameNameLB2.text = gameModel.game_name_cn;
                if (gameModel.categoryArray) {
                    self.categorModel = gameModel.categoryArray[0];
                    self.gameTypeLB2.text = self.categorModel.name;
                    [self drawStar:gameModel.avg_appraise_star.floatValue  leftOrRight:NO];
                }
            }
        }
    }
}

-(void)drawStar:(CGFloat)star leftOrRight:(BOOL)left{
//    CGFloat star = appraiseModel.star.floatValue / 2;
    CGFloat star1 = star / 2;
    for (int i = 0; i < 5; i ++) {
        StarView *starView = [StarView new];
        [self addSubview:starView];
        if (left) {
            starView.el_toSize(CGSizeMake(13, 13)).el_axisYToAxisY(self.gameTypeLB1,0).el_leftToRight(self.gameTypeLB1,5 + (i * 13));
            if (i == 4) {
                UILabel *starLB = [UILabel new];
                [self addSubview:starLB];
                starLB.el_toSize(CGSizeMake(20, 10)).el_axisYToAxisY(starView,0).el_leftToRight(starView,5);
                starLB.text = [NSString stringWithFormat:@"%.1f",star];
                starLB.font = [UIFont systemFontOfSize:10];
                starLB.textColor = [UIColor grayColor];
            }
        }else{
            starView.el_toSize(CGSizeMake(13, 13)).el_axisYToAxisY(self.gameTypeLB2,0).el_leftToRight(self.gameTypeLB2,5 + (i * 13));
            if (i == 4) {
                UILabel *starLB = [UILabel new];
                [self addSubview:starLB];
                starLB.el_toSize(CGSizeMake(20, 10)).el_axisYToAxisY(starView,0).el_leftToRight(starView,5);
                starLB.text = [NSString stringWithFormat:@"%.1f",star];
                starLB.font = [UIFont systemFontOfSize:10];
                starLB.textColor = [UIColor grayColor];
            }
        }
        
        starView.backgroundColor = [UIColor clearColor];
        
        if (star1 >= 1) {
            [starView setPercent:1];
        }else if(star1 < 0) {
            [starView setPercent:0];
        }else{
            [starView setPercent:star1];
        }
        star1 -= 1;
    }
}

@end
