//
//  EcmSettingBaseTVC.m
//  ecmSetting
//
//  Created by zengchunjun on 16/12/2.
//  Copyright © 2016年 zengchunjun. All rights reserved.
//

#import "DifferSettingBaseTVC.h"
#import "DifferSettingItem.h"
#import "DifferSettingGroup.h"
#import "DifferSettingCell.h"

@interface DifferSettingBaseTVC ()

@end

@implementation DifferSettingBaseTVC

-(instancetype)init{
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellDatas = [NSMutableArray array];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.cellDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    DifferSettingGroup *group = [self.cellDatas objectAtIndex:section];
    
    return group.differSettingItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DifferSettingCell *cell = [DifferSettingCell cellWithTableView:tableView];
    
    //获取组的模型数据
    DifferSettingGroup *group = self.cellDatas[indexPath.section];
    
    //获取行的模型数据
    DifferSettingItem *item = group.differSettingItems[indexPath.row];
    
    //设置模型 显示数据
    cell.item = item;
    return cell;
}


#pragma mark cell的点中
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //获取组模型
    DifferSettingGroup *group = self.cellDatas[indexPath.section];
    
    //获取行的模型
    DifferSettingItem *item = group.differSettingItems[indexPath.row];
    
    //要么有其他的操作，要么推到下一个控制器
    if (item.operation) {
        
        item.operation();
    }else if(item.vcClass){
        
        id vc = [[item.vcClass alloc] init];
        
        [vc setTitle:item.title];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark 头部标题
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //获取组模型
    DifferSettingGroup *group = self.cellDatas[section];
    return group.headerTitle;
    
}

#pragma mark 尾部标题
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    //获取组模型
    DifferSettingGroup *group = self.cellDatas[section];
    return group.footerTitle;
    
}


// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}


@end
