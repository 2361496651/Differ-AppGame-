//
//  RemarkViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/8.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "RemarkViewController.h"
#import "DiffUtil.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "DifferNetwork.h"
#import "UserModel.h"


@interface RemarkViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;


@end

@implementation RemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个性签名";
    
    self.navigationItem.rightBarButtonItem = [DiffUtil initButtonItemWithTitle:@"保存" action:@selector(saveRemark) delegate:self];
    
    self.textView.text = self.remark;
    [self textViewDidChange:self.textView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.textView becomeFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)saveRemark
{
    UserModel *accountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    
    DifferAccount *account = [DifferAccountTool account];
    
    accountModel.remark = self.textView.text;
    NSDictionary *dict = @{
                           @"access_token":account.access_token,
                           @"remark":self.textView.text
                           
                           };
    [[[DifferNetwork shareInstance] requestChangeUserInformationParamet:dict] subscribeNext:^(id x) {
        
        [NSKeyedArchiver archiveRootObject:accountModel toFile:[DiffUtil getUserPathAtDocument]];
        
        self.RemarkCompleteBlock(self.textView.text);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];

    } error:^(NSError *error) {
        NSString *noticeStr = [error description] ? [error description] : @"保存失败";
        [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
        NSLog(@"保存失败：%@",error);
    }];

}


- (void)textViewDidChange:(UITextView *)textView
{
    NSString *text = textView.text;
    if (text == nil || [text isEqualToString:@""]) {
        self.placeholderLabel.text = @"编辑你的个性签名。。。";
    }else{
        self.placeholderLabel.text = @"";
    }
    
    int length = 50;//限制的字数
    NSString *toBeString = textView.text;
    
    //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    NSString *lang = textView.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];       //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position || !selectedRange)
        {
            if (toBeString.length > length)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
                if (rangeIndex.length == 1)
                {
                    textView.text = [toBeString substringToIndex:length];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
                    textView.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }else{
        
        if (toBeString.length > length) {
            textView.text = [toBeString substringToIndex:length - 1];
        }
    }
    

    NSInteger textLength = (50 - textView.text.length) <= 0 ? 0 : (50 - textView.text.length);
    if (textLength <= 0) {
        textLength = 0;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%ld",textLength];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}

@end
