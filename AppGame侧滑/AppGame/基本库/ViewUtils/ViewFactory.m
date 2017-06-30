//
//  ViewFactory.m
//  AppGame
//
//  Created by supozheng on 2017/5/21.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ViewFactory.h"

@implementation ViewFactory

#pragma mark - view -------------------------
+(UIView*)createView:(UIView*)ParentView backgroundColor:(UIColor*)backgroundColor{
    UIView *view = [UIView new];
    [ParentView addSubview:view];
    view.backgroundColor = backgroundColor;
    return view;
}

+(UIView*)createLineView:(UIView*)ParentView{
    UIView *view = [ViewFactory createView:ParentView backgroundColor:[UIColor HEX:0xe2e2e2]];
    view.el_toHeight(0.5);
    return view;
}

+(UIView*)createCircleView:(UIView*)ParentView backgroundColor:(UIColor*)backgroundColor size:(CGSize)size{
    UIView *view = [ViewFactory createView:ParentView backgroundColor:backgroundColor];
    view.layer.cornerRadius = size.height/2;
    view.layer.masksToBounds = YES;
    view.el_toHeight(size.height).el_toWidth(size.width);
    return view;
}

+(UIView*)createEmptyCircleView:(UIView*)ParentView borderColor:(UIColor*)borderColor size:(CGSize)size borderWidth:(CGFloat)borderWidth{
    UIView *view = [ViewFactory createView:ParentView backgroundColor:[UIColor clearColor]];
    view.layer.cornerRadius = size.height/2;
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = borderWidth;
    view.layer.borderColor = borderColor.CGColor;
    view.el_toHeight(size.height).el_toWidth(size.width);
    return view;
}

#pragma mark - label -------------------------
+(UILabel*)createLabel:(UIView*)ParentView fontSize:(CGFloat)fontSize text:(NSString*)text textcolor:(UIColor*)textcolor{
    UILabel *label = [UILabel new];
    [ParentView addSubview:label];
    label.textColor = textcolor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.text = text;
    return label;
}

#pragma mark - button -------------------------
+(UIButton*)createButton:(UIView*)ParentView titleColor:(UIColor*)titleColor titleLabelFontSize:(CGFloat)fontSize title:(NSString*)title{
    UIButton *button = [UIButton new];
    if(ParentView)
        [ParentView addSubview:button];
    [button setTitleColor:titleColor forState: UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

#pragma mark - textfield -------------------------
+(UITextField*)createTextField:(UIView*)ParentView holder:(NSString*)holder textFontSize:(CGFloat)textFontSize {
    
    UITextField *textField = [UITextField new];
    [ParentView addSubview:textField];
    textField.placeholder = holder;
    textField.font = [UIFont systemFontOfSize:textFontSize];
    return textField;
}

#pragma mark - textview --------------------------
+(SZTextView*)createTextView:(UIView*)ParentView holder:(NSString*)holder textFontSize:(CGFloat)textFontSize {
    
    SZTextView *textView = [[SZTextView alloc] init];
    [ParentView addSubview:textView];
    textView.placeholder = holder;
    textView.font = [UIFont systemFontOfSize:textFontSize];
    textView.layer.borderColor = [UIColor HEX:0xd9d9d9].CGColor;
    textView.layer.borderWidth = 1.5;
    return textView;
}

#pragma mark - tabelview -------------------------
+(UITableView*)createTabelView:(id<UITableViewDataSource>)sourceDelegate delegate:(id <UITableViewDelegate>)delegate{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.dataSource = sourceDelegate;
    tableView.delegate = delegate;
    tableView.separatorStyle = NO;
    tableView.showsVerticalScrollIndicator = NO;
    return tableView;
}

#pragma mark - vollectionview -------------------------
+(void)createCollectionView{
    
}

#pragma mark - scrollview -------------------------
+(void)createScrollView{
    
}
@end
