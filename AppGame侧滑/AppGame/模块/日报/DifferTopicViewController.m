//
//  DifferTopicViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DifferTopicViewController.h"
#import "DailyTopicCell.h"
#import "DailyModel.h"
#import "TopicModel.h"
#import "DiffUtil.h"
#import "GameModel.h"
#import "TopicHeaderView.h"
#import "DownLinkModel.h"

#import <SVProgressHUD.h>

#import "ToolBarView.h"

#import "DifferNetwork.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"

#import "TagsModel.h"
#import "CommentModel.h"
#import "UserModel.h"
#import "TagsBtnView.h"
#import "TagView.h"
#import "DailyModel.h"
#import "ArticleModel.h"
#import "ReplyModel.h"

#import "CommentsDetailCell.h"
#import "DailyDetailHeader.h"
#import "DailyDetailFooter.h"

#import "ProfileViewController.h"

typedef enum
{
    ReturnTypeComment = 0, // 评论 return
    ReturnTypeTag,  // 点击发送 贴标签
    ReturnTypeReply,  // 评论别人的评论
    ReturnTypeReplyLine  // 点击某一行进行评论
}ReturnType;

const NSInteger foldCounts = 3;// 评论回复最大折叠数

@interface DifferTopicViewController ()<UITableViewDelegate,UITableViewDataSource,DailyTopicCellDelegate,UITextFieldDelegate,DailyDetailHeaderDelegate,DailyDetailFooterDelegate>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray<GameModel *> *dataSource;

@property (nonatomic,strong)TopicHeaderView *headerView;

@property (nonatomic,strong)ToolBarView *toolBarView;

@property (nonatomic,strong)TagsBtnView *tagsView;

// 标签按钮数据
@property (nonatomic, strong) NSMutableArray *buttonList;

// 存放标签
@property (nonatomic,strong)NSMutableArray<TagsModel *> *tagsArray;
//存放评论
@property (nonatomic,strong)NSMutableArray<CommentModel *> *commentsArray;

// 键盘return执行的类型
@property (nonatomic,assign)ReturnType retrunType;


// 保存评论回复的那条评论
@property (nonatomic,strong)CommentModel *replyComment;
// 保存 点击某一行 的那个 回复
@property (nonatomic,strong)ReplyModel *replyLine;

@end

@implementation DifferTopicViewController



- (UIView *)toolBarView
{
    if (_toolBarView == nil) {
        _toolBarView = [[ToolBarView alloc] initToolBarWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, ScreenWidth, 44) textfieldDelegate:self];
        _toolBarView.backgroundColor = [UIColor whiteColor];
    }
    return _toolBarView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        CGRect frame = self.view.bounds;
        frame.size.height -= 44;
        _tableView.frame = frame;
        
        _tableView = [[UITableView alloc]initWithFrame:frame style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
    }
    return _tableView;
}

// 承载标签的按钮数组
- (NSMutableArray *)buttonList
{
    if (_buttonList == nil) {
        _buttonList = [NSMutableArray array];
    }
    return _buttonList;
}
// 标签数组
- (NSMutableArray *)tagsArray
{
    if (_tagsArray == nil) {
        _tagsArray = [NSMutableArray array];
    }
    return _tagsArray;
}
// 评论数组
- (NSMutableArray *)commentsArray
{
    if (_commentsArray == nil) {
        _commentsArray = [NSMutableArray array];
    }
    return _commentsArray;
}

- (UIView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[TopicHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
        _headerView.topic = self.daily.topic;
        
        NSString *bgColor = self.daily.topic.bg_color;
        _headerView.textColor = self.daily.topic.font_color;
        _headerView.backgroundColor = [DiffUtil colorWithHexString:bgColor];
    }
    return _headerView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        
        for (GameModel *game in self.daily.topic.games) {
            [_dataSource addObject:game];
        }
    }
    
    return _dataSource;
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [DiffUtil judgIsLoginWithViewController:self];//判断是否登录，未登录则弹出登录界面
    
    NSString *content = textField.text;
    NSString *target = self.daily.target;
    NSString *targetId = self.daily.target_id;
    
    // 添加标签 或 评论
    if (self.retrunType == ReturnTypeComment || self.retrunType == ReturnTypeTag) {
        [[[DifferNetwork shareInstance] addTagOrCommentWithTarget:target targetId:targetId name:content isTag:self.retrunType] subscribeNext:^(id x) {
            if (self.retrunType) { // 添加标签
                [self loadTagsData];
            }else{ // 添加评论
                [self loadCommentsData];
            }

        } error:^(NSError *error) {
            NSString *noticeStr = [error description] ? [error description] : @"添加标签或评论失败";
            [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
            NSLog(@"添加标签或评论失败：%@",error);
        }];
    }
    // 评论回复
    if (self.retrunType == ReturnTypeReply) {
        
        CommentModel *comment = self.replyComment;
        
        [[[DifferNetwork shareInstance] commentReplyWithCommentId:comment.uid content:content isReplied:NO replyId:nil replyUserId:nil] subscribeNext:^(id x) {
            [self loadCommentsData];

        } error:^(NSError *error) {
            NSString *noticeStr = [error description] ? [error description] : @"评论某人对某篇文章的评论失败";
            [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
            NSLog(@"评论某人对某篇文章的评论失败：%@",error);
        }];
    }
    // 点击某一行进行回复
    if (self.retrunType == ReturnTypeReplyLine) {
        
        CommentModel *comment = self.replyComment;
        ReplyModel *reply = self.replyLine;
        content = [NSString stringWithFormat:@"回复:%@:%@",reply.user.nickname,content];
        [[[DifferNetwork shareInstance] commentReplyWithCommentId:comment.uid content:content isReplied:YES replyId:reply.uid replyUserId:reply.user.uid] subscribeNext:^(id x) {
            [self loadCommentsData];
        } error:^(NSError *error) {
            NSString *noticeStr = [error description] ? [error description] : @"点击某一行进行评论失败";
            [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
            NSLog(@"点击某一行进行评论失败：%@",error);
        }];
    }
    
    [self.toolBarView registFirstResponseWithPlaceHolder:@"说点什么吧"];
    
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor whiteColor];//[DiffUtil colorWithHexString:bgColor];
    [self.view addSubview:self.tableView];
    
    
    self.tableView.tableHeaderView = self.headerView;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self.view addSubview:self.toolBarView];//底部toolbar
    
    __weak typeof(self) weakSelf = self;
    self.toolBarView.callBack = ^(NSInteger index) {
        
        if (index == 0) {//点击了左边的按钮
            [weakSelf.toolBarView becomFirstResponseWithPlaceHolder:@"说点什么吧"];
        }else if (index == 1){ //点击了右边的按钮
            [weakSelf addTagsClick:nil];
        }
    };
    
    //监听键盘frame改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 输入框设置
    [self setupInputField];
    
    // 设置标签
    [self loadTagsData];
    
    // 设置讨论tableview
    [self loadCommentsData];
}

#pragma mark 请求标签数据
- (void)loadTagsData
{
    self.buttonList = nil;
    self.tagsArray = nil;
    
    NSString *access_token = [DifferAccountTool account].access_token;
    NSString *target = self.daily.target;
    NSString *targetId = self.daily.target_id;
    
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
            [self.tagsArray addObject:tag];
        }
        
        [self setupTagsView];// 设置标签视图
        //        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        NSLog(@"请求标签列表失败");
    }];
}

- (void)setupTagsView
{
    
    // 重新加载标签按钮
    for (UIView *view in self.tagsView.subviews) {
        [view removeFromSuperview];
    }
    // 创建标签按钮
    for (int i = 0; i < self.tagsArray.count; i++) {
        
        TagsModel *tag = self.tagsArray[i];
        NSString *tagStr = [NSString stringWithFormat:@" %@ | %@ ", tag.name,[DiffUtil tagCountLimitWithCount:tag.thumbs_up.integerValue]];
        
        UIButton *button = [[UIButton alloc] init];
        button.tag = i;
        [button setTitle:tagStr forState:UIControlStateNormal];
        button.titleLabel.alpha = 0.8;
        button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        [button setTitleColor: [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1/1.0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        CGSize size = [DiffUtil sizeWithText:tagStr width:self.tagsView.frame.size.width textFont:10.0];
        CGFloat height = size.height > 15 ? 14.32 : size.height;
        button.size = CGSizeMake(size.width + 2, height + 5);
        button.layer.cornerRadius = button.size.height * 0.5;
        button.layer.masksToBounds = YES;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.5;
        if (tag.is_thumb.integerValue) { // 1 为已经点赞，0 非
            [button setTitleColor: [UIColor colorWithRed:21/255.0 green:177/255.0 blue:184/255.0 alpha:1/1.0] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor colorWithRed:21/255.0 green:177/255.0 blue:184/255.0 alpha:1/1.0].CGColor;
        }
        [button addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.buttonList addObject:button];//隐藏标签
        
//        [self.tagsView addSubview:button];
    }
    
    // 添加最后一个 添加标签 的按钮
    TagView *lasttagView = [[TagView alloc] initWithFrame:CGRectMake(0, 2, 50, 15) TagType:TagTypeDottedLine BorderColor:[UIColor lightGrayColor]];
    lasttagView.tagText.textColor = [UIColor grayColor];
    lasttagView.tagText.text = @"  +  ";
    lasttagView.tagText.font = [DiffUtil getDifferFont:16];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTagsClick:)];
    [lasttagView addGestureRecognizer:tapGesture];
    
    lasttagView.hidden = YES;//隐藏标签
    
    [self.buttonList addObject:lasttagView];
//    [self.tagsView addSubview:lasttagView];
    
    self.tagsView = [[TagsBtnView alloc]initTagsViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100) tags:self.buttonList commentsCount:self.daily.article.commented.integerValue];
    self.tagsView.backgroundColor = [UIColor whiteColor];
    
    
    
    [self.tableView reloadData];
}

#pragma mark: 添加标签
- (void)addTagsClick:(UIButton *)sender {
    
    // 判断是否登录
    if (![DiffUtil judgIsLoginWithViewController:self]) {
        return;
    }
    
//    [self.inputTextField becomeFirstResponder];
//    self.inputTextField.placeholder = @"请输入标签";
    [self.toolBarView becomFirstResponseWithPlaceHolder:@"请输入标签"];
    
    self.retrunType = ReturnTypeTag;
}

#pragma mark:// 顶标签
- (void)tagBtnClick:(UIButton *)sender
{
    TagsModel *tag = self.tagsArray[sender.tag];
    NSString *type = tag.is_thumb.integerValue ? @"0" : @"1";
    
    if (type.integerValue == 0 && tag.thumbs_up.integerValue < 2) { //标签数小于2时，不能取消顶标签
        return;
    }
    
    [[[DifferNetwork shareInstance]  postTagsThumb:tag.uid type:type] subscribeNext:^(id x) {
        [self loadTagsData];

    } error:^(NSError *error) {
        NSLog(@"顶标签失败");
    }];
}

#pragma mark 请求评论数据
- (void)loadCommentsData
{
    NSString *access_token = [DifferAccountTool account].access_token;
    NSString *target = self.daily.target;
    NSString *targetId = self.daily.target_id;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"target"] = target;
    dict[@"target_id"] = targetId;
    dict[@"page_size"] = @"100";
    if (access_token != nil) {
        dict[@"access_token"] = access_token;
    }
    
    
//        dict[@"access_token"] = access_token;
//        dict[@"page_size"] = @"100";
//        dict[@"target"] = @"article";
//        dict[@"target_id"] = @"1321477670010018";
    
    
    [[[DifferNetwork shareInstance] getCommentsWithParameter:dict] subscribeNext:^(id responseObj) {
        
        self.commentsArray = nil;
        
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *commentsArrayDict = responseDict[@"data"];
        NSArray *comments = commentsArrayDict[@"list"];
        
        for (NSDictionary *commentDict in comments) {
            CommentModel *comment = [CommentModel mj_objectWithKeyValues:commentDict];
            
            if (comment.replies.count >= foldCounts) {// 请求到数据就对评论进行折叠处理
                comment.isFold = YES;
            }else{
                comment.isFold = NO;
            }
            
            [self.commentsArray addObject:comment];
        }
        //        [self setupCommentTableView];// 设置评论视图
        [self.tableView reloadData];

    } error:^(NSError *error) {
        NSLog(@"请求评论列表失败");
    }];
}

#pragma mark:键盘frame改变，底部bottom上移
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect frame = self.toolBarView.frame;
    frame.origin.y = endFrame.origin.y - frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        
        self.toolBarView.frame = frame;

    }];
}

//退出键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self setupInputField];
}

#pragma mark:默认输入框为写评论
- (void)setupInputField
{
    self.retrunType = ReturnTypeComment;
    
//    self.inputTextField.text = nil;
//    self.inputTextField.placeholder = @"说点什么吧";
//    [self.inputTextField resignFirstResponder];
    
    [self.toolBarView registFirstResponseWithPlaceHolder:@"说点什么吧"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self scrollViewDidEndDecelerating:self.tableView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:offsetY/(self.headerView.frame.size.height)];
    
    if (offsetY/(self.headerView.frame.size.height) >= 1.0) {
        self.title = self.daily.topic.title;
    }else{
        self.title = nil;
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self handleScrollPlaying:scrollView];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (decelerate) {
        return;
    }

    [self handleScrollPlaying:scrollView];
}

- (void)handleScrollPlaying:(UIScrollView *)scrollView
{
    NSArray *indexs = [self.tableView indexPathsForVisibleRows];
    //    NSIndexPath *firstIndex = indexs[0];
    //    if (firstIndex.section != 0) return;
    
    NSMutableArray *gameIndexs = [NSMutableArray array];
    for (NSIndexPath *index in indexs) {
        if (index.section == 0) {
            [gameIndexs addObject:index];
        }
    }
    
    if (gameIndexs.count == 0) return;
    
    //    NSInteger midIndex = (gameIndexs.count + 1) * 0.5;
    if(gameIndexs.count == 1){
        
        NSIndexPath *indexPath = gameIndexs[0];
        DailyTopicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (![cell.videoPlayView isPlaying]) {
            [cell.videoPlayView play];
        }
        
    }else if (gameIndexs.count == 2){
        
        if (scrollView.contentOffset.y > [UIScreen mainScreen].bounds.size.height * 0.3) {
            NSIndexPath *indexPath = gameIndexs[0];
            DailyTopicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if ([cell.videoPlayView isPlaying]) {
                [cell.videoPlayView play];
            }
            
            NSIndexPath *indexPath1 = gameIndexs[1];
            DailyTopicCell *cell1 = [self.tableView cellForRowAtIndexPath:indexPath1];
            if (![cell1.videoPlayView isPlaying]) {
                [cell1.videoPlayView play];
            }
        }else{
            NSIndexPath *indexPath = gameIndexs[0];
            DailyTopicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            if (![cell.videoPlayView isPlaying]) {
                [cell.videoPlayView play];
            }
            
            NSIndexPath *indexPath1 = gameIndexs[1];
            DailyTopicCell *cell1 = [self.tableView cellForRowAtIndexPath:indexPath1];
            if ([cell1.videoPlayView isPlaying]) {
                [cell1.videoPlayView play];
            }
        }
        
        
        
        
    }else if (gameIndexs.count == 3){
        
        NSIndexPath *indexPath = gameIndexs[1];
        DailyTopicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (![cell.videoPlayView isPlaying]) {
            [cell.videoPlayView play];
        }
        
        NSIndexPath *indexPath0 = gameIndexs[0];
        DailyTopicCell *cell0 = [self.tableView cellForRowAtIndexPath:indexPath0];
        if ([cell0.videoPlayView isPlaying]) {
            [cell0.videoPlayView play];
        }
        
        NSIndexPath *indexPath2 = gameIndexs[2];
        DailyTopicCell *cell2 = [self.tableView cellForRowAtIndexPath:indexPath2];
        if ([cell2.videoPlayView isPlaying]) {
            [cell2.videoPlayView play];
        }
        
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //专题游戏 + 底部评论
    return 1 + self.commentsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.dataSource.count;
    }else{
        CommentModel *comments = self.commentsArray[section-1];
        
        if (comments.isFold) { //  大于等于3条 查看全部评论
            return foldCounts-1;
        }else{   // 展开
            return comments.replies.count;
        }
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        GameModel *game = self.dataSource[indexPath.row];
        return game.cellHeight;
    }else{
        CommentModel *comments = self.commentsArray[indexPath.section-1];
        ReplyModel *reply = comments.replies[indexPath.row];
        return reply.cellHeight;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        DailyTopicCell *cell = [DailyTopicCell cellWithTableView:tableView];
        GameModel *game = self.dataSource[indexPath.row];
        cell.game = game;
        cell.fontColor = self.daily.topic.font_color;
        cell.delegate = self;
        
        NSString *bgColor = self.daily.topic.bg_color;
        cell.backgroundColor = [DiffUtil colorWithHexString:bgColor];
        
        return cell;
    }else{
        CommentModel *comments = self.commentsArray[indexPath.section-1];
        
        CommentsDetailCell *cell = [CommentsDetailCell cellWithTableView:tableView];
        
        ReplyModel *reply = comments.replies[indexPath.row];
        
        cell.reply = reply;
        
        return cell;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.0001;
    }
    
    
    CommentModel *comment = self.commentsArray[section-1];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [DiffUtil sizeWithText:comment.content width:(screenW - 50) textFont:15];
    CGFloat height = size.height + 60 + 20;
    
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    static NSString *headerIdentify = @"commentheader";
    
    DailyDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentify];
    if (header == nil) {
        header = [[DailyDetailHeader alloc]initWithReuseIdentifier:headerIdentify];
    }
    
    header.comment = self.commentsArray[section-1];
    header.delegate = self;
    
    return header;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section ==0) {
        
        return self.tagsView.frame.size.height;
    }
    
    
    CommentModel *comment = self.commentsArray[section-1];
    
    if (comment.replies.count >= foldCounts) { // 折叠的高度
        return 25;
    }
    
    return 8; //分割线
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    if (section == 0) {
        
        return self.tagsView;
    }
    
    CommentModel *comment = self.commentsArray[section-1];
    
    static NSString *headerIdentify = @"commentFooter";
    
    DailyDetailFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentify];
    if (footer == nil) {
        footer = [[DailyDetailFooter alloc]initWithReuseIdentifier:headerIdentify];
    }
    footer.delegate = self;
    footer.comment = comment;
    
    return footer;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        return;
    }
    
    // 回复评论
    CommentModel *comments = self.commentsArray[indexPath.section-1];
    ReplyModel *reply = comments.replies[indexPath.row];
    
//    [self.inputTextField becomeFirstResponder];
//    self.inputTextField.placeholder = [NSString stringWithFormat:@"回复%@:",reply.user.nickname];
    
    [self.toolBarView becomFirstResponseWithPlaceHolder:[NSString stringWithFormat:@"回复%@:",reply.user.nickname]];
    self.retrunType = ReturnTypeReplyLine;
    
    self.replyComment = comments;
    self.replyLine = reply;
}


#pragma mark DailyDetailHeaderDelegate 评论文章代理方法
// 点击头像
- (void)dailyDetailHeader:(DailyDetailHeader *)header iconClick:(CommentModel *)comment
{
    ProfileViewController *profileTVC = [[ProfileViewController alloc] init];
    profileTVC.userId = comment.user.uid;
    [self.navigationController pushViewController:profileTVC animated:YES];
    
    //    ZJProfileViewController *vc = [[ZJProfileViewController alloc]init];
    //    vc.userId = comment.user.uid;
    //    [self.navigationController pushViewController:vc animated:YES];
}
// 评论回复
- (void)dailyDetailHeader:(DailyDetailHeader *)header commentClick:(CommentModel *)comment
{
    NSString *reply = comment.user.nickname;
    
//    [self.inputTextField becomeFirstResponder];
//    self.inputTextField.placeholder = [NSString stringWithFormat:@"回复%@:",reply];
    [self.toolBarView becomFirstResponseWithPlaceHolder:[NSString stringWithFormat:@"回复%@:",reply]];
    
    self.retrunType = ReturnTypeReply;
    
    self.replyComment = comment;
}
// 点赞
- (void)dailyDetailHeader:(DailyDetailHeader *)header likeClick:(CommentModel *)comment
{
    NSString *type = comment.is_thumb.integerValue ? @"0" : @"1";
    [[[DifferNetwork shareInstance] commentThumbWithCommentId:comment.uid type:type] subscribeNext:^(id x) {
        
        //        [self loadCommentsData];
        // 点赞不改变 折叠收起 状态，不要发请求
        
        NSInteger index = [self.commentsArray indexOfObject:comment];
        CommentModel *newComment = comment;
        comment.is_thumb = type;
        NSInteger commentsCount = type.integerValue ? (comment.thumbs_up.integerValue + 1) : (comment.thumbs_up.integerValue - 1);
        comment.thumbs_up = [NSString stringWithFormat:@"%ld",commentsCount];
        [self.commentsArray replaceObjectAtIndex:index withObject:newComment];
        
        //        [self setupCommentTableView];
        //        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        //        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];

    } error:^(NSError *error) {
        NSLog(@"评论点赞失败");
    }];
}

#pragma mark : DailyDetailFooterDelegate 评论回复代理
- (void)DailyDetailFooterCell:(DailyDetailFooter *)commentCell moreCommentClick:(CommentModel *)comment
{
    BOOL isShow = !comment.isFold; // 改变当前评论的折叠收起状态
    
    NSInteger index = [self.commentsArray indexOfObject:comment];
    CommentModel *newComment = comment;
    newComment.isFold = isShow;
    [self.commentsArray replaceObjectAtIndex:index withObject:newComment];
    
//    [self setupCommentTableView];
//    NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:1];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
}




// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}

#pragma mark:DailyTopicCellDelegate 点击下载
- (void)dailyTopicCellClickDownLoad:(GameModel *)game
{
    for (DownLinkModel *link in game.downLinkArray) {
        if ([link.platform.lowercaseString isEqualToString:@"ios"]) {
            
            if ([[UIApplication sharedApplication] canOpenURL:link.link]) { // 跳转
                [[UIApplication sharedApplication] openURL:link.link];
            }else{
                [SVProgressHUD showErrorWithStatus:@"打开链接失败"];
            }
            
        }
    }
}


@end
