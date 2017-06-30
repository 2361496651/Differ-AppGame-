//
//  DropdownMenu.m
//  AppGame
//
//  Created by chan on 17/5/15.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DropdownMenu.h"

#define AnimateTime 0.25f   // 下拉动画时间

@interface DropdownMenu()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *mainBtn;            //主按钮
@property (nonatomic, strong) UIImageView *arrowMark; //箭头图标
@property (nonatomic, strong) UIView *listView;                 //下拉列表背景
@property (nonatomic, strong) UITableView *tableView;    //下拉列表
@property (nonatomic, strong) NSArray *titleArr;               //选项数组

@property (nonatomic, strong) UIView *coverView;

@end

@implementation DropdownMenu{
    CGFloat  _rowHeight;
}

-(UIView *)coverView{
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.superview addSubview:_coverView];
        _coverView.backgroundColor = [UIColor clearColor];
        _coverView.userInteractionEnabled = YES;
        [_coverView bk_whenTapped:^{
            [self hideDropDown];
        }];
    }
    return _coverView;
}

-(UIButton *)mainBtn{
    if (!_mainBtn) {
        _mainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_mainBtn];
        [_mainBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_mainBtn setTitle:@"热门评价" forState:UIControlStateNormal];
        [_mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
        _mainBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _mainBtn.selected = NO;
    }
    return _mainBtn;
}

-(UIImageView *)arrowMark{
    if (!_arrowMark) {
        _arrowMark = [UIImageView new];
        [self addSubview:_arrowMark];
        _arrowMark.image  = [UIImage imageNamed:@"icon_down_def"];
    }
    return _arrowMark;
}

-(void)setMenuTitles:(NSArray *)titlesArr{
    _titleArr = titlesArr;
    if (self == nil) return;
    
    _rowHeight = 40;
    
    self.mainBtn.el_axisXToAxisX(self,0).el_axisYToAxisY(self,0);

    self.arrowMark.el_toSize(CGSizeMake(15, 15)).el_leftToRight(self.mainBtn,5).el_axisYToAxisY(self.mainBtn,0);

    // 下拉列表背景View
    self.listView = [[UIView alloc] init];
    self.listView.frame = CGRectMake(0, 0, ScreenWidth, 0);
//    self.listView.clipsToBounds       = YES;
//    self.listView.layer.masksToBounds = NO;
    
    
    CGPoint point = self.origin;
    point.y =  64;
    self.listView.origin = point;
    
    // 下拉列表TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,ScreenWidth, _rowHeight)];
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces         = NO;
    [self.listView addSubview:self.tableView];
    
    //默认第一个cell选中
    NSIndexPath*index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView selectRowAtIndexPath:index animated:NO scrollPosition:UITableViewScrollPositionNone];

}

- (void)clickMainBtn:(UIButton *)button{
    
    [self.superview addSubview:self.listView]; // 将下拉视图添加到控件的俯视图上
    
    if(button.selected == NO) {
        [self showDropDown];
    }
    else {
        [self hideDropDown];
    }
}

-(void)showDropDown{
    
    self.coverView.hidden = NO;
    [self.listView.superview bringSubviewToFront:self.listView]; // 将下拉列表置于最上层
    [UIView animateWithDuration:AnimateTime animations:^{
        self.arrowMark.transform = CGAffineTransformMakeRotation(M_PI);
        self.listView.frame = CGRectMake(0, 0, ViewWidth(self.listView), _rowHeight *_titleArr.count);
        CGPoint point = self.origin;
        point.x = 0;
        point.y =  64;
        self.listView.origin = point;
        self.tableView.frame = CGRectMake(0, 0, ViewWidth(self.listView), ViewHeight(self.listView));
    }];
    
    self.mainBtn.selected = YES;
}

-(void)hideDropDown{
    self.coverView.hidden = YES;
    [UIView animateWithDuration:AnimateTime animations:^{
        self.arrowMark.transform = CGAffineTransformIdentity;
        self.listView.frame  = CGRectMake(0, 0, ViewWidth(self.listView), 0);
        
        CGPoint point = self.origin;
        point.x = 0;
        point.y =  64;
        self.listView.origin = point;
        self.tableView.frame = CGRectMake(0, 0, ViewWidth(self.listView), ViewHeight(self.listView));
    }];
    self.mainBtn.selected = NO;
}

#pragma mark - UITableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rowHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.titleArr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //---------------------------下拉选项样式，可在此处自定义-------------------------
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font          = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor     = [UIColor whiteColor];
        cell.backgroundColor = [UIColor ag_MAIN];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor di_MAIN2];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, _rowHeight -0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor ag_G5];
        [cell addSubview:line];
        //---------------------------------------------------------------------------
    }
    
    cell.textLabel.text =[self.titleArr objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.mainBtn setTitle:cell.textLabel.text forState:UIControlStateNormal];
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenu:selectedCellNumber:)]) {
        [self.delegate dropdownMenu:self selectedCellNumber:indexPath.row]; // 回调代理
    }
    
    [self hideDropDown];
}
@end
