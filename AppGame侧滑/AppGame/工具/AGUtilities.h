//
//  APUilities.h
//  LittleGame
//
//  Created by Mao on 14-8-14.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ag_to_string(x) @#x
#define AGSizeByScreenScale(x) CGSizeMake(x.width * [UIScreen mainScreen].scale, x.height * [UIScreen mainScreen].scale) 
// 6+适配
#define AGValueMultiRatio(x) ((x) * [AGUtilities screenWidthRatio])

@interface AGUtilities : NSObject
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
+ (CGFloat)onePixelHeight;
+ (CGFloat)portraitScreenWidth;
+ (CGFloat)portraitScreenHeight;
//屏幕宽度比例，以iPhone6为基准
+ (CGFloat)screenWidthRatio;

+ (CVPixelBufferRef)createPixelBufferFromCGImage:(CGImageRef)image;
@end
