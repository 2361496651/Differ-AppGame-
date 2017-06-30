//
//  MessageReplyCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/12.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "MessageReplyCell.h"

@interface MessageReplyCell ()




@end

@implementation MessageReplyCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MessageReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageReplyCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MessageReplyCell" owner:nil options:nil].firstObject;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
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
