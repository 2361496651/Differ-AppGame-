//
//  APUilities.m
//  LittleGame
//
//  Created by Mao on 14-8-14.
//  Copyright (c) 2014年 Mao. All rights reserved.
//

#import "AGUtilities.h"
#import <CoreText/CoreText.h>
#import <ImageIO/ImageIO.h>

@implementation AGUtilities
+ (CGFloat)screenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}
+ (CGFloat)screenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}
+ (CGFloat)onePixelHeight{
    return 1.0/[[UIScreen mainScreen] scale];
}
+ (CGFloat)portraitScreenWidth{
    return [UIScreen mainScreen].nativeBounds.size.width / [UIScreen mainScreen].nativeScale;
}
+ (CGFloat)portraitScreenHeight{
    
    return [UIScreen mainScreen].nativeBounds.size.height / [UIScreen mainScreen].nativeScale;
}
+ (CGFloat)screenWidthRatio{
    if ([UIScreen mainScreen].nativeScale > 2.1) {
        return [self portraitScreenWidth] / [self __47ScreenWidth];
    } else {
        return 1;
    }
}
+ (CGFloat)__47ScreenWidth{
    return 375;
}

/*
void dataFromImageDataProviderReleaseCallback(void *releaseRefCon, const void *baseAddress)
{
    CFRelease(releaseRefCon);
}

+ (CVPixelBufferRef)createPixelBufferFromCGImage:(CGImageRef)image{
    
    CVPixelBufferRef pxbuffer = NULL;
    size_t width =  CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    size_t bytesPerRow = CGImageGetBytesPerRow(image);
    CFDataRef  dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image));
    GLubyte  *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    CVPixelBufferCreateWithBytes(kCFAllocatorDefault,width,height,kCVPixelFormatType_32BGRA,imageData,bytesPerRow,dataFromImageDataProviderReleaseCallback,(void*)dataFromImageDataProvider,NULL,&pxbuffer);
    return pxbuffer;
}
 */
+ (CVPixelBufferRef)createPixelBufferFromCGImage:(CGImageRef)image{
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image),
                                  CGImageGetHeight(image));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@YES, kCVPixelBufferCGImageCompatibilityKey,
     @YES, kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width, frameSize.height, kCVPixelFormatType_32BGRA, (__bridge CFDictionaryRef)options, &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(
                                                 pxdata, frameSize.width, frameSize.height,
                                                 8, CVPixelBufferGetBytesPerRow(pxbuffer),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGBitmapByteOrder32Little |
                                                 kCGImageAlphaPremultipliedFirst);
    
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image),
                                           CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    return pxbuffer;
}
@end
