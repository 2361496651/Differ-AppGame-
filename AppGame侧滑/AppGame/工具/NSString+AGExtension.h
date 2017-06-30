//
//  NSString+Extension.h
//  CocoapodTest
//
//  Created by tage on 14-4-9.
//  Copyright (c) 2014年 cn.kaakoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AGExtension)
+ (NSString*)randomWordsNoCaptialWithLength:(NSUInteger)len;
+ (NSString*)randomWordsWithLength:(NSUInteger)len;
- (NSURL *)toURL;
- (NSString *)thumbnailPath;
- (NSString *)MD5;
- (NSString *)SHA1;
- (NSString *)SHA256;

- (NSInteger)countOfSubstring:(NSString*)subString;
- (NSInteger)locationOfSubstring:(NSString*)subString atIndex:(NSInteger)index;
- (BOOL)maxLineWhenReturnWithSubstring:(NSString*)subString atIndex:(NSInteger)index;

+ (NSString*)prettyDisplayWithInt:(NSInteger)i;

+ (NSString*)prettyTimeStringWithInt:(NSInteger)i;

/**
 *  采用SDWebImage对图片url地址进行编码的格式
 *
 */

- (NSString *)cachedFileName;

/**
 *  是否含有Emoji
 *
 */

- (BOOL)containsEmoji;

/**
 *  是否含有特殊字符 
 *
 *  输入汉字时，如果没有选择汉字直接点击搜索会有特殊字符在获取到的字符串中
 *
 */

- (BOOL)containsSpecialChar;

/**
 *  去除特殊字符
 *
 */

- (NSString *)deleteSpecialChar;
/**
 *  UUID
 *
 *  @return NSString UUID 
 */
+ (NSString *)ag_UUID;


-(BOOL)checkPhoneNumInput;

- (id)objectFromJSONString;
- (NSArray*)arrayFromJSONString;
- (NSDictionary*)dictionaryFromJSONString;
//key 要替换的  value 替换成什么
-(NSString*)replacingDictionary:(NSDictionary*)replacedic;
-(NSDictionary*)getResponseDictionary;
-(NSString*)filtration:(NSString*)regEx_html;


/**
 *  安装APP
 */
-(BOOL)isEmpty;

/**
 *  安装APP
 */
-(void)installApp;
/**
 *   是否装有APP
 *
 *  @return 是否
 */
-(BOOL)isInstallationApp;


/**
 *  检测是否为邮箱
 *  @return 是否是
 */
- (BOOL) validateEmail;

/**
 *  是否为数字
 *  @return 是否是
 */
-(BOOL)isPureInt;

/**
 *  是否有中文
 *  @return 是否是
 */
-(BOOL)isChineseWord;

/**
 *  需要过滤的特殊字符
 *  @return 是否是
 */
-(BOOL)isIncludeSpecialCharact;

/**
 *  取得截止nstring cutoffPostion
 *
 *  @param cutoffnstring 截止 nstring
 *
 *  @return 截止 NSRange
 */
-(NSRange)cutoffPostion:(NSString*)cutoffnstring;

/**
 *  截止nstring 的颜色
 *
 *  @param nstringArray 要截止的nsstring
 *  @param cutcolor     截止的nsstring 的颜色
 */

-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)stringArray AndColor:(UIColor*)cutcolor;

/**
 *  截止nstring 的颜色
 *
 *  @param dicArray 添加 NSDictionary 要截止的nsstring key为(string) 截止的nsstring 的颜色 key为(color) 截止的nsstring 的font key为(font)
 *
 */
-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)dicArray;

/**
 *  截止nstring 的颜色
 *
 *  @param dicArray @param dicArray 添加 NSDictionary 要截止的nsstring key为(string) 截止的nsstring 的颜色 key为(color)
 *  @param font     字体
 *
 *  @return NSMutableAttributedString
 */
-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)dicArray AndFont:(UIFont*)font;
/**
 *  截止nstring 的颜色
 *
 *  @param stringArray 要截止的nsstring
 *  @param cutcolor    截止的nsstring 的颜色
 *  @param font        字体
 *
 *  @return NSMutableAttributedString
 */
-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)stringArray AndColor:(UIColor*)cutcolor AndFont:(UIFont*)font;

/**
 *  自定截止nstring 的颜色 大小
 *
 *  @param dicArray dicArray 添加 NSDictionary 要截止的nsstring key为(string) 截止的nsstring 的颜色 key为(color) 截止的nsstring 的font key为(font)
 *  @param font     其它的大小
 *
 *  @return NSMutableAttributedString
 */
-(NSMutableAttributedString*)getAttributedColornstringWithArray:(NSArray*)dicArray otherFont:(UIFont*)font;

/**
 *  按行间距返回NSMutableAttributedString
 *
 *  @param font     字体的大小
 *
    @param  lineSpacing 间距
 *  @return NSMutableAttributedString
 */
- (NSMutableAttributedString *)attributedStringFromStingWithFont:(UIFont *)font
                                                 withLineHeightMultiple:(CGFloat)lineHeightMultiple withColor:(UIColor *)color;


/**
 *  获取文字的尺寸
 *
 *  @param font    字体的大小
 *  @param height  限高
 *  @param width   限宽
 *
 @param   间距
 *  @return NSMutableAttributedString
 */
- (CGSize)setUILabelSizeWithfont:(CGFloat)fontSize xianHeight:(CGFloat)height xianWidth:(CGFloat)width;

- (CGSize)setUILabelSizeWithfont:(CGFloat)fontSize xianHeight:(CGFloat)height xianWidth:(CGFloat)width withLineHeightMultiple:(CGFloat)lineHeightMultiple;

/**
 *  复制字符串到剪贴板
 */
-(void)copyStringTopasteboard;

/**
 *  数字转换
 *
 *  @return 数字
 */
-(NSString*)numberconversion;

/**
 *  数字转换
 *
 *  @param number 数字
 *
 *  @return 字符串
 */
+ (NSString *)ag_numberConversion:(NSInteger)number;

/**
 *  计算高度
 *
 *  @param fontSize 字体大小
 *  @param width Label宽度
 *  @return label高度
 */
- (CGFloat)di_getLabelHeightFontSize:(CGFloat)fontSize Width:(CGFloat)width;
- (CGFloat)di_getLabelHeightFontSize:(CGFloat)fontSize Width:(CGFloat)width numberOfLines:(NSInteger)integer;

/**
 * 通过字符串计算文本需要的大小
 * @param font 字体
 * @param width 宽度限制 不限制可传CGFLOAT_MAX
 * 说明：换行符也按照字符串处理比如\n\r
 */
-(CGSize)di_sizeOfStringToLable:(UIFont*)font width:(CGFloat)width;

-(CGFloat)getSpaceLabelHeight:(UIFont*)font withWidth:(CGFloat)width linespace:(CGFloat)linespace;

-(NSInteger)getLineNumbers:(float)width font:(UIFont*)font;

-(NSString*)delLinebreaks;
@end
