//
//  AboutTAVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/6/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AboutTAVC.h"
#import "AboutTAHeader.h"
#import "DifferAccount.h"
#import "DifferNetwork.h"

#import "GuestModel.h"
#import <MJExtension.h>
#import "AboutMessageCell.h"

#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "UserModel.h"
#import "RankModel.h"
#import "AchievesModel.h"
#import "DiffUtil.h"

#import <UIImageView+WebCache.h>
#import "UITableView+EmptyData.h"

@interface AboutTAVC ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)AboutTAHeader *header;
@property (nonatomic,strong)UIView *footerView;

//留言
@property (nonatomic,strong)NSMutableArray<GuestModel *> *guests;

@property (nonatomic,strong)UserModel *user;

@end

const CGFloat headerFooterHeights = 44;

@implementation AboutTAVC

- (NSMutableArray<GuestModel *> *)guests
{
    if (_guests == nil) {
        _guests = [NSMutableArray array];
    }
    return _guests;
}

//- (UITableView *)tableView
//{
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
//        _tableView.backgroundColor = [UIColor whiteColor];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}

- (AboutTAHeader *)header
{
    if (_header == nil) {
        _header = [[AboutTAHeader alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 260)];
    }
    return _header;
}

- (UIView *)footerView
{
    if (_footerView == nil) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, headerFooterHeights)];
    }
    
    [_footerView removeAllSubviews];
    
    NSString *title = nil;
    if (self.guests.count == 0) {
        title = @"空虚寂寞冷,谁来温暖TA";
    }else{
        title = @"查看全部";
    }
    
    UIButton *moreGuest = [[UIButton alloc]initWithFrame:_footerView.bounds];
    [moreGuest setTitle:title forState:UIControlStateNormal];
    moreGuest.titleLabel.font = [DiffUtil getDifferFont:16];
    moreGuest.titleLabel.alpha = 0.6;
    [moreGuest setTitleColor:[DiffUtil colorWithHexString:@"#59C5CA"] forState:UIControlStateNormal];
    [moreGuest addTarget:self action:@selector(moreGuestClick) forControlEvents:UIControlEventTouchUpInside];
    [_footerView addSubview:moreGuest];
    
    return _footerView;
}

//全部留言
- (void)moreGuestClick
{
    if (self.guests.count == 0) return;
    
    NSLog(@"%s %d",__func__,__LINE__);
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.header;
    
    
    [self loadUserGuest];// 请求留言列表
    [self loadUserInfomation];//请求用户信息
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)loadUserInfomation
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
        
        self.user = [UserModel mj_objectWithKeyValues:responseObj[@"data"]];
        self.header.user = self.user;
        
    } error:^(NSError *error) {
        NSLog(@"获取用户信息失败");
    }];
}

// 获取用户留言列表
- (void)loadUserGuest
{
    NSString *userid = self.userId;
    if (self.isMyself) {
        userid = nil;
    }
//    [[DifferNetwork shareInstance] getUserGuestUserId:userid success:^(id responseObj) {
//        NSLog(@"%@",responseObj);
//        NSDictionary *responseDict = (NSDictionary *)responseObj;
//        NSArray *dataArray = responseDict[@"data"];
//        
//        for (NSDictionary *dataDict in dataArray) {
//            GuestModel *guest = [GuestModel mj_objectWithKeyValues:dataDict];
//            [self.guests addObject:guest];
//        }
//        
//        [self setupTableData];
//        
//    } failure:^(NSError *error) {
//        NSLog(@"获取用户留言列表失败：%@",error);
//    }];
    
    [[[DifferNetwork shareInstance] getUserGuestUserId:userid] subscribeNext:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSArray *dataArray = responseDict[@"data"];
        
        for (NSDictionary *dataDict in dataArray) {
            GuestModel *guest = [GuestModel mj_objectWithKeyValues:dataDict];
            [self.guests addObject:guest];
        }
        
        [self setupTableData];
    } error:^(NSError *error) {
        NSLog(@"获取用户留言列表失败：%@",error);
    }];
}


- (void)setupTableData
{
    self.header.guestCount = self.guests.count;
    
    [self.tableView reloadData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return [NSString stringWithFormat:@"%ld条留言",self.guests.count];
//    }
//    return nil;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = self.guests.count > 3 ? 3 : self.guests.count;
    return rows;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return headerFooterHeights;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return self.footerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GuestModel *guest = self.guests[indexPath.row];
    return guest.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AboutMessageCell *cell = [AboutMessageCell cellWithTableView:tableView];
    cell.guest = self.guests[indexPath.row];
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
