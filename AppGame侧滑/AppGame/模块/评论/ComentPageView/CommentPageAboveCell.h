//
//  CommentPageMainCell.h
//  AppGame
//
//  Created by chan on 17/5/8.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppraiseModel.h"
#import "TagsModel.h"


@protocol CommentPageAboveCellDelegate<NSObject>

-(void)clickCellTagAdd;
-(void)reloadTableView;
-(void)clickHeadIcon:(NSString*)userId;
-(void)clickSortBtn:(UIButton *)button;
@end

@interface CommentPageAboveCell : UITableViewCell

@property (nonatomic, strong) AppraiseModel *appraiseModel;
@property(nonatomic)id<CommentPageAboveCellDelegate> delegate;

-(float)setTagView:(NSMutableArray<TagsModel*>*) tagsList;
-(float)setTagView:(NSMutableArray<TagsModel*>*) tagsList isShowAddTagView:(BOOL)isShowAddTagView isLimitRows:(BOOL)isLimitRows;

-(void)setContentRow:(NSInteger)interger;
-(void)isShowMoreView:(BOOL)isShowMoreView isRemoveMoerView:(BOOL)isRemoveMoerView isShowRortBtn:(BOOL)isShowRortBtn;
@end
