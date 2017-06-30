//
//  PrivacyTableViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/20.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "PrivacyTableViewController.h"
#import "DifferNetwork.h"
#import "UserModel.h"
#import "DiffUtil.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"

@interface PrivacyTableViewController ()

@property (nonatomic,strong)UISwitch *attentonSwitch;
@property (nonatomic,strong)UISwitch *flowerSwitch;

@property (nonatomic,strong)UserModel *accountModel;

@end

@implementation PrivacyTableViewController

#pragma mark:懒加载

- (UserModel *)accountModel
{
    if (_accountModel == nil) {
        _accountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    }
    return _accountModel;
}
// 公开我的关注开关
- (UISwitch *)attentonSwitch
{
    if (_attentonSwitch == nil) {
        _attentonSwitch = [[UISwitch alloc] init];
        _attentonSwitch.on = self.accountModel.public_following == 0 ? NO : YES;
        [_attentonSwitch addTarget:self action:@selector(attentionChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _attentonSwitch;
}

- (void)attentionChanged:(UISwitch *)attentSwitch
{
    self.accountModel.public_following = attentSwitch.isOn ? 1 : 0;
 
    [self saveInfomationPublicFolower];
}
// 公开我的粉丝开关
- (UISwitch *)flowerSwitch
{
    if (_flowerSwitch == nil) {
        _flowerSwitch = [[UISwitch alloc] init];
        _flowerSwitch.on = self.accountModel.public_follower == 0 ? NO : YES;
        [_flowerSwitch addTarget:self action:@selector(flowerChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _flowerSwitch;
}

- (void)flowerChanged:(UISwitch *)flowerSwitch
{
    self.accountModel.public_follower = flowerSwitch.isOn ? 1 : 0;

    [self saveInfomationPublicFolower];
}

#pragma mark:更改用户隐私信息
- (void)saveInfomationPublicFolower
{
//    UserModel *accountModel = self.accountModel;
    NSString *publicFollower = [NSString stringWithFormat:@"%ld",self.accountModel.public_follower];
    NSString *publicFollowering = [NSString stringWithFormat:@"%ld",self.accountModel.public_following];
    
    DifferAccount *account = [DifferAccountTool account];
    
    NSDictionary *dict = @{
                           @"access_token":account.access_token,
                           @"public_follower":publicFollower,
                           @"public_following":publicFollowering,
                           };
    
    [[[DifferNetwork shareInstance] requestChangeUserInformationParamet:dict] subscribeNext:^(id object) {
        [NSKeyedArchiver archiveRootObject:self.accountModel toFile:[DiffUtil getUserPathAtDocument]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
    } error:^(NSError *error) {
        NSLog(@"保存失败：%@",error);
    }];
}

#pragma mark:系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐私设置";
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source 数据源及代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"privacyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"公开我的关注";
        cell.accessoryView = self.attentonSwitch;
        
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"公开我的粉丝";
        cell.accessoryView = self.flowerSwitch;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
