//
//  CorrelationGameCell.h
//  AppGame
//
//  Created by chan on 17/5/17.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CorrelationGameCellDelegate <NSObject>

-(void)clickCorrelationGameCell:(NSInteger)tag;

@end
@interface CorrelationGameCell : UITableViewCell

@property(nonatomic ,weak) id<CorrelationGameCellDelegate>delegate;
@property(nonatomic ,strong)NSArray *gameModelArr;
@end
