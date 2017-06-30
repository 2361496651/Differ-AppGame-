//
//  FansCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "FansCell.h"
#import "AppraiseModel.h"
#import "GameModel.h"
#import "UserModel.h"
#import "TagsModel.h"
#import "AttentionModel.h"
#import <UIImageView+WebCache.h>

@interface FansCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation FansCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //    static NSString *ID = @"commentCell";
    FansCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FansCell"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FansCell" owner:nil options:nil].firstObject;
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setFans:(AttentionModel *)fans
{
    _fans = fans;
    
    [self.iconImageView sd_setImageWithURL:fans.avatar];
    self.nameLabel.text = fans.nickname;
    self.typeLabel.text = @"游戏玩家";
    
    if (fans.cellHeight == 0) {
        [self layoutIfNeeded];
        _fans.cellHeight = CGRectGetMaxY(self.iconImageView.frame) + CGRectGetMinY(self.iconImageView.frame);
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
    if ([self.delegate respondsToSelector:@selector(fansCellClickIconImage:attentionModel:)]) {
        [self.delegate fansCellClickIconImage:self attentionModel:self.fans];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
