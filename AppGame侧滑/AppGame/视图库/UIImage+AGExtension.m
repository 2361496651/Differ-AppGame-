//
//  UIImage+ImageUtil.m
//  AppGame
//
//  Created by 姚东海 on 1/8/14.
//  Copyright (c) 2014年 计 炜. All rights reserved.
//

#import "UIImage+AGExtension.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (AGExtension)
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size scale:(CGFloat)scale{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  颜色  生成图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size radius:(CGFloat)radius scale:(CGFloat)scale{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIBezierPath *maskShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.f, -1.f);
    CGContextAddPath(context, maskShape.CGPath);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size radius:(CGFloat)radius{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIBezierPath *maskShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.f, -1.f);
    CGContextAddPath(context, maskShape.CGPath);
    CGContextClip(context);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)horizontalGradientImageFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    gradientLayer.colors = @[(id)fromColor.CGColor, (id)toColor.CGColor];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)verticalGradientImageFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0.5, 0.0);
    gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    gradientLayer.colors = @[(id)fromColor.CGColor, (id)toColor.CGColor];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (UIImage *)horizontalGradientImageWithColors:(NSArray*)colors size:(CGSize)size{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    NSMutableArray *cgcolors = [NSMutableArray array];
    for (UIColor *each in colors) {
        [cgcolors addObject:(id)each.CGColor];
    }
    gradientLayer.colors = cgcolors;
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(gradientLayer.bounds.size, NO, [[UIScreen mainScreen] scale]);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
- (UIImage *)coverWithImage:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(self.size, YES, self.scale);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    //四个参数为水印图片的位置
    [image drawInRect:CGRectMake((self.size.width - image.size.width)/2, (self.size.height - image.size.height)/2, image.size.width, image.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
- (UIImage *)coverWithDefautlColor {
    UIImage *coverImage = [UIImage imageWithColor:[[UIColor ag_G0] colorWithAlphaComponent:0.4] andSize:self.size];
    return [self coverWithImage:coverImage];
}
+ (UIImage *)wireframeWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius{
    return [self wireframeWithColor:color size:size lineWith:1 cornerRadius:cornerRadius];
}
+ (UIImage *)wireframeWithColor:(UIColor *)color size:(CGSize)size lineWith:(CGFloat)lineWith cornerRadius:(CGFloat)cornerRadius{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
    CGContextSetLineWidth(ctx, lineWith);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:cornerRadius];
    [color setStroke];
    [path stroke];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
- (UIImage *)imageWithRoundedSize:(CGSize)size borderWidth:(CGFloat)borderWidth{
    UIImage *aImage = self;
    if (aImage.size.width < size.width) {
        aImage = [aImage scaleByFactor:size.width / aImage.size.width];
    }
    if (aImage.size.height < size.height) {
        aImage = [aImage scaleByFactor:size.height / aImage.size.height];
    }
    aImage = [self scaleToFillSize:size];
    aImage = [aImage imageWithRoundedWithBorderWidth:borderWidth];
    return aImage;
}
- (UIImage *)imageWithRoundedSize:(CGSize)size{
    return [self imageWithRoundedSize:size borderWidth:0];
}

- (UIImage *)imageWithRounded{
    return [self imageWithRoundedWithBorderWidth:0];
}

- (UIImage *)imageWithRoundedWithBorderWidth:(CGFloat)borderWidth{
    CGFloat inset = 1;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat cornerRadius;
    UIBezierPath *maskShape;
    if (width > height) {
        cornerRadius = height / 2.0 - inset;
        maskShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((width-height)/2.0 + inset, 0 + inset, height-2*inset, height-2*inset) cornerRadius:cornerRadius];
    }else{
        cornerRadius = width / 2.0 - inset;
        maskShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0+inset, (height-width)/2.0+inset, width-2*inset, width-2*inset) cornerRadius:cornerRadius];
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextAddPath(ctx, maskShape.CGPath);
    CGContextClip(ctx);
    
    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), self.CGImage);
    CGContextRestoreGState(ctx);
    
    if (borderWidth > 0) {
        [[UIColor whiteColor] setStroke];
        CGFloat halfWidth = borderWidth / 2.0;
        UIBezierPath *border = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(halfWidth, halfWidth, self.size.width - borderWidth , self.size.width - borderWidth)];
        CGContextSetShouldAntialias(ctx, YES);
        CGContextSetAllowsAntialiasing(ctx, YES);
        CGContextSetLineWidth(ctx, borderWidth);
        CGContextAddPath(ctx, border.CGPath);
        CGContextStrokePath(ctx);
        
    }
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
    
}

- (UIImage *)imageWithCornerRadius:(CGFloat)radius{
    CGFloat width = self.size.width * self.scale;
    CGFloat height = self.size.height * self.scale;
    UIBezierPath *maskShape = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:radius];
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, 1.f, -1.f);
    CGContextAddPath(ctx, maskShape.CGPath);
    CGContextClip(ctx);
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), self.CGImage);
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
- (UIImage *)imageWithCropRect:(CGRect)cropRect{
    CGImageRef result = CGImageCreateWithImageInRect(self.CGImage, cropRect);
    return [UIImage imageWithCGImage:result scale:self.scale orientation:self.imageOrientation];
}
- (UIImage *)imageToOrientationUp;{
    
    // No-op if the orientation is already correct
    UIImage *aImage = self;
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
+ (UIImage *)imageFromCahcheWithURL:(NSURL*)URL size:(CGSize)size{
    return [self imageFromCahcheWithURL:URL size:size borderWidth:0];
}

+ (UIImage *)imageFromCahcheWithURL:(NSURL*)URL size:(CGSize)size borderWidth:(CGFloat)borderWidth{
    return [[PINMemoryCache sharedCache] objectForKey:[self cachedImageKeyWithURL:URL size:size borderWidth:borderWidth]];
}
+ (void)cacheImage:(UIImage*)image URL:(NSURL*)URL size:(CGSize)size{
    return[self cacheImage:image URL:URL size:size borderWidth:0];
}
+ (void)cacheImage:(UIImage*)image URL:(NSURL*)URL size:(CGSize)size borderWidth:(CGFloat)borderWidth{
    [[PINMemoryCache sharedCache]  setObject:image forKey:[self cachedImageKeyWithURL:URL size:size borderWidth:borderWidth]];
}
+ (NSString*)cachedImageKeyWithURL:(NSURL*)URL size:(CGSize)size borderWidth:(CGFloat)borderWidth{
    if (borderWidth > 0) {
        return [NSString stringWithFormat:@"%@%@%@", URL, NSStringFromCGSize(size), @(borderWidth)];
    }
    return [NSString stringWithFormat:@"%@%@", URL, NSStringFromCGSize(size)];
}
- (UIImage *)imageWithOriginalRenderingMode{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
- (UIImage *)imageWithTemplateRenderingMode{
    return [self imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)stretchableImageWithImageName:(NSString *)imageName LeftCapWidth:(float)w topCapHeight:(float)h
{
    UIImage *stretchedImage = nil;
    [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:w topCapHeight:h];
    
    return stretchedImage;
}

//虚线
+ (UIImage *)drawImaginaryLineViewWithImageview:(UIImageView *)imageview
{
    float width  = imageview.frame.size.width;
    float height = imageview.frame.size.height;
    UIGraphicsBeginImageContext(imageview.frame.size);   //开始画线
    [imageview.image drawInRect:CGRectMake(0, 0, width, height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //设置线条终点形状
    
    
    CGFloat lengths[] = {5,3};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor HEX:0x585858].CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextSetLineWidth(line, 0.5);
    
    CGContextMoveToPoint(line, 0.0, 0);    //开始画线
    CGContextAddLineToPoint(line, width, 0);
    CGContextStrokePath(line);
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    return newImage;
}

+ (UIImage*)imageWithSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    if(!sampleBuffer){
        return nil;
    }
    CVImageBufferRef buffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    if (!buffer) {
        return nil;
    }
    CVPixelBufferLockBaseAddress(buffer, 0);
    
    uint8_t *base;
    size_t width, height, bytesPerRow;
    base = (uint8_t *)CVPixelBufferGetBaseAddress(buffer);
    width = CVPixelBufferGetWidth(buffer);
    height = CVPixelBufferGetHeight(buffer);
    bytesPerRow = CVPixelBufferGetBytesPerRow(buffer);
    
    CGColorSpaceRef colorSpace;
    CGContextRef cgContext;
    colorSpace = CGColorSpaceCreateDeviceRGB();
    cgContext = CGBitmapContextCreate(base, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);
    
    CGImageRef cgImage;
    UIImage *image;
    cgImage = CGBitmapContextCreateImage(cgContext);
    image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    CGContextRelease(cgContext);
    
    CVPixelBufferUnlockBaseAddress(buffer, 0);
    return image;
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    
    //convert to ARGB if it isn't
    if (CGImageGetBitsPerPixel(imageRef) != 32 ||
        CGImageGetBitsPerComponent(imageRef) != 8 ||
        !((CGImageGetBitmapInfo(imageRef) & kCGBitmapAlphaInfoMask)))
    {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        [self drawAtPoint:CGPointZero];
        imageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
        UIGraphicsEndImageContext();
    }
    
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
    
}
- (NSString *)ag_toJPEGBase64{
    NSData *pngData = UIImageJPEGRepresentation(self, 0.8);//UIImagePNGRepresentation(self);
    
    NSString *base64String = [pngData base64EncodedStringWithOptions:0];
    return base64String;
}
@end
