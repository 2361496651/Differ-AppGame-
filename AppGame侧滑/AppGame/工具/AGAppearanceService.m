//
//  AppearanceService.m
//  LittleGame
//
//  Created by Mao on 14-8-22.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import "AGAppearanceService.h"
#import "UIImage+AGExtension.h"

@implementation AGAppearanceService

+ (void)setDefaultAppearanceSetting{
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor ag_G1],
                                                           NSFontAttributeName : [UIFont ag_mediumFontOfSize:17],
                                                           }];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    UIImage *backButtonImage = [[UIImage imageNamed:@"icon_go_grey."] imageWithOriginalRenderingMode];
    [[UIBarButtonItem  appearance] setBackButtonBackgroundImage:[backButtonImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backButtonImage.size.width, 0, 0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIButton *btn = [UIButton appearanceWhenContainedIn:[UIActionSheet class], nil];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
}

    
@end

@implementation UIColor (AGAppearance)

+ (UIColor*)ag_MAIN{
    return [UIColor HEX:0x252d43];
}

+ (UIColor*)ag_G0{
    return [UIColor HEX:0x141324];
}
+ (UIColor*)ag_G1{
    return [UIColor HEX:0x373d54];
}
+ (UIColor*)ag_G2{
    return [UIColor HEX:0x636c8f];
}
+ (UIColor*)ag_G3{
    return [UIColor HEX:0x8c97ba];
}
+ (UIColor*)ag_G4{
    return [UIColor HEX:0xc5cde6];
}
+ (UIColor*)ag_G5{
    return [UIColor HEX:0xf1f2f4];
}
+ (UIColor*)ag_G6{
    return [UIColor HEX:0xaaafc7];
}
+ (UIColor*)ag_G7{
    return [UIColor HEX:0xe2e6f3];
}

+ (UIColor*)ag_P1{
    return [UIColor HEX:0x7c8aff];
}
+ (UIColor*)ag_P2{
    return [UIColor HEX:0x9aa9e4];
}

+ (UIColor*)ag_R1{
    return [UIColor HEX:0xfe4d67];
}

+ (UIColor*)ag_W1{
    return [UIColor HEX:0xffffff];
}

+ (UIColor*)di_Circle1{
    return [UIColor HEX:0xdddddd];
}
+ (UIColor*)di_MAIN2{
    return [UIColor HEX:0x15b1b8];
}

+ (UIColor*)di_Page1{
    return [UIColor HEX:0xd8d8d8];
}

@end

@implementation UIFont (AGAppearance)

+ (UIFont*)ag_lightFontOfSize:(NSInteger)size{
    return [UIFont systemFontOfSize:size weight:UIFontWeightLight];
}
+ (UIFont*)ag_regularFontOfSize:(NSInteger)size{
    return [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
}
+ (UIFont*)ag_mediumFontOfSize:(NSInteger)size{
    return [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
}

@end
