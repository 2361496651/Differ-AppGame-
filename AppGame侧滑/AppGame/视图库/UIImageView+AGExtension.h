//
//  UIImageView+AGExtension.h
//  AGVideo
//
//  Created by Mao on 15/6/15.
//  Copyright (c) 2015年 AppGame. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AGFile;

@interface UIImageView (AGExtension)
- (void)setRoundedImageWithURL:(nonnull NSURL*)URL placeholderImage:(nonnull UIImage*)image size:(CGSize)size;
- (void)setScaleImageWithURL:(nonnull NSURL*)URL width:(float)width placeholderImage:(nonnull UIImage*)image block:(nonnull void(^)(float imageViewHeight))block;
- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL size:(CGSize)size;
- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL;
//覆盖层
- (void)setCoverWithColor:(nonnull UIColor *)color alpha:(CGFloat)alpha;
- (void)setDefaultCoverColor;
/** 异步获取网络图片 */
- (void)ag_setImageWithAgfile:(nonnull AGFile *)file;
- (void)ag_setImageWithAgfile:(nonnull AGFile *)file placeholderImage:(nonnull UIImage *)placeholderImage;
@end
