//
//  CommentPageViewController.m
//  AppGame
//
//  Created by chan on 17/5/5.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CommentPageViewController.h"
#import "UIView+EasyLayout.h"
#import "CommonMacroDefinition.h"
#import "GameModel.h"
#import "UIImageView+WebCache.h"
#import "TagView.h"
#import "AGTools.h"
#import "UIView+Extension.h"
#import "CommentPageAboveCell.h"
#import "CommentPageBelowCell.h"
#import "CommentsDetailCell.h"
#import "DifferNetwork.h"
#import "CommentModel.h"
#import <MJExtension.h>
#import "CommentHeaderView.h"
#import "DiffUtil.h"
#import "GameServices.h"
#import "CommentType.h"
#import "DifferAccountTool.h"
#import "DifferAccount.h"
#import "TagsModel.h"
#import "ProfileViewController.h"
#import "GameDetailViewController.h"
#import "ViewFactory.h"

typedef NS_ENUM(NSUInteger, ReplyType) {
    ReplyType_To_Author,
    ReplyType_To_User,
    ReplyType_To_Tag,
    ReplyType_To_Comment_User
};

@interface CommentPageViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,CommentPageBelowCelllDelegate,CommentPageAboveCellDelegate>
//topView
@property(nonatomic, strong) UIView *topView;

//tableView
@property(nonatomic, strong) UITableView *tableView;

//bottomView
@property(nonatomic, strong) UIView *bottomView;

@property(nonatomic, strong) UIView *bottomReplyView;

@property(nonatomic, strong) UITextField *bottomCommentTextField;

@property(nonatomic, strong) GameModel *gameModel;

@property(nonatomic, strong) NSMutableArray<CommentModel *> *commentsArray;

@property(nonatomic, strong) NSMutableArray *belowCellHeightArr;
@property(nonatomic, assign) CGFloat aboveCellLabelHeight;
@property(nonatomic, assign) CGFloat aboveCellTagsHeght;

@property(nonatomic, strong) NSMutableArray<TagsModel *> *tagsList;

@property(nonatomic,strong) NSString *commentPlaceholder;

@property(nonatomic) ReplyType replyType;

@property(nonatomic,strong) CommentModel *replyCommentModel;
@property(nonatomic,strong) CommentPageAboveCell *aboveCell;
@property(nonatomic,strong) CommentPageBelowCell *belowCell;
@property(nonatomic,strong) ReplyModel *replyModel;

@property(nonatomic) float aboveCellHeight;

@property(nonatomic,strong) UIView *coverView;
@end

@implementation CommentPageViewController

-(NSString *)commentPlaceholder{
    return @"说点什么吧";
}
#pragma mark 视图懒加载 -----------------------

-(UIView *)coverView{
    if (!_coverView) {
        //创建一个遮罩
        _coverView = [[UIView alloc] initWithFrame:self.view.frame];
        _coverView.backgroundColor = [UIColor clearColor];
//        _coverView.alpha = 0.4;
        _coverView.userInteractionEnabled = YES;
        [self.view addSubview:_coverView];
        
        [_coverView bk_whenTapped:^{
            [self.bottomCommentTextField resignFirstResponder];
        }];
    }
    return _coverView;
}

- (UITableView *) tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [UIView new];
        [self.view addSubview:_topView];
        _topView.backgroundColor = [UIColor whiteColor];
        _topView.layer.shadowColor = [UIColor blackColor].CGColor;
        _topView.layer.shadowOffset = CGSizeMake(0, 1);
        _topView.layer.shadowOpacity=0.1;
        
        UIImageView *icon = [UIImageView new];
        [_topView addSubview:icon];
        [icon sd_setImageWithURL:self.gameModel.icon];
        icon.el_toSize(CGSizeMake(18, 18)).el_axisYToAxisY(_topView,0).el_leftToLeft(_topView,20);
        
        UILabel *gameName = [UILabel new];
        [self.topView addSubview:gameName];
        gameName.text = self.gameModel.game_name_cn;
        gameName.font = [UIFont boldSystemFontOfSize:18];
        gameName.el_toHeight(18).el_rightToSuperView(0).el_axisYToAxisY(_topView,0).el_leftToRight(icon,10);
        
    }
    return _topView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [UIView new];
        [self.view addSubview:_bottomView];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0, -1);
        _bottomView.layer.shadowOpacity=0.1;
        
        UIImageView *imageView = [UIImageView new];
        [_bottomView addSubview:imageView];
        imageView.el_toSize(CGSizeMake(25, 25)).el_axisYToSuperView(0).el_leftToSuperView(10);
        imageView.image = [UIImage imageNamed:@"icon_tab_comment"];
        
//        TagView *tagView = [[TagView alloc] initWithFrame:CGRectMake(0, 0, 80, 30) TagType:TagTypeDottedLine BorderColor:[UIColor grayColor]];
//        [_bottomView addSubview:tagView];
//        tagView.el_toSize(CGSizeMake(80, 30)).el_axisYToSuperView(0).el_rightToRight(_bottomView,20);
//        tagView.tagText.textColor = [UIColor grayColor];
//        tagView.tagText.text = @"+ 贴标签";
        
        UIButton *bottomButton = [UIButton new];
        [_bottomView addSubview: bottomButton];
        bottomButton.el_toHeight(30).el_axisYToSuperView(0).el_leftToRight(imageView,10).el_rightToSuperView(10);
        bottomButton.backgroundColor = [UIColor clearColor];
        [bottomButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [bottomButton setTitle:self.commentPlaceholder forState:UIControlStateNormal];
        bottomButton.titleLabel.font = [UIFont systemFontOfSize:15];
        bottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [bottomButton bk_whenTapped:^{
            [self showBottomReplyViewVisible:@"请输入内容" replyType:ReplyType_To_Author];
        }];
        
//        [tagView bk_whenTapped:^{
//            [self showBottomReplyViewVisible:@"请标签输入内容" replyType:ReplyType_To_Tag];
//        }];
    }
    return _bottomView;
}

-(UIView *)bottomReplyView{
    if(!_bottomReplyView){

        _bottomReplyView = [UIView new];
        [self.view addSubview:_bottomReplyView];
        _bottomReplyView.backgroundColor = [UIColor whiteColor];
        _bottomReplyView.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottomReplyView.layer.shadowOffset = CGSizeMake(0, -1);
        _bottomReplyView.layer.shadowOpacity=0.1;
        
        UIButton *replyButton = [UIButton new];
        [_bottomReplyView addSubview:replyButton];
        replyButton.layer.cornerRadius = 5;
        replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [replyButton setBackgroundColor:[UIColor di_MAIN2]];
        [replyButton setTitle:@"发送" forState:UIControlStateNormal];
        [replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        replyButton.el_toSize(CGSizeMake(50, 30)).el_axisYToSuperView(0).el_rightToRight(_bottomView,20);
        
        self.bottomCommentTextField = [UITextField new];
        [_bottomReplyView addSubview:self.bottomCommentTextField];
        self.bottomCommentTextField.delegate = self;
        self.bottomCommentTextField.el_toHeight(30).el_axisYToSuperView(0).el_leftToSuperView(10).el_rightToLeft(replyButton, 20);
        self.bottomCommentTextField.placeholder = self.commentPlaceholder;
        self.bottomCommentTextField.font = [UIFont systemFontOfSize:15];
        
        [replyButton bk_whenTapped:^{
            [self.bottomCommentTextField resignFirstResponder];
            if(![DiffUtil judgIsLoginWithViewController:[DiffUtil currentViewController]]){
                return;
            }
            
            ReplyType replyType = self.bottomCommentTextField.tag;
            switch (replyType) {
                case ReplyType_To_Author:
                    NSLog(@"回复作者");
                    if(![self.bottomCommentTextField.text isEqualToString:@""]){
//                        [[GameServices shareInstance] addTagOrCommentWithTarget:@"appraise" targetId:self.appraiseModel.uid name:self.bottomCommentTextField.text isTag:NO isSuccess:^(BOOL isSuccess) {
//                            if(isSuccess){
//                                [self loadData];
//                            }
//                        }];
                        
                        [[GameServices shareInstance] addTagOrCommentWithTarget:@"appraise" targetId:self.appraiseModel.uid name:self.bottomCommentTextField.text isTag:NO isSuccess:^(BOOL isSuccess) {
                            if(isSuccess){
                                [self loadData];
                            }
                        } failure:^(NSError *error, NSUInteger code, NSString *notice) {
                            NSString *noticeStr = notice ? notice : @"回复失败";
                            [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
                            NSLog(@"回复失败：%@",error);
                        }];
                    }
                    break;
                case ReplyType_To_User:
                    {
                        NSLog(@"回复用户");
                        if(![self.bottomCommentTextField.text isEmpty]){
                            
                            [[[DifferNetwork shareInstance] commentReplyWithCommentId:self.replyCommentModel.uid
                                                                              content:self.bottomCommentTextField.text
                                                                            isReplied:NO
                                                                              replyId:nil
                                                                          replyUserId:nil]
                             subscribeNext:^(id object) {
                                [self loadData];
                                NSLog(@"评论成功");
                            } error:^(NSError *error) {
                                NSString *noticeStr = [error description] ? [error description] : @"评论失败";
                                [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
                                NSLog(@"评论失败:%@",error);
                            }];
                        }
                    }
                    break;
                case ReplyType_To_Tag:
                    [self tagBtnClick];
                    NSLog(@"回复标签");
                    [self tagAdd];
                    break;
                case ReplyType_To_Comment_User:
                {
                    if(![self.bottomCommentTextField.text isEmpty]){
                        NSLog(@"commentuid = %@, replyuid = %@, replyuserid = %@",self.replyCommentModel.uid,self.replyModel.uid,self.replyModel.user.uid);
                        NSString *content = [NSString stringWithFormat:@"回复%@ %@",self.replyModel.user.nickname, self.bottomCommentTextField.text];
                        [[[DifferNetwork shareInstance] commentReplyWithCommentId:self.replyCommentModel.uid
                                                                          content:content
                                                                        isReplied:YES
                                                                          replyId:self.replyModel.uid
                                                                      replyUserId:self.replyModel.user.uid]
                         subscribeNext:^(id x) {
                            NSLog(@"回复评论成功");
                            [self loadData];
                        } error:^(NSError *error) {
                            NSString *noticeStr = [error description] ? [error description] : @"点击某一行进行评论失败";
                            [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
                            NSLog(@"点击某一行进行评论失败:%@",error);
                        }];
                    }
                }
                    break;
                default:
                    break;
            }
        }];
        
    }
    
    UIView *lineView1 = [ViewFactory createLineView:_bottomReplyView];
    lineView1.backgroundColor = [UIColor grayColor];
    lineView1.el_toWidth(ScreenWidth).el_leftToSuperView(0).el_topToSuperView(0);
    
    UIView *lineView2 = [ViewFactory createLineView:_bottomReplyView];
    lineView2.backgroundColor = [UIColor grayColor];
    lineView2.el_toWidth(ScreenWidth).el_leftToSuperView(0).el_bottomToSuperView(0);
    
    return _bottomReplyView;
}


- (NSMutableArray *)commentsArray
{
    if (_commentsArray == nil) {
        _commentsArray = [NSMutableArray array];
    }
    return _commentsArray;
}

static NSString * const headerId = @"header";


#pragma mark - 生命周期 ---------------------

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听键盘frame改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aboveCellHeight = 0;
    self.replyType = ReplyType_To_Author;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.title = @"评论正文";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.gameModel = self.appraiseModel.game;
    
    self.topView.el_toSize(CGSizeMake(ScreenWidth, 50));
    
    //166 = topview51 + bottomView51 + navigationView44+ 状态栏20
    self.tableView.el_toSize(CGSizeMake(ScreenWidth, self.view.height -166)).el_topToBottom(self.topView,1);
    [self.tableView registerClass:[CommentHeaderView class] forHeaderFooterViewReuseIdentifier:headerId];
    
    self.bottomView.el_toSize(CGSizeMake(ScreenWidth,50)).el_bottomToBottom(self.view,0).el_axisXToSuperView(0);
    
    [self loadData];
    
    [self loadTagsData];
    
    self.coverView.hidden = YES;
    
    self.topView.userInteractionEnabled = YES;
    
    [self.topView bk_whenTapped:^{
        GameDetailViewController *gameDetailVC = [[GameDetailViewController alloc] init];
        gameDetailVC.gameModel = self.gameModel;
        [self.navigationController pushViewController:gameDetailVC animated:YES];
    }];
    
}

//点击屏幕处理方法，取消textField第一响应者
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.bottomCommentTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 键盘 --------------------
- (void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat keyboardHeight = keyboardRect.size.height;
    CGRect frame = self.bottomView.frame;
    frame.origin.y = self.view.height - frame.size.height - keyboardHeight;
    [self.bottomReplyView setFrame:frame];
    self.coverView.hidden = NO;
}


- (void)keyboardWillHide:(NSNotification *)notification{
//    CGRect frame = self.bottomView.frame;
//    frame.origin.y = self.view.frame.size.height - frame.size.height;
//    [self.bottomView setFrame:frame];
    self.bottomReplyView.hidden = YES;
    self.coverView.hidden = YES;

}

#pragma mark tableView代理方法--------------------------
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        CommentHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
        headerView.label.text = self.commentsArray.count ? [NSString stringWithFormat:@"玩家评论（%ld）",self.commentsArray.count] : @"玩家评论（0）";
        return headerView;
    }
    
    return nil;
}

//返回当前表格有多少个分组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //80 = cell的固定高度
    if (indexPath.section == 0) return self.aboveCellLabelHeight + self.aboveCellHeight +80;
    
    NSString * belowCellHeightStr = self.belowCellHeightArr[indexPath.row];
    return belowCellHeightStr.floatValue + 80 + [self.belowCell getBelowCellCommentReplyHeight];
}

//返回当前分组有多少行数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0)  return 1;
    return self.commentsArray.count;
}

//返回组头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0)   return 1;
    return 70;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *aboveCellId = @"aboveCell";
    static NSString *belowCellId = @"belowCell";
    if (indexPath.section == 0) {
        self.aboveCell = [tableView dequeueReusableCellWithIdentifier:aboveCellId];
        if (!self.aboveCell) {
            self.aboveCell = [[CommentPageAboveCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:aboveCellId];
        }
        self.aboveCell.delegate = self;
        self.aboveCell.appraiseModel = self.appraiseModel;
        [self.aboveCell isShowMoreView:NO isRemoveMoerView:YES isShowRortBtn:NO];
        [self.aboveCell setContentRow:0];
        self.aboveCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  self.aboveCell;
    }
    
    self.belowCell = [tableView dequeueReusableCellWithIdentifier:belowCellId];
    if (!self.belowCell) {
        self.belowCell = [[CommentPageBelowCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:belowCellId];
    }
    self.belowCell.commentModel = self.commentsArray[indexPath.row];
    self.belowCell.selectionStyle = UITableViewCellSelectionStyleNone;
    self.belowCell.delegate = self;
    return  self.belowCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.bottomCommentTextField resignFirstResponder];
}

#pragma mark - 加载数据 -----------------
-(void) loadData{
    [self.commentsArray removeAllObjects];
    
    [[[DifferNetwork shareInstance]getCommentList:@"0" pageSize:@"10" target:@"appraise" targetId:self.appraiseModel.uid] subscribeNext:^(id responseObj) {
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *commentsArrayDict = responseDict[@"data"];
        NSArray *comments = commentsArrayDict[@"list"];
        
        for (NSDictionary *commentDict in comments) {
            CommentModel *comment = [CommentModel mj_objectWithKeyValues:commentDict];
            if (comment.replies.count >= 2) {// 请求到数据就对评论进行折叠处理
                comment.isFold = NO;
            }else{
                comment.isFold = YES;
            }
            [self.commentsArray addObject:comment];
        }
        
        [self getBelowCellLabelHeight:self.commentsArray];
        [self getAboveCellLabelHeight:self.appraiseModel.content];
        [self.tableView setNeedsUpdateConstraints];
        [self.tableView layoutIfNeeded];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        
    }];
}

-(void) getBelowCellLabelHeight:(NSMutableArray<CommentModel *> *)commentModel{
    self.belowCellHeightArr = [NSMutableArray array];
    //70为cell的label约束左右的距离
    float labelHeight = ScreenWidth-70;
    
    for (int i = 0; i < commentModel.count; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelHeight, 0)];
        //注: 此label字体大小需要与cell的label字体大小一致
        label.font = [UIFont systemFontOfSize:13];
        label.numberOfLines = 0;
        label.text = commentModel[i].content;
        [label sizeToFit];
        [self.belowCellHeightArr addObject:[NSString stringWithFormat:@"%f",label.bounds.size.height]];
    }
}
-(void) getAboveCellLabelHeight:(NSString *)string{
    float labelHeight = ScreenWidth-70;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelHeight, 0)];
    label.font = [UIFont systemFontOfSize:14];
    label.numberOfLines = 0;
    label.text = string;
    [label sizeToFit];
    self.aboveCellLabelHeight = label.bounds.size.height;
}


#pragma Mark - CommentPageBelowCellDelegate 点击cell里面的评论数
-(void)clickCellCommentCount:(NSString*)authorName commentModel:(CommentModel *)commentModel{
    NSLog(@"author name = %@", authorName);
    if(authorName){
        self.replyCommentModel = commentModel;
        self.commentPlaceholder = authorName;
        NSString *text = [NSString stringWithFormat:@"回复 %@:", authorName];
        [self showBottomReplyViewVisible:text replyType:ReplyType_To_User];
    }
}

#pragma mark - UITextFieldDelegate ----------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    ReplyType replyType = textField.tag;
    //如果是标签，限制输入个数在15个以内
    if(replyType == ReplyType_To_Tag && ![string isEmpty]){
        if (textField == self.bottomCommentTextField) {
            if (textField.text.length > 14) return NO;
        }
    }
    return YES;
}

-(void)clickOpenConment:(CommentModel*)comment{
    BOOL isShow = !comment.isFold; // 改变当前评论的折叠收起状态
    
    NSInteger index = [self.commentsArray indexOfObject:comment];
    CommentModel *newComment = comment;
    newComment.isFold = isShow;
    [self.commentsArray replaceObjectAtIndex:index withObject:newComment];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
}

//点击回复评论
-(void)clickCommentReply:(ReplyModel*)reply commentModel:(CommentModel *)commentModel{
    self.replyCommentModel = commentModel;
    self.replyModel = reply;
    NSString *text = [NSString stringWithFormat:@"回复 %@:", self.replyModel.user.nickname];
    [self showBottomReplyViewVisible:text replyType:ReplyType_To_Comment_User];
}

-(void)clickCellTagAdd{
    [self showBottomReplyViewVisible:@"请输入标签内容" replyType:ReplyType_To_Tag];
}

-(void)showBottomReplyViewVisible:(NSString*)text replyType:(ReplyType)type{
    self.bottomReplyView.hidden = NO;
    CGPoint point = self.bottomCommentTextField.frame.origin;
    point.y = ScreenHeight;
    [self.bottomReplyView setOrigin:point];
    self.bottomCommentTextField.placeholder = text;
    self.bottomCommentTextField.text = @"";
    self.bottomCommentTextField.tag = type;
    [self.bottomCommentTextField becomeFirstResponder];
}

#pragma mark: 顶标签
- (void)tagBtnClick
{
    
    [[[DifferNetwork shareInstance]  postTagsThumb:self.appraiseModel.uid type:@"1"]subscribeNext:^(id x) {
         NSLog(@"顶标签成功");
    } error:^(NSError *error) {
        NSLog(@"顶标签失败：%@",error);
    }];
}

#pragma mark - 添加标签
- (void)tagAdd
{
    [[[DifferNetwork shareInstance] addTagOrCommentWithTarget:@"appraise"
                                                    targetId:self.appraiseModel.uid
                                                        name:self.bottomCommentTextField.text
                                                       isTag:YES] subscribeNext:^(id x) {
        NSLog(@"贴标签成功");
        [self loadTagsData];
    } error:^(NSError *error) {
        NSString *noticeStr = [error description] ? [error description] : @"添加标签或评论失败";
        [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
        NSLog(@"添加标签或评论失败:%@",error);
    }];

}

#pragma mark 请求标签数据
- (void)loadTagsData
{
    if(!self.tagsList){
        self.tagsList = [[NSMutableArray<TagsModel*> alloc] init];
    }
    [self.tagsList removeAllObjects];
    
    NSString *access_token = [DifferAccountTool account].access_token;
    NSString *target = @"appraise";
    NSString *targetId = self.appraiseModel.uid;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"target"] = target;
    dict[@"target_id"] = targetId;
    dict[@"page_size"] = @"100";
    if (access_token != nil) {
        dict[@"access_token"] = access_token;
    }
    
    [[[DifferNetwork shareInstance] getTagsWithParameter:dict] subscribeNext:^(id responseObj) {
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *tagsArrayDict = responseDict[@"data"];
        NSArray *tags = tagsArrayDict[@"list"];
        
        for (NSDictionary *tagDict in tags) {
            TagsModel *tag = [TagsModel mj_objectWithKeyValues:tagDict];
            [self.tagsList addObject:tag];
        }
        self.aboveCellHeight = [self.aboveCell setTagView:self.tagsList];
        [self.tableView reloadData];
    } error:^(NSError *error) {
        NSLog(@"请求标签列表失败：%@",error);
    }];
}

#pragma - CommentPageAboveCellDelegate 顶标签后重新load数据
-(void)reloadTableView{
    [self loadTagsData];
}

-(void)clickHeadIcon:(NSString*)userId{
    ProfileViewController *profileTVC = [[ProfileViewController alloc] init];
    profileTVC.userId = userId;
    [self.navigationController pushViewController:profileTVC animated:YES];
}


@end
