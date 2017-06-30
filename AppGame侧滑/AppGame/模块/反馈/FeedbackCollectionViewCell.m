//
//  FeedbackCollectionViewCell.m
//  AppGame
//
//  Created by supozheng on 2017/5/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "FeedbackCollectionViewCell.h"

@implementation FeedbackCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


-(void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    self.radioButton = [[RadioButton alloc] init];
    [self.contentView addSubview:self.radioButton];
    self.radioButton.el_axisYToSuperView(0).el_leftToSuperView(5);
}



- (void)clickRadioButton:(UIGestureRecognizer *)gestureRecognizer {
//    UIView *view = (UIView*)[gestureRecognizer view];
//    NSInteger tagId = view.tag;
//    [self closeChoose:self.chooseIndex];
//    self.chooseIndex = tagId;
//    [self choose:tagId];
}

@end
