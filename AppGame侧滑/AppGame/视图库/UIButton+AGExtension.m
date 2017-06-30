//
//  UIButton+AGExtension.m
//  VideoCommunity
//
//  Created by Mao on 14/12/5.
//  Copyright (c) 2014年 AppGame. All rights reserved.
//

#import "UIButton+AGExtension.h"
#import <objc/runtime.h>
#import "UIImage+API.h"

static char WorkingKey;
static const NSInteger AGIndicatorViewTag = 10034;
static char SettingRemoteImageKey;

@interface UIButton ()

@end
@implementation UIButton (AGExtension)
- (BOOL)working{
    return [objc_getAssociatedObject(self, &WorkingKey) boolValue];
}
- (void)setWorking:(BOOL)working{
    objc_setAssociatedObject(self, &WorkingKey, @(WorkingKey), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (working) {
        self.hidden = YES;
        [self.indicatorView startAnimating];
    }else{
        self.hidden = NO;
        [self.indicatorView stopAnimating];
        [self.indicatorView removeFromSuperview];
    }
}
- (nonnull UIActivityIndicatorView*)indicatorView{
    UIActivityIndicatorView *aIndicatorView = (UIActivityIndicatorView*)[self.superview viewWithTag:AGIndicatorViewTag];
    if (!aIndicatorView) {
        aIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self.superview addSubview:aIndicatorView];
        aIndicatorView.center = self.center;
        aIndicatorView.tag = AGIndicatorViewTag;
        [aIndicatorView setHidesWhenStopped:YES];
        [[[self rac_signalForSelector:@selector(removeFromSuperview)] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(id x) {
            [aIndicatorView removeFromSuperview];
        }];
    }else{
        [aIndicatorView.superview bringSubviewToFront:aIndicatorView];
    }
    return aIndicatorView;
}

- (void)setRoundedImageWithURL:(nonnull NSURL*)URL placeholderImage:(nonnull UIImage*)image size:(CGSize)size{
    return [self setRoundedImageWithURL:URL placeholderImage:image size:size borderWidth:0];
}
- (void)setRoundedImageWithURL:(nonnull NSURL*)URL placeholderImage:(nonnull UIImage*)placeholderImage size:(CGSize)size borderWidth:(CGFloat)borderWidth{
    if (URL) {
        UIImage *aImage = [UIImage imageFromCahcheWithURL:URL size:size borderWidth:borderWidth];
        if (aImage) {
            [self setImage:[aImage imageWithOriginalRenderingMode] forState:UIControlStateNormal];
        }else{
            [self sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:placeholderImage options:SDWebImageAvoidAutoSetImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    UIImage *bImage = [image imageWithRoundedSize:size borderWidth:borderWidth];
                    [UIImage cacheImage:bImage URL:URL size:size borderWidth:borderWidth];
                    [self setImage:[bImage imageWithOriginalRenderingMode] forState:UIControlStateNormal];
                }
            }];
        }
    }
}

- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL size:(CGSize)size{
    if (URL) {
        [self setRoundedImageWithURL:URL placeholderImage:[UIImage imageForRoundedPlaceholderAvatar] size:size borderWidth:0];
    } else {
        [self setImage:[UIImage imageForRoundedPlaceholderAvatar] forState:UIControlStateNormal];
    }
}
- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL{
    [self setRoundedAvatarWithURL:URL size:AGSizeByScreenScale(self.size)];
}

- (void)setRoundedAvatarWithURL:(nonnull NSURL*)URL borderWidth:(CGFloat)borderWidth{
    //0.7干什么用的呢？图片加上边框，然后图片被放大了，所以近似接近borderWidth
    [self setRoundedImageWithURL:URL placeholderImage:[UIImage imageForRoundedPlaceholderAvatarWidthBorderWidth:borderWidth*0.7] size:AGSizeByScreenScale(self.size) borderWidth:borderWidth];
}

- (BOOL)settingRemoteImage{
    return [objc_getAssociatedObject(self, &SettingRemoteImageKey) boolValue];
}

- (void)setSettingRemoteImage:(BOOL)b{
    @synchronized(self) {
        objc_setAssociatedObject(self, &SettingRemoteImageKey, @(b), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color forState:(UIControlState)state {
    NSDictionary *attris = @{
                             NSFontAttributeName : font,
                             NSForegroundColorAttributeName : color
                             };
    NSAttributedString *attriString = [[NSAttributedString alloc] initWithString:title attributes:attris];
    [self setAttributedTitle:attriString forState:state];
}

@end
