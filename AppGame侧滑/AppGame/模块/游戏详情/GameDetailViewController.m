//
//  GameDetailViewController.m
//  AppGame
//
//  Created by chan on 17/5/12.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "GameDetailViewController.h"
#import "NavHeadView.h"
#import "HeadContentView.h"
#import "SelectView.h"
#import "DifferNetwork.h"
#import "GameDetailModel.h"
#import <MJExtension.h>
#import "DownLinkModel.h"
#import "ContentCell.h"
#import "AppraiseModel.h"
#import "CommentPageAboveCell.h"
#import "CorrelationGameCell.h"
#import "GameScoreCell.h"
#import "CommentPageViewController.h"
#import "FeedbackViewController.h"
#import "DiffUtil.h"
#import "GameServices.h"
#import "GameAppraiseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ViewFactory.h"
#import "ZFPlayer.h"
#import <BTLabel.h>

//选择View的高度
static const CGFloat SelectViewHeight = 45;

@interface GameDetailViewController ()<UIScrollViewDelegate,NavHeadViewDelegate,SelectViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ContentCellDelegate,CorrelationGameCellDelegate,GameScoreCellDelegate,ZFPlayerDelegate,CommentPageAboveCellDelegate>

@property(nonatomic,strong) UIView *ImgBackgroundV;
@property(nonatomic,strong) UIImageView *backgroundImageView;
@property(nonatomic,strong) UIScrollView *backgroundScrollView;
@property(nonatomic,strong) NavHeadView *navHeadView;
@property(nonatomic,strong) HeadContentView *headContentView;
@property(nonatomic,strong) SelectView *selectView;
@property(nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) UIButton *bottomButton;
/** 详情tableView */
@property (nonatomic, strong) UITableView *detailTableView;
/** 评价tableView */
@property (nonatomic, strong) UITableView *commentTableView;
/** 记录当前展示的tableView 计算顶部topView滑动的距离 */
@property (nonatomic, weak  ) UITableView *showingTableView;
/** 记录scrollView上次偏移的Y距离 */
@property (nonatomic, assign) CGFloat scrollY;
/** 记录scrollView上次偏移X的距离 */
@property (nonatomic, assign) CGFloat scrollX;
/** 数据模型*/
@property (nonatomic, strong) GameDetailModel *gameDetailModel;
@property (nonatomic, strong) NSMutableArray<AppraiseModel *> *appraiseList1;
@property (nonatomic, strong) NSMutableArray<AppraiseModel *> *appraiseList2;
@property (nonatomic, strong) AppraiseModel *myAppraiseModel;
@property (nonatomic, strong) NSMutableArray<TagsModel *> *tagsList;

@property(nonatomic,strong) NSString *goPlayLink;

@property(nonatomic,strong)ContentCell *contentCell;
@property(nonatomic,strong)CommentPageAboveCell *aboveCell;
@property(nonatomic,strong)CommentPageAboveCell *appraiseCell;

@property(nonatomic,strong)GameScoreCell *gameScoreCell;
@property(nonatomic,assign)CGFloat gameScoreCellHeight;

@property(nonatomic,assign)CGFloat scrollViewHeight;
@property(nonatomic,assign)CGFloat contentCellHeight;
@property(nonatomic,assign)NSInteger defaultLineNum;

//@property(nonatomic, strong) UIView *bottomReplyView;
//@property(nonatomic, strong) UITextField *bottomCommentTextField;
//@property(nonatomic, strong) UIView *coverView;
@property(nonatomic, strong) UIButton *likeBtn;

@property(nonatomic, strong)UIScrollView *showImageScrollView;
@property(nonatomic, strong)NSMutableArray *imageArray;
@property(nonatomic, strong)UIView *scrollViewCoverView;
@property(nonatomic,strong) ZFPlayerView *playView;
@property(nonatomic,strong) UIView *playerParentView;

@property(nonatomic,assign) BOOL isHotSort;
@end

@implementation GameDetailViewController
#pragma mark - 懒加载----------------------------


-(ZFPlayerView*)getPlayView:(NSURL*)videourl coverUrl:(NSString*)coverUrl{
    if(!_playView){
        self.playerParentView = [ViewFactory createView:self.ImgBackgroundV backgroundColor:[UIColor clearColor]];
        self.playerParentView.el_toSize(CGSizeMake(ScreenWidth, self.headContentView.y - 2)).el_topToSuperView(0).el_leftToSuperView(0);
        _playView = [[ZFPlayerView alloc] init];
        [_playView setCellPlayerOnCenter:YES];
        [self.playerParentView addSubview:_playView];
        _playView.el_edgesStickToSuperView();
        // control view（you can custom）
        ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
        // model
        ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
        playerModel.fatherView = self.playerParentView;
        playerModel.videoURL = videourl;
        playerModel.title = @"";
        playerModel.placeholderImageURLString = coverUrl;
        _playView.mute = YES;
        [controlView zf_playerCellPlay];
        [_playView playerControlView:controlView playerModel:playerModel];
        
        _playView.backgroundColor = [UIColor clearColor];
        
        // delegate
        _playView.delegate = self;
    }
    return _playView;
}

-(UIScrollView *)backgroundScrollView{
    if (!_backgroundScrollView) {
        _backgroundScrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backgroundScrollView.pagingEnabled = YES;
        _backgroundScrollView.bounces = NO;
        _backgroundScrollView.showsHorizontalScrollIndicator = NO;
        _backgroundScrollView.delegate = self;
        _backgroundScrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
        [self.view addSubview:_backgroundScrollView];
    }
    return _backgroundScrollView;
}

-(NavHeadView *)navHeadView{
    if (!_navHeadView) {
        _navHeadView = [[NavHeadView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _navHeadView.title = self.gameModel.game_name_cn;
        _navHeadView.delegate = self;
    }
    return _navHeadView;
}

-(HeadContentView *)headContentView{
    if (!_headContentView) {
        _headContentView = [[HeadContentView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
        CGPoint center = _headContentView.center;
        center.y = self.backgroundImageView.size.height - 10;
        _headContentView.center = center;
        _headContentView.gameModel = self.gameModel;
    }
    return _headContentView;
}

-(SelectView *)selectView{
    if (!_selectView) {
        _selectView = [[SelectView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ImgBackgroundV.frame), ScreenWidth, SelectViewHeight)];
        _selectView.delegate = self;
    }
    return _selectView;
}

-(UITableView *)detailTableView{
    if (!_detailTableView) {
        _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-50) style:UITableViewStyleGrouped];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
        _detailTableView.backgroundColor = [UIColor ag_G5];
        _detailTableView.showsVerticalScrollIndicator = NO;
        _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _detailTableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.selectView.frame), 0, 0, 0);
    }
    return _detailTableView;
}

-(UITableView *)commentTableView{
    if (!_commentTableView) {
        _commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-50) style:UITableViewStyleGrouped];
        _commentTableView.delegate = self;
        _commentTableView.dataSource = self;
        _commentTableView.showsVerticalScrollIndicator = NO;
        _commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTableView.contentInset = UIEdgeInsetsMake(CGRectGetMaxY(self.selectView.frame), 0, 0, 0);
    }
    return _commentTableView;
}

-(UIView *)ImgBackgroundV{
    if (!_ImgBackgroundV) {
        _ImgBackgroundV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth * 0.8)];
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.7)];
        [self.backgroundImageView sd_setImageWithURL:self.gameModel.cover];
        [_ImgBackgroundV addSubview:self.backgroundImageView];
        _ImgBackgroundV.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_ImgBackgroundV];
    }
    return _ImgBackgroundV;
}

-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [UIView new];
        [self.view addSubview:_bottomView];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.shadowColor = [UIColor blackColor].CGColor;
        _bottomView.layer.shadowOffset = CGSizeMake(0, -1);
        _bottomView.layer.shadowOpacity=0.1;
        
        UIImageView *imageView = [UIImageView new];
        [_bottomView addSubview:imageView];
        imageView.el_toSize(CGSizeMake(25, 25)).el_axisYToSuperView(0).el_leftToLeft(_bottomView, 20);
        imageView.image = [UIImage imageNamed:@"icon_tab_comment"];
        
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView addSubview:self.likeBtn];
        self.likeBtn.el_axisYToSuperView(0).el_toSize(CGSizeMake(70, 50)).el_rightToSuperView(0);
        [self.likeBtn setTitle:@"喜欢" forState:UIControlStateNormal];
        self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setLikeBtnState:NO];
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomView addSubview:playBtn];
        playBtn.el_axisYToSuperView(0).el_toSize(CGSizeMake(100, 50)).el_rightToLeft(self.likeBtn,0);
        [playBtn setTitle:@"去玩" forState:UIControlStateNormal];
        playBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [playBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"icon_tab_down_def"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"icon_tab_down_pre"] forState:UIControlStateHighlighted];
        
        self.bottomButton = [UIButton new];
        [_bottomView addSubview: self.bottomButton];
        self.bottomButton.el_toHeight(30).el_axisYToSuperView(0).el_leftToRight(imageView,10).el_rightToLeft(playBtn, 10);
        self.bottomButton.backgroundColor = [UIColor clearColor];
        [self.bottomButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.bottomButton setTitle:@"评价这个游戏" forState:UIControlStateNormal];
        self.bottomButton.titleLabel.font = [UIFont systemFontOfSize:12];
        self.bottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.bottomButton bk_whenTapped:^{
//            self.bottomReplyView.hidden = NO;
//            CGPoint point = self.bottomCommentTextField.frame.origin;
//            point.y = ScreenHeight;
//            [self.bottomReplyView setOrigin:point];
//            self.bottomCommentTextField.text = @"";
//            [self.bottomCommentTextField becomeFirstResponder];
            [self pushGameAppraiseVC];
        }];

        [playBtn bk_whenTapped:^{
            if(self.goPlayLink){
                [self.goPlayLink installApp];
            }
        }];
        
        [self.likeBtn bk_whenTapped:^{
            GameModel *game = self.gameModel;
            NSString *gameId = game.game_id != nil ? game.game_id : game.uid;
            NSString *isCollect = game.isCollect.integerValue ? @"delete" : @"add";
            

            
            [[[DifferNetwork shareInstance] collectionGameWithId:gameId action:isCollect] subscribeNext:^(id x) {
                game.isCollect = [NSString stringWithFormat:@"%d",!game.isCollect.integerValue];
                if(game.isCollect.integerValue){
                    self.gameModel.isCollect = @"1";
                    [self setLikeBtnState:YES];
                }else{
                    self.gameModel.isCollect = @"0";
                    [self setLikeBtnState:NO];
                }
                NSLog(@"喜欢游戏成功");
            } error:^(NSError *error) {
                NSLog(@"喜欢游戏失败：%@",error);
            }];
                
        }];
    }
    return _bottomView;
}

-(NSMutableArray<AppraiseModel*> *)appraiseList1{
    if (!_appraiseList1) {
        _appraiseList1 = [NSMutableArray array];
    }
    return _appraiseList1;
}

-(NSMutableArray<AppraiseModel*> *)appraiseList2{
    if (!_appraiseList2) {
        _appraiseList2 = [NSMutableArray array];
    }
    return _appraiseList2;
}

-(NSMutableArray<TagsModel *>*)tagsList{
    if (!_tagsList) {
        _tagsList = [NSMutableArray array];
    }
    return _tagsList;
}

//-(UIView *)coverView{
//    if (!_coverView) {
//        //创建一个遮罩
//        _coverView = [[UIView alloc] initWithFrame:self.view.frame];
//        _coverView.userInteractionEnabled = YES;
//        [self.view addSubview:_coverView];
//        [_coverView bk_whenTapped:^{
//            [self.bottomCommentTextField resignFirstResponder];
//        }];
//    }
//    return _coverView;
//}

//-(UIView *)bottomReplyView{
//    if(!_bottomReplyView){
//        
//        _bottomReplyView = [UIView new];
//        [self.view addSubview:_bottomReplyView];
//        _bottomReplyView.backgroundColor = [UIColor whiteColor];
//        _bottomReplyView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _bottomReplyView.layer.shadowOffset = CGSizeMake(0, -1);
//        _bottomReplyView.layer.shadowOpacity=0.1;
//        
//        UIButton *replyButton = [UIButton new];
//        [_bottomReplyView addSubview:replyButton];
//        replyButton.layer.cornerRadius = 5;
//        replyButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [replyButton setBackgroundColor:[UIColor di_MAIN2]];
//        [replyButton setTitle:@"发送" forState:UIControlStateNormal];
//        [replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        replyButton.el_toSize(CGSizeMake(50, 30)).el_axisYToSuperView(0).el_rightToRight(_bottomView,20);
//        
//        self.bottomCommentTextField = [UITextField new];
//        [_bottomReplyView addSubview:self.bottomCommentTextField];
//        self.bottomCommentTextField.delegate = self;
//        self.bottomCommentTextField.el_toHeight(30).el_axisYToSuperView(0).el_leftToSuperView(10).el_rightToLeft(replyButton, 20);
//        self.bottomCommentTextField.placeholder = @"请输入内容";
//        self.bottomCommentTextField.font = [UIFont systemFontOfSize:15];
//        
//        [replyButton bk_whenTapped:^{
//            [self.bottomCommentTextField resignFirstResponder];
//            if(![self.bottomCommentTextField.text isEqualToString:@""]){
//                NSString *gameID = self.gameModel.game_id == nil ? self.gameModel.uid : self.gameModel.game_id;
//                [[GameServices shareInstance] addTagOrCommentWithTarget:@"appraise" targetId:gameID name:self.bottomCommentTextField.text isTag:NO isSuccess:^(BOOL isSuccess) {
//                    if(isSuccess){
//                        [self loadData];
//                    }
//                }];
//            }
//        }];
//        
//    }
//    return _bottomReplyView;
//}

-(UIScrollView *)showImageScrollView{
    if (!_showImageScrollView) {
        _showImageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _showImageScrollView.bounces = NO;
        _showImageScrollView.pagingEnabled = YES;
        _showImageScrollView.showsHorizontalScrollIndicator = NO;
        _showImageScrollView.delegate = self;
        [self.view addSubview:_showImageScrollView];
        _showImageScrollView.hidden = YES;
    }
    return  _showImageScrollView;
}

-(UIView *)scrollViewCoverView{
    if (!_scrollViewCoverView) {
        _scrollViewCoverView = [[UIView alloc] initWithFrame:CGRectZero];
        _scrollViewCoverView.backgroundColor = [UIColor blackColor];
//        _scrollViewCoverView.alpha = 0.5;
    }
    return _scrollViewCoverView;
}

#pragma mark - 生命周期----------------------------
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    [self loadData];
    [self loadAppraiseDataoOrder:@"hot"];
    //监听键盘frame改变
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaultLineNum = 4;
    _isHotSort = YES;
    //将view的自动添加scroll的内容偏移关闭
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.backgroundScrollView];
    
    [self.backgroundScrollView addSubview:self.detailTableView];
    
    [self.backgroundScrollView addSubview:self.commentTableView];
    
    [self.ImgBackgroundV addSubview:self.headContentView];
    
    [self.view addSubview:self.navHeadView];
    
    [self.view addSubview:self.selectView];
    
    self.bottomView.el_toSize(CGSizeMake(ScreenWidth,50)).el_bottomToBottom(self.view,0).el_axisXToSuperView(0);
    
    
    
//    self.coverView.hidden = YES;
}


-(void)viewDidDisappear:(BOOL)animated{
    
}

- (void)dealloc
{
    NSLog(@"delloc ---- GameDetailViewController..");
    [self.playView removeFromSuperview];
    self.playView = nil;
}



//- (void)keyboardWillShow:(NSNotification *)notification{
//    NSDictionary *userInfo = [notification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardRect = [aValue CGRectValue];
//    CGFloat keyboardHeight = keyboardRect.size.height;
//    CGRect frame = self.bottomView.frame;
//    frame.origin.y = self.view.height - frame.size.height - keyboardHeight;
//    [self.bottomReplyView setFrame:frame];
//    self.coverView.hidden = NO;
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification{
//    self.bottomReplyView.hidden = YES;
//    self.coverView.hidden = YES;
//}

//点击屏幕处理方法，取消textField第一响应者
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [self.bottomCommentTextField resignFirstResponder];
//}

-(void)pushGameAppraiseVC{
    GameAppraiseViewController * gameAppraiceVC = [[GameAppraiseViewController alloc] init];
    gameAppraiceVC.gameModel = self.gameModel;
    gameAppraiceVC.appraiseModel = self.myAppraiseModel;
    [self.navigationController pushViewController:gameAppraiceVC animated:YES];
}

#pragma mark - 加载数据----------------------------
-(void)loadData{

    NSString *gameid = self.gameModel.game_id == nil ? self.gameModel.uid : self.gameModel.game_id;
    [[[DifferNetwork shareInstance] getGameDetail:gameid] subscribeNext:^(id responseObj) {
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *dataDic = [responseDict dictionaryForKey:@"data"];
        
        //替换掉当前的gamemodel
        GameModel *model = [GameModel mj_objectWithKeyValues:responseDict[@"data"]];
        self.gameModel = model;
        //        NSString *collected = [dataDic stringForKey:@"is_collected"];
        //        self.gameModel.isCollect = collected;
        
        GameDetailModel *gameDetailModel = [GameDetailModel mj_objectWithKeyValues:responseDict[@"data"]];
        for (DownLinkModel *linkModel in gameDetailModel.downLinkArray) {
            if([@"ios" isEqualToString:linkModel.platform]){
                self.goPlayLink = [linkModel.link absoluteString];
            }
        }
        self.gameDetailModel = gameDetailModel;
        
        float height = [@"的" getSpaceLabelHeight:[UIFont systemFontOfSize:16] withWidth:ScreenWidth-40 linespace:8];
        NSInteger lines = [[self.gameDetailModel.intro delLinebreaks] getLineNumbers:ScreenWidth-40 font:[UIFont systemFontOfSize:16]];
        NSLog(@" ---------- %@", self.gameDetailModel.intro);
        NSLog(@" ------------- lines = %lu",lines);
        
        if (lines > 4) {
            _contentCellHeight = height * 4;
        }else{
            _contentCellHeight = height * lines - 30;
        }
        //        CGFloat defaultHeight = [gameDetailModel.intro di_getLabelHeightFontSize:16 Width:(ScreenWidth-40) numberOfLines:_defaultLineNum];
        //        CGFloat totalHeight = [gameDetailModel.intro di_getLabelHeightFontSize:16 Width:(ScreenWidth-40)];
        //        if (totalHeight <= defaultHeight) {
        //            //总行数小于默认行数则减去“显示全文”按钮高度
        //            _contentCellHeight = defaultHeight -60;
        //        }else{
        //            _contentCellHeight = defaultHeight;
        //        }
        [self.detailTableView reloadData];
        if([self.gameModel.isCollect isEqualToString:@"1"]){
            [self setLikeBtnState:YES];
        }
        NSURL *videoUrl = model.video;
        NSLog(@" --------- %@",[videoUrl host]);
        if([videoUrl host]){
            
            [DiffUtil monitorNetwork:^(AFNetworkReachabilityStatus status) {
                if(status == AFNetworkReachabilityStatusReachableViaWWAN){
                    [self getPlayView:self.gameModel.video coverUrl:[self.gameModel.cover absoluteString]];
                }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){
                    
                    NSLog(@"network is wifi");
                    ZFPlayerView *playView = [self getPlayView:videoUrl coverUrl:[model.cover absoluteString]];
                    [playView startPlay];
                }
            }];
        }
    } error:^(NSError *error) {
        
    }];
}

-(void)loadAppraiseDataoOrder:(NSString *)order{
    NSString *gameid = self.gameModel.game_id == nil ? self.gameModel.uid : self.gameModel.game_id;
    [[[DifferNetwork shareInstance] getGameComment:gameid position:nil pageSize:@"10" order:order] subscribeNext:^(id responseObj) {
        [self.appraiseList1 removeAllObjects];
        [self.appraiseList2 removeAllObjects];
        
        NSDictionary *responseDict = (NSDictionary *)responseObj;
        NSDictionary *commentsArrayDict = responseDict[@"data"];
        NSArray *comments = commentsArrayDict[@"list"];
        NSNumber *isAppraise = commentsArrayDict[@"is_appraise"];
        
        if ([isAppraise isEqualToNumber:@1]) {
            NSDictionary *commentDic = commentsArrayDict[@"user_appraise"];
            [self.bottomButton setTitle:@"已评价该游戏" forState:UIControlStateNormal];
            self.myAppraiseModel = [AppraiseModel mj_objectWithKeyValues:commentDic];
            _gameScoreCellHeight = [self.gameScoreCell setMyappraiseModelOfHigtReturns:self.myAppraiseModel];
            [self.appraiseList1 addObject:self.myAppraiseModel];
        }
        
        for (NSDictionary *commentDict in comments) {
            AppraiseModel *appraiseModel = [AppraiseModel mj_objectWithKeyValues:commentDict];
            [self.appraiseList1 addObject:appraiseModel];
            [self.appraiseList2 addObject:appraiseModel];
        }
        
        [self.detailTableView reloadData];
        [self.commentTableView reloadData];
    } error:^(NSError *error) {
        
    }];
}

#pragma mark - 计算scrollView移动的方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //说明是tableView在滚动
    if (scrollView == self.detailTableView || scrollView == self.commentTableView) {
        //记录当前展示的是那个tableView
        self.showingTableView = (UITableView *)scrollView;
        //记录出上一次滑动的距离，因为是在tableView的contentInset中偏移的HeadViewHeight，所以都得加回来
        CGFloat offsetY = scrollView.contentOffset.y + self.ImgBackgroundV.height + 45;
        CGFloat seleOffsetY = offsetY - self.scrollY;
        self.scrollY = offsetY;
        
        //修改顶部的backgroundImgV位置 并且通知backgroundImgV内的控件也修改位置
        CGRect headRect = self.ImgBackgroundV.frame;
        headRect.origin.y -= seleOffsetY;
        self.ImgBackgroundV.frame = headRect;
        
        //CGRectGetMaxY(self.headContentView.frame)+10 是 设置selectView时的Y值   在减去导航高度64
        if (CGRectGetMaxY(self.ImgBackgroundV.frame) <= 64) {
            self.selectView.frame = CGRectMake(0, 64, ScreenWidth, SelectViewHeight);
        }else{
            self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.ImgBackgroundV.frame), ScreenWidth, SelectViewHeight);
        }
        
        //计算导航渐变显示
        if (offsetY > 120){
            CGFloat alpha =MIN(1,1 - ((120 +64 - offsetY) / 64));
            self.navHeadView.bgView.alpha = alpha;
        }else{
            self.navHeadView.bgView.alpha = 0;
        }
        
    }else{
        //说明是backgroundScrollView在滚动
        
        if (self.showingTableView == self.detailTableView) {
            self.commentTableView.contentOffset = self.detailTableView.contentOffset;
//            [self.commentTableView reloadData];
        } else {
            self.detailTableView.contentOffset = self.commentTableView.contentOffset;
//            [self.detailTableView reloadData];
        }
        
        CGFloat offsetX = self.backgroundScrollView.contentOffset.x;
        NSInteger index = offsetX / ScreenWidth;
        
        CGFloat seleOffsetX = offsetX - self.scrollX;
        self.scrollX = offsetX;
        
        //根据scrollViewX偏移量算出顶部selectViewline的位置
        if (seleOffsetX > 0 && offsetX / ScreenWidth >= (0.5 + index)) {
            [self.selectView lineToIndex:index + 1];
        } else if (seleOffsetX < 0 && offsetX / ScreenWidth <= (0.5 + index)) {
            [self.selectView lineToIndex:index];
        }
    }
}

#pragma mark - tableView代理方法-----------------------
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.detailTableView) {
        if (section == 1) {
            if (self.appraiseList2.count != 0) {
                return 10;
            }
        }
    }else{
        if (self.appraiseList2.count != 0) {
            return 10;
        }
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.detailTableView) {
        if (indexPath.section == 0) {
            
            return 215 + _contentCellHeight + _scrollViewHeight;
            
        }else if(indexPath.section == 1){
            //计算评论内容高度
            CGFloat  aboveCellLabelHeight = [self.appraiseList2[indexPath.row].content di_getLabelHeightFontSize:14 Width:ScreenWidth-70 numberOfLines:4];
            //计算标签高度
            for (TagsModel *tagsModel in self.appraiseList2[indexPath.row].tags) {
                [self.tagsList addObject:tagsModel];
            }
            CGFloat aboveCellTagsHeight = [self.aboveCell setTagView:self.tagsList isShowAddTagView:NO isLimitRows:YES];
            if (self.tagsList.count == 0) aboveCellTagsHeight -= 20;
            [self.tagsList removeAllObjects];
            //其余固定高度..第一行需要加上MoreView高度
            CGFloat height = 90;
            if (indexPath.row == 0) {
                height = 140;
            }
            return aboveCellLabelHeight + aboveCellTagsHeight + height;
            
        }else{
            CGFloat height = (ScreenWidth - 50)/2  * 1.2;
            return height + 65;
        }
    }else{
        if (indexPath.section == 0) {
//            height = 35 + 60;//上下间距各30
            if (self.myAppraiseModel) {
                return 120 + _gameScoreCellHeight;
            }
            return 215;
        }else{
            
            //计算评论内容高度
            CGFloat  aboveCellLabelHeight = [self.appraiseList2[indexPath.row].content di_getLabelHeightFontSize:14 Width:ScreenWidth-70 numberOfLines:4];
            //计算标签高度
            for (TagsModel *tagsModel in self.appraiseList2[indexPath.row].tags) {
                [self.tagsList addObject:tagsModel];
            }
            CGFloat aboveCellTagsHeight = [self.appraiseCell setTagView:self.tagsList isShowAddTagView:NO isLimitRows:YES];
            if (self.tagsList.count == 0) aboveCellTagsHeight -= 20;
            [self.tagsList removeAllObjects];
            //其余固定高度..第一行需要加上MoreView高度40
            CGFloat height = 90;
            if (indexPath.row == 0) {
                height = 140;
            }
            return aboveCellLabelHeight + aboveCellTagsHeight + height;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.detailTableView) return 2;
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.detailTableView) {
        if (section == 1) {
            if (!self.appraiseList2) {
                return 0;
            }else if (self.appraiseList2.count >3){
                return 3;
            }
            return self.appraiseList2.count;
        }else{
            return 1;
        }
    } //以下是commentTableView
    if (section == 0) {
        return 1;
    }
    return self.appraiseList2.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *pictureCellID = @"pictureCell";
    static NSString *commentCellID = @"commentCell";
//    static NSString *correlationGameCellID = @"correlationGameCell";
    static NSString *gameScoreCellID = @"gameScoreCell";
    static NSString *appraiseCellID = @"appraiseCell";
    if (tableView == self.detailTableView) {
        if (indexPath.section == 0) {
            self.contentCell = [tableView dequeueReusableCellWithIdentifier:pictureCellID];
            if (!self.contentCell) {
                self.contentCell = [[ContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pictureCellID];
            }

            self.contentCell.gameDetailModel = self.gameDetailModel;
            self.contentCell.delegate = self;
            self.contentCell.selectionStyle = UITableViewCellSelectionStyleNone;

            return self.contentCell;
            
        }else if(indexPath.section == 1){
            self.aboveCell = [tableView dequeueReusableCellWithIdentifier:commentCellID];
            if (!self.aboveCell) {
                self.aboveCell = [[CommentPageAboveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:commentCellID];
            }
            
            if (indexPath.row == 0) {
                [self.aboveCell isShowMoreView:YES isRemoveMoerView:NO isShowRortBtn:NO];
            }else{
                [self.aboveCell isShowMoreView:NO isRemoveMoerView:NO isShowRortBtn:NO];
            }
            
            [self.aboveCell setContentRow:4];
            self.aboveCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.aboveCell.appraiseModel = self.appraiseList2[indexPath.row];
            return self.aboveCell;

        }
        return nil;
//        else{
//            CorrelationGameCell *correlationGameCell = [tableView dequeueReusableCellWithIdentifier:correlationGameCellID];
//            if (!correlationGameCell) {
//                correlationGameCell = [[CorrelationGameCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:correlationGameCellID];
//            }
//            correlationGameCell.gameModelArr = self.gameDetailModel.relayGameArray;
//            correlationGameCell.delegate = self;
//            correlationGameCell.selectionStyle = UITableViewCellSelectionStyleNone;
//            return correlationGameCell;
//        }
    }else{   //以下是commentTableView
        
        if (indexPath.section == 0) {
            self.gameScoreCell = [tableView dequeueReusableCellWithIdentifier:gameScoreCellID];
            if (!self.gameScoreCell) {
                self.gameScoreCell = [[GameScoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gameScoreCellID];
            }
            self.gameScoreCell.delegate = self;
            self.gameScoreCell.gameModel = self.gameModel;
//            self.gameScoreCell.myAppraiseModel = self.myAppraiseModel;
            self.gameScoreCell.appraiseList = self.appraiseList1;
            [self.gameScoreCell.appraiseList addObject:self.myAppraiseModel];
            self.gameScoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.gameScoreCell;
        }else{
            self.appraiseCell = [tableView dequeueReusableCellWithIdentifier:appraiseCellID];
            if (!self.appraiseCell) {
                self.appraiseCell = [[CommentPageAboveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:appraiseCellID];
            }
            
            if (indexPath.row == 0) {
                [self.appraiseCell isShowMoreView:YES isRemoveMoerView:NO isShowRortBtn:YES];
            }else{
                [self.appraiseCell isShowMoreView:NO isRemoveMoerView:NO isShowRortBtn:NO];
            }
            [self.appraiseCell setContentRow:4];
            self.appraiseCell.delegate = self;
            self.appraiseCell.selectionStyle = UITableViewCellSelectionStyleNone;
            self.appraiseCell.appraiseModel = self.appraiseList2[indexPath.row];
            return self.appraiseCell;
        }
        
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((tableView == self.detailTableView && indexPath.section == 1) || (tableView == self.commentTableView && indexPath.section == 1)) {
        CommentPageViewController *commentPageVC = [[CommentPageViewController alloc] init];
        commentPageVC.appraiseModel = self.appraiseList2[indexPath.row];
        [self.navigationController pushViewController:commentPageVC animated:YES];
    }
}

#pragma mark - ContentCell的代理方法
-(void)showContentButtonAction:(UIButton *)button{
        if (button.selected == NO) {
            button.selected = YES;
            self.contentCell.describeLB.numberOfLines = 0;
            [self.contentCell.showMoreBtn setTitle:@"收起全文" forState:UIControlStateNormal];
            
            float height = [@"的" getSpaceLabelHeight:[UIFont systemFontOfSize:16] withWidth:ScreenWidth-40 linespace:8];

            NSInteger lines = [self.gameDetailModel.intro getLineNumbers:ScreenWidth-40 font:[UIFont systemFontOfSize:16]];
            
//                height = height * lines;
            _contentCellHeight = height * lines;
//            _contentCellHeight = [self.gameDetailModel.intro di_getLabelHeightFontSize:16 Width:ScreenWidth-40];
        }else{
            button.selected = NO;
            self.contentCell.describeLB.numberOfLines = _defaultLineNum;
            [self.contentCell.showMoreBtn setTitle:@"显示全文" forState:UIControlStateNormal];
    
            float height = [@"的" getSpaceLabelHeight:[UIFont systemFontOfSize:16] withWidth:ScreenWidth-40 linespace:8];
            
            NSInteger lines = [self.gameDetailModel.intro getLineNumbers:ScreenWidth-40 font:[UIFont systemFontOfSize:16]];
            
            if(lines > 4){
                height = height * 4;
            }else{
                height = height * lines;
                
            }
            _contentCellHeight = height;
//            _contentCellHeight = [self.gameDetailModel.intro di_getLabelHeightFontSize:16 Width:ScreenWidth-40 numberOfLines:_defaultLineNum];
        }
    [self.detailTableView reloadData];
}

-(void)showImageAction:(NSMutableArray *)imageViews{
    
    NSInteger index = imageViews.count - 1;//数组最后一个是tap手势
    UITapGestureRecognizer *tap = imageViews[index];
    CGRect frame = CGRectMake(0, 0, 0, 0);
    if (!self.imageArray) {
        self.imageArray = imageViews;
        
        self.scrollViewCoverView.frame = CGRectMake(0, 0, ScreenWidth* index, ScreenHeight);
        [self.showImageScrollView setContentSize:CGSizeMake(ScreenWidth* index, ScreenHeight)];
        [self.showImageScrollView addSubview:self.scrollViewCoverView];
        
        UIImageView *imageView = imageViews[0];
        
        if (imageView.image.size.height > imageView.image.size.width) {
            frame.size = CGSizeMake(ScreenWidth-40, ScreenHeight-100);
            frame.origin.y = ScreenHeight/2 - frame.size.height/2;
        }else{
            frame.size = CGSizeMake(ScreenWidth, ScreenWidth*0.65);
            frame.origin.y = ScreenHeight/2 - frame.size.height/2;
        }
        
        CGFloat imageXaxis = 0;
        for (int i = 0; i < index; i ++) {
            
            if (imageView.image.size.height > imageView.image.size.width) {
                imageXaxis = i * ScreenWidth + 20;
            }else{
                imageXaxis = i * ScreenWidth;
            }
            UIImageView *image = self.imageArray[i];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageXaxis, frame.origin.y, frame.size.width, frame.size.height)];
            imgView.image = image.image;
            [self.showImageScrollView addSubview:imgView];
        }
    }
    
    self.showImageScrollView.contentOffset = CGPointMake(ScreenWidth * tap.view.tag, 0);
    self.showImageScrollView.hidden = NO;
    [self.showImageScrollView bk_whenTapped:^{
        self.showImageScrollView.hidden = YES;
    }];
}

-(void)scrollViewHeight:(CGFloat)height{
    _scrollViewHeight = height;
    [self.detailTableView reloadData];
}

#pragma mark - GameScoreCell 的代理方法----------------------------
-(void)appraiseBtnAction{
    [self pushGameAppraiseVC];
}

-(void)pushAppraisePage{
    CommentPageViewController *commentPageVC = [[CommentPageViewController alloc] init];
    commentPageVC.appraiseModel = self.myAppraiseModel;
    [self.navigationController pushViewController:commentPageVC animated:YES];
}

-(void)clickSortBtn:(UIButton *)button{
    if (_isHotSort) {
        [button setTitle:@"按发布时间排列" forState:UIControlStateNormal];
        _isHotSort = NO;
        [self loadAppraiseDataoOrder:@"created_at"];
    }else{
        [button setTitle:@"按评价热度排列" forState:UIControlStateNormal];
        _isHotSort = YES;
        [self loadAppraiseDataoOrder:@"hot"];
    }
    
}

#pragma mark - 相关游戏的代理方法
//-(void)clickCorrelationGameCell:(NSInteger)tag{
//    NSLog(@"相关游戏第%ld个",tag);
//    GameDetailViewController *gameDetailVC = [[GameDetailViewController alloc] init];
//    gameDetailVC.gameModel = self.gameDetailModel.relayGameArray[tag];
//    [self.navigationController pushViewController:gameDetailVC animated:YES];
//}

#pragma mark - SelectViewDelegate选择条的代理方法
-(void)selectView:(SelectView *)selectView didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to{
    switch (to) {
        case 0:
            self.showingTableView = self.detailTableView;
            break;
        case 1:
            self.showingTableView = self.commentTableView;
            break;
        default:
            break;
    }
    
    //根据点击的按钮计算出backgroundScrollView的内容偏移量
    CGFloat offsetX = to * ScreenWidth;
    CGPoint scrPoint = self.backgroundScrollView.contentOffset;
    scrPoint.x = offsetX;
    //默认滚动速度有点慢 加速了下
    [UIView animateWithDuration:0.3 animations:^{
        [self.backgroundScrollView setContentOffset:scrPoint];
    }];
}

-(void)selectView:(SelectView *)selectView didChangeSelectedView:(NSInteger)to{
    if (to == 0) {
        self.showingTableView = self.detailTableView;
    } else if (to == 1) {
        self.showingTableView = self.commentTableView;
    }
}

-(void)navHeadBack{
    NSLog(@"点击了返回按钮");
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)navHeadShare{
    NSLog(@"点击了分享按钮");
    [self displayShareView];
}


-(void)navHeadQuery{
    NSLog(@"点击了??按钮");
    FeedbackViewController *gameListViewController = [[FeedbackViewController alloc] init];
    gameListViewController.gameId = self.gameModel.game_id?self.gameModel.game_id:self.gameModel.uid;
    UINavigationController *navig = [DiffUtil initNavigationWithRootViewController:gameListViewController];
    [self presentViewController:navig animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setLikeBtnState:(BOOL)isSelected{
    if (isSelected) {
        [self.likeBtn setImage:[UIImage imageNamed:@"icon_like_up"] forState:UIControlStateNormal];
        [self.likeBtn setTitleColor:[UIColor di_MAIN2] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"icon_like_down"] forState:UIControlStateNormal];
        [self.likeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - ZFPlayerDelegate ----------------------------------
/** backBtn event */
- (void)zf_playerBackAction{
    NSLog(@"player back action");
}

/** downloadBtn event */
- (void)zf_playerDownload:(NSString *)url{
    NSLog(@"player back download");
}

- (void)zf_playerAction{
    NSLog(@" ---------- play action !!!");
    NSLog(@"network is 流量");
    NSString *content = @"您当前正在使用移动网络，继续播放将消耗流量";
//    UIView *dialog = [ViewFactory createView:self.view backgroundColor:[UIColor whiteColor]];
//    dialog.el_toWidth(ScreenWidth - 30).el_toHeight(100).el_axisXToSuperView(0).el_axisYToSuperView(0);
//    UILabel *label = [ViewFactory createLabel:dialog fontSize:13 text:content textcolor:[UIColor blackColor]];
//    label.numberOfLines = 0;
//    label.el_leftToSuperView(15).el_rightToSuperView(15).el_topToSuperView(15);
//    
//    UIButton *leftBtn = [ViewFactory createButton:dialog titleColor:[UIColor blackColor] titleLabelFontSize:12 title:@"停止播放"];
//    UIButton *rightBtn = [ViewFactory createButton:dialog titleColor:[UIColor blackColor] titleLabelFontSize:12 title:@"继续播放"];
//    
//    rightBtn.el_rightToSuperView(15).el_topToBottom(label,10);
//    leftBtn.el_axisYToAxisY(rightBtn,0).el_rightToLeft(rightBtn,10);
    

    [DiffUtil monitorNetwork:^(AFNetworkReachabilityStatus status) {
        if(status == AFNetworkReachabilityStatusReachableViaWWAN){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:content preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self.playView startPlay];
            }];
            
            UIAlertAction *action2= [UIAlertAction actionWithTitle:@"停止播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            
            [alert addAction:action1];
            
            [alert addAction:action2];
            
            [self presentViewController:alert animated:YES completion:nil];
        }else if(status == AFNetworkReachabilityStatusReachableViaWiFi){
            [self.playView startPlay];
        }
    }];
    
}
@end
