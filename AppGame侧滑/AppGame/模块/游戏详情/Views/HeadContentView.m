//
//  HeadView.m
//  AppGame
//
//  Created by chan on 17/5/11.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "HeadContentView.h"
#import "CountView.h"
#import "DownLinkModel.h"
@interface HeadContentView ()
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) UIImageView *gameIcon;
@property(nonatomic,strong) UILabel *gameName;
@property(nonatomic,strong) UILabel *fileSize;
/** 画圆工具 */
@property (nonatomic, strong) CountView *countView;
@end
@implementation HeadContentView
-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        [self addSubview:_bgView];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.shadowOffset=CGSizeMake(3, 3);
        _bgView.layer.cornerRadius=5;
        _bgView.layer.shadowColor = [UIColor grayColor].CGColor;
        _bgView.layer.shadowOpacity=0.5;
        _bgView.layer.shadowRadius=5;
    }
    return _bgView;
}

-(UIImageView *)gameIcon{
    if (!_gameIcon) {
        _gameIcon = [UIImageView new];
        [self.bgView addSubview:_gameIcon];
        _gameIcon.layer.cornerRadius = 8;
        _gameIcon.layer.masksToBounds = YES;
    }
    return _gameIcon;
}

-(UILabel *)gameName{
    if (!_gameName) {
        _gameName = [UILabel new];
        [self.bgView addSubview:_gameName];
        _gameName.font = [UIFont systemFontOfSize:15];
    }
    return _gameName;
}

-(UILabel *)fileSize{
    if (!_fileSize) {
        _fileSize = [UILabel new];
        [self addSubview:_fileSize];
        _fileSize.font = [UIFont systemFontOfSize:11];
        _fileSize.textColor = [UIColor grayColor];
    }
    return _fileSize;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bgView.el_toHeight(70).el_bottomToSuperView(3).el_leftToSuperView(20).el_rightToSuperView(20);
        
        self.gameIcon.el_toSize(CGSizeMake(50, 50)).el_axisYToSuperView(0).el_leftToSuperView(10);
        
        self.countView = [[CountView alloc] init];
        [self.bgView addSubview:self.countView];
        [self.countView buildView:50.f height:50.f];
        self.countView.el_axisYToSuperView(0).el_rightToSuperView(20).el_toSize(CGSizeMake(50, 50));
        
        
        self.gameName.el_leftToRight(self.gameIcon,10).el_topToTop(self.gameIcon,5).el_rightToLeft(self.countView,5);
        
        self.fileSize.el_leftToLeft(self.gameName,0).el_topToBottom(self.gameName,10);
//        self.fileSize.text = @"123.3M";
        
    }
    return self;
}

- (void)setGameModel:(GameModel *)gameModel{
    
    for (DownLinkModel *link in gameModel.downLinkArray) {
        if ([link.platform.lowercaseString isEqualToString:@"ios"]) {
            self.fileSize.text = [NSString stringWithFormat:@"%@M",link.size];
            break;
            }
    
    }
    
    [self.gameIcon sd_setImageWithURL:gameModel.icon];
    self.gameName.text = gameModel.game_name_cn;
    self.countView.percent = gameModel.avg_appraise_star.floatValue / 10.f;
    [self.countView showWithAnimated];
}

@end
