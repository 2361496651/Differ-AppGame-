//
//  PicCollectionView.h
//  AppGame
//
//  Created by zengchunjun on 2017/5/23.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoBrowserAnimation.h"

@interface PicCollectionView : UICollectionView<PhotoAnimationPresentedDelegate>

@property (nonatomic,strong)NSArray<NSURL *> *urls;

@end
