//
//  RadioButton.m
//  AppGame
//
//  Created by supozheng on 2017/5/26.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "RadioButton.h"
#import "ViewFactory.h"

@implementation RadioButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    [self createRadioButton:NO text:@""];
}

-(UIView*)createRadioButton:(BOOL)isChoose text:(NSString*)text{
    self.circleView = [UIView new];
    [self addSubview:self.circleView];
    if(isChoose){
        UIView *cView = [ViewFactory createCircleView:self.circleView backgroundColor:[UIColor di_MAIN2] size:CGSizeMake(12, 12)];
        [self.circleView addSubview:cView];
        cView.el_topToSuperView(0).el_leftToSuperView(0);
        self.circleView.el_toSize(CGSizeMake(12, 12)).el_axisYToSuperView(0);
        
        self.textLabel = [ViewFactory createLabel:self fontSize:16 text:text textcolor:[UIColor blackColor]];
        self.textLabel.el_leftToRight(self.circleView,10).el_axisYToAxisY(self.circleView,0).el_toSize(CGSizeMake(150, 40));
    }else{
        UIView *cView = [ViewFactory createEmptyCircleView:self.circleView borderColor:[UIColor grayColor]  size:CGSizeMake(10, 10) borderWidth:2.0];
        [self.circleView addSubview:cView];
        cView.el_topToSuperView(0).el_leftToSuperView(0);
        self.circleView.el_toSize(CGSizeMake(10, 10)).el_axisYToSuperView(0).el_leftToSuperView(0);
        
        self.textLabel = [ViewFactory createLabel:self fontSize:16 text:text textcolor:[UIColor grayColor]];
        self.textLabel.el_leftToRight(self.circleView,10).el_axisYToAxisY(self.circleView,0).el_toSize(CGSizeMake(150, 40));
    }
    return self;
}

-(void)choose:(BOOL)isChoose{    
    [self.circleView removeAllSubviews];
    if(isChoose){
        UIView *cView = [ViewFactory createCircleView:self.circleView backgroundColor:[UIColor di_MAIN2] size:CGSizeMake(12, 12)];
        [self.circleView addSubview:cView];
        cView.el_topToSuperView(0).el_leftToSuperView(0);
        self.textLabel.textColor = [UIColor di_MAIN2];
    }else{
        UIView *cView = [ViewFactory createEmptyCircleView:self.circleView borderColor:[UIColor grayColor]  size:CGSizeMake(10, 10) borderWidth:2.0];
        [self.circleView addSubview:cView];
        cView.el_topToSuperView(0).el_leftToSuperView(0);
        self.textLabel.textColor = [UIColor grayColor];
    }
    
}
@end
