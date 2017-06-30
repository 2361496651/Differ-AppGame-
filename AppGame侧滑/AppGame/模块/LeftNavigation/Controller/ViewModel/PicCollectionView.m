//
//  PicCollectionView.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/23.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "PicCollectionView.h"
#import "PicCollectionCell.h"
#import "GlobelConst.h"
#import "PhotoBrowserAnimation.h"

@interface PicCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>



@end

@implementation PicCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.dataSource = self;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate = self;
    
    [self registerNib:[UINib nibWithNibName:@"PicCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"PicCollectionCell"];
}

- (void)setUrls:(NSArray<NSURL *> *)urls
{
    _urls = urls;
    
    [self reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PicCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PicCollectionCell" forIndexPath:indexPath];
    cell.picUrl = self.urls[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userInfo = @{ShowPhotoBrowserIndexKey : indexPath , ShowPhotoBrowserUrlsKey:self.urls};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowPhotoBrowserNote object:self userInfo:userInfo];
}

#pragma mark  PhotoAnimationPresentedDelegate

- (CGRect)startRect:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    CGRect startRect = [self convertRect:cell.frame toCoordinateSpace:[UIApplication sharedApplication].keyWindow];
    return startRect;
}
- (CGRect)endRect:(NSIndexPath *)indexPath
{
    NSURL *url = self.urls[indexPath.item];
    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:url.absoluteString];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    CGFloat height = (width / image.size.width) * image.size.height;
    CGFloat y = 0.0;
    if (height > screenH) {
        y = 0.0;
    }else{
        y = (screenH - height) * 0.5;
    }
    
    return CGRectMake(0, y, width, height);
}
- (UIImageView *)imageView:(NSIndexPath *)indexPath
{
    UIImageView *imageView = [[UIImageView alloc]init];
    NSURL *url = self.urls[indexPath.item];
    UIImage *image = [[[SDWebImageManager sharedManager] imageCache] imageFromDiskCacheForKey:url.absoluteString];
    
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    
    return imageView;
    
}


@end
