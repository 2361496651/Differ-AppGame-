//
//  WaterFallLayout.h
//  AppGame
//
//  Created by chan on 17/5/2.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterfallLayout;
@protocol WaterfallLayoutDelegate <NSObject>
@required
- (CGFloat)waterLayout:(UICollectionViewLayout *)waterLayout itemWidth:(CGFloat)itemWidte indexPath:(NSIndexPath *)indexPath;
@optional
/** 行间距 */
- (CGFloat)rowIntervalInWaterFlowLayout:(UICollectionViewLayout *)layout;
/** 列间距 */
- (CGFloat)columnIntervalInWaterFlowLayout:(UICollectionViewLayout *)layout;
/** 列数 */
- (NSInteger)columnCountInWaterFlowLayout:(UICollectionViewLayout *)layout;
/** collectionView内边距 */
- (UIEdgeInsets)edgeInsetsInWaterFlowLayout:(UICollectionViewLayout *)layout;
@end


@interface WaterfallLayout : UICollectionViewLayout

//代理属性
@property (nonatomic, weak) id<WaterfallLayoutDelegate> delegate;

@end
