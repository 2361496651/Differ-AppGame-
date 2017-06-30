//
//  ProfileFansVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/5.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ProfileFansVC.h"
#import "AttentionModel.h"
#import "UITableView+EmptyData.h"
#import "FansCell.h"

#import "ProfileViewController.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "DifferNetwork.h"
#import <MJExtension.h>
#import "UserModel.h"



@interface ProfileFansVC ()<UITableViewDelegate,UITableViewDataSource,fansCellDelegate>

//@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UserModel *user;

@property (nonatomic,strong)NSMutableArray<AttentionModel *> *fans;
@end

@implementation ProfileFansVC

#pragma makr -懒加载属性

- (NSMutableArray *)fans
{
    if (_fans == nil) {
        _fans = [ NSMutableArray array];
    }
    return _fans;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadFansData];// 请求粉丝列表
    [self loadUserInfomation];
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
        
        [self.tableView reloadData];

    } error:^(NSError *error) {
        NSLog(@"获取用户信息失败");
    }];
}

- (void)loadFansData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    DifferAccount *model = [DifferAccountTool account];
    dict[@"access_token"] = model.access_token;
    
    if (!self.isMyself) {// 进入别人的个人中心
        //        dict[@"user_id"] = self.account.uid;
        dict[@"user_id"] = self.userId;
    }
    // 获取粉丝列表
    NSString *fansUrl = @"/api/user/follower";
    [[[DifferNetwork shareInstance] getUserPropertyListWithURL:fansUrl Paramet:dict] subscribeNext:^(id responseObj) {
        
        [self.fans removeAllObjects];
        
        NSDictionary *result = (NSDictionary *)responseObj;
        NSArray *datas = result[@"data"];
        
        for (NSDictionary *modelDict in datas) {
            AttentionModel *attention = [AttentionModel mj_objectWithKeyValues:modelDict];
            [self.fans addObject:attention];
            
        }
        [self.tableView reloadData];

    } error:^(NSError *error) {
        NSLog(@"请求用户粉丝列表失败");

    }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isMyself && self.user.public_follower == 0) {
        [tableView tableViewDisplayWitMsg:@"主人设置了隐私权限" ifNecessaryForRowCount:0];
        return 0;
    }
    
    [tableView tableViewDisplayWitMsg:@"暂时没有粉丝\n\n\n\n\n\n" ifNecessaryForRowCount:self.fans.count];
    return self.fans.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionModel *fan = self.fans[indexPath.row];
    return fan.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FansCell *cell = [FansCell cellWithTableView:tableView];
    cell.fans = self.fans[indexPath.row];
    cell.delegate = self;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProfileViewController *profileTVC = [[ProfileViewController alloc] init];
    profileTVC.userId = self.fans[indexPath.row].uid;
    [self.navigationController pushViewController:profileTVC animated:YES];
    
//    ZJProfileViewController *vc = [[ZJProfileViewController alloc]init];
//    vc.userId = self.fans[indexPath.row].uid;
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark:fansCellDelegate粉丝cell的代理方法
- (void)fansCellClickIconImage:(FansCell *)fansCell attentionModel:(AttentionModel *)fans
{
    ProfileViewController *profileTVC = [[ProfileViewController alloc] init];

    profileTVC.userId = fans.uid;
    [self.navigationController pushViewController:profileTVC animated:YES];
//    ZJProfileViewController *vc = [[ZJProfileViewController alloc]init];
//    vc.userId = fans.uid;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}

@end
