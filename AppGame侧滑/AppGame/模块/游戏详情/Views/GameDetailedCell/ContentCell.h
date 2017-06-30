//
//  PictureCell.h
//  AppGame
//
//  Created by chan on 17/5/16.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameDetailModel.h"
@protocol ContentCellDelegate <NSObject>
- (void)showContentButtonAction:(UIButton *)button;
- (void)showImageAction:(NSMutableArray <UIImageView *> *)imageViews;
- (void)scrollViewHeight:(CGFloat)height;
@end

@interface ContentCell : UITableViewCell
@property(nonatomic, strong)UILabel *describeLB;
@property(nonatomic, strong)UIButton *showMoreBtn;

@property(nonatomic ,weak) id<ContentCellDelegate>delegate;
@property(nonatomic ,strong)GameDetailModel *gameDetailModel;


@end
