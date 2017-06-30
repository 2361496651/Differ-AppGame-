//
//  CommentPageMainCell.m
//  AppGame
//
//  Created by chan on 17/5/8.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CommentPageAboveCell.h"
#import "TagView.h"
#import "UIView+EasyLayout.h"
#import "GameModel.h"
#import "UserModel.h"
#import "DifferNetwork.h"
#import "StarView.h"
#import "ProfileViewController.h"
#import "DiffUtil.h"
#import "ViewFactory.h"

@interface CommentPageAboveCell()
@property(nonatomic,strong) UIView *titleView;

@property(nonatomic,strong) UIImageView *icon;
@property(nonatomic,strong) UILabel *userName;
@property(nonatomic,strong) UILabel *contentLB;
@property(nonatomic,strong) UIView *lineView;

@property(nonatomic, strong) NSMutableArray *tagsWidthArr;

@property(nonatomic, assign) CGFloat recordsTagsHeight;
@property(nonatomic,strong) UIView *locationView;
@property(nonatomic,strong) UIButton *commentCountBtn;
@property(nonatomic,strong) UIButton *tagCountBtn;

@property(nonatomic,strong) UIButton *sortBtn;

@property(nonatomic,strong)NSMutableArray<TagsModel*>* tagsList;

@property(nonatomic,strong) UIView *pointView;

@end

@implementation CommentPageAboveCell

@synthesize delegate;


#pragma mark - 懒加载view ----------------------------

-(UIView *)createPointView:(NSInteger)star{
    
    UIView *view = [self.contentView viewWithTag:999];
    if(view){
        [view removeFromSuperview];
    }

    _pointView = [ViewFactory createView:self.contentView backgroundColor:[UIColor clearColor]];
    _pointView.tag = 999;
    _pointView.el_topToBottom(self.userName,3).el_leftToLeft(self.userName,0);
    
    for (int i = 0; i < 5; i ++) {
        StarView *starView = [StarView new];
        [_pointView addSubview:starView];
        starView.el_toSize(CGSizeMake(13, 13)).el_topToSuperView(0).el_leftToSuperView(0 + (i * 13));
        starView.backgroundColor = [UIColor clearColor];
            
        if (star >= 1) {
            [starView setPercent:1];
        }else if(star < 0) {
            [starView setPercent:0];
        }else{
            [starView setPercent:star];
        }
        star -= 1;
            
        if (i == 4) {
            UILabel *starLB = [UILabel new];
            [_pointView addSubview:starLB];
            starLB.el_toSize(CGSizeMake(25, 30)).el_axisYToAxisY(starView,0).el_leftToRight(starView,5);
            starLB.text = [NSString stringWithFormat:@"%.1f",self.appraiseModel.star.floatValue];
            starLB.font = [UIFont systemFontOfSize:11];
            starLB.textColor = [UIColor grayColor];
        }
    }
    return _pointView;
}

-(UIView *)titleView{
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        _titleView.userInteractionEnabled = YES;
        UILabel *titleLable =[UILabel new];
        [_titleView addSubview:titleLable];
        titleLable.font = [UIFont boldSystemFontOfSize:18];
        titleLable.text = @"用户评价";
        titleLable.textColor = [UIColor blackColor];
        titleLable.el_axisYToSuperView(10).el_leftToSuperView(20);
        
        UIView *lineView = [UIView new];
        [_titleView addSubview:lineView];
        lineView.el_toHeight(2).el_leftToLeft(titleLable,0).el_rightToRight(titleLable,0).el_topToBottom(titleLable, 5);
        lineView.backgroundColor = [UIColor blackColor];
        
        self.sortBtn = [UIButton new];
        [_titleView addSubview:self.sortBtn];
        self.sortBtn.el_axisYToAxisY(titleLable,0).el_rightToSuperView(20);
        [self.sortBtn setTitle:@"按评价热度排列" forState:UIControlStateNormal];
        self.sortBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.sortBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.sortBtn setImage:[UIImage imageNamed:@"ic_sort"] forState:UIControlStateNormal];
        [self.sortBtn bk_whenTapped:^{
            [self.delegate clickSortBtn:self.sortBtn];
        }];
        
    }
    return _titleView;
}

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
        _userName.font = [UIFont systemFontOfSize:15];
        _userName.textColor = [UIColor grayColor];
    }
    return _userName;
}

-(UIButton *)commentCountBtn{
    if (!_commentCountBtn) {
        _commentCountBtn = [UIButton new];
        [self addSubview:_commentCountBtn];
        [_commentCountBtn setTitle:@"0" forState:UIControlStateNormal];
        [_commentCountBtn setImage:[UIImage imageNamed:@"game_icon_comment_little"] forState:UIControlStateNormal];
        [_commentCountBtn setTitleColor:[UIColor grayColor] forState: UIControlStateNormal];
        _commentCountBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _commentCountBtn;
}

-(UIButton *)tagCountBtn{
    if (!_tagCountBtn) {
        _tagCountBtn = [UIButton new];
        [self addSubview:_tagCountBtn];
        [_tagCountBtn setTitle:@"0" forState:UIControlStateNormal];
        [_tagCountBtn setImage:[UIImage imageNamed:@"game_icon_label"] forState:UIControlStateNormal];
        [_tagCountBtn setTitleColor:[UIColor grayColor] forState: UIControlStateNormal];
        _tagCountBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    }
    return _tagCountBtn;
}

-(UILabel *)contentLB{
    if (!_contentLB) {
        _contentLB = [UILabel new];
        [self.contentView addSubview:_contentLB];
//        _contentLB.numberOfLines = 0;
        _contentLB.font = [UIFont systemFontOfSize:14];
    }
    return _contentLB;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [UIView new];
        [self.contentView addSubview:_lineView];
        _lineView.backgroundColor = [UIColor ag_G5];
    }
    return _lineView;
}

-(NSMutableArray *)tagsWidthArr{
    if (!_tagsWidthArr) {
        _tagsWidthArr = [NSMutableArray array];
    }
    return  _tagsWidthArr;
}

#pragma mark - view初始化入口 ----------------------------
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

//        [self addSubview:self.spacingView];
        
        [self addSubview:self.titleView];
        
        self.icon.el_topToBottom(self.titleView,10).el_leftToSuperView(20).el_toSize(CGSizeMake(20, 20));
        
        self.userName.el_axisYToAxisY(self.icon,0).el_leftToRight(self.icon, 10).el_toWidth(180);
        
        self.commentCountBtn.el_axisYToAxisY(self.icon,0).el_rightToSuperView(20);
        
        self.tagCountBtn.el_axisYToAxisY(self.icon,0).el_rightToLeft(self.commentCountBtn,10);
        
        self.contentLB.el_topToBottom(self.icon,20).el_leftToLeft(self.userName,0).el_rightToSuperView(20);
        
        self.lineView.el_toHeight(0.8).el_leftToLeft(self.contentLB,0).el_rightToSuperView(0).el_topToBottom(self.contentLB,10);
        
        self.icon.userInteractionEnabled = YES;
        [self.icon bk_whenTapped:^{
            //切换到用户页面
            [delegate clickHeadIcon:self.appraiseModel.author.uid];
        }];
    }
    return self;
}

#pragma mark - 数据 ----------------------------
-(void) setAppraiseModel:(AppraiseModel *)appraiseModel{
    
    if (_appraiseModel == appraiseModel) return ;

    _appraiseModel = appraiseModel;
    
    UserModel *userModel = appraiseModel.author;
    CGFloat star = appraiseModel.star.floatValue / 2;
    
    [self createPointView:star];
    
    [self.icon sd_setImageWithURL:userModel.avatar];
    self.userName.text = userModel.nickname;
    [self.commentCountBtn setTitle:appraiseModel.commented forState:UIControlStateNormal];
    [self.tagCountBtn setTitle:appraiseModel.taged forState:UIControlStateNormal];
    self.contentLB.text = appraiseModel.content;

    
}

-(float) getLableWidth:(NSString *) labelText tagCount:(int)tagCount height:(CGFloat)height{
    NSString *text = [NSString stringWithFormat:@"%@ | %d",labelText,tagCount];
    CGSize size = [text di_sizeOfStringToLable:[UIFont systemFontOfSize:height/2] width:CGFLOAT_MAX];
    return size.width + 20;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma mark - 设置标签 ----------------------------
-(float)setTagView:(NSMutableArray<TagsModel*>*) tagsList{
   return [self setTagView:tagsList isShowAddTagView:YES isLimitRows:NO];
}

-(float)setTagView:(NSMutableArray<TagsModel*>*) tagsList isShowAddTagView:(BOOL)isShowAddTagView isLimitRows:(BOOL)isLimitRows{
    int rowCount = 0;
    
    if(!self.locationView){
        self.locationView = [UIView new];
        [self addSubview:self.locationView];
    }
//    self.locationView.backgroundColor = [UIColor ag_G6];
    [self.locationView removeAllSubviews];
    CGRect frame = CGRectMake(0, 0, 0, 18);
    
    self.locationView.el_topToBottom(self.lineView,10).el_leftToLeft(self.userName,0);
    self.tagsList = tagsList;
    
//    if (self.tagsList.count == 0) {
//        self.lineView.hidden = YES;
//        return 0;
//    }
    self.lineView.hidden = NO;
    
    // 创建标签按钮
    for (int i = 0; i < tagsList.count; i++) {
        TagsModel *tag = tagsList[i];
        CGFloat tagsWidth = [self getLableWidth:tag.name tagCount:tag.thumbs_up.intValue height:frame.size.height];
        
        frame.size.width = tagsWidth;
        UIColor *color;
        if([tag.is_thumb isEqualToString:@"1"]){
            color = [UIColor di_MAIN2];
            self.tag = 1;
        }else{
            self.tag = 0;
            color = [UIColor grayColor];
        }
        TagView *tagView = [[TagView alloc] initWithFrame:frame TagType:TagTypeSolidLine BorderColor:color];
        [self.locationView addSubview:tagView];

        tagView.tagText.textColor = [UIColor grayColor];
        //如果标签点赞数大于99则显示为99+
        NSString *text;
        if(tag.thumbs_up.intValue > 99){
            text = [NSString stringWithFormat:@"%@ | %@",tag.name,@"99+"];
        }else{
            text = [NSString stringWithFormat:@"%@ | %d",tag.name,tag.thumbs_up.intValue];
        }
//        tagView.tagText.text = [NSString stringWithFormat:@"%@ | %d",tag.name, tag.thumbs_up.intValue];
        tagView.tagText.text = text;
        
        tagView.tagText.textColor =color;
        tagView.tag = i;

        
        //当前的x坐标 + 当前宽度 + 10，得到下一个的x坐标
        frame.origin.x = frame.origin.x + tagsWidth + 10;
        if(i < tagsList.count - 1){
            CGFloat nextTagsWidth = [self getLableWidth:tagsList[i+1].name tagCount:tagsList[i+1].thumbs_up.intValue height:frame.size.height];
            //判断下一个的x坐标 + 下一个的宽度 + 10，如果超出范围则换行
//            NSLog(@"%f",self.userName.origin.x);
            if(frame.origin.x + nextTagsWidth + 10 > ScreenWidth - 50){
                //限制行数--------------------------------------------
                rowCount ++;
                if (rowCount >= 3 && isLimitRows) {
                    break;
                }
                frame.origin.x  = 0;
                frame.origin.y += frame.size.height + 10;
                
            }
            
        }
            if (isShowAddTagView) {
                tagView.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTag:)];
                [tagView addGestureRecognizer:singleTap];
            }
        
    }
    
    if (isShowAddTagView) {
        frame.size.width  = 50;
        if(frame.origin.x + frame.size.width + 10 > ScreenWidth - self.userName.origin.x){
            frame.origin.x  = 0;
            frame.origin.y += frame.size.height + 10;
        }
        
        TagView *tagView = [[TagView alloc] initWithFrame:frame TagType:TagTypeDottedLine BorderColor:[UIColor grayColor]];
        [self.locationView addSubview:tagView];
        tagView.tagText.text = @"+";
        tagView.tagText.textColor = [UIColor grayColor];
        tagView.userInteractionEnabled = YES;
        [tagView bk_whenTapped:^{
            //add标签
            [self.delegate clickCellTagAdd];
        }];
    }
    
    self.recordsTagsHeight = frame.origin.y + frame.size.height ;
    self.locationView.el_toSize(CGSizeMake(ScreenWidth, self.recordsTagsHeight + frame.size.height*2));//frame.size.height*2 扩大正常的范围，以防+号按钮范围不能覆盖
    return self.recordsTagsHeight;
}

-(void)setContentRow:(NSInteger)interger{
    self.contentLB.numberOfLines = interger;
}

-(void)isShowMoreView:(BOOL)isShowMoreView isRemoveMoerView:(BOOL)isRemoveMoerView isShowRortBtn:(BOOL)isShowRortBtn{
    if (!isShowRortBtn) {
        [self.sortBtn removeFromSuperview];
    }
    
    if (isRemoveMoerView) {
        [self.titleView hideSubviews];
        self.titleView.backgroundColor = [UIColor whiteColor];
        CGRect frame = self.titleView.frame;
        frame.size.height = 0;
        self.titleView.frame = frame;
        return;
    }
    
    if (isShowMoreView) {
        [self.titleView showSubviews];
        self.titleView.backgroundColor = [UIColor whiteColor];
        CGRect frame = self.titleView.frame;
        frame.size.height = 60;
        self.titleView.frame = frame;

    }else{
        [self.titleView hideSubviews];
        self.titleView.backgroundColor = [UIColor ag_G5];
        CGRect frame = self.titleView.frame;
        frame.size.height = 10;
        self.titleView.frame = frame;
    }
}

#pragma mark - 点击事件 ----------------------------
- (void)clickTag:(UIGestureRecognizer *)gestureRecognizer {
    TagView *view = (TagView*)[gestureRecognizer view];
    NSInteger tagId = view.tag;
    TagsModel *tag = (TagsModel*)[self.tagsList objectAtIndex:tagId];
    //如果标签是自己已经点击的 ，且只有自己点击的则不能点
    if([tag.is_thumb isEqualToString:@"1"] && tag.thumbs_up.integerValue < 2){
        return;
    }
    NSString *type = [tag.is_thumb isEqualToString:@"1"] ? @"0" : @"1";
    [[[DifferNetwork shareInstance]  postTagsThumb:tag.uid type:type]subscribeNext:^(id x) {
        //[self loadTagsData];
        [delegate reloadTableView];
        NSLog(@"顶标签成功");
    } error:^(NSError *error) {
        NSLog(@"顶标签失败：%@",error);

    }];

}

@end
