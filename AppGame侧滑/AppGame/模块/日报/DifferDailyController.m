//
//  DifferDailyController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/27.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DifferDailyController.h"
#import "DiffUtil.h"
#import "DailyCell.h"
#import "DailyHeaderView.h"
#import "DifferNetwork.h"

#import "DailyGroup.h"
#import "DailyModel.h"
#import "ArticleModel.h"

#import <MJExtension.h>
#import <MJRefresh.h>

#import "DiffUtil.h"
#import "DailyDetailViewController.h"
#import "CustomTitleView.h"
#import "DifferTopicViewController.h"

@interface DifferDailyController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *dailys;

@property (nonatomic,assign)NSInteger position;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)CustomTitleView *titleView;

@end

@implementation DifferDailyController

- (CustomTitleView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[CustomTitleView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
        
    }
    return _titleView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [DiffUtil getDifferColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

// 数据源数组
- (NSMutableArray *)dailys
{
    if (_dailys == nil) {
        _dailys = [NSMutableArray array];
    }
    return _dailys;
}

#pragma mark:系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.titleView = self.titleView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    // 请求日报数据
    self.position = 0;
    [self loadData:YES];
    
    // 上拉刷新 下拉加载更多 "date":"2017年04月27日",
    [self addRefreshAndLoadMoreData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];

    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 不透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark : 添加上拉刷新，下拉加载更多
- (void)addRefreshAndLoadMoreData
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"松开加载" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    self.tableView.mj_header = header;
//    [self.tableView.mj_header beginRefreshing];
    
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer = footer;
    
}

#pragma mark:下拉刷新与上拉加载更多
- (void)loadNewData
{
    [self loadData:YES];
}
- (void)loadMoreData
{
    [self loadData:NO];
}


#pragma mark:请求differ日报列表数据
- (void)loadData:(BOOL)isNewData
{
    NSString *positionStr = nil;
    if (isNewData) { // 请求最新数据
        positionStr = @"0";
    }else{
        self.position += 1;
        positionStr = [NSString stringWithFormat:@"%ld",self.position];
    }
    
    NSDictionary *dict = @{@"position":positionStr};
    
    [[[DifferNetwork shareInstance] getDailyListWithParameter:dict] subscribeNext:^(id responseObj) {
        
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        DailyGroup *dailyGroup = [DailyGroup mj_objectWithKeyValues:responseDict[@"data"]]; // 请求的数据，只会有一条
        
        if (dailyGroup.list.count > 0) { // 有获取到文章
            
            if (isNewData) { // 下拉刷新
                
                DailyGroup *firstDaily = self.dailys.count > 0 ? self.dailys[0] : nil;
                
                NSString *date = firstDaily.date;
                // 通过判断请求到的数据日期 是否 与数据源中的第一条数据的日期是否相同，相同则移除再插入
                if ([date isEqualToString:[DiffUtil dateStrWithYMD]]) {
                    [self.dailys removeObject:firstDaily];
                }
                
                [self.dailys insertObject:dailyGroup atIndex:0];
                
            }else{ // 上拉加载
                [self.dailys addObject:dailyGroup];
            }
            
        }
        //        else{ // 没有获取到文章，就去获取历史消息
        //            [self loadMoreData];
        //        }
        if (self.dailys.count < 3 || dailyGroup.list.count == 0) { //避免出现第一次进来只有一篇文章的情况
            [self loadMoreData];
        }
        
        [self.tableView reloadData];
        [self scrollChangedTitle];
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

    } error:^(NSError *error) {
        NSLog(@"请求日报列表数据失败：%@",error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark:滚动改变标题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self scrollChangedTitle];
}

- (void)scrollChangedTitle
{
    NSArray<NSIndexPath *> *array = [self.tableView indexPathsForVisibleRows];
    
    if (array.count <= 0) {
        return;
    }
    NSIndexPath *firstIndexPath = array.firstObject;
    
    DailyGroup *model = self.dailys[firstIndexPath.section];
    
    self.titleView.title = model.date;
    self.titleView.subTitle = [NSString stringWithFormat:@"共%@篇",model.count];
    
}


#pragma mark:tableview 数据源及代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dailys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DailyGroup *model = self.dailys[section];
    return model.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001;
    }
    
    return 80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) return nil;
    
    static NSString *viewIdentfier = @"headView";
    
    DailyHeaderView *sectionHeadView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:viewIdentfier];
    sectionHeadView.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if(!sectionHeadView){
        
        sectionHeadView = [[DailyHeaderView alloc] initWithReuseIdentifier:viewIdentfier];
    }
    DailyGroup *model = self.dailys[section];
    sectionHeadView.timeTitle = model.date;
    sectionHeadView.airticlCount = [NSString stringWithFormat:@"共%@篇",model.count];
    
//    if (section == 0) {
//        return nil;
////        sectionHeadView.contentView.backgroundColor = [DiffUtil getDifferColor];
//    }else{
//        sectionHeadView.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    }
    
    return sectionHeadView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DailyGroup *model = self.dailys[indexPath.section];
    NSArray *dailyModels = model.list;
    DailyModel *dailyModel = dailyModels[indexPath.row];
    
    return dailyModel.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DailyCell *cell = [DailyCell cellWithTableView:tableView];
    
    DailyGroup *model = self.dailys[indexPath.section];
    NSArray *dailyModels = model.list;
    cell.dailyModel = dailyModels[indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.isHiddenBgView = NO;
    }else{
        cell.isHiddenBgView = YES;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DailyGroup *model = self.dailys[indexPath.section];
    NSArray *dailyModels = model.list;
    DailyModel *daily = dailyModels[indexPath.row];
    
    if ([daily.target isEqualToString:@"article"]) {//文章
        
        DailyDetailViewController *dailDetail = [[DailyDetailViewController alloc] initWithNibName:@"DailyDetailViewController" bundle:nil];
        dailDetail.daily = daily;
        [self.navigationController pushViewController:dailDetail animated:YES];
        
    }else if ([daily.target isEqualToString:@"topic"]){ // 主题
        
        DifferTopicViewController *topic = [[DifferTopicViewController alloc]init];
        topic.daily = daily;
        [self.navigationController pushViewController:topic animated:YES];
        
    }
    
    
    
    
}


// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}


@end
