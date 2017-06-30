//
//  PrivacySettingTVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/4.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "PrivacySettingTVC.h"
#import "UserModel.h"
#import "DiffUtil.h"

#import "DifferSettingItem.h"
#import "DifferSettingGroup.h"

@interface PrivacySettingTVC ()


@end

@implementation PrivacySettingTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DifferSettingItem *item1 = [DifferSettingSwitchItem itemWithIcon:nil title:@"公开我的关注"];
    DifferSettingItem *item2 = [DifferSettingSwitchItem itemWithIcon:nil title:@"公开我的粉丝"];
    
    DifferSettingGroup *group1 = [[DifferSettingGroup alloc] init];
    
    group1.differSettingItems = @[item1,item2];
    
    [self.cellDatas addObject:group1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
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
