//
//  AGLimitedTextView.m
//  AGVideo
//
//  Created by MaoRongsen on 15/12/10.
//  Copyright © 2015年 AppGame. All rights reserved.
//

#import "AGLimitedTextView.h"
#import "UIBarButtonItem+BlocksKit.h"
@interface AGLimitedTextView()
@property (nonatomic, strong) UILabel *countLabel;
@end
@implementation AGLimitedTextView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    
    __weak typeof(self) weakSelf = self;
    self.textContainer.lineBreakMode = NSLineBreakByClipping;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [AGUtilities screenWidth], 44)];
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(id sender) {
        [weakSelf resignFirstResponder];
    }];
    doneButtonItem.width = 44;
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.text = [NSString stringWithFormat:@"0/%@", @(self.maxWords)];
    UIBarButtonItem *titleButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_countLabel];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:@[spaceItem, titleButtonItem, doneButtonItem]];
    self.inputAccessoryView = toolBar;
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UITextViewTextDidChangeNotification object:self] takeUntil:[self rac_willDeallocSignal]] subscribeNext:^(NSNotification* x) {
        if (weakSelf.maxLineFeed != 0) {
            NSInteger location = [weakSelf.text locationOfSubstring:@"\n" atIndex:weakSelf.maxLineFeed - 1];
            if ( location != NSNotFound ){
                weakSelf.text = [weakSelf.text substringToIndex:location];
            }
        }
        if (weakSelf.text.length > weakSelf.maxWords) {
            weakSelf.text = [weakSelf.text substringToIndex:weakSelf.maxWords];
        }
        [weakSelf changeCountLabel];
    }];
}
- (void)setMaxWords:(NSInteger)maxWords{
    _maxWords = maxWords;
    [self changeCountLabel];
}
- (void)setText:(NSString *)text{
    [super setText:text];
    [self changeCountLabel];
}

- (void)changeCountLabel{
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] init];
    [aString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", @(self.text.length)] attributes:@{NSForegroundColorAttributeName : ((self.text.length == self.maxWords) ? [UIColor redColor] : [UIColor HEX:0x585858]), NSFontAttributeName : [UIFont systemFontOfSize:14]}]];
    [aString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%@", @(self.maxWords)] attributes:@{NSForegroundColorAttributeName : [UIColor HEX:0x585858], NSFontAttributeName : [UIFont systemFontOfSize:14]}]];
    self.countLabel.attributedText = aString;
}
@end
