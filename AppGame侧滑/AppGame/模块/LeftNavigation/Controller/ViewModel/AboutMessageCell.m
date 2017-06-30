//
//  AboutMessageCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/15.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AboutMessageCell.h"
#import <UIImageView+WebCache.h>
#import "GuestModel.h"
#import "UserModel.h"
#import "NSDate+CJTime.h"

@interface AboutMessageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation AboutMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    AboutMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutMessageCell"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"AboutMessageCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setGuest:(GuestModel *)guest
{
    _guest = guest;
    
    [self.iconImage sd_setImageWithURL:guest.author.avatar];
    self.nameLabel.text = guest.author.nickname;
    self.contentLabel.text = guest.content;
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:guest.created_at.longLongValue];
    self.timeLabel.text = [time diff2now];
    
    if (guest.cellHeight == 0) {
        [self layoutIfNeeded];
        guest.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + CGRectGetMinY(self.iconImage.frame);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
