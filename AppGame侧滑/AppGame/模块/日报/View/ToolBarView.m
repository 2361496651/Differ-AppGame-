//
//  ToolBarView.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ToolBarView.h"

@interface ToolBarView ()

@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIButton *rightBtn;

@end

@implementation ToolBarView

- (instancetype)initToolBarWithFrame:(CGRect)frame textfieldDelegate:(id)delegate
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI:delegate];
    }
    //    self.frame = frame;
    return self;
}


- (void)setupUI:(id)delegate
{
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 44, 44)];
    [leftBtn setImage:[UIImage imageNamed:@"icon_tab_comment"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.leftBtn = leftBtn;
    [self addSubview:self.leftBtn];
    
//    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 0, 60, 40)];
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 20, 0, 60, 40)];
    [rightBtn setTitle:@" + 贴标签 " forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.hidden = YES;
    self.rightBtn = rightBtn;
    [self addSubview:self.rightBtn];
    
    self.rightBtn.layer.cornerRadius = CGRectGetWidth(self.rightBtn.bounds)/2;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.bounds = CGRectMake(0, 0, 60, 30);
    borderLayer.position = CGPointMake(CGRectGetMidX(self.rightBtn.bounds), CGRectGetMidY(self.rightBtn.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:CGRectGetWidth(borderLayer.bounds)/2].CGPath;
    borderLayer.lineWidth = 1. / [[UIScreen mainScreen] scale];
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    borderLayer.lineDashPattern = @[@5, @5];
    [self.rightBtn.layer addSublayer:borderLayer];
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame) + 5, 4, CGRectGetMinX(self.rightBtn.frame) - CGRectGetMaxX(self.leftBtn.frame) - 5, 36)];
    textfield.delegate = delegate;
    textfield.borderStyle = UITextBorderStyleNone;
    textfield.placeholder = @"说点什么吧";
    [textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.textField = textfield;
    [self addSubview:self.textField];
    
    
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
}
//从左往右，按钮索引从0开始
- (void)leftBtnClick
{
    if (self.callBack) {
        self.callBack(0);
    }
}

- (void)rightBtnClick
{
    if (self.callBack) {
        self.callBack(1);
    }
}

- (void)becomFirstResponseWithPlaceHolder:(NSString *)placeHolder
{
    self.textField.placeholder = placeHolder;
    [self.textField becomeFirstResponder];
}

- (void)registFirstResponseWithPlaceHolder:(NSString *)placeHolder
{
    self.textField.text = nil;
    self.textField.placeholder = placeHolder;
    self.textField.returnKeyType = UIReturnKeySend;
    [self.textField resignFirstResponder];
}


- (void)textFieldDidChange:(UITextField *)textField
{
    int length = 15;//限制的字数
    NSString *toBeString = textField.text;
    
    //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    NSString *lang = textField.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position || !selectedRange)
        {
            if (toBeString.length > length)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:length];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }else{
        if (toBeString.length > length) {
            textField.text = [toBeString substringToIndex:length];
        }
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
