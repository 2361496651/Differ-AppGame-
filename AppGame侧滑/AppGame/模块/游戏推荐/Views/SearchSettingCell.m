//
//  SearchSettingCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/10.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "SearchSettingCell.h"

@interface SearchSettingCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SearchSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    SearchSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchSettingCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SearchSettingCell" owner:nil options:nil].firstObject;
    }
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor =  [UIColor colorWithRed:33/255.0 green:184/255.0 blue:184/255.0 alpha:1/1.0];
    
    return cell;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    self.contentLabel.text = content;
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
