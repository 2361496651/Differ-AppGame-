//
//  DynamicsVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DynamicsVC.h"

#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "DifferNetwork.h"
#import <MJExtension.h>
#import "UserModel.h"
#import "UITableView+EmptyData.h"
#import "DynamicModel.h"
#import "DiffUtil.h"
#import <MJExtension.h>

#import "DynamicsCell.h"
#import "PicCollectionView.h"
#import "PhotoBrowserVC.h"
#import "PhotoBrowserAnimation.h"

#import "ZCJImagesViewController.h"
#import "ZCJSelectImageViewController.h"

@interface DynamicsVC ()<UITableViewDelegate,UITableViewDataSource,ZCJSelectImageViewControllerDelegate>

//@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UserModel *user;

@property (nonatomic,strong)NSMutableArray<DynamicModel *> *dynamics;

//动画代理
@property (nonatomic,strong)PhotoBrowserAnimation *photoBrowserAnimator;

@end

@implementation DynamicsVC

- (NSString *)userId
{
    if (_userId == nil) {
        UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
        return account.uid;
    }
    return _userId;
}

- (BOOL)isMyself
{
    UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    if ([self.userId isEqualToString:account.uid]) {
        return YES;
    }
    return NO;
}

- (PhotoBrowserAnimation *)photoBrowserAnimator
{
    if (_photoBrowserAnimator == nil) {
        _photoBrowserAnimator = [[PhotoBrowserAnimation alloc] init];
    }
    return _photoBrowserAnimator;
}

- (NSMutableArray<DynamicModel *> *)dynamics
{
    if (_dynamics == nil) {
        _dynamics = [NSMutableArray array];
    }
    return _dynamics;
}


//- (UITableView *)tableView
//{
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}

- (instancetype)init
{
    if (self = [super initWithStyle:UITableViewStylePlain]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //    [self.view addSubview:self.tableView];
    [self loadDynamics];
    
    
    //监听图片点击放大的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPhotoBroser:) name:ShowPhotoBrowserNote object:nil];
    
    self.navigationItem.rightBarButtonItem = [DiffUtil initButtonItemWithTitle:@"发布" action:@selector(sendDynamic) delegate:self];
}

- (void)sendDynamic
{
    ZCJImagesViewController *imagesCtr = [[ZCJImagesViewController alloc] init];
    imagesCtr.delegate = self;
    UINavigationController *navigation = [DiffUtil initNavigationWithRootViewController:imagesCtr];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)selectImageViewController:(id)picker didFinishPickingImageWithInfo:(NSArray<UIImage *> *)info
{
    NSLog(@"%@",info);
}

#pragma mark:请求玩家动态
- (void)loadDynamics
{
    [[[DifferNetwork shareInstance] getGamerDynamics:self.userId] subscribeNext:^(id responseObj) {
        
        NSLog(@"获取玩家动态成功：%@",responseObj);
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *dataDict = responseDict[@"data"];
        NSArray *listArray = dataDict[@"list"];
        for (NSDictionary *dynamicDict in listArray) {
            DynamicModel *dynamic = [DynamicModel mj_objectWithKeyValues:dynamicDict];
            [self.dynamics addObject:dynamic];
        }
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        NSLog(@"获取玩家动态失败");
    }];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0.01;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    [tableView tableViewDisplayWitMsg:@"暂时没有动态\n\n\n\n\n\n" ifNecessaryForRowCount:self.dynamics.count];
    return self.dynamics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicModel *dynamic = self.dynamics[indexPath.row];
    return dynamic.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicsCell *cell = [DynamicsCell cellWithTableView:tableView];
    cell.dynamic = self.dynamics[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    

}


- (void)showPhotoBroser:(NSNotification *)note
{
    // 点击图片 图片所在的索引，装有URL的数组及所在的collectionView
    NSIndexPath *indexPath = note.userInfo[ShowPhotoBrowserIndexKey];
    NSArray<NSURL *> *picURLs = note.userInfo[ShowPhotoBrowserUrlsKey];
    PicCollectionView *object = (PicCollectionView *)note.object;
    
    PhotoBrowserVC *browserVC = [[PhotoBrowserVC alloc] init];
    browserVC.indexPath = indexPath;
    browserVC.picURLs = picURLs;
    
    browserVC.modalPresentationStyle = UIModalPresentationCustom;//自定义modal样式
    browserVC.transitioningDelegate = self.photoBrowserAnimator;//转场代理
    
    self.photoBrowserAnimator.presentedDelegate = object;
    self.photoBrowserAnimator.indexPath = indexPath;
    self.photoBrowserAnimator.dismissDelegate = browserVC;
    
    [self presentViewController:browserVC animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
