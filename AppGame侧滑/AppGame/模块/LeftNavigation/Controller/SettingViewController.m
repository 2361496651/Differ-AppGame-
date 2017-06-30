//
//  SettingViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/20.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "SettingViewController.h"
#import "DiffUtil.h"
#import "HMDrawerViewController.h"
#import "LoginViewController.h"
#import "ShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "DiffUtil.h"
#import "DifferAccountTool.h"

@interface SettingViewController ()<ShareViewDelegate>

/**
 *  开关
 */
@property(nonatomic,strong)UISwitch *mSwitch;

@property (nonatomic,strong)UIView *centerView;

@property (nonatomic,strong)UIButton *bgBtn;
@property (nonatomic,strong)ShareView *shareView;

@end

@implementation SettingViewController

#pragma mark:懒加载

-(UISwitch *)mSwitch{
    if (!_mSwitch) {
        _mSwitch = [[UISwitch alloc] init];
        _mSwitch.on = YES;
        //监听事件
        [_mSwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    return _mSwitch;
}

// 退出登录
- (UIView *)centerView
{
    if (_centerView == nil) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        
        UIButton *center = [[UIButton alloc] init];
        center.frame = CGRectMake(30, 28, self.view.frame.size.width - 60, 44);
        center.backgroundColor = [UIColor colorWithRed:21/255.0 green:177/255.0 blue:184/255.0 alpha:1/1.0];
        [center setTitle:@"退出登录" forState:UIControlStateNormal];
        [center addTarget:self action:@selector(loginOut:) forControlEvents:UIControlEventTouchUpInside];
        
        [bgView addSubview:center];
        _centerView = bgView;
    }
    return _centerView;
}

//分享背景蒙版
- (UIButton *)bgBtn
{
    if (_bgBtn == nil) {
        _bgBtn = [[UIButton alloc] initWithFrame:self.view.bounds];
        _bgBtn.backgroundColor = [UIColor lightGrayColor];
        _bgBtn.alpha = 0.01;
        [_bgBtn addTarget:self action:@selector(removeBgBtnView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}


// 分享
- (ShareView *)shareView
{
    if (_shareView == nil) {
        _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 240)];
        _shareView.delegate = self;
    }
    return _shareView;
}


-(void)valueChange:(UISwitch *)mSwitchs{
    
    BOOL value = mSwitchs.isOn;
    
    // 偏好设置中记录推送信息
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:@"remoteNotification"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark:退出登录
- (void)loginOut:(UIButton *)btn
{

    [DiffUtil showTwoAlertControllerWithTitle:@"" message:@"确定退出当前登录账号？" presenViewController:self callBack:^(ClickResult result) {
        
        if (result == clickResultYes) {
            //确定退出
            [DifferAccountTool deleteAccount];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
            
            [[HMDrawerViewController sharedDrawer]backToMainVc];
            
        }
    }];
}

#pragma mark:系统方法

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source & Delegate 数据源及代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"推送通知回复/贴标签";
        cell.accessoryView = self.mSwitch;
        
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"邀请朋友一起来";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if (indexPath.row == 2){
        cell.textLabel.text = [@"当前版本:" stringByAppendingString:[DiffUtil getCurrentVersion]];
        cell.detailTextLabel.text = @"已是最新版本";
        
    }else if (indexPath.row == 3){
        
        [cell.contentView addSubview:self.centerView];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.centerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {// 邀请朋友一起玩
        
        [self displayShareView];
    }
    
}

#pragma mark:展示分享面板
- (void)displayShareView
{
    [self.view addSubview:self.bgBtn];
    [self.view addSubview:self.shareView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMakeTranslation(0, -self.shareView.bounds.size.height);
        self.bgBtn.alpha = 0.6;
    }];
}

#pragma mark:滑动界面移除分享面板
- (void)removeBgBtnView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformIdentity;
        self.bgBtn.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self.shareView removeFromSuperview];
        [self.bgBtn removeFromSuperview];
    }];
}

#pragma mark:ShareViewDelegate 分享代理
/*UMSocialPlatformType_Sina               = 0, //新浪
 UMSocialPlatformType_WechatSession      = 1, //微信聊天
 UMSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
 UMSocialPlatformType_WechatFavorite     = 3,//微信收藏
 UMSocialPlatformType_QQ                 = 4,//QQ聊天页面
 UMSocialPlatformType_Qzone              = 5,//qq空间*/
- (void)shareViewClickWeixin:(ShareView *)shareView
{
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatSession];
}
- (void)shareViewClickWeixinCircle:(ShareView *)shareView
{
    [self shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine];
}
- (void)shareViewClickWeibo:(ShareView *)shareView
{
    [self shareWebPageToPlatformType:UMSocialPlatformType_Sina];
}
- (void)shareViewClickQQ:(ShareView *)shareView
{
    [self shareWebPageToPlatformType:UMSocialPlatformType_QQ];
}
- (void)shareViewClickQQCircle:(ShareView *)shareView
{
    [self shareWebPageToPlatformType:UMSocialPlatformType_Qzone];
}
- (void)shareViewClickCopyURL:(ShareView *)shareView
{
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string=@"http://www.jianshu.com/u/037e3257fa3b";
    
    [self removeBgBtnView];
    [DiffUtil showInCenterWithTitle:@"复制链接成功" backgroundColor:nil textColor:nil];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用differ" descr:@"differ欢迎你使用!" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = @"http://www.jianshu.com/u/037e3257fa3b";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"分享失败：%@",error);
        }else{
            NSLog(@"分享成功");
            [self removeBgBtnView];
            [DiffUtil showInCenterWithTitle:@"分享成功" backgroundColor:nil textColor:nil];
        }
        
    }];
}

@end
