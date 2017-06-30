//
//  MyPageControl.h
//  AppGame
//
//  Created by zengchunjun on 2017/4/17.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPageControl : UIPageControl
{
    UIImage *imagePageStateNormal;
    UIImage *imagePageStateHighlighted;
}
- (id)initWithFrame:(CGRect)frame;
@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;
@end
