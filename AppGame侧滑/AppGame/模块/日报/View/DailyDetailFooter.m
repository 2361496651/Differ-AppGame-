//
//  DailyDetailFooter.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/12.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DailyDetailFooter.h"
#import "CommentModel.h"

@interface DailyDetailFooter ()

@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@end

@implementation DailyDetailFooter

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"DailyDetailFooter" owner:nil options:nil]firstObject];
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
    
    NSString *showContent = nil;
    if (comment.isFold && comment.replies.count >= 3) {//折叠并大于3条 折叠数在 DailyDetailViewController 类中有定义
        showContent = [NSString stringWithFormat:@"查看全部%ld条评论",(unsigned long)comment.replies.count];
    }else if (!comment.isFold && comment.replies.count >= 3){
        showContent = @"收起";
    }
    [self.showBtn setTitle:showContent forState:UIControlStateNormal];
}

// 点击查看全部与收起
- (IBAction)changeShowStat:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(DailyDetailFooterCell:moreCommentClick:)]) {
        [self.delegate DailyDetailFooterCell:self moreCommentClick:self.comment];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
