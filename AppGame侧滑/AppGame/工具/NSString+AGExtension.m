//
//  NSString+Extension.m
//  CocoapodTest
//
//  Created by tage on 14-4-9.
//  Copyright (c) 2014年 cn.kaakoo. All rights reserved.
//

#import "NSString+AGExtension.h"
#import <CommonCrypto/CommonDigest.h>
#import <BTLabel.h>


@implementation NSString (Extension)
+ (NSString*)randomWordsNoCaptialWithLength:(NSUInteger)len{
    static NSArray *words;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        words = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",
                  @"h",@"i",@"j",@"k",@"l",@"m",@"n",
                  @"o",@"p",@"q",@"r",@"s",@"t",
                  @"u",@"v",@"w",@"x",@"y",@"z",
                  @"0",@"1",@"2",@"3",@"4",
                  @"5",@"6",@"7",@"8",@"9"];
    });
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < len; ++i) {
        [result appendString:words[arc4random()%36]];
    }
    return result;
}
+ (NSString*)randomWordsWithLength:(NSUInteger)len{
    static NSArray *words;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        words = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",
                  @"h",@"i",@"j",@"k",@"l",@"m",@"n",
                  @"o",@"p",@"q",@"r",@"s",@"t",
                  @"u",@"v",@"w",@"x",@"y",@"z",
                  @"A",@"B",@"C",@"D",@"E",@"F",@"G",
                  @"H",@"I",@"J",@"K",@"L",@"M",@"N",
                  @"O",@"P",@"Q",@"R",@"S",@"T",
                  @"U",@"V",@"W",@"X",@"Y",@"Z",
                  @"0",@"1",@"2",@"3",@"4",
                  @"5",@"6",@"7",@"8",@"9"];
    });
    NSMutableString *result = [NSMutableString string];
    for (NSUInteger i = 0; i < len; ++i) {
        [result appendString:words[arc4random()%62]];
    }
    return result;
}
- (NSURL*)toURL{
    NSString *aString = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    aString = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([aString rangeOfString:@"%"].location == NSNotFound) {
        aString = [aString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return [NSURL URLWithString:aString];
}
- (NSString *)thumbnailPath{
    return [self stringByAppendingString:@"thumbnail"];
}
- (NSString *)MD5
{
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];

    CC_MD5(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
    ;
}

- (NSString *)SHA1
{
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];

    CC_SHA1(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
    ;
}

- (NSString *)SHA256
{
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];

    CC_SHA256(self.UTF8String, [self UTF8Length], output);
    return [self toHexString:output length:outputLength];
    ;
}

- (NSInteger)countOfSubstring:(NSString*)subString{
    NSRange range = [self rangeOfString:subString];
    NSInteger count = 0;
    while (range.location != NSNotFound) {
        count++;
        range = [self rangeOfString:subString options:NSCaseInsensitiveSearch range:NSMakeRange(NSMaxRange(range), self.length - NSMaxRange(range))];
    }
    return count;
}
- (NSInteger)locationOfSubstring:(NSString*)subString atIndex:(NSInteger)index{
    NSRange range = [self rangeOfString:subString];
    NSInteger count = 0;
    while (range.location != NSNotFound) {
        if (count == index) {
            return range.location;
        }
        count++;
        range = [self rangeOfString:subString options:NSCaseInsensitiveSearch range:NSMakeRange(NSMaxRange(range), self.length - NSMaxRange(range))];
    }
    return NSNotFound;
}

- (BOOL)maxLineWhenReturnWithSubstring:(NSString*)subString atIndex:(NSInteger)index
{
    NSRange range = [self rangeOfString:subString];
    NSInteger count = 0;
    while (range.location != NSNotFound) {
        if (count == index) {
            return YES;
        }
        count++;
        range = [self rangeOfString:subString options:NSCaseInsensitiveSearch range:NSMakeRange(NSMaxRange(range), self.length - NSMaxRange(range))];
    }
    return NO;

}
+ (NSString*)prettyDisplayWithInt:(NSInteger)i{
    if (i >= 1000 && i < 10000) {
        return [NSString stringWithFormat:@"%.1fk", i/1000.0];
    }
    if (i >= 10000 && i < 10000000) {
        return [NSString stringWithFormat:@"%.1fw", i/10000.0];
    }
    if (i >= 10000000) {
        return [NSString stringWithFormat:@"%.1fkw", i/10000000.0];
    }
    return [NSString stringWithFormat:@"%@", @(i)];
}

+ (NSString*)prettyTimeStringWithInt:(NSInteger)interval{
    NSInteger h = interval/3600;
    NSInteger m = (interval - h * 3600)/60;
    NSInteger s = interval - h * 3600 - m * 60;
    return [NSString stringWithFormat:@"%02zi:%02zi:%02zi",h, m ,s];
}

- (unsigned int)UTF8Length
{
    return (unsigned int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)toHexString:(unsigned char *)data length:(unsigned int)length
{
    NSMutableString *hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return hash;
}

- (NSString *)cachedFileName
{
    if (self) {
        const char *str = [self UTF8String];
        if (str == NULL) {
            str = "";
        }
        unsigned char r[CC_MD5_DIGEST_LENGTH];
        CC_MD5(str, (CC_LONG)strlen(str), r);
        NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                                                        r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];

        return filename;
    } else {
        return nil;
    }
}

- (BOOL)containsEmoji
{
    if (self) {
        __block BOOL returnValue = NO;
        [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
                                                                                                                                   ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
             
             const unichar hs = [substring characterAtIndex:0];
             // surrogate pair
             if (0xd800 <= hs && hs <= 0xdbff) {
                 if (substring.length > 1) {
                     const unichar ls = [substring characterAtIndex:1];
                     const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                     if (0x1d000 <= uc && uc <= 0x1f77f) {
                         returnValue = YES;
                     }
                 }
             } else if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 if (ls == 0x20e3) {
                     returnValue = YES;
                 }
                 
             } else {
                 // non surrogate
                 if (0x2100 <= hs && hs <= 0x27ff) {
                     returnValue = YES;
                 } else if (0x2B05 <= hs && hs <= 0x2b07) {
                     returnValue = YES;
                 } else if (0x2934 <= hs && hs <= 0x2935) {
                     returnValue = YES;
                 } else if (0x3297 <= hs && hs <= 0x3299) {
                     returnValue = YES;
                 } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                     returnValue = YES;
                 }
             }
                                                                                                                                   }];

        return returnValue;
    } else {
        return NO;
    }
}

- (BOOL)containsSpecialChar
{
    if (self) {
        char *utf8Replace = "\xe2\x80\x86\0";

        NSData *data = [NSData dataWithBytes:utf8Replace length:strlen(utf8Replace)];

        NSString *utf8_str_format = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        if ([self rangeOfString:utf8_str_format].location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)deleteSpecialChar
{
    if (self) {
        char *utf8Replace = "\xe2\x80\x86\0";

        NSData *data = [NSData dataWithBytes:utf8Replace length:strlen(utf8Replace)];

        NSString *utf8_str_format = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSMutableString *mutableAblumName = [NSMutableString stringWithString:self];

        return [mutableAblumName stringByReplacingOccurrencesOfString:utf8_str_format withString:@""];
    } else {
        return nil;
    }
}
+ (NSString *)ag_UUID
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref = CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}


-(BOOL)checkPhoneNumInput{
    //放宽校验，因为很多虚拟运营商了，很多开头的号码都有了，因此放宽检测条件为1开头的11位数字
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}


- (id)objectFromJSONString{
    NSData *aData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:aData options:0 error:nil];
}
- (NSArray*)arrayFromJSONString{
    NSArray *aArray = [self objectFromJSONString];
    if ([aArray isKindOfClass:[NSArray class]]) {
        return aArray;
    }
    return nil;
}
- (NSDictionary*)dictionaryFromJSONString{
    NSDictionary *aDictionary = [self objectFromJSONString];
    if ([aDictionary isKindOfClass:[NSDictionary class]]) {
        return aDictionary;
    }
    return nil;
}
-(NSString*)replacingDictionary:(NSDictionary*)replacedic{
    NSString * replacestring=self;
    if ([replacedic isKindOfClass:[NSDictionary class]]&&replacedic.count>0) {
        for(NSString *key in replacedic){
            replacestring = [self stringByReplacingOccurrencesOfString:key withString:[replacedic objectForKey:key]];
        }
        
    }
    return replacestring;
}


-(NSDictionary*)getResponseDictionary{
    __block NSString *  jsonString=self;
    NSError *error;
    //(.|\\s)*或([\\s\\S]*)可以匹配包括换行在内的任意字符
    NSRegularExpression *regexW3tc = [NSRegularExpression
                                      regularExpressionWithPattern:@"<!-- W3 Total Cache:([\\s\\S]*)-->"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
    [regexW3tc enumerateMatchesInString:jsonString
                                options:0
                                  range:NSMakeRange(0, jsonString.length)
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 jsonString=[jsonString stringByReplacingOccurrencesOfString:[jsonString substringWithRange:result.range] withString:@""];
                             }];
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    // fetch the json response to a dictionary
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    // pass it to the block
    // check the code (success is 0)
    
    return responseDictionary;
}



-(NSString*)filtration:(NSString*)regEx_html{
    
    __block  NSString * Filtrationstring=self;
    NSError *error;
    //(.|\\s)*或([\\s\\S]*)可以匹配包括换行在内的任意字符
    //NSString *regEx_html = "<[^>]+>";
    NSRegularExpression *regexW3tc = [NSRegularExpression
                                      regularExpressionWithPattern:@"<[^>]+>"
                                      options:NSRegularExpressionCaseInsensitive
                                      error:&error];
    
    [regexW3tc enumerateMatchesInString:regEx_html
                                options:0
                                  range:NSMakeRange(0, regEx_html.length)
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                 
                                 Filtrationstring= [Filtrationstring stringByReplacingOccurrencesOfString:[regEx_html substringWithRange:result.range] withString:@""];
                             }];
    
    return Filtrationstring = [Filtrationstring stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(BOOL)isEmpty{
    return [self isEqualToString:@""];
}

/**
 *   是否装有APP
 *
 *  @return 是否
 */
-(BOOL)isInstallationApp{
    
    NSURL *url = [NSURL URLWithString:self];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return YES;
    }else{
        return NO;
    }
}


/**
 *  安装APP
 */
-(void)installApp{
    NSURL *url = [NSURL URLWithString:self];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}



/**
 *  检测是否为邮箱
 *  @return 是否是
 */
- (BOOL) validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}



/**
 *  需要过滤的特殊字符
 *  @return 是否是
 */
-(BOOL)isIncludeSpecialCharact{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€-"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

/**
 *  是否有中文
 *  @return 是否是
 */
-(BOOL)isChineseWord{
    BOOL yes=NO;
    
    NSUInteger length = [self length];
    
    for (NSUInteger i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [self substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            return YES;
            NSLog(@"汉字:%s", cString);
        }
    }
    
    return yes;
}

/**
 *  是否为数字
 *  @return 是否是
 */
-(BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

/**
 *  截止nstring 的颜色
 *
 *  @param nstringArray 要截止的nsstring
 *  @param cutcolor     截止的nsstring 的颜色
 *  @return NSMutableAttributedString
 */

-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)stringArray AndColor:(UIColor*)cutcolor{
    NSMutableAttributedString * customAttributedString=[[NSMutableAttributedString alloc]initWithString:self];
    if ([stringArray isKindOfClass:[NSArray class]]) {
        for (NSString * cutnstring in stringArray) {
            NSRange curtrange= [self cutoffPostion:cutnstring];
            [customAttributedString addAttribute:NSForegroundColorAttributeName value:cutcolor range:curtrange];
        }
    }
    
    return customAttributedString;
}


/**
 *  截止nstring 的颜色
 *
 *  @param stringArray 要截止的nsstring
 *  @param cutcolor    截止的nsstring 的颜色
 *  @param font        字体
 *
 *  @return NSMutableAttributedString
 */
-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)stringArray AndColor:(UIColor*)cutcolor AndFont:(UIFont*)font{
    NSMutableAttributedString * customAttributedString= [self getAttributedColornstringWithArray:stringArray AndColor:cutcolor];
    [customAttributedString addAttribute:NSFontAttributeName value:font range:[self rangeOfString:self]];
    return customAttributedString;
}


/**
 *  截止nstring 的颜色
 *
 *  @param dicArray @param dicArray 添加 NSDictionary 要截止的nsstring key为(string) 截止的nsstring 的颜色 key为(color)
 *  @param font     字体
 *
 *  @return NSMutableAttributedString
 */
-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)dicArray AndFont:(UIFont*)font{
    NSMutableAttributedString * customAttributedString=[self getAttributedColornstringWithArray:dicArray];
    [customAttributedString addAttribute:NSFontAttributeName value:font range:[self rangeOfString:self]];
    return customAttributedString;
}


/**
 *  截止nstring 的颜色
 *
 *  @param dicArray 添加 NSDictionary 要截止的nsstring key为(string) 截止的nsstring 的颜色 key为(color) 截止的nsstring 的font key为(font)
 *
 * @return NSMutableAttributedString
 */
-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)dicArray{
    NSMutableAttributedString * customAttributedString=[[NSMutableAttributedString alloc]initWithString:self];
    
    if ([dicArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary * dic in dicArray) {
            NSString * cutnstring= [dic objectForKey:@"string"];
            UIColor * curtcolor=[dic objectForKey:@"color"];
            UIFont * curtfont=[dic objectForKey:@"font"];
            int lineSpacing_h=[[dic objectForKey:@"linespacing"]intValue];
            NSRange curtrange= [self cutoffPostion:cutnstring];
            if ([cutnstring isKindOfClass:[NSString class]]) {
                if ([curtcolor isKindOfClass:[UIColor class]]) {
                    [customAttributedString addAttribute:NSForegroundColorAttributeName value:curtcolor range:curtrange];
                }
                if ([curtfont isKindOfClass:[UIFont class]] ) {
                    [customAttributedString addAttribute:NSFontAttributeName value:curtfont range:curtrange];
                    
                }
                if (lineSpacing_h>0) {
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineSpacing=lineSpacing_h;
                    [customAttributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:curtrange];
                }
            }
        }
    }
    
    return customAttributedString;
}



/**
 *  自定截止nstring 的颜色 大小
 *
 *  @param dicArray dicArray 添加 NSDictionary 要截止的nsstring key为(string) 截止的nsstring 的颜色 key为(color) 截止的nsstring 的font key为(font)
 *  @param font     其它的大小
 *
 *  @return NSMutableAttributedString
 */
-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)dicArray otherFont:(UIFont*)font{
    NSMutableAttributedString * customAttributedString=[[NSMutableAttributedString alloc]initWithString:self];
    [customAttributedString addAttribute:NSFontAttributeName value:font range:[self rangeOfString:self]];
    customAttributedString=[self getAttributedColornstringWithArray:dicArray];
    return customAttributedString;
}

- (NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                 withLineHeightMultiple:(CGFloat)lineHeightMultiple
                                                       withColor:(UIColor *)color
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:color}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = lineHeightMultiple;
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    
    return attributedStr;
}

- (CGSize)setUILabelSizeWithfont:(CGFloat)fontSize xianHeight:(CGFloat)height xianWidth:(CGFloat)width
{
//    UIFont *font = [UIFont fontWithName:@"Arial" size:fontSize];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    //设置一个行高上限
    CGSize size = CGSizeMake(width,height);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize;
    if (AG_IOS7_OR_LATER) {
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
        labelsize = [self boundingRectWithSize:size options:(NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    }else{
        labelsize = [self sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return labelsize;
}

- (CGSize)setUILabelSizeWithfont:(CGFloat)fontSize xianHeight:(CGFloat)height xianWidth:(CGFloat)width withLineHeightMultiple:(CGFloat)lineHeightMultiple
{
    //设置一个行高上限
    CGSize size = CGSizeMake(width,height);
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize labelsize;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = lineHeightMultiple;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
                                NSParagraphStyleAttributeName : paragraphStyle
                                };
    labelsize = [self boundingRectWithSize:size options:(NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) attributes:attribute context:nil].size;
    return labelsize;
}

/**
 *  取得截止nstring cutoffPostion
 *
 *  @param cutoffnstring 截止 nstring
 *
 *  @return 截止 NSRange
 */
-(NSRange)cutoffPostion:(NSString*)cutoffnstring{
    NSRange range = [self rangeOfString:cutoffnstring];
    return range;
}

/**
 *  复制字符串到剪贴板
 */
-(void)copyStringTopasteboard{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =self;
}




/**
 *  数字转换
 *
 *  @return 数字
 */
-(NSString*)numberconversion{
    NSString * numbverstring=self;
    
    int number=[numbverstring intValue];
    
    if (number > 100000000) {
        numbverstring=[NSString stringWithFormat:@"%d亿",(number / 100000000)];
    }else if (number > 10000){
        numbverstring=[NSString stringWithFormat:@"%d万",(number / 10000)];
        
    }else{
        numbverstring=[NSString stringWithFormat:@"%d",number];
    }
    return numbverstring;
}

+ (NSString *)ag_numberConversion:(NSInteger)number {
    NSString *numbverstring = nil;
    if (number > 100000000) {
        numbverstring=[NSString stringWithFormat:@"%0.1f亿",(number / 100000000.0)];
    }else if (number > 10000){
        numbverstring=[NSString stringWithFormat:@"%0.1f万",(number / 10000.0)];
        
    }else{
        numbverstring=[NSString stringWithFormat:@"%zd",number];
    }
    return numbverstring;
}

- (CGFloat)di_getLabelHeightFontSize:(CGFloat)fontSize Width:(CGFloat)width{
    
    return [self di_getLabelHeightFontSize:fontSize Width:width numberOfLines:0];
}

- (CGFloat)di_getLabelHeightFontSize:(CGFloat)fontSize Width:(CGFloat)width numberOfLines:(NSInteger)integer{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width ,0)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = integer;
    label.text = self;
    [label sizeToFit];
        
    return label.height;
}

/**
 * 通过字符串计算文本需要的大小
 * @param font 字体
 * @param width 宽度限制 不限制可传CGFLOAT_MAX
 * 说明：换行符也按照字符串处理比如\n\r
 */
-(CGSize)di_sizeOfStringToLable:(UIFont*)font width:(CGFloat)width{
    CGFloat maxWidth = width;
    CGSize maxSize = CGSizeMake(maxWidth, CGFLOAT_MAX);
    
    CGSize textSize = CGSizeZero;
    // iOS7以后使用boundingRectWithSize，之前使用sizeWithFont
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        // 多行必需使用NSStringDrawingUsesLineFragmentOrigin，网上有人说不是用NSStringDrawingUsesFontLeading计算结果不对
        NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
        NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineBreakMode:NSLineBreakByCharWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName : font, NSParagraphStyleAttributeName : style };
        
        CGRect rect = [self boundingRectWithSize:maxSize
                                         options:opts
                                      attributes:attributes
                                         context:nil];
        textSize = rect.size;
    }
    else{
        textSize = [self sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    return textSize;
}


-(CGFloat)getSpaceLabelHeight:(UIFont*)font withWidth:(CGFloat)width linespace:(CGFloat)linespace{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = linespace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.0f
                          };
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, ScreenHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}


-(NSInteger)getLineNumbers:(float)width font:(UIFont*)font{
    
    float allheight = [BTLabel heightForWidth:width
                                         text:self
                                         font:font
                                   edgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                numberOfLines:0
                                    imageSize:CGSizeZero
                                imagePosition:UIRectEdgeTop
                              imageEdgeInsets:UIEdgeInsetsZero] + 1;
    
    
    CGSize textSize = [self sizeWithAttributes:@{NSFontAttributeName : font}];
    CGFloat textRow = allheight / textSize.height;

    return textRow;
}

//去掉换行符
-(NSString*)delLinebreaks{
    NSString *mStr = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    mStr = [mStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    mStr = [mStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    mStr = [mStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return mStr;
}



@end
