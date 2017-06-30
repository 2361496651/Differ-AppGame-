//
//  AnimationCell.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimationCellDelegate <NSObject>

- (void)animationCellStartAnimation;

@end

@interface AnimationCell : UICollectionViewCell

@property (nonatomic,assign)id<AnimationCellDelegate> delegate;

@property (nonatomic,copy)NSString *count;

@end






