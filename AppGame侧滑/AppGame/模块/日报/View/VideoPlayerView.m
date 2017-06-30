//
//  VideoPlayerView.m
//  Video
//
//  Created by gongwenkai on 2016/12/16.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "VideoPlayerView.h"


#define kTimeLabWidth self.videoHeight * 0.4            //当前时间 总时间 Label宽
#define kBtnWidth self.videoHeight * 0.15                //按钮宽度
#define kUIy self.toolView.frame.size.height * 0.6      //大部分ui的y
#define kUIHeight self.videoHeight * 0.15               //大部分ui的高

#define kWHeight 36   // 显示数据的宽高

@interface VideoPlayerView()
@property (nonatomic,copy) NSString *path;                  //播放地址 自动判断文件路径和网址路径
@property (nonatomic,strong) AVPlayer *player;              //播放类
@property (nonatomic,strong) AVPlayerLayer *playerlayer;    //显示区域
@property (nonatomic,strong) UIButton *playBtn;             //播放暂停

@property (nonatomic,strong)UIButton *voiceBtn;              // 声音开关
@property (nonatomic ,strong)  id timeObser;    // 正在播放监听
@property (nonatomic,copy)NSString *totalTime; //播放总时长
@property (nonatomic,copy)NSString *currentTime; //播放当前时间

@property (nonatomic,strong) UIButton *stopBtn;             // 停止
@property (nonatomic,strong) UIButton *fullScreenBtn;       //全屏
@property (nonatomic,strong) UISlider *playSlider;          //进度选择
@property (nonatomic,strong) UIProgressView *progress;      //进度
@property (nonatomic,strong) UILabel *currentTimeLab;       //当前时间
@property (nonatomic,strong) UILabel *durationLab;          //总时间
@property (nonatomic,strong) UIView *toolView;              //工具栏view
@property (nonatomic,assign) BOOL isFullScreen;             //全屏判断
@property (nonatomic,assign) CGFloat videoHeight;           //video高
@property (nonatomic,assign) CGFloat videoWidth;            //video宽
@end

@implementation VideoPlayerView

//KVO检测状态
static  NSString*  const kItemStatus = @"status";
static  NSString*  const kItemLoadedTimeRanges = @"loadedTimeRanges";
static  CGFloat    const kTopMargin = 20; //上间隔
static  CGFloat    const kLrMargin = 15;  //左右间隔
#pragma mark - 初始化
//初始化
- (instancetype)initWithFrame:(CGRect)frame andPath:(NSString*)path {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.path = path;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
//        self.videoHeight = height > width ? width * 0.6 : height * 0.6;
//        self.videoWidth = [UIScreen mainScreen].bounds.size.width-2*kLrMargin;
        
        self.videoWidth = width - 36;
        self.videoHeight = self.videoWidth * 9 / 16;
        [self.layer addSublayer:self.playerlayer];
        [self addSubview:self.toolView];
    
    }
    return self;
}

#pragma mark - 懒加载
//加载显示层
- (AVPlayerLayer*)playerlayer {
    if (!_playerlayer) {
        _playerlayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        
//        _playerlayer.bounds = CGRectMake(0, 0, self.videoWidth, self.videoHeight);
        _playerlayer.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 36, ([UIScreen mainScreen].bounds.size.width - 36) * 9 / 16);
        _playerlayer.anchorPoint = CGPointMake(0, 0);
//        _playerlayer.position = CGPointMake(kLrMargin, kTopMargin);
        _playerlayer.position = CGPointMake(0, 0);
        _playerlayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    return _playerlayer;
}

//加载播放类
- (AVPlayer *)player {
    if (!_player) {
        _player = [AVPlayer playerWithURL:[self getUrlPath:self.path]];
        
        //kvo注册
        [self addObservers];
    }
    return _player;
}


//工具栏
-(UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
        _toolView.backgroundColor = [UIColor clearColor];
        [_toolView addSubview:self.playBtn];
        [_toolView addSubview:self.voiceBtn];
        [_toolView addSubview:self.stopBtn];
        [_toolView addSubview:self.durationLab];
        [_toolView addSubview:self.currentTimeLab];
        [_toolView addSubview:self.playSlider];
        [_toolView addSubview:self.fullScreenBtn];
    }
    //调用刷新frame
//    CGFloat y = self.playerlayer.frame.origin.y + self.playerlayer.frame.size.height;
    
    CGFloat width = self.videoWidth;
    CGFloat height = 2*kUIHeight+kLrMargin;
    
    CGFloat y = self.playerlayer.frame.origin.y + self.playerlayer.frame.size.height - height;
//    _toolView.frame = CGRectMake(0, y, width, height);
    _toolView.frame = self.playerlayer.bounds;
    return _toolView;
}

//播放暂停
- (UIButton *)playBtn {
    if (!_playBtn) {
//        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kUIy, kBtnWidth, kUIHeight)];
        _playBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kWHeight, kWHeight)];
//        _playBtn.hidden = YES;
        _playBtn.center = self.toolView.center;
        _playBtn.backgroundColor  =[UIColor clearColor];
        _playBtn.selected = NO;
        _playBtn.enabled = NO;
        _playBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_playBtn setImage:[UIImage imageNamed:@"ic_video_play"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"ic_video_0"] forState:UIControlStateSelected];
        [_playBtn setImage:[UIImage imageNamed:@"ic_video_pause"] forState:UIControlStateHighlighted];
        [_playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

//声音图片
- (UIButton *)voiceBtn {
    if (!_voiceBtn) {
//        _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kUIy,  kBtnWidth, kUIHeight)];
        _voiceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.toolView.frame.size.height - kWHeight, kWHeight, kWHeight)];
        _voiceBtn.backgroundColor  =[UIColor clearColor];
        _voiceBtn.selected = NO;
//        _voiceBtn.enabled = NO;
//        _voiceBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_voiceBtn setImage:[UIImage imageNamed:@"ic_mute"] forState:UIControlStateNormal];
        [_voiceBtn setImage:[UIImage imageNamed:@"ic_play"] forState:UIControlStateSelected];
        [_voiceBtn addTarget:self action:@selector(switchVoice) forControlEvents:UIControlEventTouchUpInside];
        self.player.volume = 0.0;
    }
    return _voiceBtn;
}

//停止按钮
- (UIButton *)stopBtn {
    if (!_stopBtn) {
        _stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.playBtn.frame.origin.x + self.playBtn.frame.size.width + kLrMargin, kUIy, kBtnWidth, kUIHeight)];
        _stopBtn.backgroundColor  =[UIColor orangeColor];
        _stopBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _stopBtn.hidden = YES;
        [_stopBtn setTitle:@"停止" forState:UIControlStateNormal];
        [_stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];

    }
    return _stopBtn;
}

//全屏按钮
- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
//        _fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.stopBtn.frame.origin.x + self.stopBtn.frame.size.width + kLrMargin, kUIy, kBtnWidth, kUIHeight)];
        _fullScreenBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.toolView.frame.size.width -kBtnWidth - kLrMargin, kUIy, kBtnWidth, kUIHeight)];
        _fullScreenBtn.hidden = YES;
        _fullScreenBtn.backgroundColor  =[UIColor clearColor];
        _fullScreenBtn.titleLabel.adjustsFontSizeToFitWidth = YES;

        [_fullScreenBtn setTitle:@"时间" forState:UIControlStateNormal];
        [_fullScreenBtn addTarget:self action:@selector(fullScreen) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _fullScreenBtn;
}

//选择
- (UISlider *)playSlider {
    if (!_playSlider) {
        _playSlider = [[UISlider alloc] init];
        _playSlider.maximumTrackTintColor = [UIColor clearColor];
        _playSlider.minimumTrackTintColor = [UIColor clearColor];
        [_playSlider addSubview:self.progress];
        
        // 将滑块赋图片 图片的大小就是显示的大小
        // 通常状态下
        [_playSlider setThumbImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
        // 滑动状态下
        [_playSlider setThumbImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateHighlighted];
    }
    _playSlider.frame = CGRectMake(kWHeight, self.toolView.frame.size.height - kWHeight, self.videoWidth-2*kWHeight, kWHeight);
    return _playSlider;
}
//进度
- (UIProgressView *)progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc] init];
        _progress.progress = 0;
    }
    _progress.frame = CGRectMake(2, self.playSlider.frame.size.height/2, self.playSlider.frame.size.width-2-2, kWHeight);
    return _progress;
}

//当前时长
- (UILabel *)currentTimeLab {
    if (!_currentTimeLab) {
        _currentTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.fullScreenBtn.frame.origin.x + self.fullScreenBtn.frame.size.width + kLrMargin, kUIy, kTimeLabWidth, kUIHeight)];
        _currentTimeLab.hidden = YES;
        _currentTimeLab.text = @"00:00:00";
        _currentTimeLab.backgroundColor = [UIColor clearColor];
        _currentTimeLab.textAlignment = NSTextAlignmentRight;
        _currentTimeLab.adjustsFontSizeToFitWidth = YES;
        [self.toolView addSubview:_currentTimeLab];

    }
    return _currentTimeLab;
}

//总时长
- (UILabel *)durationLab {
    if (!_durationLab) {
//        _durationLab = [[UILabel alloc] initWithFrame:CGRectMake(self.currentTimeLab.frame.origin.x + self.currentTimeLab.frame.size.width, kUIy, kTimeLabWidth, kUIHeight)];
        _durationLab = [[UILabel alloc] initWithFrame:CGRectMake(self.toolView.frame.size.width - kWHeight-2, self.toolView.frame.size.height - kWHeight, kWHeight, kWHeight)];
        _durationLab.text = @"00:00";
//        _durationLab.center = CGPointMake(self.fullScreenBtn.center.x, self.fullScreenBtn.center.y + 3);
        _durationLab.textColor = [UIColor whiteColor];
        _durationLab.backgroundColor = [UIColor clearColor];
        _durationLab.adjustsFontSizeToFitWidth = YES;
        [self.toolView addSubview:_durationLab];

   
    }
    return _durationLab;
}



#pragma mark - 添加KVO
//注册kvo
- (void)addObservers{
    [self.player.currentItem addObserver:self forKeyPath:kItemStatus options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self forKeyPath:kItemLoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    
    //播放结束监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

//播放完成
- (void)playbackFinished:(NSNotification *)note
{
    NSLog(@"%s %d",__func__,__LINE__);
    [self.player pause];
    [self.player seekToTime:CMTimeMake(0, 1)];
    self.playBtn.selected = NO;
}

//移除kvo
- (void)dealloc {
    
    [self.player removeTimeObserver:_timeObser];
    [self.player.currentItem removeObserver:self forKeyPath:kItemStatus];
    [self.player.currentItem removeObserver:self forKeyPath:kItemLoadedTimeRanges];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

//kvo回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:kItemStatus]) {
        AVPlayerItem *item = object;
        if (item.status == AVPlayerItemStatusReadyToPlay) {
            //准备播放
            [self readyToplayWithItem:item];
            
        }else if (item.status == AVPlayerItemStatusUnknown) {
            //播放失败
            UIAlertController *alertConteroller = [UIAlertController alertControllerWithTitle:@"错误" message:@"AVPlayerItemStatusUnknown\n播放失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:UIAlertActionStyleDefault];
            [alertConteroller addAction:action];
            
        }else if (item.status == AVPlayerItemStatusFailed) {
            //播放失败
            UIAlertController *alertConteroller = [UIAlertController alertControllerWithTitle:@"错误" message:@"AVPlayerItemStatusFailed\n播放失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:UIAlertActionStyleDefault];
            [alertConteroller addAction:action];
        }
    } else if ([keyPath isEqualToString:kItemLoadedTimeRanges]) {
        AVPlayerItem *item = object;
        [self getLoadedTimeRanges:item];
    }
}

#pragma mark - 基础功能
//声音的开关
- (void)switchVoice
{
    if (self.voiceBtn.selected) {
        self.voiceBtn.selected = NO;
        self.player.volume = 0.0;
    }else{
        self.voiceBtn.selected = YES;
        self.player.volume = 0.4;
    }
}

//播放 暂停
- (void)play {
    if (self.playBtn.selected) {
        self.playBtn.selected = NO;
        self.playBtn.alpha = 1.0;
        [self.player pause];
    } else {
        self.playBtn.selected = YES;
        
        [self.player play];
        self.playBtn.alpha = 0.1;
        [self timerStar];
    }
}

- (BOOL)isPlaying
{
    return self.playBtn.selected;
}

//停止
- (void)stop {
    [self.player pause];
    [self.player seekToTime:CMTimeMake(0, 1)];
    self.playBtn.selected = NO;
}
//全屏
- (void)fullScreen {
    self.toolView.hidden = YES;
    self.isFullScreen = YES;
    self.backgroundColor = [UIColor blackColor];
    self.playerlayer.bounds = [UIScreen mainScreen].bounds;
    self.playerlayer.anchorPoint = CGPointMake(0, 0);
    self.playerlayer.position = CGPointMake(0, 0);
}

//播放指定位置
- (void)playCurrentVideo {
    
    self.playBtn.selected = YES;
    NSTimeInterval second = self.playSlider.value;
    [self.player.currentItem seekToTime:CMTimeMake(second,1)];
    [self.player play];
    [self timerStar];
    
}

//旋转屏幕重设frame
- (void)resetFrame:(CGSize)size {
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    self.videoHeight = height > width ? width * 0.6 : height * 0.6;
    self.videoWidth = size.width - 2 * kLrMargin;
    
    if (self.isFullScreen) {
        //全屏时旋转
        [self setPlayerWithPosition:CGPointZero andSize:size];
    } else {
        //普通旋转
        [self setPlayerWithPosition:CGPointMake(kLrMargin, kTopMargin) andSize:CGSizeMake(self.videoWidth, self.videoHeight)];
        //刷新frame
        [self toolView];
        [self playSlider];
        [self progress];
    }
}



#pragma mark - 具体操作实现
//设置video的frame
- (void)setPlayerWithPosition:(CGPoint)position andSize:(CGSize)size {
    self.playerlayer.anchorPoint = CGPointMake(0, 0);
    self.playerlayer.position = position;
    self.playerlayer.bounds = CGRectMake(0, 0, size.width, size.height);
}

//准备播放
- (void)readyToplayWithItem:(AVPlayerItem*)item {
    self.playBtn.enabled = YES;
    long long durationSecond = item.duration.value / item.duration.timescale;
    NSString *totalTime = [NSString stringWithFormat:@" %@",[self getFormatDate:durationSecond]];
    self.durationLab.text = totalTime;
    self.totalTime = totalTime;
    self.playSlider.maximumValue = durationSecond;
    self.playSlider.minimumValue = 0;
    [self.playSlider addTarget:self action:@selector(playCurrentVideo) forControlEvents:UIControlEventValueChanged];

}

//获得缓存
- (void)getLoadedTimeRanges:(AVPlayerItem*)item {
    NSValue *value = [item.loadedTimeRanges lastObject];
    CMTimeRange range = [value CMTimeRangeValue];
    long long cacheSecond = range.start.value/range.start.timescale + range.duration.value/range.duration.timescale;
    long long currentSecond = item.currentTime.value / item.currentTime.timescale;
    self.progress.progress = (currentSecond + cacheSecond) * 0.1;
  
}


//格式化时间
- (NSString*)getFormatDate:(NSTimeInterval)time {
    int seconds = (int)time % 60;
    int minutes = (int)(time / 60) % 60;
    int hours = (int)time / 3600;
    if (hours == 0) {
        return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
//    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
}

//格式化url路径
- (NSURL*)getUrlPath:(NSString*)path {
    NSURL *url;
    if ([self.path containsString:@"http"]) {
        url = [NSURL URLWithString:self.path];
    } else {
        url = [NSURL fileURLWithPath:self.path];
    }
    return url;
}

//开启定时
- (void)timerStar {
    //定时回调
    __weak typeof(self) weakSelf = self;
    _timeObser = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        long long current = weakSelf.player.currentItem.currentTime.value / weakSelf.player.currentItem.currentTime.timescale;
        weakSelf.playSlider.value = current;
        
        NSString *currentFormat = [weakSelf getFormatDate:current];
        weakSelf.currentTimeLab.text = [NSString stringWithFormat:@"%@",currentFormat];
        
        weakSelf.currentTime = [NSString stringWithFormat:@"%@",currentFormat];
//        NSLog(@"%@ -- %@",weakSelf.totalTime,weakSelf.currentTime);
        
    }];
    
}


//触摸关闭全屏
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.isFullScreen) {
        self.toolView.hidden = NO;
        self.backgroundColor = [UIColor clearColor];
        [self setPlayerWithPosition:CGPointMake(kLrMargin, kTopMargin) andSize:CGSizeMake(self.videoWidth, self.videoHeight)];
        
        [self toolView];
        [self playSlider];
        [self progress];
        self.isFullScreen = NO;
    }
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

@end
