//
//  UIButton+DifferFont.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/16.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "UIButton+DifferFont.h"
#import "DiffUtil.h"

//不同设备的屏幕比例(当然倍数可以自己控制)
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
//#define SizeScale  ((IPHONE_HEIGHT > 667) ?  1 : IPHONE_HEIGHT/667)
#define SizeScale IPHONE_HEIGHT/667


@implementation UIButton (DifferFont)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.titleLabel.tag != 333){
            CGFloat fontSize = self.titleLabel.font.pointSize;
            
            self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.fontName size:fontSize*SizeScale];
        }
    }
    return self;
}


@end

@implementation UILabel (DifferFont)

+ (void)load{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

- (id)myInitWithCoder:(NSCoder*)aDecode{
    [self myInitWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成333跳过
        if(self.tag != 333){
            CGFloat fontSize = self.font.pointSize;
//            self.font = [DiffUtil getDifferFont:fontSize*SizeScale];
            self.font = [UIFont fontWithName:self.font.fontName size:fontSize*SizeScale];
            
        }
    }
    return self;
}

@end
