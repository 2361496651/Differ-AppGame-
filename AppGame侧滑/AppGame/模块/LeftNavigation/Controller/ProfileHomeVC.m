//
//  ProfileHomeVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/5.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ProfileHomeVC.h"

@interface ProfileHomeVC ()

@end

@implementation ProfileHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"(￣▽￣\") \n 即将上线，敬请期待\n\n\n\n\n\n\n\n\n\n";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
//    label.center = CGPointMake(self.view.center.x, self.view.center.y - 100);
    [self.view addSubview:label];
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
