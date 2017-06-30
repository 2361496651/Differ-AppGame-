//
//  MessageDifferCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/12.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "MessageDifferCell.h"

@implementation MessageDifferCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    MessageDifferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageDifferCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MessageDifferCell" owner:nil options:nil].firstObject;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
