//
//  AttentionCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AttentionCell.h"
#import "AppraiseModel.h"
#import "GameModel.h"
#import "UserModel.h"
#import "TagsModel.h"
#import "AttentionModel.h"
#import <UIImageView+WebCache.h>

@interface AttentionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *attentionIcon;



@end

@implementation AttentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    AttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AttentionCell"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AttentionCell" owner:nil options:nil].firstObject;
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setAttention:(AttentionModel *)attention
{
    _attention = attention;
   
    [self.iconImageView sd_setImageWithURL:attention.avatar];
    self.nameLabel.text = attention.nickname;
    
    // 存在最新的评论
    if (attention.lastAppraise && ![attention.lastAppraise isEqualToString:@""]) {
        self.attentionIcon.hidden = NO;
        
        self.gameNameLabel.hidden = NO;
        self.gameNameLabel.text = attention.lastAppraise;
    }else{
        self.attentionIcon.hidden = YES;
        
        self.gameNameLabel.hidden = YES;
    }
    
  
    if (attention.cellHeight == 0) {
        [self layoutIfNeeded];
        if (attention.lastAppraise && ![attention.lastAppraise isEqualToString:@""]) {
            _attention.cellHeight = CGRectGetMaxY(self.gameNameLabel.frame) + 5;
        }else{
            _attention.cellHeight = CGRectGetMaxY(self.iconImageView.frame) + 12;
        }
        
    }
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapIcon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon:)];
    self.iconImageView.userInteractionEnabled = YES;
    [self.iconImageView addGestureRecognizer:tapIcon];
}

// 点击了头像
- (void)clickIcon:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(attentionCellClickIconImage:attentionModel:)]) {
        [self.delegate attentionCellClickIconImage:self attentionModel:self.attention];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
