//
//  UIImageView+AGExtension.m
//  AGVideo
//
//  Created by Mao on 15/6/15.
//  Copyright (c) 2015年 AppGame. All rights reserved.
//

#import <objc/runtime.h>

static char SettingRemoteImageKey;

@implementation UIImageView (AGExtension)
- (void)setRoundedImageWithURL:(nonnull NSURL*)URL placeholderImage:(nonnull UIImage*)placeholderImage size:(CGSize)size{
    UIImage *avatarImage = [UIImage imageFromCahcheWithURL:URL size:size];
    if (avatarImage) {
        [self setImage:[avatarImage imageWithOriginalRenderingMode]];
        [self setSettingRemoteImage:NO];
    }else{
        __weak typeof(self) weakSelf = self;
        [self setSettingRemoteImage:YES];
        [self sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            UIImage *aImage = [image imageWithRoundedSize:size];
            [UIImage cacheImage:aImage URL:URL size:size];
            if ([weakSelf settingRemoteImage]) {
                [weakSelf setImage:[aImage imageWithOriginalRenderingMode]];
                [weakSelf setSettingRemoteImage:NO];
            }
        }];
    }
}

- (void)setScaleImageWithURL:(nonnull NSURL*)URL width:(float)width placeholderImage:(nonnull UIImage*)placeholderImage block:(void(^)(float imageViewHeight))block{
    UIImage *holderCoverImage = [UIImage imageFromCahcheWithURL:URL size:CGSizeZero];
    if (holderCoverImage) {
        
        UIImage *image = [holderCoverImage imageWithOriginalRenderingMode];
        self.anyHeightConstraint.constant = [self screenScaleImageHeightWithImage:image width:width];

        [self setImage:[holderCoverImage imageWithOriginalRenderingMode]];
        block([self screenScaleImageHeightWithImage:image width:width]);
        
    }else{
        __weak typeof(self) weakSelf = self;
        [self setSettingRemoteImage:YES];
        [self sd_setImageWithURL:URL placeholderImage:placeholderImage options:SDWebImageAvoidAutoSetImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIImage cacheImage:image URL:URL size:CGSizeZero];
            if ([weakSelf settingRemoteImage]) {
                weakSelf.anyHeightConstraint.constant = [weakSelf screenScaleImageHeightWithImage:image width:width];
                [weakSelf setSettingRemoteImage:NO];
                block([weakSelf screenScaleImageHeightWithImage:image width:width]);
                
            }
        }];
    }
}
- (float )screenScaleImageHeightWithImage:(UIImage *)image width:(float)width
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float imageScale = imageHeight/imageWidth;
    return width * imageScale;
}

- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL size:(CGSize)size{
    [self setRoundedImageWithURL:URL placeholderImage:[UIImage imageForRoundedPlaceholderAvatar] size:size];
}
- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL{
    [self setRoundedAvatarWithURL:URL size:AGSizeByScreenScale(self.size)];
}

- (BOOL)settingRemoteImage{
    return [objc_getAssociatedObject(self, &SettingRemoteImageKey) boolValue];
}

- (void)setSettingRemoteImage:(BOOL)b{
    @synchronized(self) {
        objc_setAssociatedObject(self, &SettingRemoteImageKey, @(b), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setCoverWithColor:(UIColor *)color alpha:(CGFloat)alpha {
    UIView *markView = [UIView new];
    markView.backgroundColor = [color colorWithAlphaComponent:alpha];
    [self addSubview:markView];
    markView.el_edgesStickToSuperView();
}

- (void)setDefaultCoverColor {
    [self setCoverWithColor:[UIColor ag_G0] alpha:0.4];
}

- (void)ag_setImageWithAgfile:(AGFile *)file {
    [self sd_setImageWithURL:[file.url toURL] placeholderImage:[UIImage imageForPlaceholderNormal]];
}

- (void)ag_setImageWithAgfile:(AGFile *)file placeholderImage:(UIImage *)placeholderImage {
    [self sd_setImageWithURL:[file.url toURL] placeholderImage:placeholderImage];
}
@end
