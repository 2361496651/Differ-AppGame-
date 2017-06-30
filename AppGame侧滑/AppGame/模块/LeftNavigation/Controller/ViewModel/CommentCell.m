//
//  CommentCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/20.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CommentCell.h"
#import "AppraiseModel.h"
#import "GameModel.h"
#import "UserModel.h"
#import "TagsModel.h"
#import <UIImageView+WebCache.h>

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *gameIconImage;

@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;



@end

@implementation CommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
//    static NSString *ID = @"commentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:nil options:nil].firstObject;
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setAppraise:(AppraiseModel *)appraise
{
    _appraise = appraise;
    
    
    self.commentLabel.text = @"评价了游戏";
    
    // 游戏图标
    [self.gameIconImage sd_setImageWithURL:appraise.game.icon placeholderImage:[UIImage imageNamed:@"mobile_icon"]];
    
    // 游戏名
    self.gameNameLabel.text = appraise.game.game_name_cn;
    // 游戏评价
    self.commentContentLabel.text = appraise.content;
    
    // 点赞数
    NSString *thumbsUp = appraise.thumbs_up;
    if (thumbsUp == nil || [thumbsUp isEqualToString:@""]) {
        thumbsUp = @"0";
    }
    self.likesLabel.text = thumbsUp;
    
    //评论数
    NSString *comment = appraise.commented;
    if (comment == nil || [comment isEqualToString:@""]) {
        comment = @"0";
    }
    self.commentsLabel.text = comment;
    
    //cell高度
    if (appraise.cellHeight == 0) {
        [self layoutIfNeeded];
        _appraise.cellHeight = CGRectGetMaxY(self.commentsLabel.frame) + 5;
    }
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentWidth.constant = [UIScreen mainScreen].bounds.size.width - 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
