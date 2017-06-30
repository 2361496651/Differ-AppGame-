//
//  PhotoBrowserAnimation.h
//  PhotoBrowserDemo
//
//  Created by  zengchunjun on 2017/5/13.
//  Copyright © 2017年  zengchunjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PhotoAnimationPresentedDelegate <NSObject>

@required
- (CGRect)startRect:(NSIndexPath *)indexPath;
- (CGRect)endRect:(NSIndexPath *)indexPath;
- (UIImageView *)imageView:(NSIndexPath *)indexPath;

@end

@protocol PhotoAnimationDismissDelegate <NSObject>

@required
- (NSIndexPath *)indexPathForDismissView;
- (UIImageView *)imageViewForDismissView;

@end

@interface PhotoBrowserAnimation : NSObject<UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign)BOOL isPresented;
@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,assign)id<PhotoAnimationPresentedDelegate> presentedDelegate;
@property (nonatomic,assign)id<PhotoAnimationDismissDelegate> dismissDelegate;






@end
