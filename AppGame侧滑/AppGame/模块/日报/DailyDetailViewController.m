//
//  DailyDetailViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/28.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DailyDetailViewController.h"
#import "DiffUtil.h"
#import "DailyModel.h"
#import "ArticleModel.h"
#import "UserModel.h"

#import <WebKit/WebKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+Extension.h"

#import "DifferNetwork.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "TagsModel.h"
#import "AppraiseModel.h"
#import "CommentModel.h"
#import "ReplyModel.h"

#import "DailyDetailHeader.h"
#import "CommentsDetailCell.h"

#import "UIView+Extension.h"

//#import "ProfileTableViewController.h"
#import "ProfileViewController.h"
#import "TagView.h"

#import "DailyDetailFooter.h"



typedef enum
{
    ReturnTypeComment = 0, // 评论 return
    ReturnTypeTag,  // 点击发送 贴标签
    ReturnTypeReply,  // 评论别人的评论
    ReturnTypeReplyLine  // 点击某一行进行评论
}ReturnType;

const NSInteger foldCount = 3;// 评论回复最大折叠数

@interface DailyDetailViewController ()<WKNavigationDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,DailyDetailHeaderDelegate,DailyDetailFooterDelegate>

// 最底层的scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
// 底部toolbar距离底部的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarBottomConst;


// 用来计算scrollview的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSizeHeight;

// titleView的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleViewHeight;


// 标题View
@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;// 文章作者头像

@property (weak, nonatomic) IBOutlet UILabel *nickName;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

// scrollview的contentView
@property (weak, nonatomic) IBOutlet UIView *contentView;

// 加载内容的webview
@property (nonatomic,strong)WKWebView *wkWebView;

// 标签view
//@property (nonatomic,strong)CFFlowButtonView *tagsView;
@property (nonatomic,strong)UIView *tagsView;

// 标签按钮数据
@property (nonatomic, strong) NSMutableArray *buttonList;

// 存放标签
@property (nonatomic,strong)NSMutableArray<TagsModel *> *tagsArray;
//存放评论
@property (nonatomic,strong)NSMutableArray<CommentModel *> *commentsArray;


// 最下面讨论的tableview
@property (nonatomic,strong)UITableView *tableView;

//评论数据框
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;


@property (weak, nonatomic) IBOutlet UIView *toolBarView;
//添加标签
@property (weak, nonatomic) IBOutlet UIButton *addTagBtn;

// 最底部的评论图片可点击
@property (weak, nonatomic) IBOutlet UIImageView *commentIcon;


// 键盘return执行的类型
@property (nonatomic,assign)ReturnType retrunType;

// 保存评论回复的那条评论
@property (nonatomic,strong)CommentModel *replyComment;
// 保存 点击某一行 的那个 回复
@property (nonatomic,strong)ReplyModel *replyLine;


@end

@implementation DailyDetailViewController

#pragma mark - =======================懒加载属性=======================

// 承载标签视图
- (UIView *)tagsView
{
    if (_tagsView == nil) {
        _tagsView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.wkWebView.frame), self.scrollView.frame.size.width, 0)];
        _tagsView.hidden = YES;
        [self.contentView addSubview:_tagsView];
    }
    return _tagsView;
}

// 底部评论的tableview
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, self.scrollView.frame.size.width, 0) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.hidden = YES;
        [self.contentView addSubview:_tableView];
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
// 中间加载HTML5页面的WKWebView
- (WKWebView *)wkWebView
{
    if (_wkWebView == nil) {
        
        _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), [UIScreen mainScreen].bounds.size.width,100)];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        _wkWebView.navigationDelegate = self;
        [self.contentView addSubview:_wkWebView];
    }
    return _wkWebView;
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}
#pragma mark: 右上角关注
- (IBAction)attentionClick:(UIButton *)sender {
    
    NSString *action = self.daily.article.user.is_followed.integerValue ? @"cancel" : nil;
    
    if (action) { //取消关注
        [DiffUtil showTwoAlertControllerWithTitle:@"" message:@"确定不再关注此人？" presenViewController:self callBack:^(ClickResult result) {
            
            if (result != clickResultYes) return;
            
            [self addAttentionNetwork:action];
            
        }];
        
        return;
    }

    [self addAttentionNetwork:action];
    
}

- (void)addAttentionNetwork:(NSString *)action
{
    [[[DifferNetwork shareInstance] followOrCancelFollowWithId:self.daily.article.user.uid action:action] subscribeNext:^(id x) {
        
        self.daily.article.user.is_followed = action == nil ? @"1" : @"0";
        if (self.daily.article.user.is_followed.integerValue) {// 已关注
            [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        }else{
            [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
        }

    } error:^(NSError *error) {
        NSLog(@"点击加关注或取消关注失败");
    }];
}

#pragma mark: 添加标签
- (IBAction)addTagsClick:(UIButton *)sender {
    
    [self.inputTextField becomeFirstResponder];
    self.inputTextField.placeholder = @"请输入标签";
    
    self.retrunType = ReturnTypeTag;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"differ日报";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //监听键盘frame改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    // 设置输入框
    self.inputTextField.delegate = self;
    [self.inputTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.toolBarView.layer.borderWidth = 0.7;
    self.toolBarView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.scrollView.delegate = self;
    
    
    [self setupTapGesture];//文章作者的点击事件，底部评论图片的点击事件
    
    [self initSetup];//初始化请求设置
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if(self.retrunType != ReturnTypeTag) return; //只对贴标签进行限制
    
    int length = 15;//限制的字数
    NSString *toBeString = textField.text;
    
    //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    NSString *lang = textField.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position || !selectedRange)
        {
            if (toBeString.length > length)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:length];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }else{
        if (toBeString.length > length) {
            textField.text = [toBeString substringToIndex:length];
        }
    }
    
}



- (void)initSetup
{
    // 输入框设置
    [self setupInputField];
    
    // 设置标题内容
    [self setupTitleView];
    
    // 设置标签
    [self loadTagsData];
    
    // 设置讨论tableview
    [self loadCommentsData];
    
    NSURL *url = self.daily.article.url;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.wkWebView loadRequest:request];
    
    // 添加标签的按钮设置为虚线
    self.addTagBtn.layer.cornerRadius = CGRectGetWidth(self.addTagBtn.bounds)/2;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, 60, 20);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.addTagBtn.bounds), CGRectGetMidY(self.addTagBtn.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    
    borderLayer.lineDashPattern = @[@5, @5];
    
    [self.addTagBtn.layer addSublayer:borderLayer];
}

- (void)setupTapGesture
{
    // 为头像设置点击事件手势
    UITapGestureRecognizer *tapIcon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(authorIconClick)];
    self.iconImage.userInteractionEnabled = YES;
    [self.iconImage addGestureRecognizer:tapIcon];
    
    UITapGestureRecognizer *tapComment = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentIconClick)];
    self.commentIcon.userInteractionEnabled = YES;
    [self.commentIcon addGestureRecognizer:tapComment];
}

- (void)commentIconClick
{
    [self setupInputField];
    [self.inputTextField becomeFirstResponder];
}

#pragma mark:点击左上角作者头像
- (void)authorIconClick
{
    ArticleModel *article = self.daily.article;
    UserModel *user = article.user;
    
    ProfileViewController *authorVC = [[ProfileViewController alloc]init];
    authorVC.userId = user.uid;
    [self.navigationController pushViewController:authorVC animated:YES];
    
//    ZJProfileViewController *vc = [[ZJProfileViewController alloc]init];
//    vc.userId = user.uid;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}


#pragma mark:默认输入框为写评论
- (void)setupInputField
{
    self.retrunType = ReturnTypeComment;
    
    self.inputTextField.text = nil;
    self.inputTextField.placeholder = @"说点什么吧";
    [self.inputTextField resignFirstResponder];
    //    self.isAddTag = NO;
    self.retrunType = ReturnTypeComment;
    
}
#pragma mark:键盘frame改变，底部bottom上移
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat margin = [UIScreen mainScreen].bounds.size.height - endFrame.origin.y;
    
//    CGRect frame = self.toolBarView.frame;
//    frame.origin.y = endFrame.origin.y - frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.toolBarBottomConst.constant = margin;

    }];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self setupInputField];// 设置输入框
}
#pragma mark: 键盘return事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 判断是否登录
    if (![DiffUtil judgIsLoginWithViewController:self]) {
        return NO;
    }
    
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
            NSLog(@"添加标签或评论失败:%@",error);
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
             NSLog(@"评论某人对某篇文章的评论失败:%@",error);
         }];
    }
    // 点击某一行进行回复
    if (self.retrunType == ReturnTypeReplyLine) {
        
        CommentModel *comment = self.replyComment;
        ReplyModel *reply = self.replyLine;
        content = [NSString stringWithFormat:@"回复%@ %@",reply.user.nickname,content];
        [[[DifferNetwork shareInstance] commentReplyWithCommentId:comment.uid content:content isReplied:YES replyId:reply.uid replyUserId:reply.user.uid] subscribeNext:^(id x) {
            [self loadCommentsData];
    
        } error:^(NSError *error) {
            NSString *noticeStr = [error description] ? [error description] : @"点击某一行进行评论失败";
            [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
            NSLog(@"点击某一行进行评论失败:%@",error);
        }];
    }
    
    self.inputTextField.text = nil;
    self.inputTextField.placeholder = @"说点什么吧";
    [self.inputTextField resignFirstResponder];
    
    return YES;
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
    
    [[[DifferNetwork shareInstance] getCommentsWithParameter:dict] subscribeNext:^(id responseObj) {
        self.commentsArray = nil;
        
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *commentsArrayDict = responseDict[@"data"];
        NSArray *comments = commentsArrayDict[@"list"];
        
        for (NSDictionary *commentDict in comments) {
            CommentModel *comment = [CommentModel mj_objectWithKeyValues:commentDict];
            
            if (comment.replies.count >= foldCount) {// 请求到数据就对评论进行折叠处理
                comment.isFold = YES;
            }else{
                comment.isFold = NO;
            }
            
            [self.commentsArray addObject:comment];
        }
        [self setupCommentTableView];// 设置评论视图

    } error:^(NSError *error) {
        NSLog(@"请求评论列表失败：%@",error);
    }];
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
    } error:^(NSError *error) {
        NSLog(@"请求标签列表失败：%@",error);
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    
    [self.tagsView layoutIfNeeded];
    
    [self.tableView layoutIfNeeded];
    
}
#pragma mark: 设置评论视图
- (void)setupCommentTableView
{
    [self.tableView reloadData];
    
    [self.tableView layoutIfNeeded];
    
    self.contentSizeHeight.constant = CGRectGetMaxY(self.tagsView.frame) + self.tableView.contentSize.height - self.scrollView.frame.size.height;
    
    //重新计算tableview的frame
    CGRect tableviewFrame = self.tableView.frame;
    tableviewFrame.origin.y = CGRectGetMaxY(self.tagsView.frame);
    tableviewFrame.size.height = self.tableView.contentSize.height;
    self.tableView.frame = tableviewFrame;
    
    //刷新评论数
    UILabel *label = (UILabel *)[self.tagsView viewWithTag:1001];
    label.text = [NSString stringWithFormat:@"玩家讨论 （%ld）",self.commentsArray.count];
    
}
#pragma mark: 设置标签视图
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
        CGSize size = [DiffUtil sizeWithText:tagStr width:self.tagsView.bounds.size.width textFont:10.0];
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
        [self.buttonList addObject:button];
        
        [self.tagsView addSubview:button];
    }
    
    // 添加最后一个 添加标签 的按钮
    TagView *lasttagView = [[TagView alloc] initWithFrame:CGRectMake(0, 0, 40, 15) TagType:TagTypeDottedLine BorderColor:[UIColor lightGrayColor]];
    lasttagView.tagText.textColor = [UIColor grayColor];
    lasttagView.tagText.text = @"  +  ";
    lasttagView.tagText.font = [DiffUtil getDifferFont:16];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addTagsClick:)];
    [lasttagView addGestureRecognizer:tapGesture];
    
    [self.buttonList addObject:lasttagView];
    [self.tagsView addSubview:lasttagView];
    
    
    CGFloat margin = 15;
    
    //添加一条横线
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(margin, 5, self.tagsView.size.width - 2 * margin, 1)];
    labelLine.backgroundColor = [DiffUtil colorWithHexString:@"979797"];
    [self.tagsView addSubview:labelLine];
    
    // 存放每行的第一个Button
    NSMutableArray *rowFirstButtons = [NSMutableArray array];
    // 对第一个Button进行设置
    UIButton *button0 = self.buttonList[0];
    button0.x = margin;
    button0.y = margin;
    [rowFirstButtons addObject:self.buttonList[0]];
    
    // 对其他Button进行设置
    int row = 0;
    for (int i = 1; i < self.buttonList.count; i++) {
        UIButton *button = self.buttonList[i];
        
        int sumWidth = 0;
        int start = (int)[self.buttonList indexOfObject:rowFirstButtons[row]];
        for (int j = start; j <= i; j++) {
            UIButton *button = self.buttonList[j];
            sumWidth += (button.width + margin);
        }
        sumWidth += 10;
        
        UIButton *lastButton = self.buttonList[i - 1];
        if (sumWidth >= self.tagsView.width) {
            button.x = margin;
            button.y = lastButton.y + margin + button.height;
            [rowFirstButtons addObject:button];
            row ++;
        } else {
            button.x = sumWidth - margin - button.width;
            button.y = lastButton.y;
        }
    }

    
    UIButton *lastButton = self.buttonList.lastObject;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"玩家讨论 （%@）",self.daily.article.commented];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.5];
    label.frame = CGRectMake(margin, CGRectGetMaxY(lastButton.frame)+margin, self.tagsView.frame.size.width, 30);
    label.tag = 1001;
    [self.tagsView addSubview:label];
    
    
    UIView *taglineView = [[UIView alloc] init];
    taglineView.backgroundColor = [UIColor colorWithRed:21/255.0 green:177/255.0 blue:184/255.0 alpha:0.6];
    [self.tagsView addSubview:taglineView];
    
    taglineView.frame = CGRectMake(margin, CGRectGetMaxY(label.frame), 73, 4);
    self.tagsView.height = CGRectGetMaxY(taglineView.frame) + 10;

    
    //重新计算tableview的frame
    CGRect tableviewFrame = self.tableView.frame;
    tableviewFrame.origin.y = CGRectGetMaxY(self.tagsView.frame);
    tableviewFrame.size.height = self.tableView.contentSize.height;
    self.tableView.frame = tableviewFrame;
    
    self.contentSizeHeight.constant = CGRectGetMaxY(self.tagsView.frame) + self.tableView.contentSize.height - self.scrollView.frame.size.height;
    
}

#pragma mark:// 顶标签
- (void)tagBtnClick:(UIButton *)sender
{
    // 判断是否登录
    if (![DiffUtil judgIsLoginWithViewController:self]) {
        return;
    }
    
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
#pragma mark: 设置标题视图
- (void)setupTitleView
{
    self.attentionBtn.layer.borderWidth = 0.6;
    self.attentionBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    if (self.daily.article.user.is_followed.integerValue) {// 已关注
        [self.attentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [self.attentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }
    
    ArticleModel *article = self.daily.article;
    UserModel *user = article.user;
    
    [self.iconImage sd_setImageWithURL:user.avatar placeholderImage:nil];
    self.nickName.text = user.nickname;
    self.titleLabel.text = article.title;
    
    
    // 计算titleView的高度
    CGFloat titleHeigh = CGRectGetMaxY(self.lineView.frame);
    self.titleViewHeight.constant = titleHeigh;
    self.contentSizeHeight.constant = titleHeigh;
    
    // 调整webview的y值，
    CGRect webViewframe = self.wkWebView.frame;
    webViewframe.origin.y = titleHeigh;
    self.wkWebView.frame = webViewframe;
    
}

#pragma mark wkwebview加载代理
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    self.tableView.hidden = NO;
    self.tagsView.hidden = NO;
    
    
    [webView evaluateJavaScript:@"document.documentElement.scrollHeight" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //获取页面高度，并重置webview的frame
        CGFloat documentHeight = [result doubleValue];
        CGRect frame = webView.frame;
        frame.size.height = documentHeight;
        self.wkWebView.frame = frame;
        
        // 重新计算tagsView的frame
        CGRect tagsViewframe = self.tagsView.frame;
        tagsViewframe.origin.y = CGRectGetMaxY(frame);
        self.tagsView.frame = tagsViewframe;
        
        
//        [self.tableView layoutIfNeeded];
        //重新计算tableview的frame
        CGRect tableviewFrame = self.tableView.frame;
        tableviewFrame.origin.y = CGRectGetMaxY(tagsViewframe);
        tableviewFrame.size.height = self.tableView.contentSize.height;
        self.tableView.frame = tableviewFrame;

        self.contentSizeHeight.constant = CGRectGetMaxY(tagsViewframe) + self.tableView.contentSize.height - self.scrollView.frame.size.height;

    }];
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    self.tableView.hidden = NO;
    self.tagsView.hidden = NO;
    NSLog(@"页面加载失败");
}


#pragma mark:  uitableviewdelegate && datasource 代理及数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commentsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CommentModel *comments = self.commentsArray[section];
    
    if (comments.isFold) { //  大于等于3条 查看全部评论
        return foldCount-1;
    }else{   // 展开
        return comments.replies.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentModel *comments = self.commentsArray[indexPath.section];
    
    CommentsDetailCell *cell = [CommentsDetailCell cellWithTableView:tableView];
    
    ReplyModel *reply = comments.replies[indexPath.row];
    
    cell.reply = reply;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CommentModel *comment = self.commentsArray[section];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGSize size = [DiffUtil sizeWithText:comment.content width:(screenW - 50) textFont:15];
    CGFloat height = size.height + 60 + 20;
    
    return height;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerIdentify = @"commentheader";
    
    DailyDetailHeader *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentify];
    if (header == nil) {
        header = [[DailyDetailHeader alloc]initWithReuseIdentifier:headerIdentify];
    }
    header.comment = self.commentsArray[section];
    header.delegate = self;
    
    return header;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *comments = self.commentsArray[indexPath.section];
    ReplyModel *reply = comments.replies[indexPath.row];
    return reply.cellHeight;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    CommentModel *comment = self.commentsArray[section];
    
    if (comment.replies.count >= foldCount) { // 折叠的高度
        return 25;
    }
    
    return 8; //分割线
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    CommentModel *comment = self.commentsArray[section];

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
    
    // 回复评论
    CommentModel *comments = self.commentsArray[indexPath.section];
    ReplyModel *reply = comments.replies[indexPath.row];
    
    [self.inputTextField becomeFirstResponder];
    self.inputTextField.placeholder = [NSString stringWithFormat:@"回复%@:",reply.user.nickname];
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
    
    [self.inputTextField becomeFirstResponder];
    self.inputTextField.placeholder = [NSString stringWithFormat:@"回复%@:",reply];
    self.retrunType = ReturnTypeReply;
    
    self.replyComment = comment;
}
// 点赞
- (void)dailyDetailHeader:(DailyDetailHeader *)header likeClick:(CommentModel *)comment
{
    // 判断是否登录
    if (![DiffUtil judgIsLoginWithViewController:self]) {
        return;
    }
    
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
        
        [self setupCommentTableView];
        
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
    
    [self setupCommentTableView];
//    [self.tableView reloadData];
}




// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}


@end
