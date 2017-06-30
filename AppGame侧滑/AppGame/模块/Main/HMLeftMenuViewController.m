//
//  HMLeftMenuViewController.m
//  AppGame
//
//  Created by  zengchunjun on 2017/4/16.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "HMLeftMenuViewController.h"
#import "HMDrawerViewController.h"
#import "LoginViewController.h"
#import "DiffUtil.h"

#import "DifferNetwork.h"

#import "DifferAccountTool.h"
#import "DifferAccount.h"

#import <UIButton+WebCache.h>

#import "PromoteViewController.h"
#import "DifferDailyController.h"
#import "UserModel.h"

#import "DifferSettingTVC.h"
#import "ProfileViewController.h"
#import "MessageCenterTVC.h"
#import "CommentWallViewController.h"


@interface HMLeftMenuViewController ()

// 头像按钮与父空间X的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconBtnCenterX;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *propertyLabel;

// 监听退出登录
@property (nonatomic,weak)id abserve;

@property (nonatomic,strong)UserModel *userInfo;

// 距离右边的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *notifiViewTrailingConst;

//右上角新消息提示
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;


@end

@implementation HMLeftMenuViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
        
        self.view.frame = [UIScreen mainScreen].bounds;
        
    }
    return self;
}

#pragma mark:系统方法
- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置个人信息
//    [self setupAccountInfomation];
    [self requestUserInformation];//请求用户数据
    
    // 监听个人信息改变或退出账户
    self.abserve = [[NSNotificationCenter defaultCenter] addObserverForName:@"updateAccount" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self requestUserInformation];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

//请求用户数据
- (void)requestUserInformation
{
//    UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    DifferAccount *account = [DifferAccountTool account];
    if (account == nil)
    {
        [self setupAccountInfomation];
        return;
    }
    NSDictionary *dict = @{@"access_token":account.access_token};
    
    [[[DifferNetwork shareInstance] requestUserInformationParamet:dict] subscribeNext:^(id responseObj) {
        
        self.userInfo = [UserModel mj_objectWithKeyValues:responseObj[@"data"]];
        
        //保存用户信息，头像
        [NSKeyedArchiver archiveRootObject:self.userInfo toFile:[DiffUtil getUserPathAtDocument]];
        [DifferAccountTool downloadAvata:self.userInfo.avatar];
        
        [self setupAccountInfomation];

    } error:^(NSError *error) {
        NSLog(@"left请求用户信息失败");
        [self setupAccountInfomation];

    }];

}



- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.iconBtnCenterX.constant = -([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width * 0.8) * 0.5;
    
    self.notifiViewTrailingConst.constant = [UIScreen mainScreen].bounds.size.width * 0.2 + 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark:头像按钮，登录或换图片
- (IBAction)iconBtnClick:(UIButton *)sender {

//    DifferAccount *account = [DifferAccountTool account];
    UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    
//    UserModel *account = self.userInfo;
    if (account != nil) {// 本地存在账户，进去个人详情页
        
        ProfileViewController *profileTVC = [[ProfileViewController alloc] init];

        profileTVC.userId = account.uid;
        
        [[HMDrawerViewController sharedDrawer] switchViewController:profileTVC];
        
        return;
    }
    
    LoginViewController *loginVC = [LoginViewController shareInstance];
    UINavigationController *navi = [DiffUtil initNavigationWithRootViewController:loginVC];
    
    [self presentViewController:navi animated:YES completion:nil];
    
}

#pragma mark:设置个人信息
- (void)setupAccountInfomation
{
    UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
//    DifferAccount *account = [DifferAccountTool account];
    if (account == nil) {
        
        self.screenNameLabel.text = @"请登录";
        self.propertyLabel.hidden = YES;
        
        [self.iconBtn setImage:[UIImage imageNamed:@"menu_user_default"] forState:UIControlStateNormal];
        
    }else{

        self.propertyLabel.hidden = NO;
        NSString *nickName = [account.nickname isEqualToString:@""] ? @"未设置" : account.nickname;
        NSString *property = [NSString stringWithFormat:@"关注 %ld | 粉丝 %ld",account.following,account.follower];
        
        self.screenNameLabel.text = nickName;
        self.propertyLabel.text = property;
//        [self.iconBtn setImage:[DifferAccountTool getAvata] forState:UIControlStateNormal];
        [self.iconBtn sd_setImageWithURL:account.avatar forState:UIControlStateNormal];
    }
    
}

#pragma mark:发现游戏
- (IBAction)dicoverGameClick:(UIButton *)sender {
    NSLog(@"%s",__func__);
    
    PromoteViewController *promoteVC = [[PromoteViewController alloc] init];
//    UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:promoteVC];
//    [self presentViewController:navig animated:YES completion:^{
//        [[HMDrawerViewController sharedDrawer] closeLeftMenuWithDuration:0.25 completion:nil];
//    }];
    [[HMDrawerViewController sharedDrawer] switchViewController:promoteVC];
}

#pragma mark:diff日报
- (IBAction)diffDailyClick:(UIButton *)sender {
    NSLog(@"%s",__func__);
    
    DifferDailyController *daily = [[DifferDailyController alloc] init];
    
//    UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:daily];
//    [self presentViewController:navig animated:YES completion:^{
//        [[HMDrawerViewController sharedDrawer] closeLeftMenuWithDuration:0.25 completion:nil];
//    }];
    [[HMDrawerViewController sharedDrawer] switchViewController:daily];
}

#pragma mark:玩友评论墙
- (IBAction)commentWallClick:(UIButton *)sender {

    CommentWallViewController *commentWallVC = [[CommentWallViewController alloc] init];
//    UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:commentWallVC];
//    [self presentViewController:navig animated:YES completion:^{
//        [[HMDrawerViewController sharedDrawer] closeLeftMenuWithDuration:0.25 completion:nil];
//    }];
    
    [[HMDrawerViewController sharedDrawer] switchViewController:commentWallVC];
}
//邀请好友
- (IBAction)shareClick:(UIButton *)sender {
    
    [[HMDrawerViewController sharedDrawer] closeLeftMenuWithDuration:0.15 completion:^{
        
        [[HMDrawerViewController sharedDrawer] displayShareView];
    }];
}

//设置
- (IBAction)settingClick:(UIButton *)sender {
    
    DifferSettingTVC *setting = [[DifferSettingTVC alloc] init];
    
//    UINavigationController *nav = [DiffUtil initNavigationWithRootViewController:[HMDrawerViewController sharedDrawer]];
//    [nav pushViewController:setting animated:YES];
    
    [[HMDrawerViewController sharedDrawer] switchViewController:setting];
    
    
    
}

// 右上角点击事件  消息中心
- (IBAction)notificationBtnClick:(UIButton *)sender {
    NSLog(@"%s %d",__func__,__LINE__);
    MessageCenterTVC *message = [[MessageCenterTVC alloc]init];
    
    [[HMDrawerViewController sharedDrawer] switchViewController:message];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_abserve name:@"updateAccount" object:nil];
}


@end
