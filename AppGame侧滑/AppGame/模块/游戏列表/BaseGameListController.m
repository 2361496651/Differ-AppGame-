//
//  BaseGameListControllerViewController.m
//  AppGame
//
//  Created by supozheng on 2017/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "BaseGameListController.h"
#import "GameCollectionViewCell.h"
#import "CollectionHeadView.h"
#import "DifferNetwork.h"
#import "GameListGroup.h"
#import "GameServices.h"
#import <MJExtension.h>
#import "GameModel.h"
#import "GameDetailViewController.h"
#import "DifferAccountTool.h"
#import "DiffUtil.h"

@interface BaseGameListController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *games;
@property (nonatomic,assign)NSInteger position;
@property (nonatomic,assign)NSInteger cellWidth;
@property (nonatomic,assign)NSInteger cellHeight;
@property (nonatomic,assign)BOOL isRecommand;
@end

@implementation BaseGameListController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self loadData];
    // add by zcj
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setupView{
    float cellWidthHeightRatio = 333 / 354.f;
    self.cellWidth = ScreenWidth/2 - 30/2;
    self.cellHeight = self.cellWidth / cellWidthHeightRatio;
    self.collectionView.hidden = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*)games{
    if (!_games) {
        _games = [NSMutableArray array];
    }
    return _games;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.cellWidth, self.cellHeight);
        layout.sectionInset = UIEdgeInsetsMake(10,10, 10, 10);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 100) collectionViewLayout:layout];

        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.hidden = NO;
        _collectionView.backgroundColor = [UIColor HEX:0xfbfbfb];
        [_collectionView registerClass:GameCollectionViewCell.class forCellWithReuseIdentifier:@"gameTableViewCell"];
        [_collectionView registerClass:CollectionHeadView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionViewTitleCell"];
        
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}


-(void)loadData
{
    NSString *requestAction = nil;
    if (self.gameListType == Game_Action_Played) {
        requestAction = GAME_ACTION_TYPE_PLAYED;
    }else if(self.gameListType == Game_Action_Liked){
        requestAction = GAME_ACTION_TYPE_LIKED;
    }
    [[[DifferNetwork shareInstance] getMineCollections:requestAction position:@"0"] subscribeNext:^(id responseObj) {
        NSLog(@"request finish --- ");
        
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSArray *dataArr = responseDict[@"data"];
        if(dataArr.count > 0 ){
            for (NSDictionary *dic in dataArr) {
                GameListGroup *gameGroup = [GameListGroup mj_objectWithKeyValues:dic];
                gameGroup.game.game_id = gameGroup.game.uid;
                self.isRecommand = NO;
                [self.games addObject:gameGroup];
            }
            [self.collectionView reloadData];
        }else{
            [self loadRecomandData];
        }
    } error:^(NSError *error) {
        NSLog(@"游戏请求失败：%@",error);
    }];
}


-(void)loadRecomandData{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    parameter[@"type"] = @"excellent";
    
    // 探索游戏
    
    [[[DifferNetwork shareInstance] searchGameWithParameter:parameter] subscribeNext:^(id responseObj) {
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *gameModels = responseDict[@"data"];
        NSArray *gameList = gameModels[@"list"];// 探索到的游戏列表
        
        if(gameList.count > 0 ){
            for (NSDictionary *dic in gameList) {
                GameModel *game = [GameModel mj_objectWithKeyValues:dic];
                GameListGroup *gameGroup = [[GameListGroup alloc] init];
                self.isRecommand = YES;
                gameGroup.game = game;
                gameGroup.game.game_id = gameGroup.game.uid;
                [self.games addObject:gameGroup];
            }
            [self.collectionView reloadData];
        }else{
            [self loadRecomandData];
        }
        
    } error:^(NSError *error) {
        NSLog(@"探索游戏失败");
    }];
    
}



#pragma mark:  UICollectionViewDelegate && datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //返回1组
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //table的数量
    return self.games.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GameCollectionViewCell *cell = nil;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gameTableViewCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[GameCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    [cell ag_setShadow];
    cell.backgroundColor = [UIColor whiteColor];
    GameListGroup *mGame  = self.games[indexPath.row];
    cell.gameData = mGame.game;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    GameListGroup *mGame  = self.games[indexPath.row];
    GameDetailViewController *gameDetailVC = [[GameDetailViewController alloc] init];
    gameDetailVC.gameModel = mGame.game;
    [self.navigationController pushViewController:gameDetailVC animated:YES];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionViewTitleCell" forIndexPath:indexPath];
    //设置名称
    view.titleLable.text = @"编辑推荐";

    if(self.games.count <= 0 || self.isRecommand ){
        view.hidden = NO;
    }else{
        [view removeAllSubviews];
    }
    
    return view;
}

#pragma mark: 滑动处理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"scrollview -----------");
}

#pragma mark : UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(self.games.count <= 0 || self.isRecommand){
        //设置headview大小
        float ratio = 375 / 125;
        return CGSizeMake(ScreenWidth, ScreenWidth/ratio + 40);
    }else{
        return CGSizeMake(0, 0);
    }

}



@end
