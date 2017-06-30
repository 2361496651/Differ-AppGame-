//
//  CustomSettingBtn.m
//  Ecm
//
//  Created by zengchunjun on 16/12/5.
//
//

#import "CustomSettingBtn.h"

#define screenW [UIScreen mainScreen].bounds.size.width

@implementation CustomSettingBtn

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //设置图片的显示样式
        self.imageView.contentMode = UIViewContentModeRight;
        
        self.titleLabel.contentMode = UIViewContentModeLeft;
    }
    
    return self;
    
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(screenW/6 + 8, 0, screenW/6 - 8, 44);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 0, screenW/6, 44);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
