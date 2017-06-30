//
//  ProfileAttentionVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/5.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ProfileAttentionVC.h"
#import "AttentionModel.h"
#import "AttentionCell.h"
#import "UITableView+EmptyData.h"
#import "ProfileViewController.h"
#import "DifferNetwork.h"
#import "DifferAccountTool.h"
#import "DifferAccount.h"

#import "UserModel.h"


@interface ProfileAttentionVC ()<UITableViewDelegate,UITableViewDataSource,AttentionCellDelegate>

//@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UserModel *user;


// 关注和粉丝 都用attentionModel
@property (nonatomic,strong)NSMutableArray<AttentionModel *> *attentions;

@end

@implementation ProfileAttentionVC

#pragma makr -懒加载属性

- (NSMutableArray *)attentions
{
    if (_attentions == nil) {
        _attentions = [NSMutableArray array];
    }
    return _attentions;
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


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    NSLog(@"%lf",scrollView.contentOffset.y);
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadAttentionData];// 请求关注数据
    
    [self loadUserInfomation];//请求用户信息，判断是否公开关注与粉丝
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    [self.tableView layoutIfNeeded];
    
}

- (void)loadAttentionData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    DifferAccount *model = [DifferAccountTool account];
    dict[@"access_token"] = model.access_token;
    
    if (!self.isMyself) {// 进入别人的个人中心
        //        dict[@"user_id"] = self.account.uid;
//        dict[@"user_id"] = self.userId;
        dict[@"user_id"] = self.userId;
    }
    
    // 获取关注列表
    NSString *attentonUrl = @"/api/user/following";
    [[[DifferNetwork shareInstance] getUserPropertyListWithURL:attentonUrl Paramet:dict] subscribeNext:^(id responseObj) {
        
        [self.attentions removeAllObjects];
        
        NSDictionary *result = (NSDictionary *)responseObj;
        NSArray *datas = result[@"data"];
        
        for (NSDictionary *modelDict in datas) {
            
            AttentionModel *attention = [AttentionModel mj_objectWithKeyValues:modelDict];
            [self.attentions addObject:attention];
        }
 
        [self.tableView reloadData];

    } error:^(NSError *error) {
        NSLog(@"请求用户关注列表失败");
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //            NSInteger public_follower; //是否公开粉丝；0否，1是
    //            NSInteger public_following;//是否公开关注；0否，1是
    if (!self.isMyself && self.user.public_following == 0) {
        [tableView tableViewDisplayWitMsg:@"主人设置了隐私权限" ifNecessaryForRowCount:0];
        return 0;
    }
    [tableView tableViewDisplayWitMsg:@"暂时还没有关注任何人\n\n\n\n\n\n" ifNecessaryForRowCount:self.attentions.count];
    return self.attentions.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionModel *attention = self.attentions[indexPath.row];
    return attention.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttentionCell *cell = [AttentionCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.attention = self.attentions[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProfileViewController *profileTVC = [[ProfileViewController alloc] init];
    profileTVC.userId = self.attentions[indexPath.row].uid;;
    [self.navigationController pushViewController:profileTVC animated:YES];
//    ZJProfileViewController *vc = [[ZJProfileViewController alloc]init];
//    vc.userId = self.attentions[indexPath.row].uid;
//    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark AttentionCellDelegate 关注cell的代理方法
- (void)attentionCellClickGameName:(AttentionCell *)attentionCell attentionModel:(AttentionModel *)attention
{
    NSLog(@"%s %d",__func__,__LINE__);
}

- (void)attentionCellClickIconImage:(AttentionCell *)attentionCell attentionModel:(AttentionModel *)attention
{
    NSLog(@"%s %d",__func__,__LINE__);
    ProfileViewController *profileTVC = [[ProfileViewController alloc] init];
    // 关注模型 转 用户模型
    //    profileTVC.account = [TranslateModel translationByAttentionModel:attention];
    profileTVC.userId = attention.uid;
    [self.navigationController pushViewController:profileTVC animated:YES];
    
//    ZJProfileViewController *vc = [[ZJProfileViewController alloc]init];
//    vc.userId = attention.uid;
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
