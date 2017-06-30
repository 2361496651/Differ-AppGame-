//
//  GameScoreCell.m
//  AppGame
//
//  Created by chan on 17/5/18.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameScoreCell.h"
#import "CountView.h"
#import "UserModel.h"
#import "StarView.h"
#import "ViewFactory.h"
#import "TagsModel.h"
#import "TagView.h"
@interface GameScoreCell()

@property (nonatomic, strong) CountView *countView;
@property (nonatomic, strong) UILabel *appraiseNumberLB;
@property (nonatomic, strong) UIButton *appraiseBtn;

@property (nonatomic, strong) UIView *pointView;

@property (nonatomic, assign) CGFloat height;
@end

@implementation GameScoreCell

-(CountView *)countView{
    if (!_countView) {
        _countView = [[CountView alloc] init];
        [self addSubview:_countView];
        [_countView buildView:60.f height:60.f];
    }
    return _countView;
}

-(UILabel *)appraiseNumberLB{
    if (!_appraiseNumberLB) {
        _appraiseNumberLB = [UILabel new];
        [self addSubview:_appraiseNumberLB];
        _appraiseNumberLB.font = [UIFont systemFontOfSize:16];
        _appraiseNumberLB.textColor = [UIColor ag_G3];
        _appraiseNumberLB.textAlignment = NSTextAlignmentCenter;
    }
    return _appraiseNumberLB;
}

-(UIButton *)appraiseBtn{
    if (!_appraiseBtn) {
        _appraiseBtn = [UIButton new];
        [self addSubview:_appraiseBtn];
        [_appraiseBtn setTitle:@"我要评价" forState:UIControlStateNormal];
        _appraiseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_appraiseBtn.layer setCornerRadius:5.0];
        [_appraiseBtn.layer setBorderWidth:1.0];
        [_appraiseBtn setTitleColor:[UIColor di_MAIN2] forState:UIControlStateNormal];
        [_appraiseBtn.layer setMasksToBounds:YES];
        [_appraiseBtn.layer setBorderColor:[UIColor di_MAIN2].CGColor];
    }
    return _appraiseBtn;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.countView.el_leftToSuperView(50).el_topToSuperView(30).el_toSize(CGSizeMake(60, 60));

    self.appraiseNumberLB.el_axisXToAxisX(self.countView,0).el_topToBottom(self.countView, 10);

    return self;
}

-(void)setGameModel:(GameModel *)gameModel{
    self.countView.percent = gameModel.avg_appraise_star.floatValue / 10.f;
    [self.countView show];
}

-(void)setAppraiseList:(NSMutableArray<AppraiseModel *> *)appraiseList{
    
    self.appraiseNumberLB.text = [NSString stringWithFormat:@"%ld人",appraiseList.count];

    CGFloat lineWidth = ScreenWidth - 200;
    NSMutableArray * array = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",nil];
    for (AppraiseModel *model in appraiseList) {
        int star = model.star.intValue / 2;
        NSString *str = array[star-1];
        [array replaceObjectAtIndex:star-1 withObject:[NSString stringWithFormat:@"%d",str.intValue + 1]];
    }
    
    for (int i = 0; i < 5; i ++) {
        UILabel *numberLB = [UILabel new];
        [self addSubview:numberLB];
        numberLB.el_leftToRight(self.countView,20).el_bottomToBottom(self.appraiseNumberLB, 18*i).el_toWidth(10);
        numberLB.textColor = [UIColor grayColor];
        numberLB.font = [UIFont systemFontOfSize:13];
        numberLB.text = [NSString stringWithFormat:@"%d",i+1];
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        lineView.el_toHeight(5).el_leftToRight(numberLB,10).el_rightToSuperView(50).el_axisYToAxisY(numberLB,0);
        lineView.backgroundColor = [UIColor ag_G5];
        
        NSString *count = array[i];
        if (count.intValue != 0) {
            UIView *view = [UIView new];
            [self addSubview:view];
            view.el_toHeight(5).el_leftToRight(numberLB,10).el_axisYToAxisY(numberLB,0).el_toWidth((lineWidth/appraiseList.count) * count.intValue);
            view.backgroundColor = [UIColor blackColor];
        }
    }
    
    self.appraiseBtn.el_toSize(CGSizeMake(90, 35)).el_axisXToSuperView(0).el_topToBottom(self.appraiseNumberLB,30);
    [self.appraiseBtn bk_whenTapped:^{
        if ([_delegate respondsToSelector:@selector(appraiseBtnAction)]) {
            [_delegate appraiseBtnAction];
        }
    }];

}

-(UIView *)createPointView:(AppraiseModel *)myAppraiseModel{
    
    UIView *view = [self.contentView viewWithTag:888];
    if(view){
        [view removeFromSuperview];
    }
    
    _pointView = [ViewFactory createView:self.contentView backgroundColor:[UIColor clearColor]];
    _pointView.tag = 888;
    _pointView.el_topToBottom(self.appraiseNumberLB,20).el_leftToSuperView(0).el_rightToSuperView(0).el_bottomToSuperView(0);
    [_pointView bk_whenTapped:^{
        if ([_delegate respondsToSelector:@selector(pushAppraisePage)]) {
            [_delegate pushAppraisePage];
        }
    }];
    self.height = 0;
    self.appraiseBtn.hidden = YES;
    UserModel *userModel = myAppraiseModel.author;
    
    UIImageView *icon = [UIImageView new];
    [_pointView addSubview:icon];
    icon.layer.masksToBounds =YES;
    icon.layer.cornerRadius =10;
    icon.el_topToBottom(self.appraiseNumberLB,20).el_leftToSuperView(20).el_toSize(CGSizeMake(20, 20));
    [icon sd_setImageWithURL:userModel.avatar];
    
    UILabel *userName = [UILabel new];
    [_pointView addSubview:userName];
    userName.font = [UIFont systemFontOfSize:15];
    userName.textColor = [UIColor grayColor];
    userName.text = @"我";
    userName.el_axisYToAxisY(icon,0).el_leftToRight(icon, 10).el_toWidth(180);
    
    UIButton *appraiseBtn = [UIButton new];
    [_pointView addSubview:appraiseBtn];
    [appraiseBtn setTitleColor:[UIColor di_MAIN2] forState:UIControlStateNormal];
    [appraiseBtn.layer setMasksToBounds:YES];
    [appraiseBtn.layer setBorderColor:[UIColor di_MAIN2].CGColor];
    [appraiseBtn setTitle:@"更改" forState:UIControlStateNormal];
    appraiseBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [appraiseBtn.layer setCornerRadius:2.0];
    [appraiseBtn.layer setBorderWidth:1.0];
    appraiseBtn.el_toSize(CGSizeMake(40, 20)).el_axisYToAxisY(icon,0).el_rightToSuperView(20);
    [appraiseBtn bk_whenTapped:^{
        if ([_delegate respondsToSelector:@selector(appraiseBtnAction)]) {
            [_delegate appraiseBtnAction];
        }
    }];
    
    CGFloat star = myAppraiseModel.star.floatValue / 2;
    for (int i = 0; i < 5; i ++) {
        StarView *starView = [StarView new];
        [_pointView addSubview:starView];
        starView.el_toSize(CGSizeMake(13, 13)).el_topToBottom(userName,5).el_leftToLeft(userName,0 + (i * 13));
        starView.backgroundColor = [UIColor clearColor];
        
        if (star >= 1) {
            [starView setPercent:1];
        }else if(star < 0) {
            [starView setPercent:0];
        }else{
            [starView setPercent:star];
        }
        star -= 1;
        
        if (i == 4) {
            UILabel *starLB = [UILabel new];
            [_pointView addSubview:starLB];
            starLB.el_toSize(CGSizeMake(20, 30)).el_axisYToAxisY(starView,0).el_leftToRight(starView,5);
            starLB.text = [NSString stringWithFormat:@"%.1f",myAppraiseModel.star.floatValue];
            starLB.font = [UIFont systemFontOfSize:11];
            starLB.textColor = [UIColor grayColor];
        }
    }
    //65
    UILabel *contentLB = [UILabel new];
    [_pointView addSubview:contentLB];
    contentLB.el_topToBottom(icon,25).el_leftToLeft(userName,0).el_rightToSuperView(20);
    contentLB.numberOfLines = 4;
    contentLB.font = [UIFont systemFontOfSize:14];
    contentLB.text = myAppraiseModel.content;
    //高度计算
    self.height += [myAppraiseModel.content di_sizeOfStringToLable:[UIFont systemFontOfSize:14] width:ScreenWidth-70].height;
    
    
    if (myAppraiseModel.tags.count != 0) {
        UIView *lineView = [ViewFactory createLineView:self];
        lineView.el_topToBottom(contentLB,10).el_leftToLeft(contentLB,0).el_rightToSuperView(0);
        
        UIView *tagBGV = [UIView new];
        [_pointView addSubview:tagBGV];
        tagBGV.el_topToBottom(lineView,10).el_leftToLeft(lineView,0).el_rightToSuperView(0);
        
        CGRect frame = CGRectMake(0, 0, 0, 18);
        int rowCount = 0;
        for (int i = 0; i < myAppraiseModel.tags.count; i++) {
            TagsModel *tagModel = myAppraiseModel.tags[i];
            CGFloat tagsWidth = [self getLableWidth:tagModel.name tagCount:tagModel.thumbs_up.intValue height:frame.size.height];
            frame.size.width = tagsWidth;
            
            TagView *tagView = [[TagView alloc] initWithFrame:frame TagType:TagTypeSolidLine BorderColor:[UIColor di_MAIN2]];
            tagView.tagText.textColor = [UIColor di_MAIN2];
            [tagBGV addSubview:tagView];
            if(tagModel.thumbs_up.intValue > 99){
                tagView.tagText.text = [NSString stringWithFormat:@"%@ | %@",tagModel.name,@"99+"];
            }else{
                tagView.tagText.text = [NSString stringWithFormat:@"%@ | %d",tagModel.name,tagModel.thumbs_up.intValue];
            }
            
            frame.origin.x = frame.origin.x + tagsWidth + 10;
            if(i < myAppraiseModel.tags.count - 1){
                TagsModel *nextTagModel = myAppraiseModel.tags[i+1];
                CGFloat nextTagsWidth = [self getLableWidth:nextTagModel.name tagCount:nextTagModel.thumbs_up.intValue height:frame.size.height];
                if (frame.origin.x + nextTagsWidth + 10> ScreenWidth - 50) {
                    //限制行数--------------------------------------------
                    rowCount ++;
                    if (rowCount >= 3) {
                        break;
                    }
                    frame.origin.x  = 0;
                    frame.origin.y += frame.size.height + 10;
                }
            }
        }
        self.height += frame.origin.y + frame.size.height;
    }
    
    
    return _pointView;
}

-(CGFloat) setMyappraiseModelOfHigtReturns:(AppraiseModel *)myAppraiseModel{
    
    [self createPointView:myAppraiseModel];

    return self.height + 95;
}


-(float) getLableWidth:(NSString *) labelText tagCount:(int)tagCount height:(CGFloat)height{
    NSString *text = [NSString stringWithFormat:@"%@ | %d",labelText,tagCount];
    CGSize size = [text di_sizeOfStringToLable:[UIFont systemFontOfSize:height/2] width:CGFLOAT_MAX];
    return size.width + 20;
}
@end
