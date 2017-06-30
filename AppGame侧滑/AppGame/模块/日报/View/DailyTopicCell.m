//
//  DailyTopicCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/19.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "DailyTopicCell.h"
#import <UIImageView+WebCache.h>
#import <AVFoundation/AVFoundation.h>
#import "StarsView.h"
#import "DiffUtil.h"
#import "ZFPlayerModel.h"

#import "AppDelegate.h"


@interface DailyTopicCell ()<ZFPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *gameIcon;
@property (weak, nonatomic) IBOutlet UILabel *gameName;

@property (weak, nonatomic) IBOutlet UIView *playView;

@property (strong, nonatomic) IBOutlet ZFPlayerView *playerView;


@property (weak, nonatomic) IBOutlet UIImageView *coverImage;


@property (weak, nonatomic) IBOutlet UILabel *gameStarsLabel;
@property (weak, nonatomic) IBOutlet UIButton *downLoadBtn;

@property (weak, nonatomic) IBOutlet UILabel *gameIntro;

@property (weak, nonatomic) IBOutlet StarsView *startView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startViewWidthConst;

//@property (nonatomic,strong)AVPlayer *player;

@end

@implementation DailyTopicCell

/*
#pragma mark - 懒加载代码
- (AVPlayer *)setupPlayer:(NSURL *)url
{
        // 获取URL(远程/本地)
//        NSURL *url = [NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
    
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
        
        // 3.创建AVPlayer
        _player = [AVPlayer playerWithPlayerItem:item];
    
        _player.volume = 0.0;
    
        // 4.添加AVPlayerLayer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_player];
        layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 36, ([UIScreen mainScreen].bounds.size.width - 36) * 9 / 16);
        [self.playView.layer addSublayer:layer];
    
    return _player;
}
*/
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
    }
    return self;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    DailyTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DailyTopicCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"DailyTopicCell" owner:nil options:nil].firstObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//修改字体颜色
- (void)setFontColor:(NSString *)fontColor
{
    _fontColor = fontColor;
    
    UIColor *color = [DiffUtil colorWithHexString:fontColor];
    
    self.gameName.textColor = color;
    self.gameIntro.textColor = color;
    [self.downLoadBtn setTitleColor:color forState:UIControlStateNormal];
    self.gameStarsLabel.textColor = color;
}


- (void)setGame:(GameModel *)game
{
    _game = game;
    
    [self.gameIcon sd_setImageWithURL:game.icon];
    self.gameName.text = game.game_name_cn;
    self.gameStarsLabel.text = game.avg_appraise_star;
    self.gameIntro.text = game.intro;
    
    [self setupStarView:game];//布局评价星星
    
    [self layoutIfNeeded];
    game.cellHeight = CGRectGetMaxY(self.gameIntro.frame) + 5;
    
//    [self setupVideo:game];//设置播放
//    self.videoPlayView = [[VideoPlayerView alloc] initWithFrame:self.playView.bounds andPath:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
    self.videoPlayView = [[VideoPlayerView alloc] initWithFrame:self.playView.bounds andPath:game.video.absoluteString];
    [self.playView addSubview:self.videoPlayView];
    
    //优先展示video
    if (game.video && ![game.video.absoluteString isEqualToString:@""]) {

        self.coverImage.hidden = YES;
    }else{
        self.coverImage.hidden = NO;
        [self.coverImage sd_setImageWithURL:game.cover];
    }
    
}

- (void)setupStarView:(GameModel *)game
{
    [self.startView removeAllSubviews];
    
    CGFloat starItem = 15;
    CGFloat starsMargin = 3;
    NSInteger starsCount = 5;
    StarsView *stars = [[StarsView alloc]initWithStarSize:CGSizeMake(starItem, starItem) space:starsMargin numberOfStar:starsCount];
    stars.selectable = NO;
    stars.score = game.avg_appraise_star.floatValue * 0.5;
    [self.startView addSubview:stars];
    
    self.startViewWidthConst.constant = starItem * starsCount + starsMargin * (starsCount - 1);
}

- (void)setupVideo:(GameModel *)game
{
    self.playerView = [[ZFPlayerView alloc] init];
    [self.playView addSubview:self.playerView];
    
    // 初始化控制层view(可自定义)
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    
    // 初始化播放模型
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.fatherView = self.playView;
    playerModel.videoURL = game.video;
    playerModel.title = game.game_name_cn;
    
    // 网络图片
    playerModel.placeholderImageURLString = game.cover.absoluteString;
    
    [self.playerView playerControlView:controlView playerModel:playerModel];
    
    //     设置代理
    self.playerView.delegate = self;
    //是否静音
//    self.playerView.mute = YES;
    //cell消失时是否停止
    self.playerView.stopPlayWhileCellNotVisable = YES;
   
    
    AppDelegate *differDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [[UIApplication sharedApplication].windows firstObject].rootViewController
    if (differDelegate.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN) {//流量
        
    }else{
        [self.playerView autoPlayTheVideo];
        [self.playerView startPlay];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor clearColor];
    
    self.downLoadBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.downLoadBtn.layer.borderWidth = 1.0;
    self.downLoadBtn.layer.cornerRadius = 5;
    self.downLoadBtn.layer.masksToBounds = YES;
    
   
}

- (IBAction)downLoadBtn:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(dailyTopicCellClickDownLoad:)]) {
        [self.delegate dailyTopicCellClickDownLoad:self.game];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//点击了播放
- (void)zf_playerAction
{
    NSLog(@"bof");
}

/** 播放按钮事件 */
- (void)zf_controlView:(UIView *)controlView playAction:(UIButton *)sender
{
    NSLog(@"bof");
}

@end
