//
//  WaterfallCell.h
//  AppGame
//
//  Created by chan on 17/5/3.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppraiseModel.h"
#import "GameModel.h"

@protocol WaterfallCellDelegate

-(void)clickCellTitle:(GameModel*)gameModel;

@end

@interface WaterfallCell : UICollectionViewCell

@property(nonatomic)id<WaterfallCellDelegate> delegate;
@property(nonatomic,strong)AppraiseModel *appraiseModel;

@end
