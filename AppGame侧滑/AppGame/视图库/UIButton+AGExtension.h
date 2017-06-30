//
//  UIButton+AGExtension.h
//  VideoCommunity
//
//  Created by Mao on 14/12/5.
//  Copyright (c) 2014年 AppGame. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton (AGExtension)
@property (nonnull, nonatomic, readonly) UIActivityIndicatorView *indicatorView;
@property (nonatomic, assign) BOOL working;
- (void)setRoundedImageWithURL:(nonnull NSURL*)URL placeholderImage:(nonnull UIImage*)image size:(CGSize)size borderWidth:(CGFloat)borderWidth;
- (void)setRoundedImageWithURL:(nonnull NSURL*)URL placeholderImage:(nonnull UIImage*)image size:(CGSize)size;
- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL borderWidth:(CGFloat)borderWidth;
- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL size:(CGSize)size;
- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL;

- (void)setTitle:(nonnull NSString *)title font:(nonnull UIFont *)font color:(nonnull UIColor *)color forState:(UIControlState)state;

@end
