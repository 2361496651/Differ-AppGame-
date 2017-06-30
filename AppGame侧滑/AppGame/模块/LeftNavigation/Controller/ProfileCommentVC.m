//
//  ProfileCommentVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/5.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ProfileCommentVC.h"

#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "DifferNetwork.h"
#import "AppraiseModel.h"
#import <MJExtension.h>
#import "CommentCell.h"
#import "UITableView+EmptyData.h"
#import "UserModel.h"

@interface ProfileCommentVC ()<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong)UITableView *tableView;
// 评论 用appraiseModel
@property (nonatomic,strong)NSMutableArray<AppraiseModel *> *appraises;


@end

@implementation ProfileCommentVC
//CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64)
//- (UITableView *)tableView
//{
//    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStyleGrouped];
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//    }
//    return _tableView;
//}

#pragma makr -懒加载属性
- (NSMutableArray *)appraises
{
    if (_appraises == nil) {
        _appraises = [NSMutableArray array];
    }
    return _appraises;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadCommentData];// 请求评论数据
}

- (void)loadCommentData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    DifferAccount *model = [DifferAccountTool account];
    dict[@"access_token"] = model.access_token;
    
    if (!self.isMyself) {// 进入别人的个人中心
        //        dict[@"user_id"] = self.account.uid;
//        dict[@"user_id"] = self.userId;
        dict[@"user_id"] = self.userId;
    }
    // 获取评论列表
    NSString *appraiseUrl = @"/api/user/appraises";
    
    [[[DifferNetwork shareInstance] getUserPropertyListWithURL:appraiseUrl Paramet:dict] subscribeNext:^(id responseObj) {
        
        [self.appraises removeAllObjects];
        
        NSDictionary *result = (NSDictionary *)responseObj;
        NSArray *datas = result[@"data"];
        
        for (NSDictionary *modelDict in datas) {
            AppraiseModel *appraise = [AppraiseModel mj_objectWithKeyValues:modelDict];
            [self.appraises addObject:appraise];
            
            //            for (int i = 0; i <= 10; i++) {
            //                [self.appraises addObject:appraise];
            //            }
        }
        [self.tableView reloadData];
        
    } error:^(NSError *error) {
        NSLog(@"请求用户评价列表失败");
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView tableViewDisplayWitMsg:@"暂时没有评论\n\n\n\n\n\n" ifNecessaryForRowCount:self.appraises.count];
    return self.appraises.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppraiseModel *appraise = self.appraises[indexPath.row];
    return appraise.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [CommentCell cellWithTableView:tableView];
    cell.appraise = self.appraises[indexPath.row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
