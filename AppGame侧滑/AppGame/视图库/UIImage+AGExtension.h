//
//  UIImage+ImageUtil.h
//  AppGame
//
//  Created by 姚东海 on 1/8/14.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
@interface UIImage (AGExtension)
/**
 *  颜色生成图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size scale:(CGFloat)scale;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size radius:(CGFloat)radius scale:(CGFloat)scale;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size radius:(CGFloat)radius;
+ (UIImage *)horizontalGradientImageFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size;
+ (UIImage *)verticalGradientImageFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size;
+ (UIImage *)horizontalGradientImageWithColors:(NSArray*)colors size:(CGSize)size;
- (UIImage *)coverWithImage:(UIImage*)image;
- (UIImage *)coverWithDefautlColor;
+ (UIImage *)wireframeWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;
+ (UIImage *)wireframeWithColor:(UIColor *)color size:(CGSize)size lineWith:(CGFloat)lineWith cornerRadius:(CGFloat)cornerRadius;
- (UIImage *)imageWithRoundedSize:(CGSize)size;
- (UIImage *)imageWithRoundedSize:(CGSize)size borderWidth:(CGFloat)borderWidth;
- (UIImage *)imageWithRounded;
+ (UIImage *)imageFromCahcheWithURL:(NSURL*)URL size:(CGSize)size borderWidth:(CGFloat)borderWidth;
- (UIImage *)imageWithRoundedWithBorderWidth:(CGFloat)borderWidth;
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
- (UIImage *)imageWithCropRect:(CGRect)cropRect;
- (UIImage *)imageToOrientationUp;
+ (UIImage *)imageFromCahcheWithURL:(NSURL*)URL size:(CGSize)size;
+ (void)cacheImage:(UIImage*)image URL:(NSURL*)URL size:(CGSize)size;
+ (void)cacheImage:(UIImage*)image URL:(NSURL*)URL size:(CGSize)size borderWidth:(CGFloat)borderWidth;
- (UIImage *)imageWithOriginalRenderingMode;
- (UIImage *)imageWithTemplateRenderingMode;
+ (UIImage *)stretchableImageWithImageName:(NSString *)imageName LeftCapWidth:(float)w topCapHeight:(float)h;

+ (UIImage *)drawImaginaryLineViewWithImageview:(UIImageView *)imageview;

+ (UIImage*)imageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
- (NSString *)ag_toJPEGBase64;
@end
