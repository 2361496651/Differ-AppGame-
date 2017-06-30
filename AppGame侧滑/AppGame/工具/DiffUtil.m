//
//  DiffUtil.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DiffUtil.h"
#import "CJNavigationController.h"
#import "LoginViewController.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"

@implementation DiffUtil

+ (UIColor *)getDifferColor
{
    return [UIColor colorWithRed:36/255.0 green:47/255.0 blue:68/255.0 alpha:1.0];
}

+ (UIFont *)getDifferFont:(CGFloat)size
{
    return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
}


+ (NSString *)dateStrWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy年MM月dd日";
    return [fmt stringFromDate:[NSDate date]];
}

+ (UINavigationController *)initNavigationWithRootViewController:(UIViewController *)viewController
{
    CJNavigationController *navigation = [[CJNavigationController alloc] initWithRootViewController:viewController];
//    navigation.navigationBar.translucent = NO;
//    navigation.navigationBar.barTintColor = [UIColor colorWithRed:36/255.0 green:47/255.0 blue:68/255.0 alpha:1.0];
//    navigation.navigationBar.tintColor = [UIColor whiteColor];
//    navigation.navigationBar.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor blackColor]};
    
    return navigation;
}

+ (UIBarButtonItem *)initButtonItemWithTitle:(NSString *)title action:(SEL)target delegate:(id)delegate
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:delegate action:target];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[self colorWithHexString:@"#15B1B8"], NSForegroundColorAttributeName, [self getDifferFont:14], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    return item;
}

+ (UIBarButtonItem *)initButtonItemWithImage:(NSString *)image action:(SEL)target delegate:(id)delegate
{
    UIImage *Originalimage = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:Originalimage style:UIBarButtonItemStylePlain target:delegate action:target];
    
    /*
    // 创建按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:Originalimage forState:UIControlStateNormal];
    [btn addTarget:delegate action:target forControlEvents:UIControlEventTouchUpInside];
//    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    // 把UIButton包装成UIBarButtonItem 有会按钮点击范围过大的问题
    // 解决这个问题
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:containView];
    */
    return item;
}

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message presenViewController:(UIViewController *)viewController
{
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //修改内容，字号，颜色。使用的key值是“attributedMessage”
    NSMutableAttributedString *hogan1 = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan1 addAttribute:NSFontAttributeName value:[self getDifferFont:15] range:NSMakeRange(0, [[hogan1 string] length])];
    [hogan1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[hogan1 string] length])];
    [alertContr setValue:hogan1 forKey:@"attributedMessage"];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertContr addAction:done];
    [viewController presentViewController:alertContr animated:YES completion:nil];
}

+ (void)showTwoAlertControllerWithTitle:(NSString *)title message:(NSString *)message presenViewController:(UIViewController *)viewController callBack:(AlertCallback)alerCallback
{
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //修改标题，字号，颜色。使用的key值是“attributedTitle”
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
    [hogan addAttribute:NSFontAttributeName value:[self getDifferFont:14] range:NSMakeRange(0, [[hogan string] length])];
    [hogan addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, [[hogan string] length])];
//    [alertContr setValue:hogan forKey:@"attributedTitle"];
    
    //修改内容，字号，颜色。使用的key值是“attributedMessage”
    NSMutableAttributedString *hogan1 = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan1 addAttribute:NSFontAttributeName value:[self getDifferFont:15] range:NSMakeRange(0, [[hogan1 string] length])];
    [hogan1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[hogan1 string] length])];
    [alertContr setValue:hogan1 forKey:@"attributedMessage"];
    
    //修改按钮的颜色，同上可以使用同样的方法修改内容，样式

    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        alerCallback(clickResultYes);
    }];
//    [done setValue:[UIColor blueColor] forKey:@"_titleTextColor"];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        alerCallback(clickResultCancel);
        
    }];
//    [cancel setValue:[UIColor blackColor] forKey:@"_titleTextColor"];
    
    [alertContr addAction:done];
    [alertContr addAction:cancel];
    [viewController presentViewController:alertContr animated:YES completion:nil];
}

+ (void)showThreeAlertControllerWithTitle:(NSString *)title message:(NSString *)message presenViewController:(UIViewController *)viewController callBack:(AlertCallback)alerCallback
{
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //修改内容，字号，颜色。使用的key值是“attributedMessage”
    NSMutableAttributedString *hogan1 = [[NSMutableAttributedString alloc] initWithString:message];
    [hogan1 addAttribute:NSFontAttributeName value:[self getDifferFont:15] range:NSMakeRange(0, [[hogan1 string] length])];
    [hogan1 addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [[hogan1 string] length])];
    [alertContr setValue:hogan1 forKey:@"attributedMessage"];
    
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        alerCallback(clickResultYes);
    }];
    
    UIAlertAction *not = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        alerCallback(clickResultNo);
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        alerCallback(clickResultCancel);
        
    }];
    
    [alertContr addAction:done];
    [alertContr addAction:not];
    [alertContr addAction:cancel];
    [viewController presentViewController:alertContr animated:YES completion:nil];
}

// base64编码后的字符串
+ (NSString *)encodingBase64WithOriginStr:(NSString *)originStr
{
    NSData* originData = [originStr dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encodeResult;
}

// base64解码后的字符串
+ (NSString *)decodingBase64WithEncodingStr:(NSString *)encodingStr
{
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:encodingStr options:0];
    NSString *decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    return decodeStr;
}

// 字典转json字符串
+ (NSString *)jsonStringWithDict:(NSDictionary *)dict
{
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    return jsonStr;
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}
//json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

// 获取 设备与应用绑定 的唯一标识
+ (NSString *)getIdentifierForVendor
{
    NSUUID *uuid = [UIDevice currentDevice].identifierForVendor;
    return uuid.UUIDString;
}

// UUID是一个32位的十六进制序列，UUID再某一时空下是唯一的
+ (NSString *)getUUID
{
    return [NSUUID UUID].UUIDString;
}


#pragma mark:沙河中的document文件下创建一个用户文件夹来保存用户信息
//创建的文件夹均以differ开头

// 创建/获取 账户路径
+ (NSString *)getAccountPathAtDocument
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    path = [path stringByAppendingPathComponent:@"DifferAccount"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:@"account.data"];
    
}

+ (NSString *)getUserPathAtDocument
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    path = [path stringByAppendingPathComponent:@"DifferAccount"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:@"user.data"];
}


//用户头像路径
+ (NSString *)getAccountAvataPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    path = [path stringByAppendingPathComponent:@"DifferAccount"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:@"avata.jpg"];
}

//每日探索到的游戏ID
+ (NSString *)getSearchGameIdsPath
{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    path = [path stringByAppendingPathComponent:@"DifferAccount"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [path stringByAppendingPathComponent:@"searchGame.plist"];
}
// 删除保存的游戏ID
+ (void)removeSearchGameIds
{
    NSFileManager *manage = [NSFileManager defaultManager];
    NSString *searchPath = [self getSearchGameIdsPath];
    
    BOOL result = NO;
    
    if ([manage fileExistsAtPath:searchPath]) {
        result = [manage removeItemAtPath:searchPath error:nil];
        if (!result) {
            NSLog(@"删除保存的探索游戏ID数据失败");
        }
    }
}
// 获取探索游戏id字符串，多个用，隔开
+ (NSString *)getSearchGameIdString
{
    NSMutableArray *tempArray = [NSMutableArray arrayWithContentsOfFile:[self getSearchGameIdsPath]];
    if (tempArray == nil) {
        tempArray = [NSMutableArray array];
    }
    NSString *searchIds = @"";
    for (NSString *gameId in tempArray) {
        searchIds = [NSString stringWithFormat:@"%@,%@",searchIds,gameId];
    }
    
    if ([searchIds hasPrefix:@","]) {
        searchIds = [searchIds substringFromIndex:1];
    }
    
    return searchIds;
}


//获取当前版本
+ (NSString *)getCurrentVersion
{
    NSDictionary *dictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [dictionary objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}

// 改变头像尺寸
const CGFloat MAX_UPLOADAVATA_LENGTH = 128;

+ (UIImage *)resizeImageToUpdaloadAvata:(UIImage *)image
{
    if (image.size.width > MAX_UPLOADAVATA_LENGTH || image.size.height > MAX_UPLOADAVATA_LENGTH)
    {
        CGFloat ratio = MAX_UPLOADAVATA_LENGTH / image.size.width;
        if (image.size.width < image.size.height)
        {
            ratio = MAX_UPLOADAVATA_LENGTH / image.size.height;
        }
        CGSize newSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
        return [self imageWithImage:image scaledToSize:newSize];
    }
    else
    {
        return image;
    }
}

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 *  短暂显示在底部的提示框
 *
 *  @param title           提示的内容
 *  @param backgroundColor 提示框的背景颜色,默认为灰色
 *  @param textColor       提示文本的颜色，默认为白色
 *
 */
+ (void)showInBottomWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor
{
    if (!backgroundColor) {
        backgroundColor = [self getDifferColor];
    }
    if (!textColor) {
        textColor = [UIColor whiteColor];
    }
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGSize textSize = [self sizeWithText:title width:screenW textFont:14.0];
    CGFloat height = textSize.height;
    
    
    UILabel *success = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH, screenW, height*3)];
    success.text = title;// @"分享成功";
    success.backgroundColor = backgroundColor;// [UIColor blackColor];
    success.textColor = textColor;//[UIColor whiteColor];
    success.textAlignment = NSTextAlignmentCenter;
    [[[UIApplication sharedApplication].windows lastObject] addSubview:success];
    
    
    [UIView animateWithDuration:1.0 animations:^{
        success.transform = CGAffineTransformMakeTranslation(0, -height*3);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            success.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [success removeFromSuperview];
        }];
        
    }];
    
}

/**
 *  短暂显示在上部的提示框
 *
 *  @param title           提示的内容
 *  @param backgroundColor 提示框的背景颜色,默认为灰色
 *  @param textColor       提示文本的颜色，默认为白色
 *
 */
+ (void)showInTopWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor
{
    if (!backgroundColor) {
        backgroundColor = [self getDifferColor];
    }
    if (!textColor) {
        textColor = [UIColor whiteColor];
    }
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
//    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGSize textSize = [self sizeWithText:title width:screenW textFont:14.0];
    CGFloat height = textSize.height;
    
    
    UILabel *success = [[UILabel alloc] initWithFrame:CGRectMake(0, -height*3, screenW, height*3)];
    success.text = title;// @"分享成功";
    success.backgroundColor = backgroundColor;// [UIColor blackColor];
    success.textColor = textColor;//[UIColor whiteColor];
    success.textAlignment = NSTextAlignmentCenter;
    [[[UIApplication sharedApplication].windows lastObject] addSubview:success];
    
    
    [UIView animateWithDuration:1.0 animations:^{
        success.transform = CGAffineTransformMakeTranslation(0, height*3);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            success.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [success removeFromSuperview];
        }];
        
    }];
    
}


/**
 *  短暂显示在中部的提示框
 *
 *  @param title           提示的内容
 *  @param backgroundColor 提示框的背景颜色,默认为黑色
 *  @param textColor       提示文本的颜色，默认为白色
 *
 */
+ (void)showInCenterWithTitle:(NSString *)title backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor
{
    if (!backgroundColor) {
        backgroundColor = [self getDifferColor];
    }
    if (!textColor) {
        textColor = [UIColor blackColor];
    }
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    CGSize textSize = [self sizeWithText:title width:screenW textFont:14.0];
    CGFloat height = textSize.height;
    
    
    UILabel *success = [[UILabel alloc] initWithFrame:CGRectMake(0, screenH * 0.6, screenW*0.5 , height*3)];
    success.center = [[UIApplication sharedApplication].windows firstObject].center;
    success.alpha = 0.0;
    success.text = title;
    success.font = [self getDifferFont:16];
    success.backgroundColor = [UIColor lightGrayColor];//backgroundColor;
    success.textColor = textColor;
    success.textAlignment = NSTextAlignmentCenter;
    [[[UIApplication sharedApplication].windows firstObject] addSubview:success];
    
    [UIView animateWithDuration:0.5 delay:0.4 options:UIViewAnimationOptionCurveLinear animations:^{
        success.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
            success.alpha = 0.01;
        } completion:^(BOOL finished) {
            [success removeFromSuperview];
        }];
    }];
}


+ (CGSize)sizeWithText:(NSString *)text width:(CGFloat)width textFont:(CGFloat)textFont
{
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:textFont]} context:nil].size;
    return textSize;
}


+ (UIColor *)colorWithHexString:(NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+ (void)monitorNetwork:(void (^)(AFNetworkReachabilityStatus))reach
{
    //网络监控句柄
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //要监控网络连接状态，必须要先调用单例的startMonitoring方法
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:reach];
}
    
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        //status:
//        //AFNetworkReachabilityStatusUnknown          = -1,  未知
//        //AFNetworkReachabilityStatusNotReachable     = 0,   未连接
//        //AFNetworkReachabilityStatusReachableViaWWAN = 1,   3G
//        //AFNetworkReachabilityStatusReachableViaWiFi = 2,   无线连接
//        //        NSLog(@"%ld", status);
//        self.isReachable = status;
//        [self.tableView reloadData];
//    }];


// 判断是否登录 ，未登录直接弹出登录界面
+ (BOOL)judgIsLoginWithViewController:(UIViewController *)viewControll
{
    DifferAccount *account = [DifferAccountTool account];
    if (account == nil) {
        
        LoginViewController *loginVC = [LoginViewController shareInstance];
        UINavigationController *navi = [DiffUtil initNavigationWithRootViewController:loginVC];
        
        [viewControll presentViewController:navi animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
    
}
// 判断是否是手机号码
+ (BOOL)judgePhoneNumber:(NSString *)phoneNum
{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    
    // 一个判断是否是手机号码的正则表达式
    NSString *pattern = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",CM_NUM,CU_NUM,CT_NUM];
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *mobile = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        NO;
    }
    
    // 无符号整型数据接收匹配的数据的数目
    NSUInteger numbersOfMatch = [regularExpression numberOfMatchesInString:mobile options:NSMatchingReportProgress range:NSMakeRange(0, mobile.length)];
    if (numbersOfMatch>0) return YES;
    
    return NO;
    
}


+ (UIViewController*)currentViewController{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
        
    }
    
    return vc;
}

//标签数量限制
+ (NSString *)tagCountLimitWithCount:(NSInteger)count
{
    // > 10000 10100 1.2W
    NSString *title = nil;
    
    if (count > 99) {
        //        CGFloat floatCount = count / 10000.0;
        //        title = [NSString stringWithFormat:@"%.1fW",floatCount];
        //        title = [title stringByReplacingOccurrencesOfString:@".0" withString:@""];
        title = [NSString stringWithFormat:@"%ld+",count];
    }else{ // < 10000
        title = [NSString stringWithFormat:@"%ld",count];
    }
    
    
    return title;
    
}

@end
