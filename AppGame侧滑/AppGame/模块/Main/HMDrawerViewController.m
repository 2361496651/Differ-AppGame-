//
//  HMDrawerViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/14.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "HMDrawerViewController.h"
#import "DiffUtil.h"
#import "ShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "GlobelConst.h"
#import <SVProgressHUD.h>

@interface HMDrawerViewController()<UIGestureRecognizerDelegate,ShareViewDelegate>
/**
 *  正在显示的控制器
 */
@property (nonatomic, strong) UIViewController *showingVc;
// 左边菜单显示的最大宽度
@property (nonatomic, assign) CGFloat leftWidth;
// 主控制器
@property (nonatomic, strong) UIViewController *mainVc;
// 左边菜单控制器
@property (nonatomic, strong) UIViewController *leftMenuVc;
// 遮盖按钮
@property (nonatomic, strong) UIButton *coverBtn;


@property (nonatomic,strong)UIButton *bgBtn;
@property (nonatomic,strong)ShareView *shareView;

@end

@implementation HMDrawerViewController

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


// 分享
- (ShareView *)shareView
{
    if (_shareView == nil) {
        _shareView = [[ShareView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 240)];
        _shareView.delegate = self;
    }
    return _shareView;
}

/**
 *  返回抽屉控制器
 *
 */
+(instancetype)sharedDrawer {
    return (HMDrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}
/**
 *  快速创建一个抽屉控制器
 *
 *  @param mainVc     主控制器
 *  @param leftMenuVc 左边菜单控制器
 *  @param leftWidth  左边菜单控制器最大显示的宽度
 *
 *  @return 抽屉控制器
 */
+(instancetype)drawerWithMainVc:(UIViewController *)mainVc leftMenuVc:(UIViewController *)leftMenuVc leftWidth:(CGFloat)leftWidth {
    // 创建抽屉控制器
    HMDrawerViewController *drawerVc = [[HMDrawerViewController alloc] init];
    // 记录属性
    drawerVc.leftWidth = leftWidth;
    drawerVc.mainVc = mainVc;
    drawerVc.leftMenuVc = leftMenuVc;
    // 将leftMenuVc控制器的view添加到当前控制器view上
    [drawerVc.view addSubview:leftMenuVc.view];
    // 将mainVc控制器的view添加到当前控制器view上
    [drawerVc.view addSubview:mainVc.view];
    
    // 让外界传人的两个控制器成为当前控制器的子控制器
    [drawerVc addChildViewController:leftMenuVc];
    [drawerVc addChildViewController:mainVc];
    // 返回创建好的抽屉控制器
    return drawerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [DiffUtil getDifferColor];
    
    // 设置左边菜单控制器默认向左边偏移leftWidth
    self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth, 0);
    
    // 给主控制器的左边缘添加阴影效果
//    self.mainVc.view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    self.mainVc.view.layer.shadowOffset = CGSizeMake(-3, -3);
//    self.mainVc.view.layer.shadowRadius = 2;
//    self.mainVc.view.layer.shadowOpacity = 0.5;
    
    // 为主控制器添加屏幕边缘拖拽手势
//    for (UIView *view in self.mainVc.view.subviews) {
//        [self addScreenEdgePanGestureRecognizerToView:view];
//    }
    
    if([self.mainVc isKindOfClass:[UIViewController class]]) {
        NSArray *childViewControllers = self.mainVc.childViewControllers;
        for (UIViewController *childVc in childViewControllers) {
        [self addScreenEdgePanGestureRecognizerToView:childVc.view];
        }
    } else {
        [self addScreenEdgePanGestureRecognizerToView:self.mainVc.view];
    }
}

#pragma mark - 手势相关方法
/**
 *  给指定的view的添加边缘拖拽手势
 */
- (void)addScreenEdgePanGestureRecognizerToView:(UIView *)view{
    // 创建屏幕边缘拖拽手势对象
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGestureRecognizer:)];
    // 设置手势触发边缘为左边缘
    pan.edges = UIRectEdgeLeft;
    pan.delegate = self;
    // 添加手势到指定view
    [view addGestureRecognizer:pan];
}

//多手势共同触发
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
//以下两个成对的方法比较有趣（实现其一即可）
//返回yes－前面失效后面生效    返回no－前面生效后面失效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return ![gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
    
}

//返回yes-前面生效后面失效    返回no-前面失效后面生效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

/**
 *  手势识别回调方法
 */
- (void)edgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)pan {
    // 获得x方向拖动的距离
    CGFloat offsetX = [pan translationInView:pan.view].x;
    // 限制offsetX的最大值为leftWidth
    offsetX = MIN(self.leftWidth, offsetX);
    // 判断手势的状态
    if(pan.state == UIGestureRecognizerStateChanged) {
        // 手势一直处于改变状态
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(offsetX, 0);
        self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth + offsetX, 0);
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        // 手势结束或手势被取消了
        // 获得mainVc的x值
        CGFloat mainX = self.mainVc.view.frame.origin.x;
        if (mainX >= self.leftWidth * 0.5) { // 超过屏幕的一半
            [self openLeftMenuWithDuration:0.15 completion:nil];
        } else { // 没有超过屏幕的一半
            [self closeLeftMenuWithDuration:0.15 completion:nil];
        }
    }
    
}

/**
 *  遮盖按钮拖拽手势回调方法
 */
-(void)panCoverBtn:(UIPanGestureRecognizer *)pan {
    // 获得x方向的拖拽的距离
    CGFloat offsetX = [pan translationInView:pan.view].x;
    // 判断是否大于0
    if(offsetX >= 0)return;
    NSInteger distance =  self.leftWidth - ABS(offsetX);
    if (pan.state == UIGestureRecognizerStateChanged) {
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(MAX(distance, 0), 0);
        self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth + distance, 0);
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        CGFloat mainX = self.mainVc.view.frame.origin.x;
        if (mainX >= self.leftWidth * 0.5) { // 超过屏幕的一半
            [self openLeftMenuWithDuration:0.15 completion:nil];
        } else { // 没有超过屏幕的一半
            [self closeLeftMenuWithDuration:0.15 completion:nil];
        }
    }
}

#pragma mark - 切换到指定的控制器
- (void)switchViewController:(UIViewController *)vc {
    
    UINavigationController *navigation = [DiffUtil initNavigationWithRootViewController:vc];
    
//    UINavigationController *navigation = [[UINavigationController alloc]initWithRootViewController:vc];
//    navigation.navigationBar.barTintColor = [DiffUtil getDifferColor];
    
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMainVc)];
//    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToMainVc)];
    
    navigation.view.frame = self.mainVc.view.bounds;
    navigation.view.transform = self.mainVc.view.transform;
    
    [self.view addSubview:navigation.view];
    [self addChildViewController:navigation];
    self.showingVc = navigation;
    
    [self closeLeftMenuWithDuration:0.25 completion:nil];
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        navigation.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  回到主页控制器
 */
- (void)backToMainVc {
    self.mainVc.view.transform = CGAffineTransformMakeTranslation(-self.mainVc.view.frame.size.width, 0);
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.showingVc.view.transform = CGAffineTransformMakeTranslation(self.showingVc.view.frame.size.width, 0);
        self.mainVc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.showingVc.view removeFromSuperview];
        [self.showingVc removeFromParentViewController];
        self.showingVc = nil;
        
    }];
}

#pragma mark - 打开和关闭抽屉方法
/**
 *  打开左边菜单
 */
- (void)openLeftMenuWithDuration:(CGFloat)duration completion:(void (^)())completion {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainVc.view.transform = CGAffineTransformMakeTranslation(self.leftWidth, 0);
        self.leftMenuVc.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        if (!self.coverBtn.superview) {
            // 添加遮盖按钮
            [self.mainVc.view addSubview:self.coverBtn];
        }
        if (completion) {
            completion();
        }
    }];
}

/**
 *  关闭左边菜单
 */
- (void)closeLeftMenuWithDuration:(CGFloat)duration completion:(void (^)())completion{
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.mainVc.view.transform = CGAffineTransformIdentity;
        self.leftMenuVc.view.transform = CGAffineTransformMakeTranslation(-self.leftWidth, 0);
    } completion:^(BOOL finished) {
        // 移除遮盖按钮
        [self.coverBtn removeFromSuperview];
        self.coverBtn = nil;
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - 懒加载遮盖按钮
- (UIButton *)coverBtn {
    if (_coverBtn == nil) {
        _coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _coverBtn.frame = self.mainVc.view.bounds;
        _coverBtn.backgroundColor = [UIColor clearColor];
        [_coverBtn addTarget:self action:@selector(coverBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        // 添加拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCoverBtn:)];
        [_coverBtn addGestureRecognizer:pan];
    }
    return _coverBtn;
}

- (void)coverBtnClick {
    [self closeLeftMenuWithDuration:0.25 completion:nil];
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
//            [DiffUtil showInTopWithTitle:@"分享成功" backgroundColor:nil textColor:nil];
        }
        
    }];
}


@end
