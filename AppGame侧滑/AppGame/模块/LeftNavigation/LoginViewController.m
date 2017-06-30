//
//  LoginViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "LoginViewController.h"
#import "GlobelConst.h"
#import "DiffUtil.h"

#import "AccountNetwork.h"
#import "DifferNetwork.h"

#import <UMSocialCore/UMSocialCore.h>
#import <WXApi.h>


#import "UserModel.h"
#import <MJExtension.h>

#import <SVProgressHUD.h>
#import "DifferAccount.h"
#import "DifferAccountTool.h"

#import "DiffUtil.h"
#import "NSString+AGExtension.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;// 用户头像

@property (weak, nonatomic) IBOutlet UITextField *phoneNumTextField; // 手机号
@property (weak, nonatomic) IBOutlet UITextField *veryCodeTextField; // 验证码
@property (weak, nonatomic) IBOutlet UIButton *veryCodeBtn;//验证码按钮

@property (weak, nonatomic) IBOutlet UIButton *QQLoginBtn;

@property (weak, nonatomic) IBOutlet UIButton *WXLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *WBLoginBtn;


@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger count;

@end

@implementation LoginViewController

+ (instancetype)shareInstance
{
    static LoginViewController *g_login = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];;
    });
    return g_login;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SETVIEWCONTROLLERNOINSETS
    
    self.title = @"登录";
    
    // 设置返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_down_def"] style:UIBarButtonItemStyleDone target:self action:@selector(cancelLogin)];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.veryCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    // 隐藏相应平台
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    
    if (hadInstalledWeixin) {
        self.WXLoginBtn.hidden = NO;
    }else{
        self.WXLoginBtn.hidden = YES;
    }
    
    if (hadInstalledQQ) {
        self.QQLoginBtn.hidden = NO;
    }else{
        self.QQLoginBtn.hidden = YES;
    }
    
    self.phoneNumTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入手机号码" attributes:@{NSForegroundColorAttributeName: [DiffUtil colorWithHexString:@"#69778A"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15]}];
    self.veryCodeTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSForegroundColorAttributeName:[DiffUtil colorWithHexString:@"#69778A"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:15]}];

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark:UITextFieldDelegate相关代理

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

// 取消登录
- (void)cancelLogin
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 获取验证码
- (IBAction)getVerifyCode:(UIButton *)sender {

    if (self.phoneNumTextField.text == nil || [self.phoneNumTextField.text isEqualToString:@""]) {
        
        [DiffUtil showAlertControllerWithTitle:@"获取失败" message:@"请输入您的手机号" presenViewController:self];
        
        return;
    }
    
//    if (![DiffUtil judgePhoneNumber:self.phoneNumTextField.text]) {
//        
//        [DiffUtil showAlertControllerWithTitle:@"获取失败" message:@"请输入正确的手机号" presenViewController:self];
//        return;
//    }
    
    if (![self.phoneNumTextField.text checkPhoneNumInput]) {
        [DiffUtil showAlertControllerWithTitle:@"获取失败" message:@"请输入正确的手机号" presenViewController:self];
        return;
    }
    
    self.veryCodeBtn.enabled = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCountDown) userInfo:nil repeats:YES];
    self.count = 60;
    
    // 去空格处理
    NSString *phoneNum = [self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 获取验证码
    [[AccountNetwork shareInstance] getVertyCodeWithMobile:phoneNum success:^(id responseObj) {
        NSLog(@"获取验证码成功");
    } failure:^(NSError *error, NSUInteger code, NSString *notice) {
        NSLog(@"获取验证码失败:%@",error);
        [SVProgressHUD showErrorWithStatus:notice];
    }];
    
}

// 验证码倒计时
- (void)timeCountDown
{
    self.count --;
    
    NSString *countStr = [NSString stringWithFormat:@"%lds",self.count];
    [self.veryCodeBtn setTitle:countStr forState:UIControlStateNormal];
    
    if (self.count == 0) {
        self.veryCodeBtn.enabled = YES;
        [self.veryCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        
        [self.timer invalidate];
    }
    
}

// 立即登录
- (IBAction)loginClick:(UIButton *)sender {
    
    if (self.phoneNumTextField.text == nil || [self.phoneNumTextField.text isEqualToString:@""]) {
        
        [DiffUtil showAlertControllerWithTitle:@"登录失败" message:@"请输入您的手机号" presenViewController:self];
        
        return;
    }
    
    if (self.veryCodeTextField.text == nil || [self.veryCodeTextField.text isEqualToString:@""]) {
        
        [DiffUtil showAlertControllerWithTitle:@"登录失败" message:@"请输入获取的验证码" presenViewController:self];
        
         return;
    }
    
    // 去空格处理
    NSString *phoneNum = [self.phoneNumTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *veryCode = [self.veryCodeTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [SVProgressHUD showWithStatus:@"正在登录"];
    [[AccountNetwork shareInstance] loginWithMobile:phoneNum captcha:veryCode success:^(id responseObj) {
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        DifferAccount *account = [DifferAccount accountWithDic:responseDict];
        [DifferAccountTool saveAccount:account];
        
        self.phoneNumTextField.text = nil;
        self.veryCodeTextField.text = nil;
        
        // 请求用户数据
        [self requestUserInfomationWithToken:account.access_token expired:account.expires_in];
        
    } failure:^(NSError *error, NSUInteger code, NSString *notice) {
        [SVProgressHUD dismiss];
        NSLog(@"登录失败：%@",error);
        NSString *notices = notice ? notice : @"手机号或验证码错误";
        [DiffUtil showAlertControllerWithTitle:@"登录失败" message:notices presenViewController:self];
    }];
    
    
}

#pragma mark :  QQ，微博，微信登录
- (IBAction)loginWithWeibo:(UIButton *)sender {
    NSLog(@"%s %d",__func__,__LINE__);
    
//    appkey 3055766945  . 3781674297
//    App Secret：90f6d33f3ec1dbe124a5220a19798ab3 . c9dd4a8035bde215729ae0e362e8f7f7
    
    [self loginWithThird:UMSocialPlatformType_Sina];
}


- (IBAction)loginWithWeChat:(UIButton *)sender {
    NSLog(@"%s %d",__func__,__LINE__);
    
//    AppID：wxfa88e143e15b8297
//    App Secret ad93241bec78c98b5ea2a817c33832bc
    [self loginWithThird:UMSocialPlatformType_WechatSession];
    
}

- (IBAction)loginWithQQ:(UIButton *)sender {
    NSLog(@"%s %d",__func__,__LINE__);
//    APP ID  1106109400  .  1106063028
//    APP KEY  tm5oATwBg56AYBJw  .  vMb3Fr1gZrRS4H1H
    [self loginWithThird:UMSocialPlatformType_QQ];
    
    
}

- (void)loginWithThird:(UMSocialPlatformType)platformType
{
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"取消授权"];
        
        if (error) {
            
        } else {
            
            [SVProgressHUD showWithStatus:@"正在登陆"];
            
            UMSocialUserInfoResponse *resp = result;
            
            NSDictionary *dict = nil;
            NSString *providerId = nil;
         
            switch (platformType) {
                case UMSocialPlatformType_QQ:
                    dict = @{
                             @"openid":resp.openid,            //用户标识
                             @"app_id": @"1106063028",           //应用ID
                             @"access_token":resp.accessToken     //访问TOKEN
                             };
                    providerId = @"Qq";
                    break;
                case UMSocialPlatformType_WechatSession:
                    dict = @{
                             @"openid":resp.openid,            //用户标识
                             @"access_token":resp.accessToken //访问TOKEN
                             };
                    providerId = @"Weixin";
                    break;
                case UMSocialPlatformType_Sina:
                    dict = @{
                             @"uid":resp.uid, //应用返回的UID，用户唯一标识
                             @"access_token":resp.accessToken
                             };
                    providerId = @"Weibo";
                default:
                    break;
            }
            
            
            
            NSString *dataJsonStr = [DiffUtil jsonStringWithDict:dict];
            [[AccountNetwork shareInstance] loginWithProvider:providerId baseStr:dataJsonStr success:^(id responseObj) {
                
                NSDictionary *responseDict = (NSDictionary *)responseObj;
                
                DifferAccount *account = [DifferAccount accountWithDic:responseDict];
                
                [DifferAccountTool saveAccount:account];
                
                [self requestUserInfomationWithToken:account.access_token expired:account.expires_in];
                
            } failure:^(NSError *error, NSUInteger code, NSString *notice) {
               
                NSLog(@"%@",error);
                [SVProgressHUD dismiss];
                NSString *noticeStr = notice ? notice : @"获取用户授权失败，请重新授权";
                [DiffUtil showAlertControllerWithTitle:@"授权失败" message:noticeStr presenViewController:self];
            }];
        }
    }];

}


- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
//        UMSocialUserInfoResponse *resp = result;
        
    }];
}

#pragma mark 请求用户信息
- (void)requestUserInfomationWithToken:(NSString *)access_token expired:(NSString *)expired
{
    NSDictionary *dict = @{@"access_token":access_token};
    
    [[[DifferNetwork shareInstance] requestUserInformationParamet:dict] subscribeNext:^(id responseObj) {
        [SVProgressHUD dismiss];
        
        NSLog(@"%@,%@,%@",responseObj,[responseObj class],[NSThread currentThread]);
        
        UserModel *userInfo = [UserModel mj_objectWithKeyValues:responseObj[@"data"]];
        // 本地保存用户信息
        [NSKeyedArchiver archiveRootObject:userInfo toFile:[DiffUtil getUserPathAtDocument]];
        [DifferAccountTool downloadAvata:userInfo.avatar];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
        // 返回
        [self cancelLogin];
    } error:^(NSError *error) {
        [SVProgressHUD dismiss];
        [DiffUtil showAlertControllerWithTitle:@"登录失败" message:@"获取用户信息失败，请重新登录" presenViewController:self];
        //获取用户信息失败的话就直接删除账户
        [DifferAccountTool deleteAccount];
        
        NSLog(@"请求用户数据失败：%@",error);
    }];
    
}



@end















