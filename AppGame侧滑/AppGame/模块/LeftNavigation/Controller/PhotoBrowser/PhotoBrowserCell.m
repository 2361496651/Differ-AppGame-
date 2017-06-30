//
//  PhotoBrowserCell.m
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import "PhotoBrowserCell.h"
#import "PhotoProgressView.h"

#import "SDWebImage/SDWebImageManager.h"
#import "UIImageView+WebCache.h"

@interface PhotoBrowserCell ()

@property (nonatomic,strong)UIScrollView *scrollView;
//@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)PhotoProgressView *progressView;


@end

@implementation PhotoBrowserCell

- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        CGRect frame = _scrollView.frame;
        frame.size.width -= 20;
        _scrollView.frame = frame;
    }
    return _scrollView;
}

- (PhotoProgressView *)progressView
{
    if (_progressView == nil) {
        _progressView = [[PhotoProgressView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _progressView.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
        _progressView.hidden = YES;
        _progressView.backgroundColor = [UIColor clearColor];
    }
    return _progressView;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick)];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tap];
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    
    [self.contentView addSubview:self.scrollView];
    
    [self.contentView addSubview:self.progressView];
    
    [self.scrollView addSubview:self.imageView];
    
    
    
}

- (void)imageViewClick
{
    if ([self.delegate respondsToSelector:@selector(photoBrowserCellimageViewClick:)]) {
        [self.delegate photoBrowserCellimageViewClick:self];
    }
}

- (void)setPicUrl:(NSURL *)picUrl
{
    _picUrl = picUrl;
    
    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:picUrl.absoluteString];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = (width / image.size.width) * image.size.height;
    CGFloat y = 0.0;
    if (height > screenH) {
        y = 0.0;
    }else{
        y = (screenH - height) * 0.5;
    }
    
    self.imageView.frame = CGRectMake(0, y, width, height);
    
//    self.progressView.hidden = NO;
    // 如果可以 这里需要放一张大图
    [self.imageView sd_setImageWithURL:picUrl placeholderImage:image options:0];
    self.scrollView.contentSize = CGSizeMake(width, height);
    
}

























@end
