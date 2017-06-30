//
//  PhotoBrowserVC.h
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserAnimation.h"

@interface PhotoBrowserVC : UIViewController<PhotoAnimationDismissDelegate>

@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)NSArray<NSURL *> *picURLs;

@end



@interface PhotoBrowserCollectionViewFlowLayout : UICollectionViewFlowLayout

@end
