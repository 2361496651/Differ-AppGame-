//
//  TagView.h
//  AppGame
//
//  Created by chan on 17/5/8.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagView : UIView

typedef NS_ENUM(NSInteger , TagType){
    TagTypeDottedLine,
    TagTypeSolidLine,
};

@property (nonatomic, strong) UILabel *tagText;

-(UIView *) initWithFrame:(CGRect)frame TagType:(TagType) tagType BorderColor:(UIColor *)color;
@end
