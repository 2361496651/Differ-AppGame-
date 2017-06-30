//
//  AppDelegate.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/14.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "AppDelegate.h"
#import "HMDrawerViewController.h"
#import "HMLeftMenuViewController.h"
#import "HomeViewController.h"
#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UserNotifications/UserNotifications.h>
#import "UMessage.h"
#import <UMMobClick/MobClick.h>

#import "DiffUtil.h"

#import "MainViewController.h"
#import "DifferChooseRoot.h"

#define NewVersionSwitch NO

#define UMengAppKey @"58f7279304e2050cda000f22"


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 友盟推送
//   appkey: 58f7279304e2050cda000f22
//   app secret: pfakmlhyoiay2az38hkofj5zbe5tyoff
    // 友盟远程通知
    [self registerRemotionNotification:launchOptions];
    // 友盟统计
    [self initUMengAnalyticsNOIDFA];
    // 友盟登录分享
    [self initUMengShare];
    
    //网络监听
    [self monitorNetwork];
    
    // 设置提示显示时间
    [SVProgressHUD setMinimumDismissTimeInterval:1.0];

    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [DiffUtil getDifferColor];
    
    //选择根控制器 (根据是否有新版)
//    [DifferChooseRoot chooseRootControllerWithWindow:self.window];
    
    if (NewVersionSwitch) {
        
        MainViewController *tabBar = [[MainViewController alloc] init];
        
        self.window.rootViewController = tabBar;
        
    }else{
        
        HMLeftMenuViewController *leftMenuVc = [[HMLeftMenuViewController alloc] initWithNibName:@"HMLeftMenuViewController" bundle:[NSBundle mainBundle]];
        UINavigationController *leftNav = [DiffUtil initNavigationWithRootViewController:leftMenuVc];
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *mainVc = sb.instantiateInitialViewController;
        
        self.window.rootViewController = [HMDrawerViewController drawerWithMainVc:mainVc leftMenuVc:leftNav leftWidth:[UIScreen mainScreen].bounds.size.width * 0.8];
    }
    
    [self.window makeKeyAndVisible];
    
     
    return YES;
}



#pragma mark 友盟统计
- (void)initUMengAnalyticsNOIDFA
{
    //版本标识
    NSString *version = [DiffUtil getCurrentVersion];
    [MobClick setAppVersion:version];
    
    // 友盟统计
    UMConfigInstance.appKey = UMengAppKey;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.ePolicy = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
}

#pragma mark 友盟登录
- (void)initUMengShare
{
    // UM登录分享
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:NO];
    /* 设置友盟appkey */ // 58f7279304e2050cda000f22
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMengAppKey];
    [self configUSharePlatforms];
    [self confitUShareSettings];
}


#pragma mark 友盟登录分享

- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */ //wxdc1e388c3822c80b
    //    AppID：wxfa88e143e15b8297
    //    App Secret ad93241bec78c98b5ea2a817c33832bc
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxfa88e143e15b8297" appSecret:@"ad93241bec78c98b5ea2a817c33832bc" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    //    APP ID  1106109400  .  1106063028
    //    APP KEY  tm5oATwBg56AYBJw  .  vMb3Fr1gZrRS4H1H
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106063028"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    //    appkey 3055766945  . 3781674297
    //    App Secret：90f6d33f3ec1dbe124a5220a19798ab3 . c9dd4a8035bde215729ae0e362e8f7f7
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3781674297"  appSecret:@"c9dd4a8035bde215729ae0e362e8f7f7" redirectURL:@"https://api.weibo.com/oauth2/default.html"];
    
}

#pragma mark : 系统回调
// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
// 仅支持iOS9以上系统，iOS8及以下系统不会回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
// 支持目前所有iOS系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

/***********************远程通知********************/
- (void)registerRemotionNotification:(NSDictionary *)launchOptions
{
    
//    [UMessage startWithAppkey:@"58f7279304e2050cda000f22" launchOptions:launchOptions httpsEnable:YES];
    
    [UMessage startWithAppkey:UMengAppKey launchOptions:launchOptions];
    //注册通知，如果要使用category的自定义策略，可以参考demo中的代码。
    [UMessage registerForRemoteNotifications];
    
    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|  UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10     completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许
            //这里可以添加一些自己的逻辑
        } else {
            //点击不允许
            //这里可以添加一些自己的逻辑
        }
    }];
    
    [UMessage setLogEnabled:YES];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册远程通知失败：%@",error);
}


//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}


- (void)monitorNetwork
{
    //网络监控句柄
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //status:
        //AFNetworkReachabilityStatusUnknown          = -1,  未知
        //AFNetworkReachabilityStatusNotReachable     = 0,   未连接
        //AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
        //AFNetworkReachabilityStatusReachableViaWiFi = 2,   无线连接
        //        NSLog(@"%ld", status);
        self.networkStatus = status;
        
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
