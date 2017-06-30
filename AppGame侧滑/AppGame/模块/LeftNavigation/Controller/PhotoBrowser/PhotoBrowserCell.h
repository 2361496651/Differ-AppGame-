//
//  PhotoBrowserCell.h
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoBrowserCell;

@protocol PhotoBrowserCellDelegate <NSObject>

- (void)photoBrowserCellimageViewClick:(PhotoBrowserCell *)cell;




@end

@interface PhotoBrowserCell : UICollectionViewCell

@property (nonatomic,strong)NSURL *picUrl;

@property (nonatomic,weak)id<PhotoBrowserCellDelegate> delegate;

@property (nonatomic,strong)UIImageView *imageView;

@end
