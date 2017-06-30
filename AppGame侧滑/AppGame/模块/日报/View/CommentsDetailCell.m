//
//  CommentsDetailCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CommentsDetailCell.h"
#import "ReplyModel.h"
#import "UserModel.h"
#import "CommentModel.h"
#import "DiffUtil.h"

@interface CommentsDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation CommentsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    
    
    CommentsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentdetailCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"CommentsDetailCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setReply:(ReplyModel *)reply
{
    _reply = reply;
    
    self.iconLabel.text = [NSString stringWithFormat:@"%@:",reply.user.nickname];
    
    NSString *replyContent = reply.content;
    if ([replyContent rangeOfString:@"回复#Replay#"].location != NSNotFound) {
        replyContent = [replyContent stringByReplacingOccurrencesOfString:@"#Replay#" withString:@""];
    }
    [self resetContent:replyContent];
    
//    if (reply.cellHeight == 0) {
        [self layoutIfNeeded];
        reply.cellHeight = CGRectGetMaxY(self.contentLabel.frame) + CGRectGetMinY(self.contentLabel.frame);
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//首行缩进
- (void)resetContent:(NSString *)content{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    CGSize size = [DiffUtil sizeWithText:self.reply.user.nickname width:400 textFont:15];
    [paragraphStyle setFirstLineHeadIndent:size.width + 12];//首行缩进 根据用户昵称宽度
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    self.contentLabel.attributedText = attributedString;
    
}




@end
