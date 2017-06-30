//
//  DailyDetailHeader.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DailyDetailHeader.h"
#import "UserModel.h"
#import "CommentModel.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface DailyDetailHeader ()


@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//点赞数
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
// 评论数
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

@property (weak, nonatomic) IBOutlet UIButton *commentLikeBtn;



@end

@implementation DailyDetailHeader


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"DailyDetailHeader" owner:nil options:nil]firstObject];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        StarsView *view = [[StarsView alloc] initWithStarSize:CGSizeMake(14, 14) space:5 numberOfStar:5];
//        //    view.supportDecimal = YES;
//        view.selectable = NO;
//        view.score = 3.7;
//        view.frame = self.starsView.bounds;
//        [self.starsView addSubview:view];
        
//        self.starView = view;
    }
    
    return self;
}

- (void)setComment:(CommentModel *)comment
{
    _comment = comment;
    UserModel *user = comment.user;
    
    [self.iconBtn sd_setImageWithURL:user.avatar forState:UIControlStateNormal];
    self.nameLabel.text = user.nickname == nil ? @"匿名用户" : user.nickname;
    self.contentLabel.text = comment.content;
    self.likesLabel.text = comment.thumbs_up;
    self.commentsLabel.text = [NSString stringWithFormat:@"%ld",comment.replies.count];
    
    if (comment.is_thumb.integerValue) {
        self.commentLikeBtn.selected = YES;
    }else{
        self.commentLikeBtn.selected = NO;
    }
    
    if (comment.headerHeight == 0) {
        [self layoutIfNeeded];
        comment.headerHeight = CGRectGetMaxY(self.commentsLabel.frame);
    }
}

// 点击头像
- (IBAction)iconClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(dailyDetailHeader:iconClick:)]) {
        [self.delegate dailyDetailHeader:self iconClick:self.comment];
    }
}
// 点赞
- (IBAction)likeClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(dailyDetailHeader:likeClick:)]) {
        [self.delegate dailyDetailHeader:self likeClick:self.comment];
    }
    
}
// 点击评论
- (IBAction)commentClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(dailyDetailHeader:commentClick:)]) {
        [self.delegate dailyDetailHeader:self commentClick:self.comment];
    }
}


@end
