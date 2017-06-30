//
//  GameScoreCell.h
//  AppGame
//
//  Created by chan on 17/5/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppraiseModel.h"
#import "GameModel.h"
@protocol GameScoreCellDelegate <NSObject>
@required
-(void)appraiseBtnAction;
-(void)pushAppraisePage;
@end

@interface GameScoreCell : UITableViewCell
@property(nonatomic ,weak) id<GameScoreCellDelegate>delegate;
@property(nonatomic,strong)NSMutableArray<AppraiseModel *> *appraiseList;
@property(nonatomic,strong)AppraiseModel *myAppraiseModel;
@property(nonatomic,strong)GameModel *gameModel;


-(CGFloat) setMyappraiseModelOfHigtReturns:(AppraiseModel *)myAppraiseModel;
@end
