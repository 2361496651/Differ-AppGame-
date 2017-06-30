//
//  CommentPageBelowCell.m
//  AppGame
//
//  Created by chan on 17/5/10.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CommentPageBelowCell.h"
#import "UserModel.h"
#import "GameServices.h"
#import "DiffUtil.h"

#import "CommentPageViewController.h"
#import "DifferNetwork.h"

@interface CommentPageBelowCell()

@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *userName;
@property(nonatomic,strong) UIButton *commentCountBtn;
@property(nonatomic,strong) UIButton *endorseCountBtn;
@property(nonatomic,strong) UILabel *contentLB;

@property(nonatomic,strong)NSArray *replies;
@property(nonatomic,strong) UIView *replyView;
@end

@implementation CommentPageBelowCell

@synthesize delegate;

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [UIImageView new];
        [self addSubview:_icon];
        _icon.layer.masksToBounds =YES;
        _icon.layer.cornerRadius =10;
    }
    return _icon;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [UILabel new];
        [self addSubview:_userName];
        _userName.textColor = [UIColor grayColor];
        _userName.font = [UIFont systemFontOfSize:15];
    }
    return _userName;
}

-(UILabel *)contentLB{
    if (!_contentLB) {
        _contentLB = [UILabel new];
        [self addSubview:_contentLB];
        _contentLB.numberOfLines = 0;
        _contentLB.font = [UIFont systemFontOfSize:13];
    }
    return _contentLB;
}

-(UIButton *)endorseCountBtn{
    if (!_endorseCountBtn) {
        _endorseCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_endorseCountBtn];
        _endorseCountBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_endorseCountBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_endorseCountBtn setTitle:@"0" forState:UIControlStateNormal];
        [_endorseCountBtn setImage:[UIImage imageNamed:@"game_icon_like_def"] forState:UIControlStateNormal];
    }
    return _endorseCountBtn;
}

-(UIButton *)commentCountBtn{
    if (!_commentCountBtn) {
        _commentCountBtn =  [UIButton new];
        [self addSubview:_commentCountBtn];
        [_commentCountBtn setTitleColor:[UIColor grayColor] forState: UIControlStateNormal];
        _commentCountBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_commentCountBtn setTitle:@"0" forState:UIControlStateNormal];
        [_commentCountBtn setImage:[UIImage imageNamed:@"game_icon_comment_little"] forState:UIControlStateNormal];
    }
    return _commentCountBtn;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.icon.el_topToSuperView(10).el_leftToSuperView(20).el_toSize(CGSizeMake(20, 20));

        self.userName.el_axisYToAxisY(self.icon,0).el_leftToRight(self.icon, 10).el_toWidth(180);
        
        self.contentLB.el_topToBottom(self.userName,20).el_leftToLeft(self.userName,0).el_rightToRight(self.contentView,20);

        self.endorseCountBtn.el_rightToSuperView(20).el_topToBottom(self.contentLB,5);
     
        self.commentCountBtn.el_axisYToAxisY(self.endorseCountBtn,0).el_rightToLeft(self.endorseCountBtn,10);
        
        
        UIView *lineView = [UIView new];
        [self.contentView addSubview:lineView];
        lineView.el_toHeight(0.5).el_leftToSuperView(20).el_rightToSuperView(0).el_bottomToSuperView(2);
        lineView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
        
        //点击喜欢
        [self.endorseCountBtn bk_whenTapped:^{
            NSString *type = self.commentModel.is_thumb.integerValue ? @"0" : @"1";
            [[[DifferNetwork shareInstance] commentThumbWithCommentId:self.commentModel.uid type:type] subscribeNext:^(id x) {
                
                self.commentModel.is_thumb = type;
                int value = 0;
                if ([type isEqualToString:@"0"]) {
                    value = self.commentModel.thumbs_up.intValue;
                    [self setLikeBtnState:self.endorseCountBtn isSelected:NO];
                }else{
                    value = self.commentModel.thumbs_up.intValue + 1;
                    [self setLikeBtnState:self.endorseCountBtn isSelected:YES];
                }
                //
                //                [self setupCommentTableView];
                [self.endorseCountBtn setTitle:[NSString stringWithFormat:@"%d",value] forState:UIControlStateNormal];
                NSLog(@"评论点赞成功");
            } error:^(NSError *error) {
                NSLog(@"评论点赞失败");
            }];
            
        }];
        
        //点击回复评论
        [self.commentCountBtn bk_whenTapped:^{
            [self.delegate clickCellCommentCount:self.commentModel.user.nickname commentModel:self.commentModel];
        }];
        
    }
    
    self.icon.userInteractionEnabled = YES;
    [self.icon bk_whenTapped:^{
        NSLog(@" --------------- %@",self.commentModel.user.uid);
        [delegate clickHeadIcon:self.commentModel.user.uid];
    }];
    return self;
}

-(UIView*)createReplyView{
    
    //创建replies
    self.replyView = [UIView new];
    [self.contentView addSubview:self.replyView];
    self.replyView.backgroundColor = [UIColor HEX:0xf6f6f6];
    //        [replyView addSubview:[self createSingleReplyView:@"我的了" content:@"sdfjsdfe"]];
    for (int i = 0; i < self.replies.count; i++) {
        if( !self.commentModel.isFold )
            if(i == 2)break;
        
        ReplyModel *reply = [self.replies objectAtIndex:i];
        UIView *view = [self createSingleReplyView:reply.user.nickname content:reply.content];
        [self.replyView addSubview:view];
        CGRect frame = view.frame;
        frame.origin.y = frame.origin.y + (i)*20;
        view.frame = frame;
        view.tag = i;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickReplyView:)];
        [view addGestureRecognizer:singleTap];

    }
    
    if(self.replies.count > 2){
        NSString *text;
        if (self.commentModel.isFold) {
            text = @"收起";
        }else{
            text = [NSString stringWithFormat:@"查看全部%lu条评论",(unsigned long)self.replies.count];
        }
        
        UILabel *nameLable = [UILabel new];
        [self.replyView addSubview:nameLable];
        //    nameLable.backgroundColor = [UIColor redColor];
        nameLable.textColor = [UIColor di_MAIN2];
        nameLable.font = [UIFont systemFontOfSize:12];
        nameLable.text = text;
        nameLable.textAlignment = NSTextAlignmentRight;
        nameLable.el_toSize(CGSizeMake(200, 20)).el_rightToSuperView(10).el_bottomToSuperView(10);
        nameLable.userInteractionEnabled = YES;
        [nameLable bk_whenTapped:^{
            [delegate clickOpenConment:self.commentModel];
        }];
    }
    self.replyView.el_toSize(CGSizeMake(ScreenWidth-40, [self getBelowCellCommentReplyHeight] - 10)).el_topToBottom(self.commentCountBtn,8).el_leftToSuperView(20);
    return self.replyView;
}

-(void) setCommentModel:(CommentModel *)commentModel{
    
    UserModel *userModel = commentModel.user;
    
    _commentModel = commentModel;
    self.replies = nil;
    self.replies = commentModel.replies;
    [self.icon sd_setImageWithURL:userModel.avatar];
    self.userName.text = userModel.nickname;
    self.contentLB.text = commentModel.content;
    [self.endorseCountBtn setTitle:commentModel.thumbs_up forState:UIControlStateNormal];
    if([commentModel.is_thumb isEqualToString:@"1"]){
        [self setLikeBtnState:self.endorseCountBtn isSelected:YES];
    }
    [self.commentCountBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)self.replies.count] forState:UIControlStateNormal];
    if(self.replies.count > 0){
        if(self.replyView){
            [self.replyView removeFromSuperview];
        }
        [self createReplyView];
        self.replyView.hidden = NO;
    }else{
        if(self.replyView){
            self.replyView.hidden = YES;
        }
    }
}

-(UIView*)createSingleReplyView:(NSString*)name content:(NSString*)content{
    CGSize nameSize = [name di_sizeOfStringToLable:[UIFont systemFontOfSize:13] width:CGFLOAT_MAX];
    CGSize contentSize = [content di_sizeOfStringToLable:[UIFont systemFontOfSize:13] width:CGFLOAT_MAX];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth - 40, 20)];
    UILabel *nameLable = [UILabel new];
    [view addSubview:nameLable];
//    nameLable.backgroundColor = [UIColor redColor];
    nameLable.textColor = [UIColor blackColor];
    nameLable.font = [UIFont systemFontOfSize:13];
    nameLable.text = [NSString stringWithFormat:@"%@:",name];
    nameLable.el_toSize(CGSizeMake(nameSize.width+5, 20)).el_leftToSuperView(30).el_topToSuperView(2);
    
    UILabel *contentLable = [UILabel new];
    [view addSubview:contentLable];
    contentLable.textColor = [UIColor HEX:0x9a9a9a];
    contentLable.font = [UIFont systemFontOfSize:13];
    contentLable.text = content;
    contentLable.el_leftToRight(nameLable,4).el_axisYToAxisY(nameLable,0).el_toSize(CGSizeMake(contentSize.width+5, 20));
    
    
    return view;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -  计算评论回复的高度
-(float)getBelowCellCommentReplyHeight{
    
    float height = 0; //计算评论回复的高度
    
    NSArray *replies = self.commentModel.replies;
    if(replies.count > 0){
        if(!self.commentModel.isFold){
            if(replies.count == 1){
                height = height + 40;
            }else{
                height = height + 60;
            }
        }else{
            height = height + 20 + replies.count * 20;
        }
        
        if(replies.count > 2){
            height = height + 20;
        }
    }
    height += 10;//增加距离底部10个点
    return height;
}

#pragma mark - 点击事件 ----------------------------
- (void)clickReplyView:(UIGestureRecognizer *)gestureRecognizer {
    UIView *view = [gestureRecognizer view];
    NSInteger index = view.tag;
    ReplyModel *reply = (ReplyModel*)[self.replies objectAtIndex:index];
    
    [delegate clickCommentReply:reply commentModel:self.commentModel];
    
//    NSString *type = [tag.is_thumb isEqualToString:@"1"] ? @"0" : @"1";
//    [[DifferNetwork shareInstance]  postTagsThumb:tag.uid type:type success:^(id responseObj) {
//        //[self loadTagsData];
//        [delegate reloadTableView];
//        NSLog(@"顶标签成功");
//    } failure:^(NSError *error) {
//        NSLog(@"顶标签失败：%@",error);
//    }];
}

-(void)setLikeBtnState:(UIButton*)button isSelected:(BOOL)isSelected{
    if (isSelected) {
        [button setImage:[UIImage imageNamed:@"game_icon_like_pre"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor di_MAIN2] forState:UIControlStateNormal];
    }else{
        [button setImage:[UIImage imageNamed:@"game_icon_like_def"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

@end
