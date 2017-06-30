//
//  AGBaseViewController.m
//
//
//  Created by supozheng on 2017/5/3.
//  Copyright © 2017年 supozheng. All rights reserved.
//

#import "BaseViewController.h"
#import "DifferNetwork.h"
#import "ShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import <SVProgressHUD.h>
#import "DiffUtil.h"

@interface BaseViewController () <ShareViewDelegate>
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic,strong)ShareView *shareView;
@property (nonatomic,strong)UIButton *bgBtn;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {

}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.view.backgroundColor = [UIColor clearColor];
}

// 屏幕旋转
- (void)statusBarOrientationChange {
    if ([UIScreen mainScreen].applicationFrame.size.width > 480) { // 横屏
//        [self.alertView anyCentreYConstraint].constant = 0;
    }else {
//        [self.alertView anyCentreYConstraint].constant = -25;
    }
    [self.view layoutIfNeeded];
}

-(void)loadData
{

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

//分享背景蒙版
- (UIButton *)bgBtn
{
    if (_bgBtn == nil) {
        _bgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _bgBtn.backgroundColor = [UIColor lightGrayColor];
        _bgBtn.alpha = 0.01;
        [_bgBtn addTarget:self action:@selector(removeBgBtnView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}


#pragma mark:展示分享面板
- (void)displayShareView
{
    [self.view addSubview:self.bgBtn];
    [self.view addSubview:self.shareView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.shareView.transform = CGAffineTransformMakeTranslation(0, -self.shareView.bounds.size.height);
        self.bgBtn.transform = CGAffineTransformMakeTranslation(0, -self.bgBtn.bounds.size.height);
        self.bgBtn.alpha = 0.8;
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
    NSString *shareUrl = [NSString stringWithFormat:@"%@/h5/download",differ_base_service];
    pasteboard.string=shareUrl;
    
    [self removeBgBtnView];
    //    [DiffUtil showInCenterWithTitle:@"复制链接成功" backgroundColor:nil textColor:nil];
    [SVProgressHUD showSuccessWithStatus:@"复制链接成功"];
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UIImage* thumbImage = [UIImage imageNamed:@"shareIcon20x20"];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"下载differ，和我一起畅玩精品游戏" descr:@"发掘游戏乐趣，推荐个性爆棚的游戏和内涵丰富的文章，更有无数同好者圈子分享游戏趣事、新鲜事" thumImage:thumbImage];
    //设置网页地址
    NSString *shareUrl = [NSString stringWithFormat:@"%@/h5/download",differ_base_service];
    shareObject.webpageUrl = shareUrl;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"分享失败：%@",error);
        }else{
            NSLog(@"分享成功");
            [self removeBgBtnView];
            //            [DiffUtil showInBottomWithTitle:@"分享成功" backgroundColor:nil textColor:nil];
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
        }
        
    }];
}

-(void)showDialog:(NSString*)title content:(NSString*)content leftButtonText:(NSString*)leftButtonText{
    [self showDialog:title content:content leftButtonText:leftButtonText rightButtonText:nil];
}

-(void)showDialog:(NSString*)title content:(NSString*)content leftButtonText:(NSString*)leftButtonText rightButtonText:(NSString*)rightButtonText{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    if(rightButtonText){
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:rightButtonText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self clickDialogRightButton];
        }];
        [alert addAction:action1];
    }
    
    if(leftButtonText){
        UIAlertAction *action2= [UIAlertAction actionWithTitle:leftButtonText style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [self clickDialogLeftButton];
        }];
        [alert addAction:action2];
    }

    [self presentViewController:alert animated:YES completion:nil];
}

-(void)clickDialogLeftButton{
    
}

-(void)clickDialogRightButton{
    
}

-(BOOL)isLoginWithLoginWindow{
    return [DiffUtil judgIsLoginWithViewController:self];
}

@end
