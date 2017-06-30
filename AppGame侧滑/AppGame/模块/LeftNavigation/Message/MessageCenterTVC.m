//
//  MessageTVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/12.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "MessageCenterTVC.h"
#import "MessageDifferCell.h"
#import "MessageReplyCell.h"
#import "MessageSystemTVC.h"

@interface MessageCenterTVC ()

@end

@implementation MessageCenterTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        MessageDifferCell *cell = [MessageDifferCell cellWithTableView:tableView];
        return cell;
        
    }else if (indexPath.row == 1){
        
        MessageDifferCell *cell = [MessageDifferCell cellWithTableView:tableView];
        return cell;
    }
    
    
    MessageReplyCell *cell = [MessageReplyCell cellWithTableView:tableView];
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageSystemTVC *systemTVC = [[MessageSystemTVC alloc]init];
    
    if (indexPath.row == 0) {//系统通知
        systemTVC.title = @"系统通知";
        
    }else if (indexPath.row == 1){// 官方通知
        systemTVC.title = @"官方通知";
        
    }else{
        return;
    }
    
    [self.navigationController pushViewController:systemTVC animated:YES];
}






@end
