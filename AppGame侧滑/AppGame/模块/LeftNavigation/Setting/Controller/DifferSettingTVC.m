//
//  DifferSettingTVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/4.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DifferSettingTVC.h"
#import "DifferSettingItem.h"
#import "DifferSettingGroup.h"

#import "DiffUtil.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "HMDrawerViewController.h"
#import "AppDelegate.h"

#import "DifferNetwork.h"

@interface DifferSettingTVC ()

@property (nonatomic,strong)id abserve;

//保存是否有新版本
@property (nonatomic,copy)NSString *haveNewVersion;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger lastType;

@end

@implementation DifferSettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    [self setupSourceData];// 设置数据源
    
//    [self checkVersion];//查询版本
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkNotification) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)checkNotification
{
    NSInteger type = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    
    if (self.lastType != type) {
        [self setupSourceData];
    }
}



- (void)checkVersion
{
    [[[DifferNetwork shareInstance] getOfDiffer:@"/api/version?plateform=ios&provider_code=Differ" params:nil] subscribeNext:^(id responseObj) {
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *dataDict = responseDict[@"data"];
        NSDictionary *attributesDict = dataDict[@"attributes"];
        NSString *version = attributesDict[@"version"];
        
        self.haveNewVersion = version;
        
        [self setupSourceData];

    } error:^(NSError *error) {
        NSLog(@"获取版本信息失败");
    }];
}


- (void)setupSourceData
{
    [self.cellDatas removeAllObjects];
    
    NSInteger type = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
    self.lastType = type;
    NSString *subTitle= type ? @"已打开" : @"已关闭 去打开";
    
    DifferSettingItem *item1 = nil;
    if (type) {
        item1 = [DifferSettingItem itemWithIcon:nil title:@"接受新消息通知"];
    }else{
        item1 = [DifferSettingArrowItem itemWithIcon:nil title:@"接受新消息通知"];
    }
    item1.subTitle = subTitle;
    item1.operation = ^{
        
        if (!type) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    };
    
    DifferSettingGroup *group1 = [[DifferSettingGroup alloc] init];
    group1.footerTitle = @"请在iPhone的\"设置\"-\"通知\"-\"differ\"中进行设置";
    group1.differSettingItems = @[item1];
    [self.cellDatas addObject:group1];
    
    
    
    NSString *currentVersion = [DiffUtil getCurrentVersion];
    
    DifferSettingItem *item2 = [DifferSettingItem itemWithIcon:nil title:[NSString stringWithFormat:@"当前版本:%@",currentVersion]];
    if (self.haveNewVersion && [currentVersion isEqualToString:self.haveNewVersion]) {
        item2.subTitle = @"已经是最新版本";
    }else if (self.haveNewVersion && ![currentVersion isEqualToString:self.haveNewVersion]){
        
        // 第一个版本无法跳转，
//        item2.subTitle = @"有新版本，前往升级";
        item2.operation = ^{
            // 升级操作，跳转到App Store
            
        };
    }
    
    
    
    DifferSettingGroup *group2 = [[DifferSettingGroup alloc] init];
    group2.differSettingItems = @[item2];
//    [self.cellDatas addObject:group2];
    
    __weak typeof(self) weakSelf = self; 
    DifferSettingItem *item3 = [DifferSettingCenterItem itemWithIcon:nil title:@"退出登录"];
    item3.operation = ^{
        
        [DiffUtil showTwoAlertControllerWithTitle:@"" message:@"确定退出当前登录账号？" presenViewController:weakSelf callBack:^(ClickResult result) {
            
            if (result == clickResultYes) {
                //确定退出
                [DifferAccountTool deleteAccount];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
                
                [[HMDrawerViewController sharedDrawer] backToMainVc];
                
            }
        }];
        
    };
    DifferSettingGroup *group3 = [[DifferSettingGroup alloc] init];
    group3.differSettingItems = @[item3];
    
    DifferAccount *account = [DifferAccountTool account];
    if (account)
    {
        [self.cellDatas addObject:group3];
    }
    
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 25;
    }
    
    return [super tableView:tableView heightForFooterInSection:section];
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
