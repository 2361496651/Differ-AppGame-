//
//  FeedbackViewController.m
//  AppGame
//
//  Created by supozheng on 2017/5/22.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "FeedbackViewController.h"
#import "ViewFactory.h"
#import "SZTextView.h"
#import "FeedbackModel.h"
#import <MJExtension.h>
#import "RadioButton.h"
#import "FeedbackCollectionViewCell.h"
#import "DifferNetwork.h"
#import <SVProgressHUD.h>


@interface FeedbackViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextViewDelegate>

@property(nonatomic,assign)NSIndexPath *chooseIndex;
@property(nonatomic,strong)RadioButton *radioButtonView;
@property(nonatomic,strong)SZTextView *textView;
@property(nonatomic,strong)UIButton *submitButton;
@property(nonatomic,strong)NSMutableArray<FeedbackModel*> *feedbacks;
@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,assign)NSInteger cellWidth;
@property (nonatomic,assign)NSInteger cellHeight;
@end

@implementation FeedbackViewController

#pragma mark - 创建视图 -----------------------

-(void)setupView{
    self.cellWidth = ScreenWidth/2 - 30/2;
    self.cellHeight = 30;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.cellWidth, self.cellHeight);
        layout.sectionInset = UIEdgeInsetsMake(0,10, 10, 10);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 180) collectionViewLayout:layout];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_collectionView];
        [_collectionView registerClass:FeedbackCollectionViewCell.class forCellWithReuseIdentifier:@"fellback"];
    }
    return _collectionView;
}


-(NSMutableArray*)feedbacks{
    if (!_feedbacks) {
        _feedbacks = [NSMutableArray array];
    }
    return _feedbacks;
}

-(SZTextView*)textView{
    if(!_textView){
        _textView = [ViewFactory createTextView:self.view holder:@"请输入您遇到的问题或建议" textFontSize:15];
        _textView.layer.borderWidth = 0.5;
        _textView.delegate = self;
    }
    return _textView;
}

-(UIButton*)submitButton{
    if(!_submitButton){
        _submitButton = [ViewFactory createButton:self.view titleColor:[UIColor whiteColor] titleLabelFontSize:16 title:@"提交反馈"];
        [_submitButton setBackgroundColor:[UIColor HEX:0xc2c2c2]];
        _submitButton.layer.cornerRadius = 5;
        _submitButton.enabled = NO;
    }
    return _submitButton;
}


// 设置顶部导航栏
- (void)setupNavigationBar {
    
    self.title = @"反馈";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
}

#pragma mark - 生命周期 -----------------------------
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavigationBar];
    
    [self setupView];
    self.collectionView.hidden = NO;//35
    self.textView.el_topToBottom(self.collectionView,35).el_leftToSuperView(20).el_rightToSuperView(20).el_toSize(CGSizeMake(ScreenWidth - 40, 150));
    self.submitButton.el_topToBottom(self.textView,20).el_leftToSuperView(20).el_rightToSuperView(20).el_toSize(CGSizeMake(ScreenWidth - 40, 50));
   
    [self.submitButton bk_whenTapped:^{
        FeedbackModel *model = self.feedbacks[self.chooseIndex.row];
        NSString *typeId = model.uid;
        [[[DifferNetwork shareInstance] postFeedBack:self.gameId content:self.textView.text typeId:typeId] subscribeNext:^(id x) {
            [self dismissViewControllerAnimated:YES completion:^{
                [SVProgressHUD showSuccessWithStatus:@"提交反馈成功"];
            }];
        } error:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"提交反馈失败"];
        }];
    }];
    
    [self loadData];
    
    
    //监听键盘frame改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 数据加载 -----------------------------

-(void)loadData{
    [[[DifferNetwork shareInstance] getFeedbackTypes] subscribeNext:^(id responseObj) {
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *models = responseDict[@"data"];
        for (NSDictionary *dic in models) {
            FeedbackModel *model = [FeedbackModel mj_objectWithKeyValues:dic];
            [self.feedbacks addObject:model];
                
        }
            
        [self.collectionView reloadData];
        NSInteger count = self.feedbacks.count;
        self.collectionView.el_toHeight((count/2 + 2) * self.cellHeight).el_toWidth(ScreenWidth).el_topToSuperView(20).el_leftToSuperView(0);

    } error:^(NSError *error) {
        NSLog(@"获取反馈数据失败");
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}


#pragma mark:  UICollectionViewDelegate && datasource -----------------

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //返回1组
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //table的数量
    NSLog(@"count %lu",self.feedbacks.count);
    return self.feedbacks.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedbackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fellback" forIndexPath:indexPath];
    if(!cell){
        cell = [[FeedbackCollectionViewCell alloc] initWithFrame:CGRectZero];
    }
    
    FeedbackModel *model  = self.feedbacks[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.radioButton.textLabel.text = model.name;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.chooseIndex){
        FeedbackCollectionViewCell *cell = (FeedbackCollectionViewCell *)[collectionView cellForItemAtIndexPath:self.chooseIndex ];
        [cell.radioButton choose:NO];
    }
    self.submitButton.backgroundColor = [UIColor di_MAIN2];
    self.submitButton.enabled = YES;
    self.chooseIndex = indexPath;
    FeedbackCollectionViewCell *cell = (FeedbackCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath ];
    [cell.radioButton choose:YES];
    
}


#pragma mark - UITextViewDelegate ----------------

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"text size = %lu",textView.text.length);
    if(![text isEmpty]){
        if (textView.text.length > 200) return NO;
    }
    return YES;
}


#pragma mark - 键盘事件 -----------------------------
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    
}


#pragma mark - 点击事件 -----------------------------
- (void)backClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
