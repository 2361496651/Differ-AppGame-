//
//  PromoteViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "PromoteViewController.h"
#import "DiffUtil.h"
#import "CustomFlowLayout.h"
#import "GameCollectionCell.h"
#import "GameModel.h"
#import "DifferNetwork.h"
#import <MJExtension.h>
#import "DownLinkModel.h"
#import "AnimationView.h"

#import "AnimationCell.h"
#import "GlobelConst.h"
#import "NoGameAlertView.h"
#import "SearchSettingTVC.h"

#import "DifferAccountTool.h"
#import "DifferAccount.h"

#import "CommonMacroDefinition.h"
#import "GameDetailViewController.h"
#import "GameListMainViewController.h"

#import <SVProgressHUD.h>

// 屏幕宽 内边距  高度比例系数  行间距
#define ScreenW [UIScreen mainScreen].bounds.size.width
#define insetMargin 25
#define mutiple 0.88
#define LineSpacing 10

@interface PromoteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,AnimationCellDelegate,NoGameAlertViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConst;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *goPlayLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;


@property (nonatomic,strong)NSMutableArray<GameModel *> *games;

@property (nonatomic,assign)NSInteger currentIndex;


@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)AnimationView *animationView;

@property (nonatomic,assign)BOOL isLastView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

// 无游戏
@property (nonatomic,strong)UILabel *tipLabel;

// 搜索无游戏
@property (nonatomic,strong)NoGameAlertView *alertView;
// 底部去玩与喜欢的父视图
@property (weak, nonatomic) IBOutlet UIView *downView;


// 搜索偏好设置

@property (weak, nonatomic) IBOutlet UIView *bottomSearchView;

@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

@end


static NSString * const ID = @"GameCollectioncell";
static NSString * const AnimationID = @"AnimationCell";

@implementation PromoteViewController
#pragma mark: 懒加载属性
// 无游戏弹框
- (NoGameAlertView *)alertView
{
    if (_alertView == nil) {
        NoGameAlertView *view = [[NoGameAlertView alloc]initWithFrame:self.view.bounds];
        view.delegate = self;
        _alertView = view;
    }
    return _alertView;
}

- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:self.collectionView.bounds];
        _tipLabel.text = @"今日已经没有可搜索游戏的机会了!";
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = [UIColor lightGrayColor];
        _tipLabel.hidden = YES;
        [self.collectionView addSubview:_tipLabel];
    }
    return _tipLabel;
}
// 承载动画的bgView
- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:self.view.bounds];
        _bgView.backgroundColor = [DiffUtil getDifferColor];
    }
    return _bgView;
}
//动画view
- (AnimationView *)animationView
{
    if (_animationView == nil) {
        _animationView = [[AnimationView alloc] initWithFrame:CGRectMake(0, 0, 280, 280)];
        _animationView.backgroundColor = [UIColor whiteColor];
        _animationView.count = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
    }
    return _animationView;
}
// 游戏
- (NSMutableArray *)games
{
    if (_games == nil) {
        _games = [NSMutableArray array];
    }
    return _games;
}

- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [DiffUtil getDifferColor];
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.title = @"今日推荐";
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_down_def"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    
    
    
    // 默认当前索引为0
    self.currentIndex = 0;
    
    self.isLastView = NO;// 默认不是最后一个动画界面
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (iPhone5) {
        self.bottomViewHeightConst.constant = 85;
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 请求数据
    [self loadData];
    
    NSString *index = [[NSUserDefaults standardUserDefaults] objectForKey:searchSettingIndex];
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"探索玩家推荐(默认)", @"探索好评的",@"探索其他玩家都在玩",@"探索可能喜欢的",@"探索可能没玩过",nil];
    self.searchLabel.text = [NSString stringWithFormat:@"当前探索条件是:%@",array[index.integerValue]];
}
#pragma mark:设置布局，只有在viewdidappear后，self.collectionView的约束才正确，否则都是xib中的尺寸
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    CustomFlowLayout *flowlayout = ({
        CustomFlowLayout *layout = [[CustomFlowLayout alloc] init];
        
        CGSize size = self.collectionView.bounds.size;
        
        CGSize itemSize = CGSizeMake(ScreenW - insetMargin * 2, size.height * mutiple);
        layout.itemSize = itemSize;
        
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat margin = (ScreenW - itemSize.width) * 0.5;
        layout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
        // 设置最小行间距
        layout.minimumLineSpacing = LineSpacing;
        layout;
        
    });
    
    self.collectionView.collectionViewLayout = flowlayout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"GameCollectionCell" bundle:nil] forCellWithReuseIdentifier:ID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"AnimationCell" bundle:nil] forCellWithReuseIdentifier:AnimationID];
}

#pragma mark:// 发送通知，修改主页封面
- (void)postNotificationToUpdateHomeGame
{
    //封面的游戏和里面的第一个没有收藏的游戏保持一致
    if (self.games.count == 0) return;
    for (GameModel *game in self.games) {
        
        if (game.isCollect.integerValue) continue;
        
        // 发送通知，修改主页封面
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateColumn" object:game];
        break;
    }
    
    
}

#pragma mark: 请求今日推荐游戏数据
- (void)loadData
{
    [[[DifferNetwork shareInstance] getRecommendSuccess] subscribeNext:^(id responseObj) {
        
        [self.games removeAllObjects];
            
        NSArray *gameModels = responseObj[@"data"];
        for (NSDictionary *gameDict in gameModels) {
            GameModel *game = [GameModel mj_objectWithKeyValues:gameDict];
            [self.games addObject:game];
        }
        // 发送通知，修改主页封面
        [self postNotificationToUpdateHomeGame];
            
        //        [self.collectionView reloadData];
        [self displayTip];

    } error:^(NSError *error) {
        NSLog(@"今日推荐游戏请求失败");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource 数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *lastCount = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
    
    if (lastCount.integerValue > 0) {
        return self.games.count + 1;
    }
    
    return self.games.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == self.games.count) { // 最后一个界面
        AnimationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AnimationID forIndexPath:indexPath];
        cell.count = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
        cell.delegate = self;
        
//        [self hiddenBottomButton:YES];// 

        return cell;
    }
    
    GameCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.game = self.games[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == self.games.count) { //点击了最后一个 
        return;
    }
    
    GameDetailViewController *gameDetailVC = [[GameDetailViewController alloc] init];
    gameDetailVC.gameModel = self.games[indexPath.row];
    [self.navigationController pushViewController:gameDetailVC animated:YES];
    //    CommentPageViewController *commentPageVC = [[CommentPageViewController alloc] init];
    //    commentPageVC.appraiseModel = self.appraises[indexPath.row];
    //    [self.navigationController pushViewController:commentPageVC animated:YES];
}

#pragma mark: animationCellDelegate 点击最后一个cell开启动画
// 开始动画
- (void)animationCellStartAnimation
{
    [self.view addSubview:self.bgView];
    
    self.animationView.center = CGPointMake(self.bgView.center.x, self.bgView.center.y-25);
    [self.bgView addSubview:self.animationView];
    
    // 第几次探索
    NSString *pageStr = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
    NSInteger pageIndex = 6 - pageStr.integerValue;
    NSString *page = [NSString stringWithFormat:@"%ld",pageIndex];
    
    DifferAccount *account = [DifferAccountTool account];
    NSString *searchIds = [DiffUtil getSearchGameIdString];
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    if (account != nil) {
        parameter[@"access_token"] = account.access_token;
    }
    if (searchIds && ![searchIds isEqualToString:@""]) {
        parameter[@"ids"] = searchIds;
    }
    parameter[@"page"] = page;
    // 探索游戏

    [[[DifferNetwork shareInstance] searchGameWithParameter:parameter] subscribeNext:^(id responseObj) {
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *gameModels = responseDict[@"data"];
        NSDictionary *columnDict = gameModels[@"column"];
        
        GameModel *column = [GameModel mj_objectWithKeyValues:columnDict]; // 封面的游戏
        NSArray *gameList = gameModels[@"list"];// 探索到的游戏列表
        
        //探索无结果
        if (gameList.count == 0) {
            
            [self removeSearchAnimation];
            [self displayNoSearchGame];
            [self.collectionView reloadData];
            
            return ;
        }
        //保存今日探索到的游戏Ids
        [self saveSearchGameIds:gameList];
        
        [self.collectionView reloadData];
        
        // 发送通知，修改主页封面
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateColumn" object:column];
        [self postNotificationToUpdateHomeGame];
        
        //保存最新的游戏ID以及重置探索次数
        [self resetSearchCountAndSaveLastGameId:column];
        
        //移除动画，并显示最新的游戏
        [self removeSearchAnimation];

    } error:^(NSError *error) {
        NSLog(@"探索游戏失败");
    }];
}

#pragma mark: 保存今天已经探索到的游戏
- (void)saveSearchGameIds:(NSArray *)gameList
{
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:[DiffUtil getSearchGameIdsPath]];
    if (tempArray == nil) {
        tempArray = [NSMutableArray array];
    }
    
    
    for (NSDictionary *listDict in gameList) {
        GameModel *game = [GameModel mj_objectWithKeyValues:listDict];
        [self.games insertObject:game atIndex:0];
        [tempArray addObject:game.uid];
    }
    [tempArray writeToFile:[DiffUtil getSearchGameIdsPath] atomically:YES];
}

#pragma mark:保存最新的游戏ID以及重置探索次数
- (void)resetSearchCountAndSaveLastGameId:(GameModel *)column
{
    // 保存最新的游戏ID
//    [[NSUserDefaults standardUserDefaults] setObject:column.uid forKey:lastSearchGameId];
    // 重置每日探索次数
    NSString *lastSearchs = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
    NSString *lastCounts = [NSString stringWithFormat:@"%ld",lastSearchs.integerValue - 1];
    [[NSUserDefaults standardUserDefaults] setObject:lastCounts forKey:lastSearchCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark:移除探索动画
- (void)removeSearchAnimation
{
    sleep(2);
    
    [UIView animateWithDuration:1.2 animations:^{
        self.bgView.alpha = 0.01;
    } completion:^(BOOL finished) {
        
        [self.animationView removeFromSuperview];
        self.animationView = nil;
        [self.bgView removeFromSuperview];
        self.bgView = nil;
        
    }];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self hiddenBottomButton:NO];
    self.currentIndex = 0;
}

#pragma mark: 探索无结果
- (void)displayNoSearchGame
{
    [self.view addSubview:self.alertView];
}

#pragma mark:NoGameAlertViewDelegate
- (void)alertViewBgClick:(NoGameAlertView *)alertView
{
    
    [self.alertView removeFromSuperview];
}

#pragma mark:去我的游戏
- (void)alertViewGoClick:(NoGameAlertView *)alertView
{
    //去我的游戏

    BOOL isLogin = [DiffUtil judgIsLoginWithViewController:self];//判断是否登录，未登录则弹出登录界面
    if(isLogin){
        GameListMainViewController *gameListViewController = [[GameListMainViewController alloc] init];
        UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:gameListViewController];
        [self presentViewController:navig animated:YES completion:nil];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGSize size = self.collectionView.frame.size;
    
    CGSize itemSize = CGSizeMake(ScreenW - insetMargin * 2, size.height * mutiple);
    // 偏移量 / itemSize宽度 + 间距10
    NSInteger index = (scrollView.contentOffset.x / (itemSize.width + LineSpacing)) + 0.5;
    
    self.currentIndex = index;
    
    [self setupCollectionBtnState];
    
    //结束滑动，下面的按钮可用
//    self.downloadBtn.enabled = YES;
//    self.collectionBtn.enabled = YES;
    
    NSString *lastCount = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
    if (lastCount.integerValue > 0 && index == self.games.count) {
        [self hiddenBottomButton:YES];
    }else{
        [self hiddenBottomButton:NO];
    }

}

#pragma mark:滑动停止
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    CGSize size = self.collectionView.frame.size;
//    
//    CGSize itemSize = CGSizeMake(ScreenW - insetMargin * 2, size.height * mutiple);
//   // 偏移量 / itemSize宽度 + 间距10
//    NSInteger index = (scrollView.contentOffset.x / (itemSize.width + LineSpacing)) + 0.5;
//    
//    self.currentIndex = index;
//    
//    [self setupCollectionBtnState];
//    
//    //结束滑动，下面的按钮可用
//    self.downloadBtn.enabled = YES;
//    self.collectionBtn.enabled = YES;
//    
//    NSString *lastCount = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
//    if (lastCount.integerValue > 0 && index == self.games.count) {
//        [self hiddenBottomButton:YES];
//    }else{
//        [self hiddenBottomButton:NO];
//    }
//}
#pragma mark: 喜欢按钮状态，只在本地改变，每次今天都不会出现自己以及喜欢的游戏
- (void)setupCollectionBtnState
{
    if (self.currentIndex >= self.games.count) {
        return;
    }
    
    GameModel *game = self.games[self.currentIndex];
    if (game.isCollect.integerValue == 1) {
        [self.collectionBtn setImage:[UIImage imageNamed:@"icon_like_pre"] forState:UIControlStateNormal];
    }else{
        [self.collectionBtn setImage:[UIImage imageNamed:@"icon_like_def"] forState:UIControlStateNormal];
    }
}


#pragma mark: 隐藏或显示底部的按钮
- (void)hiddenBottomButton:(BOOL)isHidden
{
    self.downView.hidden = isHidden;
    
//    self.bottomSearchView.hidden = !isHidden;
    self.bottomSearchView.hidden = YES;//暂时隐藏
    
//    CATransition *animation = [CATransition animation];
//    animation.type = kCATransitionFade;
//    animation.duration = 0.3;
//
//    [self.downView.layer addAnimation:animation forKey:nil];
//    [self.bottomSearchView.layer addAnimation:animation forKey:nil];
    
}

#pragma mark: 今日推荐是否有游戏
- (void)displayTip
{
    NSString *lastCount = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
    if (self.games.count == 0 && lastCount.integerValue == 0) {
        
//        self.tipLabel.hidden = NO;
        [self displayNoSearchGame];// 展示无游戏界面
        
        [self hiddenBottomButton:YES];
        
        
        
    }else{
        self.tipLabel.hidden = YES;
        [self.collectionView reloadData];
    }
}

#pragma mark: 下载
- (IBAction)downloadClick:(UIButton *)sender {

    NSString *lastCount = [[NSUserDefaults standardUserDefaults] objectForKey:lastSearchCount];
    if (self.currentIndex == self.games.count && lastCount.integerValue > 0) {
        return;
    }
    
    GameModel *game = self.games[self.currentIndex];
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


#pragma mark: 喜欢
- (IBAction)loveClick:(UIButton *)sender {
    // 判断是否登录
    if (![DiffUtil judgIsLoginWithViewController:self]) {
        return;
    }
    GameModel *game = self.games[self.currentIndex];
    NSString *gameId = game.uid == nil ? game.game_id : game.uid;
    NSString *isCollect = game.isCollect.integerValue ? @"delete" : @"add"; ;
    
    [[[DifferNetwork shareInstance] collectionGameWithId:gameId action:isCollect] subscribeNext:^(id responseObj) {
        GameModel *game = self.games[self.currentIndex];
        game.isCollect = [NSString stringWithFormat:@"%d",!game.isCollect.integerValue];
        [self.games replaceObjectAtIndex:self.currentIndex withObject:game];
        
        // 设置喜欢按钮状态
        [self setupCollectionBtnState];
        //        [self displayTip];
        //更改封面游戏
        [self postNotificationToUpdateHomeGame];

    } error:^(NSError *error) {
        NSLog(@"喜欢游戏失败");
    }];
}

#pragma mark: 点击 探索偏好设置
- (IBAction)settingSearchClick:(UIButton *)sender {
    
    SearchSettingTVC *search = [[SearchSettingTVC alloc]init];
    
    NSString *index = [[NSUserDefaults standardUserDefaults] objectForKey:searchSettingIndex];
    search.searchIndex = index.integerValue;
    
    [self.navigationController pushViewController:search animated:YES];
}


// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}


@end
