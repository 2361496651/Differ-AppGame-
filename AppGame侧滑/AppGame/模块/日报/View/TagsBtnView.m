//
//  TagsView.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/24.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "TagsBtnView.h"
#import "UIView+Extension.h"
#import "DiffUtil.h"

@interface TagsBtnView ()

@property (nonatomic,strong)NSArray<UIButton *> *buttonList;

@property (nonatomic,assign)NSInteger commentsCount;

@end

@implementation TagsBtnView


- (instancetype)initTagsViewWithFrame:(CGRect)frame tags:(NSArray<UIButton *> *)tags commentsCount:(NSInteger)count
{
    if (self = [super initWithFrame:frame]) {
        
        self.buttonList = tags;
        self.commentsCount = count;
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI
{
    CGFloat margin = 12;
    
    //添加一条横线
    UILabel *labelLine = [[UILabel alloc]initWithFrame:CGRectMake(margin, 5, self.frame.size.width - 2 * margin, 1)];
    labelLine.backgroundColor = [DiffUtil colorWithHexString:@"979797"];
    [self addSubview:labelLine];
    
    for (UIButton *btn in self.buttonList) {
        [self addSubview:btn];
    }
    
    
    
    // 存放每行的第一个Button
    NSMutableArray *rowFirstButtons = [NSMutableArray array];
    // 对第一个Button进行设置
    UIButton *button0 = self.buttonList[0];
    button0.x = margin;
    button0.y = margin;
    [rowFirstButtons addObject:self.buttonList[0]];
    
    // 对其他Button进行设置
    int row = 0;
    for (int i = 1; i < self.buttonList.count; i++) {
        UIButton *button = self.buttonList[i];
        
        int sumWidth = 0;
        int start = (int)[self.buttonList indexOfObject:rowFirstButtons[row]];
        for (int j = start; j <= i; j++) {
            UIButton *button = self.buttonList[j];
            sumWidth += (button.width + margin);
        }
        sumWidth += 10;
        
        UIButton *lastButton = self.buttonList[i - 1];
        if (sumWidth >= self.width) {
            button.x = margin;
            button.y = lastButton.y + margin + button.height;
            [rowFirstButtons addObject:button];
            row ++;
        } else {
            button.x = sumWidth - margin - button.width;
            button.y = lastButton.y;
        }
    }
    
    
    UIButton *lastButton = self.buttonList.lastObject;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"玩家讨论 （%ld）",self.commentsCount];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16.5];
    label.frame = CGRectMake(margin, CGRectGetMaxY(lastButton.frame)+margin, self.frame.size.width, 30);
    [self addSubview:label];
    
    
    UIView *taglineView = [[UIView alloc] init];
    taglineView.backgroundColor = [UIColor colorWithRed:21/255.0 green:177/255.0 blue:184/255.0 alpha:1/1.0];
    [self addSubview:taglineView];
    
    taglineView.frame = CGRectMake(margin, CGRectGetMaxY(label.frame), 73, 4);
    self.height = CGRectGetMaxY(taglineView.frame) + 20;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
