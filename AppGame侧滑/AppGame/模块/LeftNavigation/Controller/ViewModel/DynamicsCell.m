//
//  DynamicsCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/23.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DynamicsCell.h"
#import "DynamicModel.h"
#import "GameModel.h"
#import "UserModel.h"
#import "CategoryModel.h"
#import "PicCollectionView.h"
#import "DiffUtil.h"
#import "NSDate+CJTime.h"

#import <UIImageView+WebCache.h>

//距离屏幕两侧的边距 展示图片的item间距
#define edgMargin 20
#define itemMargin 10

@interface DynamicsCell ()

// 相关约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidthConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCollectionViewWidthConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCollectionViewHeightConst;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picCollectionViewToGameIconConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *retweetedContentToContentConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gameBgViewLeadingConst;



@property (weak, nonatomic) IBOutlet UIView *sectionView;


//主动态
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//转发
@property (weak, nonatomic) IBOutlet UIView *retweetedBgView;
@property (weak, nonatomic) IBOutlet UILabel *retweetedContent;
@property (weak, nonatomic) IBOutlet PicCollectionView *picCollectionView;

// 游戏
@property (weak, nonatomic) IBOutlet UIView *gameBgView;

@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (weak, nonatomic) IBOutlet UILabel *gameTag1;
@property (weak, nonatomic) IBOutlet UILabel *gameTag2;

@property (weak, nonatomic) IBOutlet UILabel *gameTag3;

// 底部工具栏
@property (weak, nonatomic) IBOutlet UIView *toolBarView;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;

@property (weak, nonatomic) IBOutlet UILabel *likesLabel;

@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;



@end

@implementation DynamicsCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    //    static NSString *ID = @"commentCell";
    DynamicsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicsCell"];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DynamicsCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setDynamic:(DynamicModel *)dynamic
{
    _dynamic = dynamic;
    
    UserModel *user = dynamic.author;
    GameModel *game = dynamic.game;
    DynamicModel *retweetDynamic = dynamic.forward;
    NSArray *images = dynamic.images;
    
    [self.userIcon sd_setImageWithURL:user.avatar];
    
    NSString *userNick = user.nickname;
    if (userNick == nil || [userNick isEqualToString:@""]) {
        userNick = @"differ用户";
    }
    self.userNameLabel.text = userNick;
    
    self.fromLabel.text = dynamic.is_forward.integerValue ? @"转发" : @"分享游戏";
    
    NSDate *time = [NSDate dateWithTimeIntervalSince1970:dynamic.created_at.longLongValue];
    self.timeLabel.text = [time diff2now];
    
    
    NSString * htmlString = dynamic.content;
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.contentLabel.attributedText = attrStr;
    self.contentLabel.font = [DiffUtil getDifferFont:16];
    
    //配图collectionView的大小
    CGSize picViewSize = [self calculatePicCollectionViewSize:images.count];
    self.picCollectionViewWidthConst.constant = picViewSize.width;
    self.picCollectionViewHeightConst.constant = picViewSize.height;
    
    self.picCollectionView.urls = images;
    
    //转发动态
    if (retweetDynamic != nil) {
        
        if (retweetDynamic.content) {
            self.retweetedContent.text = [NSString stringWithFormat:@"@%@:%@",retweetDynamic.author.nickname,retweetDynamic.content];
            self.retweetedContentToContentConst.constant = 10;
        }else{
            self.retweetedContent.text = nil;
            self.retweetedContentToContentConst.constant = 5;
        }
        
        self.retweetedBgView.hidden = NO;
        
        
    }else{
        self.retweetedContent.text = nil;
        self.retweetedBgView.hidden = YES;
        self.retweetedContentToContentConst.constant = 5;
        
        
    }
    
    //背景颜色处理
    if (dynamic.is_forward.integerValue) {//转发
        self.gameBgView.backgroundColor = [UIColor whiteColor];
        self.retweetedBgView.backgroundColor = [DiffUtil colorWithHexString:@"F4F4F4"];
        
        self.gameBgViewLeadingConst.constant = -10;//游戏背景色向右偏移一点

        
    }else{
        self.gameBgView.backgroundColor = [DiffUtil colorWithHexString:@"F4F4F4"];
        self.retweetedBgView.backgroundColor = [UIColor whiteColor];
        
        self.gameBgViewLeadingConst.constant = 0;

    }
    
    //游戏
    [self.gameIcon sd_setImageWithURL:game.icon];
    self.gameName.text = game.game_name_cn;
    for (int i = 0; i < game.categoryArray.count; i++) {
        
        CategoryModel *category = game.categoryArray[i];
        NSString *tagStr = category.name;
        
        if (i == 0) {
            self.gameTag1.text = [NSString stringWithFormat:@" %@ ",tagStr];
        }else if (i == 1){
            self.gameTag2.text = [NSString stringWithFormat:@" %@ ",tagStr];
        }else if (i == 2){
            self.gameTag3.text = [NSString stringWithFormat:@" %@ ",tagStr];
        }
    }
    
    // toolBar
    if (dynamic.is_thumb.integerValue) {
        [self.likeBtn setImage:[UIImage imageNamed:@"game_icon_like_pre"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"game_icon_like_def"] forState:UIControlStateNormal];
    }
    
    self.likesLabel.text = dynamic.thumbs_up;
    self.commentsLabel.text = dynamic.commented;
    self.shareLabel.text = dynamic.shared;
    
    
    //行高
    if (dynamic.cellHeight == 0) {
        [self layoutIfNeeded];
        dynamic.cellHeight = CGRectGetMaxY(self.sectionView.frame);
    }
}

//配图分析  计算collectionview的尺寸
/*
 没有配图
 四张配图 田字
 其他张配图 （count -1）/3 + 1 = rows
 */
- (CGSize)calculatePicCollectionViewSize:(NSInteger)picsCount
{
    if (picsCount == 0) {
        self.picCollectionViewToGameIconConst.constant = 10;
        return CGSizeZero;
    }
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.picCollectionView.collectionViewLayout;
    // 40 从用户icon后面开始，用户icon宽高40
//    CGFloat itemWH = ([UIScreen mainScreen].bounds.size.width - 2*edgMargin - 2*itemMargin - 40) / 3;
    CGFloat itemWH = (self.contentWidthConst.constant - 2*itemMargin) / 3;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    
    
    if (picsCount == 4) {
        CGFloat picViewWH = itemWH * 2 + itemMargin;
        return CGSizeMake(picViewWH, picViewWH);
    }
    
    NSInteger rows = (picsCount - 1)/3 + 1;
    CGFloat picViewH = rows * itemWH + (rows - 1.0) * itemMargin;
    CGFloat picViewW = self.contentWidthConst.constant;
//    CGFloat picViewW = [UIScreen mainScreen].bounds.size.width - 2*edgMargin - 40;
    
    return CGSizeMake(picViewW, picViewH);
    
    
//    return CGSizeZero;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentWidthConst.constant = [UIScreen mainScreen].bounds.size.width - 2 * edgMargin - 40; // 40 用户头像宽高
    
    self.gameTag1.layer.borderColor = [UIColor blackColor].CGColor;
    self.gameTag1.layer.borderWidth = 0.5;
    self.gameTag1.layer.opacity = 0.3;
    
    self.gameTag2.layer.borderColor = [UIColor blackColor].CGColor;
    self.gameTag2.layer.borderWidth = 0.5;
    self.gameTag2.layer.opacity = 0.3;
    
    self.gameTag3.layer.borderColor = [UIColor blackColor].CGColor;
    self.gameTag3.layer.borderWidth = 0.5;
    self.gameTag3.layer.opacity = 0.3;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
