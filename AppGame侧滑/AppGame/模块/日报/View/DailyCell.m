//
//  DailyCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DailyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DailyModel.h"
#import "ArticleModel.h"
#import "UserModel.h"
#import "DiffUtil.h"
#import "TopicModel.h"

@interface DailyCell ()

@property (weak, nonatomic) IBOutlet UIView *differBgView;


@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameIntroduce;

@property (weak, nonatomic) IBOutlet UIImageView *gameCover;


@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewHeightConst;


@end

@implementation DailyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    DailyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"DailyCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)setIsHiddenBgView:(BOOL)isHiddenBgView
{
    
    _isHiddenBgView = isHiddenBgView;
    self.differBgView.hidden = isHiddenBgView;
}

- (void)setDailyModel:(DailyModel *)dailyModel
{
    _dailyModel = dailyModel;
    
    if ([dailyModel.target isEqualToString:@"article"]) {//文章
        
        ArticleModel *article = dailyModel.article;
        UserModel *user = article.user;
        
        [self.iconImage sd_setImageWithURL:user.avatar placeholderImage:nil];
        self.nameLabel.text = user.nickname;
        self.fromLabel.text = [NSString stringWithFormat:@" %@ ",article.from];
        if (article.from == nil || [article.from isEqualToString:@""]) {
            self.fromLabel.text = article.from;
        }
        
        [self.gameCover sd_setImageWithURL:article.cover placeholderImage:nil];
        self.gameTitleLabel.text = article.title;
        self.gameIntroduce.text = article.descript;
        
        self.likesLabel.text = [NSString stringWithFormat:@"%ld",article.tags.count];
        self.commentsLabel.text = article.commented == nil ? @"0" : article.commented;
        
    }else if ([dailyModel.target isEqualToString:@"topic"]){
        
        TopicModel *topic = dailyModel.topic;
        UserModel *user = topic.user;
        
        [self.iconImage sd_setImageWithURL:user.avatar placeholderImage:nil];
        self.nameLabel.text = user.nickname;
        self.fromLabel.text = [NSString stringWithFormat:@" %@ ",topic.from];
        if (topic.from == nil || [topic.from isEqualToString:@""]) {
            self.fromLabel.text = topic.from;
        }
        
        [self.gameCover sd_setImageWithURL:topic.cover placeholderImage:nil];
        self.gameTitleLabel.text = topic.title;
        self.gameIntroduce.text = topic.content;
        
        self.likesLabel.text = topic.taged == nil ? @"0" : topic.taged;
        self.commentsLabel.text = topic.commented == nil ? @"0" : topic.commented;
        
    }
    
    
    [self layoutIfNeeded]; //一定要先强制布局，不然计算有误差
    self.bgViewHeightConst.constant = CGRectGetMaxY(self.likesLabel.frame) + CGRectGetMinY(self.iconImage.frame) ;
    
//    if (dailyModel.cellHeight == 0) {
        [self layoutIfNeeded];
        dailyModel.cellHeight = CGRectGetMaxY(self.bgView.frame) + CGRectGetMinY(self.bgView.frame) + 10;// 5是bgView距离下边的距离
        
//    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.fromLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.fromLabel.layer.borderWidth = 0.5;
    
    self.differBgView.backgroundColor = [DiffUtil getDifferColor];
    
//    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    self.bgView.layer.shadowOffset = CGSizeMake(-3, 3);
//    self.bgView.layer.shadowRadius = 2;
//    self.bgView.layer.shadowOpacity = 0.5;
    
    
//    self.bgView.backgroundColor = [UIColor redColor];
    
//    self.contentView.backgroundColor = [UIColor yellowColor];
    
                                        
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
