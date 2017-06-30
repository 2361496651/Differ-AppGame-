//
//  GameAppraiseController.m
//  AppGame
//
//  Created by chan on 17/5/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameAppraiseViewController.h"
#import "DiffUtil.h"
#import "SZTextView.h"
#import "ViewFactory.h"
#import "TagView.h"
#import "DifferNetwork.h"
#import "TagsModel.h"
#import <SVProgressHUD.h>

@interface GameAppraiseViewController ()<UITextFieldDelegate>

@property(nonatomic,strong)UILabel *appraiseLB;
@property(nonatomic,copy) NSString *star;
@property(nonatomic,strong)NSArray *appraiseArr;
@property(nonatomic,strong)SZTextView *textView;
@property(nonatomic,strong)UIView *tagsBackgroundView;

@property(nonatomic, strong) UIView *coverView;
@property(nonatomic, strong) UIView *bottomReplyView;
@property(nonatomic, strong) UITextField *bottomCommentTextField;

@property(nonatomic, copy) NSMutableString *tagJson;
@property(nonatomic, strong) TagView *addTagView;
@property(nonatomic, assign) BOOL isDidAddTagView;

@property(nonatomic, assign) CGRect tagFrame;
@property(nonatomic, assign) CGFloat tagsBackgroundHeight;

@property(nonatomic, assign) int tagKey;
@end

@implementation GameAppraiseViewController

#pragma mark 懒加载 -----------------------

-(UIView *)coverView{
    if (!_coverView) {
        //创建一个遮罩
        _coverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _coverView.userInteractionEnabled = YES;
        [self.view addSubview:_coverView];
        [_coverView bk_whenTapped:^{
            [self.bottomCommentTextField resignFirstResponder];
        }];
    }
    return _coverView;
}

-(UILabel *)appraiseLB{
    if (!_appraiseLB) {
        _appraiseLB = [UILabel new];
        
        [self.view addSubview:_appraiseLB];
        _appraiseLB.font = [UIFont systemFontOfSize:15];
        _appraiseLB.textColor = [UIColor grayColor];
    }
    return _appraiseLB;
}

-(NSArray *)appraiseArr{
    if (!_appraiseArr) {
        _appraiseArr = [NSArray arrayWithObjects:@"比较失望",@"一般而已",@"值得一玩",@"绝非凡品",@"强烈推荐", nil];
    }
    return _appraiseArr;
}

-(SZTextView*)textView{
    if(!_textView){
        _textView = [ViewFactory createTextView:self.view holder:@"请留下您的评语，认真评价会使您得到其他玩家的认可" textFontSize:15];
//        [self.view addSubview:_textView];
    }
    return _textView;
}

-(UIView *)tagsBackgroundView{
    if (!_tagsBackgroundView) {
        _tagsBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(20, 230, ScreenWidth, 24)];
        
    }
    return _tagsBackgroundView;
}

-(NSMutableString *)tagJson{
    if (!_tagJson) {
        _tagJson = [[NSMutableString alloc ] initWithString :@"{\"tags\":{}}"];
    }
    return _tagJson;
}

-(UIView *)bottomReplyView{
    if(!_bottomReplyView){
        
        _bottomReplyView = [UIView new];
        [self.view addSubview:_bottomReplyView];
        _bottomReplyView.backgroundColor = [UIColor whiteColor];
        _bottomReplyView.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottomReplyView.layer.shadowOffset = CGSizeMake(0, -1);
        _bottomReplyView.layer.shadowOpacity=0.1;
        
        UIButton *replyButton = [UIButton new];
        [_bottomReplyView addSubview:replyButton];
        replyButton.layer.cornerRadius = 5;
        replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [replyButton setBackgroundColor:[UIColor di_MAIN2]];
        [replyButton setTitle:@"发送" forState:UIControlStateNormal];
        [replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        replyButton.el_toSize(CGSizeMake(50, 30)).el_axisYToSuperView(0).el_rightToSuperView(20);
        
        self.bottomCommentTextField = [UITextField new];
        [_bottomReplyView addSubview:self.bottomCommentTextField];
        self.bottomCommentTextField.delegate = self;
        self.bottomCommentTextField.el_toHeight(30).el_axisYToSuperView(0).el_leftToSuperView(10).el_rightToLeft(replyButton, 20);
        self.bottomCommentTextField.placeholder = @"请输入标签内容";
        self.bottomCommentTextField.font = [UIFont systemFontOfSize:15];
        
        [replyButton bk_whenTapped:^{
            [self tagAdd];
        }];
        
    }
    return _bottomReplyView;
}

#pragma mark - 生命周期 ---------------------

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //监听键盘frame改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价游戏";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [DiffUtil initButtonItemWithTitle:@"发布" action:@selector(publishAppraise) delegate:self];
    _isDidAddTagView = NO;
    _tagFrame = CGRectMake(0, 0, 0, 24);
    _tagsBackgroundHeight = 24;
    _star = @"2";
    _tagKey = 1;
    
    if (self.appraiseModel != nil) {
        int star = self.appraiseModel.star.intValue / 2;
        _star = self.appraiseModel.star;
        for (int i = 0; i < 5; i ++) {
            UIButton *button = [UIButton new];
            [self.view addSubview:button];
            button.el_toSize(CGSizeMake(25, 25)).el_topToSuperView(20).el_leftToSuperView(i * 35 + 20);
            if (i < star) {
                [button setImage:[UIImage imageNamed:@"icon_Star_green"] forState:UIControlStateNormal];
            }else{
                [button setImage:[UIImage imageNamed:@"icon_Star_grey"] forState:UIControlStateNormal];
            }
            if (i == 4) {
                self.appraiseLB.el_leftToRight(button,10).el_axisYToAxisY(button,0);
                self.appraiseLB.text = self.appraiseArr[star -1];
            }
        }
    }else{
        for (int i = 0; i < 5; i ++) {
            UIButton *button = [UIButton new];
            [self.view addSubview:button];
            button.tag = i+1;
            [button setImage:[UIImage imageNamed:@"icon_Star_grey"] forState:UIControlStateNormal];
            button.el_toSize(CGSizeMake(25, 25)).el_topToSuperView(20).el_leftToSuperView(i * 35 + 20);
            [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            if (i == 0) {
                [button setImage:[UIImage imageNamed:@"icon_Star_green"] forState:UIControlStateNormal];
            }else if (i == 4) {
                self.appraiseLB.el_leftToRight(button,10).el_axisYToAxisY(button,0);
            }
        }
        self.appraiseLB.text = @"比较失望";
    }
    
    UIView *lineV1 = [ViewFactory createLineView:self.view];
    lineV1.el_topToBottom(self.appraiseLB,20).el_toWidth(ScreenWidth);
    
    self.textView.el_topToBottom(lineV1,10).el_leftToSuperView(20).el_toSize(CGSizeMake(ScreenWidth-40, 120));
    self.textView.layer.borderWidth = 0;
    
    UIView *lineV2 = [ViewFactory createLineView:self.view];
    lineV2.el_topToBottom(self.textView,10).el_toWidth(ScreenWidth);
    
    [self.view addSubview:self.tagsBackgroundView];
    
    
    
    if (self.appraiseModel != nil) {
        self.textView.text = self.appraiseModel.content;
//
//        NSArray<TagsModel *>* tagModels = self.appraiseModel.tags;
//        for (int i = 0; i < tagModels.count; i ++) {
//            TagsModel *tagModel = tagModels[i];
//            CGSize size = [[NSString stringWithFormat:@"%@ | 11",tagModel.name] di_sizeOfStringToLable:[UIFont systemFontOfSize:_tagsBackgroundHeight/2] width:CGFLOAT_MAX];
//            _tagFrame.size.width = size.width;
//            if (_tagFrame.origin.x + size.width + 20 >= ScreenWidth) {
//                _tagFrame.origin.y += _tagsBackgroundHeight + 10;
//                _tagFrame.origin.x = 0;
//                CGRect frame = self.tagsBackgroundView.frame;
//                frame.size.height += _tagsBackgroundHeight + 10;
//                self.tagsBackgroundView.frame = frame;
//            }
//            
//            TagView * tagView = [[TagView alloc] initWithFrame:_tagFrame TagType:TagTypeSolidLine BorderColor:[UIColor di_MAIN2]];
//            _tagFrame.origin.x += size.width + 10;
//            tagView.tagText.text = [NSString stringWithFormat:@"%@ | 1",tagModel.name];
//            tagView.tagText.textColor = [UIColor di_MAIN2];
//            [self.tagsBackgroundView addSubview:tagView];
//            _isDidAddTagView = YES;
//            
//            if (_tagKey != 1) {
//                if (![[self.tagJson substringWithRange:NSMakeRange([self.tagJson length]-3, 1)] isEqualToString:@","]) {
//                    [self.tagJson insertString:@"," atIndex:[self.tagJson length]-2];
//                }
//            }
//            [self.tagJson insertString:[NSString stringWithFormat:@"\"name%d\":\"%@\",",_tagKey++,tagModel.name] atIndex:[self.tagJson length]-2];
//        }
    }else{
        UILabel *placeholder = [UILabel new];
        [self.tagsBackgroundView addSubview:placeholder];
        placeholder.el_axisYToSuperView(0).el_leftToSuperView(0);
        placeholder.text = @"添加标签可以增加趣味性哦";
        placeholder.font = [UIFont systemFontOfSize:14];
        placeholder.textColor = [UIColor grayColor];

        self.addTagView = [[TagView alloc] initWithFrame:CGRectMake( 0, 0, 80, 30) TagType:TagTypeDottedLine BorderColor:[UIColor grayColor]];
        [self.view addSubview:self.addTagView];
        self.addTagView.el_topToBottom(self.tagsBackgroundView,10).el_leftToSuperView(20).el_toSize(CGSizeMake(80, 30));
        self.addTagView.tagText.textColor = [UIColor grayColor];
        self.addTagView.tagText.text = @"+ 贴标签";
        
        [self.addTagView bk_whenTapped:^{
            [self showBottomReplyView];
        }];
    }

    self.coverView.hidden = YES;
    
}

-(void)showBottomReplyView{
    self.bottomReplyView.hidden = NO;
    self.bottomCommentTextField.text = @"";
    CGPoint point = self.bottomCommentTextField.frame.origin;
    point.y = ScreenHeight;
    [self.bottomReplyView setOrigin:point];
    [self.bottomCommentTextField becomeFirstResponder];
}

- (void)tagAdd{
    if ([self.bottomCommentTextField.text isEqualToString:@""]) {
        NSLog(@"空");
    }else{
        [self.bottomCommentTextField resignFirstResponder];
        
        if (!_isDidAddTagView) {
            [self.tagsBackgroundView removeAllSubviews];
        }
        
        NSString *text = [NSString stringWithFormat:@"%@ | 11",self.bottomCommentTextField.text];
        CGSize size = [text di_sizeOfStringToLable:[UIFont systemFontOfSize:_tagsBackgroundHeight/2] width:CGFLOAT_MAX];
        _tagFrame.size.width = size.width;
        if (_tagFrame.origin.x + size.width + 20 >= ScreenWidth) {
            _tagFrame.origin.y += _tagsBackgroundHeight + 10;
            _tagFrame.origin.x = 0;
            CGRect frame = self.tagsBackgroundView.frame;
            frame.size.height += _tagsBackgroundHeight + 10;
            self.tagsBackgroundView.frame = frame;
        }
        TagView * tagView = [[TagView alloc] initWithFrame:_tagFrame TagType:TagTypeSolidLine BorderColor:[UIColor di_MAIN2]];
        _tagFrame.origin.x += size.width + 10;
        tagView.tagText.text = [NSString stringWithFormat:@"%@ | 1",self.bottomCommentTextField.text];
        tagView.tagText.textColor = [UIColor di_MAIN2];
        [self.tagsBackgroundView addSubview:tagView];
        _isDidAddTagView = YES;
        
        if (_tagKey != 1) {
            if (![[self.tagJson substringWithRange:NSMakeRange([self.tagJson length]-3, 1)] isEqualToString:@","]) {
                [self.tagJson insertString:@"," atIndex:[self.tagJson length]-2];
            }
        }
        _tagKey ++;
        [self.tagJson insertString:[NSString stringWithFormat:@"\"name\":\"%@\",",self.bottomCommentTextField.text] atIndex:[self.tagJson length]-2];
    }
}

-(void)clickAction:(UIButton *)button{
    for (int i = 0; i < 5; i ++) {
        UIButton* btn = [self.view viewWithTag:i+1];
        if (i < button.tag) {
            [btn setImage:[UIImage imageNamed:@"icon_Star_green"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"icon_Star_grey"] forState:UIControlStateNormal];
        }
    }
    self.appraiseLB.text = self.appraiseArr[button.tag-1];
    _star = [NSString stringWithFormat:@"%ld",button.tag * 2];
}

-(void)publishAppraise{

    if (![self.textView.text isEqualToString:@""]){
        
        if(_tagKey != 1){
            if ([[self.tagJson substringWithRange:NSMakeRange([self.tagJson length]-3, 1)] isEqualToString:@","]) {
                [self.tagJson deleteCharactersInRange:NSMakeRange([self.tagJson length]-3, 1)];
            }
        }else{
            [self.tagJson deleteCharactersInRange:NSMakeRange(0, [self.tagJson length])];
        }

        if (self.appraiseModel != nil) {
            [[[DifferNetwork shareInstance] postGameComment:self.appraiseModel.uid gameId:@"" content:self.textView.text tags:@"" start:_star]subscribeNext:^(id x) {
                NSLog(@"修改评价--------成功");
                [self.navigationController popViewControllerAnimated:YES];
                [SVProgressHUD showSuccessWithStatus:@"修改评价成功"];
            } error:^(NSError *error) {
                NSString *gameID = self.gameModel.game_id == nil ? self.gameModel.uid : self.gameModel.game_id;
                [[[DifferNetwork shareInstance] postGameComment:@"" gameId:gameID content:self.textView.text tags:self.tagJson start:_star] subscribeNext:^(id x) {
                    NSLog(@"发表评价--------成功");
                    [self.navigationController popViewControllerAnimated:YES];
                    [SVProgressHUD showSuccessWithStatus:@"发表评价成功"];
                } error:^(NSError *error) {
                    NSLog(@"发表评价--------失败");
                }];
                    
            }];

        }else{
            [SVProgressHUD showErrorWithStatus:@"请留下您的评语"];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.bottomCommentTextField) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
            
        }else if (self.bottomCommentTextField.text.length >= 14) {
            self.bottomCommentTextField.text = [textField.text substringToIndex:14];
            return NO;
        }
    }
    return YES;
}

-(void)clickDialogLeftButton{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 键盘 --------------------
- (void)keyboardWillShow:(NSNotification *)notification{
    
    if (![self.textView isFirstResponder]) {
        NSDictionary *userInfo = [notification userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        CGFloat keyboardHeight = keyboardRect.size.height;
        CGRect frame = CGRectMake(0, 0, ScreenWidth, 50);
        frame.origin.y = self.view.height - frame.size.height - keyboardHeight;
        [self.bottomReplyView setFrame:frame];
    }
    self.coverView.hidden = NO;

}

- (void)keyboardWillHide:(NSNotification *)notification{
     if (![self.textView isFirstResponder]) {
         self.bottomReplyView.hidden = YES;
     }
    self.coverView.hidden = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}

@end
