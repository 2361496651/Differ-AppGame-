//
//  NSMutableAttributedString+AGHelper.m
//  AGJointOperationSDK
//
//  Created by Mao on 16/3/3.
//  Copyright © 2016年 AppGame. All rights reserved.
//

#import "NSMutableAttributedString+AGHelper.h"
#import <objc/runtime.h>
char AGLastRangeKey;
char AGLastAttributedStringKey;

@implementation NSMutableAttributedString (AGHelper)
- (NSRange)lastRange{
    NSString *string = objc_getAssociatedObject(self, &AGLastRangeKey);
    if (!string) {
        return NSMakeRange(0, self.string.length);
    }
    return NSRangeFromString(string);
}
- (void)setLastRange:(NSRange)range{
    NSString *string = NSStringFromRange(range);
    objc_setAssociatedObject(self, &AGLastRangeKey, string, OBJC_ASSOCIATION_RETAIN);
}
- (NSMutableAttributedString*)lastAttributedString{
    return objc_getAssociatedObject(self, &AGLastAttributedStringKey);
}
- (void)setLastAttributedString:(NSMutableAttributedString*)attributedString{
    objc_setAssociatedObject(self, &AGLastAttributedStringKey, attributedString, OBJC_ASSOCIATION_RETAIN);
}
- (NSMutableAttributedString*(^)(UIFont*))ag_setFont{
    return ^NSMutableAttributedString*(UIFont *font){
        [self addAttribute:NSFontAttributeName value:font range:[self lastRange]];
        return self;
    };
}
- (NSMutableAttributedString*(^)(UIColor*))ag_setColor{
    return ^NSMutableAttributedString*(UIColor *color){
        [self addAttribute:NSForegroundColorAttributeName value:color range:[self lastRange]];
        return self;
    };
}
- (NSMutableAttributedString*(^)(UIColor*))ag_setBackgroundColor{
    return ^NSMutableAttributedString*(UIColor *color){
        [self addAttribute:NSBackgroundColorAttributeName value:color range:[self lastRange]];
        return self;
    };
}
- (NSMutableAttributedString*(^)(NSString*))ag_addString{
    return ^NSMutableAttributedString*(NSString *string){
        NSRange range = NSMakeRange(self.string.length, string.length);
        [self setLastRange:range];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [self setLastAttributedString:attributedString];
        [self appendAttributedString:attributedString];
        return self;
    };
}
@end

@implementation NSString (AGAttributedString)

- (NSMutableAttributedString*)ag_toAttributedString{
    return [[NSMutableAttributedString alloc] initWithString:self];
}

@end
