//
//  UIImage+API.m
//  AGVideo
//
//  Created by Mao on 16/4/25.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "UIImage+API.h"

@implementation UIImage (API)

+ (UIImage*)imageForChatCellBackgroud{
    UIImage *image = [[PINMemoryCache sharedCache] objectForKey:@"com.appgame.imageForChatCellBackgroud"];
    if (image) {
        return image;
    }
    image = [UIImage imageWithColor:[UIColor colorWithWhite:0 alpha:0.6] andSize:CGSizeMake(40, 31) radius:16 scale:[UIScreen mainScreen].scale];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
    [[PINMemoryCache sharedCache] setObject:image forKey:@"com.appgame.imageForChatCellBackgroud"];
    return image;
}

+ (UIImage*)defaultNavigationBackgroundImage{
    return [UIImage horizontalGradientImageWithColors:@[[UIColor HEX:0xF04143], [UIColor HEX:0xED3D5D]] size:CGSizeMake([AGUtilities screenWidth], 1)];
}

+ (UIImage*)likeImageForUserId:(NSString*)userId{
    static NSDictionary *colorsDic;
    if (!colorsDic) {
        colorsDic = @{@(0) : [UIImage imageNamed:@"喜欢1"],
                      @(1) : [UIImage imageNamed:@"喜欢2"],
                      @(2) : [UIImage imageNamed:@"喜欢3"],
                      @(3) : [UIImage imageNamed:@"喜欢4"],
                      @(4) : [UIImage imageNamed:@"喜欢5"],
                      @(5) : [UIImage imageNamed:@"喜欢6"],
                      @(6) : [UIImage imageNamed:@"喜欢7"],
                      @(7) : [UIImage imageNamed:@"喜欢8"],
                      @(8) : [UIImage imageNamed:@"喜欢9"]};
    }
    NSUInteger index = [userId characterAtIndex:userId.length-1] % colorsDic.count;
    return colorsDic[@(index)];
}

+ (UIImage *)imageForRoundedPlaceholderAvatar {
    UIImage *image = [[PINMemoryCache sharedCache] objectForKey:@"com.appgame.icouser"];
    if (!image) {
        image = [UIImage imageWithColor:[UIColor ag_G7] andSize:CGSizeMake(100, 100)];
        image = [image imageWithRoundedSize:image.size];
        if (image) {
            [[PINMemoryCache sharedCache] setObject:image forKey:@"com.appgame.icouser"];
        }
    }
    return image;
}

+ (UIImage *)imageForRoundedPlaceholderAvatarWidthBorderWidth:(CGFloat)borderWidth{
    UIImage *image = [[PINMemoryCache sharedCache] objectForKey:[NSString stringWithFormat:@"com.appgame.icouser_%@", @(borderWidth)]];
    if (!image) {
        image = [UIImage imageWithColor:[UIColor ag_G7] andSize:CGSizeMake(10, 10)];
        image = [image imageWithRoundedSize:image.size borderWidth:borderWidth];
        if (image) {
            [[PINMemoryCache sharedCache] setObject:image forKey:[NSString stringWithFormat:@"com.appgame.icouser_%@", @(borderWidth)]];
        }
    }
    return image;
}

+ (UIImage *)imageForPlaceholderNormal {
    UIImage *image = [[PINMemoryCache sharedCache] objectForKey:@"com.appgame.imageForPlaceholderNormal"];
    if (!image) {
        image = [UIImage imageWithColor:[UIColor ag_G7] andSize:CGSizeMake(1, 1)];
        if (image) {
            [[PINMemoryCache sharedCache] setObject:image forKey:@"com.appgame.imageForPlaceholderNormal"];
        }
    }
    return image;
}


+ (UIImage*)imageForDefaultPlaceHolderCover{
    return [UIImage imageNamed:@"封面默认图"];
}

+ (UIImage *)imageForUserCentralBackground {
    UIImage *image = [[PINMemoryCache sharedCache] objectForKey:@"com.appgame.userCentralBackgroundr"];
    if (!image) {
        image = [UIImage imageNamed:@"userCentre_background.jpg"];
        if (image) {
            [[PINMemoryCache sharedCache] setObject:image forKey:@"com.appgame.userCentralBackgroundr"];
        }
    }
    return image;
}

@end
