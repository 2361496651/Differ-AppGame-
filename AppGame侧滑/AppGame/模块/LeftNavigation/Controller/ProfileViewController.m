//
//  ProfileViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ProfileViewController.h"
#import "FullScrollView.h"

#import "ProfileFansVC.h"
#import "ProfileHomeVC.h"
#import "ProfileCommentVC.h"
#import "ProfileAttentionVC.h"

#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "DiffUtil.h"
#import "UserModel.h"
#import "DifferNetwork.h"

#import <SDWebImage/UIButton+WebCache.h>
#import "PersonalSettingTVC.h"
#import "HMDrawerViewController.h"


#import "DynamicsVC.h"

#import "GameListMainViewController.h"
#import "AboutTAVC.h"

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

@interface ProfileViewController ()<UIScrollViewDelegate,TableViewScrollingProtocol>

// contentsize约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fullScrollHeightConst;
//headerView的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeightConst;


@property (weak, nonatomic) IBOutlet FullScrollView *fullScrollView;//

@property (weak, nonatomic) IBOutlet UIView *headerView;

// headerView内容
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton *IconBtn;
@property (weak, nonatomic) IBOutlet UIButton *addAttentionBtn;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPropertyLabel;


@property (weak, nonatomic) IBOutlet UIView *titleView;// 标题父view
@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, weak) UIButton *selectButton; //选中的标题
@property (nonatomic,strong)UIView *lineView;// 标题底部下划线

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView; // 底部承载子控制器View的scrollview

@property (nonatomic, assign) BOOL isInitialize;// 是否已经初始化，四个子控制器

@property (nonatomic, assign) BOOL isMyself; // 是否进入的是自己的个人中心

@property (nonatomic,strong)UserModel *userInfo;

//断网提示View
@property (weak, nonatomic) IBOutlet UIView *netWorkView;


//fullScrollView的Y轴偏移量，在左右切换的时候再次设置标题
@property (nonatomic,assign)CGFloat offsetY;


@end

@implementation ProfileViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

#pragma makr -懒加载属性
- (UIView *)lineView
{
    if (_lineView == nil) {
        NSInteger count = self.childViewControllers.count;
        CGFloat btnW = ScreenW / count;
        CGFloat btnH = self.titleView.bounds.size.height;
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, btnH-2, btnW, 2);
        lineView.backgroundColor = [UIColor colorWithRed:21/255.0 green:177/255.0 blue:184/255.0 alpha:1/1.0];
        _lineView = lineView;
        
        [self.titleView addSubview:_lineView];
    }
    return _lineView;
}

- (NSMutableArray *)titleButtons
{
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

// 是否是自己
- (BOOL)isMyself
{
    //    DifferAccount *model = [DifferAccountTool account];
    UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    if ([self.userId isEqualToString:account.uid]) {
        return YES;
    }
    return NO;
}



- (void)setupNetworkView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNetworkView)];
    [self.netWorkView addGestureRecognizer:tap];
}

- (void)tapNetworkView
{
    [UIView animateWithDuration:0.25 animations:^{
        self.netWorkView.hidden = YES;
    }];
}

- (void)addChildViewControllers
{
    
    ProfileHomeVC *home = [[ProfileHomeVC alloc]init];
    home.title = @"主页";
    [self addChildViewController:home];
    
    ProfileCommentVC *comment = [[ProfileCommentVC alloc]init];
    comment.delegate = self;
    comment.title = @"评价";
    comment.userId = self.userId;
    comment.isMyself = self.isMyself;
    [self addChildViewController:comment];
    
    ProfileAttentionVC *attention = [[ProfileAttentionVC alloc]init];
    attention.delegate = self;
    attention.title = @"关注";
    attention.userId = self.userId;
    attention.isMyself = self.isMyself;
    [self addChildViewController:attention];
    
    ProfileFansVC *fans = [[ProfileFansVC alloc]init];
    fans.delegate = self;
    fans.title = @"粉丝";
    fans.userId = self.userId;
    fans.isMyself = self.isMyself;
    [self addChildViewController:fans];
    
//    AboutTaController *about = [[AboutTaController alloc]init];
//    about.title = @"关于TA";
//    about.userId = self.userId;
//    about.isMyself = self.isMyself;
//    [self addChildViewController:about];
    AboutTAVC *about = [[AboutTAVC alloc]init];
    about.title = @"关于TA";
    about.userId = self.userId;
    about.isMyself = self.isMyself;
    [self addChildViewController:about];
    
    DynamicsVC *dynamic = [[DynamicsVC alloc]init];
    dynamic.title = @"动态";
    dynamic.userId = self.userId;
    dynamic.isMyself = self.isMyself;
    [self addChildViewController:dynamic];
    
}

- (void)setupHeaderInfomation
{
    UserModel *account = self.userInfo;
//    if (self.isMyself) {
//        [self.IconBtn setImage:account.avatar forState:UIControlStateNormal];
//    }else{
//        [self.IconBtn sd_setImageWithURL:account.avatar forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"menu_user_default"]];
//        
//    }
    
    
    [self.IconBtn sd_setImageWithURL:account.avatar forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"menu_user_default"]];
    
    NSString *nickName = account.nickname;
    if (account.nickname == nil || [account.nickname isEqualToString:@""]){
        nickName = @"未设置";
    }
    self.userNameLabel.text = nickName;
    self.userPropertyLabel.text = [NSString stringWithFormat:@"关注 %ld | 粉丝 %ld",account.following,account.follower];
    
    // 是否已关注
    if ([account.is_followed integerValue]) {
        [self.addAttentionBtn setTitle:@"已关注" forState:UIControlStateNormal];
        
    }else{
        [self.addAttentionBtn setTitle:@"+关注" forState:UIControlStateNormal];
    }
    
    // 赋值后计算控件高度才正确
    if (!self.isMyself) {
        
        self.addAttentionBtn.hidden = NO;
        self.headerViewHeightConst.constant = CGRectGetMaxY(self.addAttentionBtn.frame) + 5;
    }else{
        
        self.addAttentionBtn.hidden = YES;
        self.headerViewHeightConst.constant = CGRectGetMaxY(self.userPropertyLabel.frame) + 5;
    }
}

#pragma markheaderView点击事件
// 加关注
- (IBAction)addAttentionClick:(UIButton *)sender {
    
    // 判断是否登录
    if (![DiffUtil judgIsLoginWithViewController:self]) {
        return;
    }
    
    NSString *action = self.userInfo.is_followed.integerValue ? @"cancel" : nil;
    
    if (action) { //取消关注
        [DiffUtil showTwoAlertControllerWithTitle:@"" message:@"确定不再关注此人？" presenViewController:self callBack:^(ClickResult result) {
            
            if (result != clickResultYes) return;
            
            [[[DifferNetwork shareInstance] followOrCancelFollowWithId:self.userInfo.uid action:action] subscribeNext:^(id x) {
                [self getHeaderViewData];

            } error:^(NSError *error) {
                NSLog(@"关注或取消关注失败");
            }];
            
        }];
        
        return;
    }
    
    
    [[[DifferNetwork shareInstance] followOrCancelFollowWithId:self.userInfo.uid action:action] subscribeNext:^(id x) {
        // 获取用户信息来刷新头部信息
        [self getHeaderViewData];

    } error:^(NSError *error) {
        NSLog(@"关注或取消关注失败");

    }];
    
}


//签名
- (void)remarkClick:(UIBarButtonItem *)sender {
    
    PersonalSettingTVC *personSetting = [[PersonalSettingTVC alloc] init];
    
    [self.navigationController pushViewController:personSetting animated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title= @"个人中心";
    
    self.scrollView.delegate = self;
    self.scrollView.decelerationRate = 0.2;//减速速率
    
    self.fullScrollView.delegate = self;
    self.fullScrollView.decelerationRate = 0.3;//减速速率
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.navigationItem.leftBarButtonItem = [DiffUtil initButtonItemWithImage:@"icon_back" action:@selector(backItemClick) delegate:self];
    
    if (self.isMyself) {
        self.navigationItem.rightBarButtonItem = [DiffUtil initButtonItemWithImage:@"porfile_icon_edit" action:@selector(remarkClick:) delegate:self];
    }
    
    [self setupNetworkView];//设置断网view
    
    __weak typeof(self) weakSelf = self;
    // 监听网络
    [DiffUtil monitorNetwork:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusNotReachable){
            weakSelf.netWorkView.hidden = NO;
        }else{
            weakSelf.netWorkView.hidden = YES;
        }
    }];
}



- (void)backItemClick
{

    if (self.isMyself) {
        [[HMDrawerViewController sharedDrawer] backToMainVc];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addChildViewControllers];// 添加子控制器
    
    if (_isInitialize == NO) {
        // 4.设置所有标题
        [self setupAllTitle];
        
        _isInitialize = YES;
    }
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    
    // 获取headerView中的信息
    [self getHeaderViewData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}
//跳到玩家已玩过的游戏列表 todo:
- (void)userGameClick:(UIBarButtonItem *)send
{
    GameListMainViewController *gameListViewController = [[GameListMainViewController alloc] init];
    UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:gameListViewController];
    [self presentViewController:navig animated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 不透明

//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setShadowImage:nil];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.addAttentionBtn.layer.borderWidth = 0.5;
    self.addAttentionBtn.layer.borderColor = [DiffUtil colorWithHexString:@"#54617B"].CGColor;
    
    self.fullScrollHeightConst.constant = self.headerViewHeightConst.constant-64;
    
}

- (void)getHeaderViewData
{
    DifferAccount *account = [DifferAccountTool account];
    NSMutableDictionary *dict =[NSMutableDictionary dictionary];
    if (self.isMyself) {
        dict[@"access_token"] = account.access_token;
    }else{
        dict[@"access_token"] = account.access_token;
        dict[@"user_id"] = self.userId;
    }
    
    [[[DifferNetwork shareInstance] requestUserInformationParamet:dict] subscribeNext:^(id responseObj) {
        
        self.userInfo = [UserModel mj_objectWithKeyValues:responseObj[@"data"]];
        
        if (self.isMyself) {
            [NSKeyedArchiver archiveRootObject:self.userInfo toFile:[DiffUtil getUserPathAtDocument]];
            [DifferAccountTool downloadAvata:self.userInfo.avatar];
            // 用户信息发生改变
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
        }
        [self setupHeaderInfomation];

    } error:^(NSError *error) {
        NSLog(@"请求用户信息失败");
    }];
}

#pragma mark - 设置所有标题
- (void)setupAllTitle
{
    // 添加所有标题按钮
    NSInteger count = self.childViewControllers.count;
    CGFloat btnW = ScreenW / count;
    CGFloat btnH = self.titleView.bounds.size.height;
    CGFloat btnX = 0;
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        UIViewController *vc = self.childViewControllers[i];
        [titleButton setTitle:vc.title forState:UIControlStateNormal];
        btnX = i * btnW;
        titleButton.frame = CGRectMake(btnX, 0, btnW, btnH);
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [DiffUtil getDifferFont:16];
        // 监听按钮点击
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 把标题按钮保存到对应的数组
        [self.titleButtons addObject:titleButton];
        
        if (i == 0) {
            [self titleClick:titleButton];
        }
        
        [self.titleView addSubview:titleButton];
    }
    
    // 设置内容的滚动范围
    self.scrollView.contentSize = CGSizeMake(count * ScreenW, 0);
    
}


#pragma mark - 处理标题点击
- (void)titleClick:(UIButton *)button
{
    
    NSInteger i = button.tag;
    
    // 2.把对应子控制器的view添加上去
    [self setupOneViewController:i];
    
    // 3.内容滚动视图滚动到对应的位置
    CGFloat x = i * [UIScreen mainScreen].bounds.size.width;
    self.scrollView.contentOffset = CGPointMake(x, 0);
    
    // 移动下划线
    CGFloat buttonH = button.frame.size.height;
    CGFloat centerX = button.center.x;
    CGFloat centerY = button.center.y + buttonH * 0.5;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.center = CGPointMake(centerX, centerY);
    } completion:nil];
    
    _selectButton = button;
}



#pragma mark - 添加一个子控制器的View
- (void)setupOneViewController:(NSInteger)i
{
    
    UIViewController *vc = self.childViewControllers[i];
    if (vc.view.superview) {
        return;
    }
    CGFloat x = i * [UIScreen mainScreen].bounds.size.width;
    vc.view.frame = CGRectMake(x, 0, ScreenW,self.scrollView.bounds.size.height);
    [self.scrollView addSubview:vc.view];
    
//    NSInteger count = self.childViewControllers.count;
//    self.scrollView.contentSize = CGSizeMake(ScreenW * count, vc.view.frame.size.height);
}


#pragma mark - UIScrollViewDelegate
// 滚动完成的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (self.fullScrollView == scrollView) { //fullScrollViw只负责监听Y轴的偏移量，来控制导航栏
        
    }else{
        // 获取当前角标
        NSInteger i = scrollView.contentOffset.x / ScreenW;
        
        // 获取标题按钮
        UIButton *titleButton = self.titleButtons[i];
        
        // 1.选中标题
        [self titleClick:titleButton];
        
        // 2.把对应子控制器的view添加上去
        [self setupOneViewController:i];
    }
    
    
}


// 设置导航栏透明度 与 标题的显示
- (void)setupTitleAndNavigationBarAlpa:(CGFloat)offsetY
{
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:offsetY/(self.headerViewHeightConst.constant - 65)];
    
    if (offsetY/(self.headerViewHeightConst.constant - 65) >= 1.0) {
        self.title = @"个人中心";
    }else{
        self.title = nil;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
//    NSLog(@"%@ == %lf ",scrollView.class,scrollView.contentOffset.y);
    
    if (self.fullScrollView == scrollView) {//fullScrollViw只负责监听Y轴的偏移量，来控制导航栏

        CGFloat offsetY = scrollView.contentOffset.y;
        self.offsetY = offsetY;
  
    }else{

    }
//    NSLog(@"%@ == %lf ==%lf ",scrollView.class,scrollView.contentOffset.y,scrollView.contentOffset.x);
    
    
    [self setupTitleAndNavigationBarAlpa:self.offsetY];
}


#pragma mark:四个子控制器中tableview的Y偏移量
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY
{

    NSLog(@"%@ == %@ == %lf",tableView.class,[tableView class],offsetY);
    
    if (self.offsetY < (self.headerViewHeightConst.constant - 68)) {
        
//        tableView.contentSize = CGSizeMake(ScreenW, ScreenH);
//        NSIndexPath *indepath = [NSIndexPath indexPathWithIndex:0];
//        [tableView scrollToRowAtIndexPath:indepath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//        self.fullScrollHeightConst.constant = self.headerViewHeightConst.constant-64 + tableView.contentSize.height;
        
        
    }else{
        
//        tableView.contentSize = CGSizeMake(ScreenW, ScreenH);
//        self.fullScrollHeightConst.constant = self.headerViewHeightConst.constant-64;
    }
    

}


// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}


@end
