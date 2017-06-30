//
//  UILabel+Extension.m
//  AppGame
//
//  Created by supozheng on 2017/5/25.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

-(void)setLabelLineSpace:(NSString*)str spacing:(float)spacint withFont:(UIFont*)font{
    [self setLabelLineSpace:str spacing:spacint withFont:font userName:@""];
}

-(void)setLabelLineSpace:(NSString*)str spacing:(float)spacint withFont:(UIFont*)font userName:(NSString *)userName{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = spacint; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    NSMutableAttributedString *attributeStr;
    if (![userName isEqualToString:@""]) {
       attributeStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",userName,str] attributes:dic];
        [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor di_MAIN2] range:NSMakeRange(0,userName.length +1)];
    }else{
        attributeStr = [[NSMutableAttributedString alloc] initWithString:str attributes:dic];
    }
    
    self.attributedText = attributeStr;
}

//-(void)setLabelSpace:withValue:(NSString*)str withFont:(UIFont*)font {
//    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
//    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
//    paraStyle.alignment = NSTextAlignmentLeft;
//    paraStyle.lineSpacing = 5; //设置行间距
//    paraStyle.hyphenationFactor = 1.0;
//    paraStyle.firstLineHeadIndent = 0.0;
//    paraStyle.paragraphSpacingBefore = 0.0;
//    paraStyle.headIndent = 0;
//    paraStyle.tailIndent = 0;
//    //设置字间距 NSKernAttributeName:@1.5f
//    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
//                          };
//    
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
//    label.attributedText = attributeStr;
//}
@end
