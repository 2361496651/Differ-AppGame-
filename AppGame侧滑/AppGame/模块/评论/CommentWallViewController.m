//
//  CommentViewController.m
//  AppGame
//
//  Created by chan on 17/5/3.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "CommentWallViewController.h"
#import "WaterfallLayout.h"
#import "WaterfallCell.h"
#import "DifferAccountTool.h"
#import "DifferAccount.h"
#import "DifferNetwork.h"
#import <MJExtension.h>
#import "AppraiseModel.h"
#import "GameModel.h"
#import "UIImageView+WebCache.h"
#import "CommentPageViewController.h"

#import "CommonMacroDefinition.h"
#import <MJRefresh.h>
#import "DropdownMenu.h"

#import "GameServices.h"
#import "GameDetailViewController.h"
#import "UserModel.h"

#import <BTLabel.h>

@interface CommentWallViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, WaterfallLayoutDelegate, DropdownMenuDelegate,WaterfallCellDelegate>

@property(nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic,strong)NSMutableArray<AppraiseModel *> *appraises;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *position;
//@property(nonatomic, strong) DropdownMenu *dropdownMenu;
//@property(nonatomic, strong) UIView *navigationView;
@property(nonatomic, strong) WaterfallCell *waterfallCell;

//@property(nonatomic, strong) UIView *backgroundView;
@property(nonatomic, assign) CGFloat offsety;
@end

@implementation CommentWallViewController

#pragma mark -懒加载属性-------------------------
- (NSMutableArray *)appraises
{
    if (_appraises == nil) {
        _appraises = [NSMutableArray array];
    }
    return _appraises;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        WaterfallLayout *layout = [[WaterfallLayout alloc] init];
        layout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-20) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

//-(UIView *)navigationView{
//    if (!_navigationView) {
//        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
//        _navigationView.backgroundColor = [UIColor ag_MAIN];
//        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_navigationView addSubview:backBtn];
//        [backBtn setFrame:CGRectMake(0, 20, 44, 44)];
//        [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
//        [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchDown];
//    }
//    return _navigationView;
//}

//-(DropdownMenu *)dropdownMenu{
//    if (!_dropdownMenu) {
//        NSArray *titleArr = [NSArray arrayWithObjects:@"热门评论",@"我的游戏",@"我没玩过的", nil];
//        _dropdownMenu = [[DropdownMenu alloc] initWithFrame:CGRectMake(0, 0, 200, 25)];
//        [self.view addSubview:_dropdownMenu];
//        _dropdownMenu.delegate = self;
//        [_dropdownMenu setMenuTitles:titleArr];
//        CGPoint point = _navigationView.center;
//        point.y += 10;
//        _dropdownMenu.center = point;
//    }
//    return _dropdownMenu;
//}

//-(UIView *)backgroundView{
//    if (!_backgroundView) {
//        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -(ScreenHeight/1.4), ScreenWidth, ScreenHeight*0.85)];
//        _backgroundView.backgroundColor = [UIColor ag_MAIN];
//    }
//    return _backgroundView;
//}

#pragma mark 生命周期------------------------------
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor HEX:0xf4f4f4];

    self.navigationItem.title = @"热门评价";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_down_def"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    
    _position = @"1";
    _type = @"hot";
    _offsety = 0;
    
    //    加载刷新功能
    [self addRefreshAndLoadMoreData];

//    [self.view addSubview:self.backgroundView];
    
    [self.view addSubview:self.collectionView];
    
//    [self.view addSubview:self.navigationView];
    
//    [self.view addSubview:self.dropdownMenu];
    
    [self.collectionView registerClass:[WaterfallCell class] forCellWithReuseIdentifier:@"waterfallCell"];
    
}
#pragma mark collectionView代理方法------------------------------
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.appraises.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"waterfallCell";
    self.waterfallCell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    self.waterfallCell.appraiseModel = self.appraises[indexPath.row];
    self.waterfallCell.delegate = self;
    return self.waterfallCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld个item" , (long)indexPath.row);
    CommentPageViewController *commentPageVC = [[CommentPageViewController alloc] init];
    commentPageVC.appraiseModel = self.appraises[indexPath.row];
//    [self.dropdownMenu hideDropDown];
    [self.navigationController pushViewController:commentPageVC animated:YES];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat pianyi = 0;
//    pianyi = scrollView.contentOffset.y - _offsety;
//    _offsety = scrollView.contentOffset.y;
//    CGRect frame = self.backgroundView.frame;
//    frame.origin.y -= pianyi;
//    self.backgroundView.frame = frame;
//}

#pragma mark -- 导航栏代理方法--------------------
//- (void)backClick{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark -- WaterLayoutDelegate
//设置每一行的高度
- (CGFloat)waterLayout:(UICollectionViewLayout *)waterLayout itemWidth:(CGFloat)itemWidte indexPath:(NSIndexPath *)indexPath {
    AppraiseModel *appraiseModel = self.appraises[indexPath.row];
    UserModel *user = appraiseModel.author;
    
    //去掉换行符
    NSString *content = [NSString stringWithFormat:@"%@：%@",user.nickname, appraiseModel.content];
    NSString *mStr = [content delLinebreaks];
    
    float height = [@"的" getSpaceLabelHeight:[UIFont systemFontOfSize:12] withWidth:(ScreenWidth-90)/2 linespace:3];
    
    NSInteger lines = [mStr getLineNumbers:(ScreenWidth-90)/2 font:[UIFont systemFontOfSize:12]];

    if(lines > 6){
        height = height * 6;
    }else{
        height = height * lines;
    }

    return height + 90;
}

#pragma mark 数据处理------------------------------
- (void)loadData:(BOOL)isNewData{
    [[[DifferNetwork shareInstance] getEvaluationWall:_position type:_type] subscribeNext:^(id responseObj) {
        
        if (isNewData) [self.appraises removeAllObjects];
        
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        self.position = responseDict[@"meta"][@"position"];
        NSArray * dataArray = responseDict[@"data"];
        for (NSDictionary *modelDict in dataArray) {
            AppraiseModel *appraise = [AppraiseModel mj_objectWithKeyValues:modelDict];
            [self.appraises addObject:appraise];
        }
        
        [self.collectionView reloadData];
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    } error:^(NSError *error) {
        NSLog(@"请求评论抢数据失败：%@",error);
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

- (void)addRefreshAndLoadMoreData
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.collectionView.mj_header = header;
    [self.collectionView.mj_header beginRefreshing];
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];

    self.collectionView.mj_footer = footer;
    
}

-(void) loadNewData{
    _position = @"1";
    [self loadData:YES];
}

-(void) loadMoreData{
    [self loadData:NO];
}

//-(void)dropdownMenu:(DropdownMenu *)menu selectedCellNumber:(NSInteger)number{
//    
//    switch (number) {
//        case 0:
//            _type = @"hot";
//            break;
//        case 1:
//            _type = @"collection";
//            break;
//        case 2:
//            _type = @"not_collection";
//            break;
//        default:
//            break;
//    }
//    [self loadNewData];
//}

-(void)clickCellTitle:(GameModel*)gameModel{
    GameDetailViewController *gameDetailVC = [[GameDetailViewController alloc] init];
    gameDetailVC.gameModel = gameModel;
    [self.navigationController pushViewController:gameDetailVC animated:YES];
}


@end
