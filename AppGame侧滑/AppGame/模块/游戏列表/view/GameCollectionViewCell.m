//
//  GameCollectionViewCell.m
//  AppGame
//
//  Created by supozheng on 2017/5/10.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameCollectionViewCell.h"
#import "UIButton+AGExtension.h"
#import "CategoryModel.h"
#import "DownLinkModel.h"

@interface GameCollectionViewCell()
@property(nonatomic,strong)UIButton *goButton;
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *descripLable;
@property(nonatomic,strong)NSString *goLink;
@end

@implementation GameCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}


-(void)setupView{
    self.backgroundColor = [UIColor whiteColor];
    
    //创建子控件
    //图片
    UIImageView *iconView = [[UIImageView alloc] init];
    [self.contentView addSubview:iconView];
    [iconView setImage:[UIImage imageNamed:@"icon_download_pre"]];
    self.iconView = iconView;
    //名称
    UILabel *nameLable = [[UILabel alloc] init];
    [self.contentView addSubview:nameLable];
    self.nameLable = nameLable;
    self.nameLable.text = @"名字";
    nameLable.font = [UIFont systemFontOfSize:14];
    //描述
    UILabel *descripLable = [[UILabel alloc] init];
    [self.contentView addSubview:descripLable];
    self.descripLable = descripLable;
    descripLable.font = [UIFont systemFontOfSize:12];
    descripLable.textColor = [UIColor HEX:0x9b9b9b];
    
    //按钮
    UIButton *goButton = [[UIButton alloc] init];
    [self.contentView addSubview:goButton];
    
    [goButton setTitle:@"去玩" font:[UIFont systemFontOfSize:12] color:[UIColor di_MAIN2] forState:UIControlStateNormal];
    goButton.backgroundColor = [UIColor clearColor];
    [goButton.layer setMasksToBounds:YES];
    [goButton.layer setCornerRadius:5];
    [goButton.layer setBorderWidth:1.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 25/255.0, 177/255.0, 184/255.0, 1 });
    [goButton.layer setBorderColor:colorref];
    self.goButton = goButton;
    
    float ratio = 333/242.f;
    iconView.el_edgesToSuperView(0,0,self.height - self.width/ratio,0);
    nameLable.el_topToBottom(iconView,8).el_leftToSuperView(5).el_toWidth(130);
    descripLable.el_topToBottom(nameLable,5).el_leftToSuperView(5);
    goButton.el_rightToSuperView(5).el_topToBottom(iconView, 26).el_toSize(CGSizeMake(40, 22));
    
    [goButton bk_whenTapped:^{
        [self.goLink installApp];
    }];

}

-(void)setGameData:(GameModel*)gameModel{
    
    _gameData = gameModel;
    //直接release无需判断也是可以的，iOS中对nil进行release操作合法
    //[_test1 release];

    if(gameModel){
        
        self.nameLable.text = gameModel.game_name_cn;
        
        [self.iconView sd_setImageWithURL:gameModel.cover];
        
        NSMutableString *descriptionStr = [[NSMutableString alloc] init];
        for (CategoryModel *category in gameModel.categoryArray) {
            [descriptionStr appendString:category.name];
            [descriptionStr appendString:@" "];
        }
        
        self.descripLable.text = descriptionStr;
        
        for (DownLinkModel *linkModel in gameModel.downLinkArray) {
            if([@"ios" isEqualToString:linkModel.platform]){
                self.goLink = [linkModel.link absoluteString];
            }
        }
    }
}

@end
