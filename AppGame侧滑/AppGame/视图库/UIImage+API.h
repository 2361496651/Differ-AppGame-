//
//  UIImage+API.h
//  AGVideo
//
//  Created by Mao on 16/4/25.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (API)
+ (UIImage*)likeImageForUserId:(NSString*)userId;
+ (UIImage*)imageForChatCellBackgroud;
/** 头像占位图 */
+ (UIImage*)imageForRoundedPlaceholderAvatar;
+ (UIImage*)imageForRoundedPlaceholderAvatarWidthBorderWidth:(CGFloat)borderWidth;
/** 普通图像占位图 */
+ (UIImage*)imageForPlaceholderNormal;
/** 默认导航条背景图 */
+ (UIImage*)defaultNavigationBackgroundImage;
/** 默认封图 */
+ (UIImage*)imageForDefaultPlaceHolderCover;
/** 默认个人页背景图 */
+ (UIImage*)imageForUserCentralBackground;

@end
