//
//  HomeViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/14.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "HomeViewController.h"
#import "MyPageControl.h"
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "GlobelConst.h"
#import "NSDate+CJTime.h"
#import "DiffUtil.h"
#import "HMDrawerViewController.h"
#import "AccountNetwork.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "DifferNetwork.h"

#import "HomeModel.h"
#import "UserModel.h"
#import <MJExtension.h>
#import <SDWebImage/UIImageView+WebCache.h>

#import "ProfileViewController.h"
#import "PromoteViewController.h"
#import "DifferDailyController.h"
#import "CommentWallViewController.h"
#import "GameListMainViewController.h"
#import "GamePlayedViewController.h"

#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)

@interface HomeViewController ()<UIScrollViewDelegate>
// scrollview与pageControl
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 底部bottom高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConst;


// 游戏推荐
@property (weak, nonatomic) IBOutlet UIView *gameContentView;// 游戏推荐父view

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;//日期

@property (weak, nonatomic) IBOutlet UILabel *yearMonthLabel; // 年月
@property (weak, nonatomic) IBOutlet UILabel *dayLabel; // 今天

@property (weak, nonatomic) IBOutlet UILabel *todayPromoteLabel;// 今日推荐

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;//游戏封面图

@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;//横幅

@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;//游戏标题

@property (weak, nonatomic) IBOutlet UILabel *gameIntroduce;//游戏介绍
@property (weak, nonatomic) IBOutlet UILabel *fromNameLabel; // 来自谁的介绍
@property (weak, nonatomic) IBOutlet UIImageView *fromIcom;


// differ日报

@property (weak, nonatomic) IBOutlet UIImageView *differImageView;

//评论墙
@property (weak, nonatomic) IBOutlet UIImageView *commentImageView;


// gif图
@property (nonatomic,strong)FLAnimatedImageView *gifImageView;

@property (nonatomic,strong)MyPageControl *pageControl;

@property (nonatomic,strong)HomeModel *homeModel;

// 监听探索游戏
@property (nonatomic,weak)id abserve;

//下部 pageView
@property (weak, nonatomic) IBOutlet UIPageControl *pageLeft;
@property (weak, nonatomic) IBOutlet UIPageControl *pageMid;
@property (weak, nonatomic) IBOutlet UIPageControl *pageRight;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *midBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;


@end


@implementation HomeViewController

#pragma mark:懒加载属性
// page页
- (MyPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[MyPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 60, [UIScreen mainScreen].bounds.size.width, 30)];
        _pageControl.numberOfPages = 3;
        _pageControl.currentPage = 0;
        
        [_pageControl setImagePageStateNormal:[UIImage imageNamed:@"image2.png"]];
        [_pageControl setImagePageStateHighlighted:[UIImage imageNamed:@"image2.png"]];

    }
    return _pageControl;
}
// 动画View
- (FLAnimatedImageView *)gifImageView
{
    if (_gifImageView == nil) {
        _gifImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    return _gifImageView;
}

#pragma mark: 打开侧栏
- (void)openLeftMenu:(UIBarButtonItem *)sender
{
    [[HMDrawerViewController sharedDrawer] openLeftMenuWithDuration:0.3 completion:nil];
}

- (void)openMyGames:(UIBarButtonItem *)sender
{
    BOOL isLogin = [DiffUtil judgIsLoginWithViewController:self];//判断是否登录，未登录则弹出登录界面
    if(isLogin){
//        GameListMainViewController *gameListViewController = [[GameListMainViewController alloc] init];
//        UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:gameListViewController];
//        [self presentViewController:navig animated:YES completion:nil];
        
        GamePlayedViewController *gamePlayedViewController = [[GamePlayedViewController alloc] init];
        UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:gamePlayedViewController];
        [self presentViewController:navig animated:YES completion:nil];
    }
}

#pragma mark:系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"今日推荐";
    
    self.navigationItem.leftBarButtonItem = [DiffUtil initButtonItemWithImage:@"icon_menu" action:@selector(openLeftMenu:) delegate:self];
    self.navigationItem.rightBarButtonItem = [DiffUtil initButtonItemWithImage:@"icon_game" action:@selector(openMyGames:) delegate:self];

    // 加载GIF动画
    [self loadingGifImage];
    
    //设置点击事件
    [self setupClickForContent];
    
    //获取首页信息
    [self getHomeInformation];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //设置底部pageView : 三个按钮+三个pageView
    [self setupBottomPageView];
    
    
    // 监听探索游戏
    self.abserve = [[NSNotificationCenter defaultCenter] addObserverForName:@"updateColumn" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        GameModel *game = note.object;
        self.homeModel.info = game;
        [self displayHomeInformation];
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (iPhone5) {
        self.bottomHeightConst.constant = 70;
    }


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    // 不透明
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    
//    [self.navigationController.navigationBar setShadowImage:nil];
    
    self.navigationController.navigationBar.translucent = NO;
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:1];
}

// 布局底部pageView
- (void)setupBottomPageView
{
    self.pageLeft.center = self.leftBtn.center;
    self.pageMid.center = self.midBtn.center;
    self.pageRight.center = self.rightBtn.center;
    
    // 0 : leftBtn,pageLeft  1:midBtn,pageMid 2:rightBtn,pageRight
    [self showBottomPage:0];
    
}

// 设置底部page的隐藏
- (void)showBottomPage:(NSInteger)tag
{
    switch (tag) {
        case 0: // 展示左边的 游戏推荐
        {
            self.leftBtn.hidden = NO;
            self.pageLeft.hidden = YES;
            
            self.midBtn.hidden = YES;
            self.pageMid.hidden = NO;
            
            self.rightBtn.hidden = YES;
            self.pageRight.hidden = NO;
        }
            
            break;
        case 1: // 展示中间的 differ日报
        {
            self.leftBtn.hidden = YES;
            self.pageLeft.hidden = NO;
            
            self.midBtn.hidden = NO;
            self.pageMid.hidden = YES;
            
            self.rightBtn.hidden = YES;
            self.pageRight.hidden = NO;
        }
            break;
        case 2: // 展示右边的 评论墙
        {
            self.leftBtn.hidden = YES;
            self.pageLeft.hidden = NO;
            
            self.midBtn.hidden = YES;
            self.pageMid.hidden = NO;
            
            self.rightBtn.hidden = NO;
            self.pageRight.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}




#pragma mark 获取首页信息 今日推荐 && differ日报 && 评论墙
- (void)getHomeInformation
{
    [[[DifferNetwork shareInstance] getHomeDataSuccess] subscribeNext:^(id responseObj) {
        
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSArray *homeArray = responseDict[@"data"];
            
        for (int i = 0; i < homeArray.count; i++) {
            NSDictionary *model = homeArray[i];
            NSDictionary *attributes = model[@"attributes"];
            if ([attributes[@"type"] isEqualToString:@"recommend"]) { // daily comment
                self.homeModel = [HomeModel mj_objectWithKeyValues:attributes];
                [self displayHomeInformation];
                    
            }
        }
    } error:^(NSError *error) {
        NSLog(@"获取主页信息失败：%@",error);
    }];
}


#pragma mark:展示主页信息，
- (void)displayHomeInformation
{
    // 今日推荐
    
    GameModel *game = self.homeModel.info;
    
    self.dateLabel.text = [[NSDate date] currentDateDayString];
    self.yearMonthLabel.text = [[NSDate date] currentDateYearMonthString];
    self.dayLabel.text = @"今天";
    
    self.todayPromoteLabel.text = self.homeModel.title;
    [self.bgImageView sd_setImageWithURL:game.cover placeholderImage:nil];
//    [UIImage imageNamed:@"img_1"]
    self.bannerImageView.image = [UIImage imageNamed:@"def_mask_game_grey"];
//    [self.bannerImageView sd_setImageWithURL:self.homeModel.info.cover placeholderImage:[UIImage imageNamed:@"def_mask_game_grey"]];
    
    self.gameNameLabel.text = game.game_name_cn;
    self.gameIntroduce.text = game.recommend_reason;
    
    NSString *nickName = game.user.nickname;
    if (nickName == nil || [nickName isEqualToString:@""]) {
        nickName = @"未知作者";
    }
    self.fromNameLabel.text = [NSString stringWithFormat:@"%@",nickName];
    [self.fromIcom sd_setImageWithURL:game.user.avatar];
    
}

#pragma mark: 刷新token
//- (void)refreshToken
//{
//    [[AccountNetwork shareInstance] refreshTokenSuccess:^(id responseObj) {
//        
//        NSDictionary *responseDict = (NSDictionary *)responseObj;
//        DifferAccount *account = [DifferAccount accountWithDic:responseDict];
//        [DifferAccountTool saveAccount:account];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"刷新token失败");
//    }];
//}


#pragma mark: 加载GIF动画
- (void)loadingGifImage
{
//    [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:lastSearchCount];
    NSString *now = [[NSDate date] dateStrWithYMD];
    NSString *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:gifAnimation];
    if ([now isEqualToString:lastDate]) { // 同一天进来，但不是第一次 此处判断用户动画和探索次数
        return;
    }
    
    // 刷新token
//    [self refreshToken];
    
    // 重置每天的探索游戏次数
    [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:lastSearchCount];
    
    [DiffUtil removeSearchGameIds];//每日删除探索到的游戏ID
    
    
    // 保存每天的动画日期
    [[NSUserDefaults standardUserDefaults] setObject:now forKey:gifAnimation];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"differ-loading" ofType:@"gif"];
    
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
    
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:imageData];
    
    self.gifImageView.animatedImage = image;
    
    __weak typeof(self) weakSelf = self;
    self.gifImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {

        if (loopCountRemaining == -2) {
            [weakSelf.gifImageView removeFromSuperview];
        }
    };
    
//    [self.view addSubview:self.gifImageView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.gifImageView];
    
}

#pragma mark : 设置内容的点击事件
- (void)setupClickForContent
{
    self.gameContentView.tag = 1;
    self.differImageView.tag = 2;
    self.commentImageView.tag = 3;
    self.differImageView.userInteractionEnabled = YES;
    self.commentImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.gameContentView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.differImageView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.commentImageView addGestureRecognizer:tap3];
}

#pragma mark:主页中三个页面的点击事件
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    switch (tap.view.tag) {
        case 1:
        {
            NSLog(@"%s %d",__func__,__LINE__);// 点击了今日推荐
            PromoteViewController *promoteVC = [[PromoteViewController alloc] init];
//            UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:promoteVC];
//            [self presentViewController:navig animated:YES completion:nil];
            [self.navigationController pushViewController:promoteVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"%s %d",__func__,__LINE__);// 点击了日报
            DifferDailyController *daily = [[DifferDailyController alloc] init];
            [self.navigationController pushViewController:daily animated:YES];
//            UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:daily];
//            [self presentViewController:navig animated:YES completion:nil];
            
            break;
        }
        case 3:
        {
            NSLog(@"%s %d",__func__,__LINE__);// 点击了评论墙
            CommentWallViewController *commentWallVC = [[CommentWallViewController alloc] init];
            [self.navigationController pushViewController:commentWallVC animated:YES];
//            UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:commentWallVC];
//            [self presentViewController:navig animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark: 结束滑动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"%lf",scrollView.contentOffset.x);
    NSInteger page = (scrollView.contentOffset.x / self.scrollView.bounds.size.width) + 0.5;
//    self.pageView.currentPage = page;
    [self showBottomPage:page];
    
    //标题改变
    switch (page) {
        case 0:
            self.title =@"今日推荐";
            break;
        case 1:
            self.title =@"differ日报";
            break;
        case 2:
            self.title =@"评论墙";
            break;
            
        default:
            break;
    }
//    self.title = page ? @"" : @"今日推荐";
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:_abserve name:@"updateColumn" object:nil];
}

@end
