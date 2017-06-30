//
//  PictureCell.m
//  AppGame
//
//  Created by chan on 17/5/16.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "ContentCell.h"
#import "TagsModel.h"
#import "TagView.h"
#import "SDWebImageManager.h"
#import "UILabel+Extension.h"
@interface ContentCell()<UIScrollViewDelegate>
@property(nonatomic, strong)NSArray *picArray;
@property(nonatomic, strong)TagsModel *tagsModel;
@property(nonatomic, strong)TagView *tagView;
@property(nonatomic, strong)UIView *tagBackgroundView;
@property(nonatomic, strong)UIScrollView *scrollView;

@property(nonatomic, strong)UIView *lineView;

@property(nonatomic,assign)NSInteger defaultLineNum;

@property(nonatomic,strong)NSMutableArray* imageArray;

@property(nonatomic,assign)CGFloat imageHeight;
@property(nonatomic,assign)CGFloat imageWidth;
@end
@implementation ContentCell

-(UIView *)tagBackgroundView{
    if (!_tagBackgroundView) {
        _tagBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
        _tagBackgroundView.backgroundColor = [UIColor whiteColor];
    }
    return _tagBackgroundView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.tagBackgroundView.height, ScreenWidth, _imageHeight)];
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(UILabel *)describeLB{
    if (!_describeLB) {
        _describeLB = [UILabel new];
        [self addSubview:_describeLB];
        _describeLB.font = [UIFont systemFontOfSize:16];
        _describeLB.numberOfLines = _defaultLineNum;
    }
    return _describeLB;
}

-(UIButton *)showMoreBtn{
    if (!_showMoreBtn) {
        _showMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_showMoreBtn];
        [_showMoreBtn setTitle:@"显示全文" forState:UIControlStateNormal];
        _showMoreBtn.backgroundColor = [UIColor whiteColor];
        _showMoreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _showMoreBtn.selected = NO;
//        _showMoreBtn.layer.shadowOffset = CGSizeMake(-2, 0);
//        _showMoreBtn.layer.shadowColor = [UIColor blackColor].CGColor;
//        _showMoreBtn.layer.shadowOpacity = 0.1;
        [_showMoreBtn setTitleColor:[UIColor di_MAIN2] forState:UIControlStateNormal];
        [_showMoreBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _showMoreBtn;
}

-(NSMutableArray*)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        
        _defaultLineNum = 4;
        
        _imageHeight = ScreenHeight*0.25;
        _imageWidth = ScreenWidth*0.25;
        
        self.backgroundColor = [UIColor whiteColor];

        [self addSubview:self.tagBackgroundView];
        
        [self addSubview:self.scrollView];
        
        UILabel *titleLable =[UILabel new];
        [self addSubview:titleLable];
        titleLable.font = [UIFont boldSystemFontOfSize:18];
        titleLable.text = @"游戏介绍";
        titleLable.textColor = [UIColor blackColor];
        titleLable.el_topToBottom(self.scrollView,30).el_leftToSuperView(20);
        
        self.lineView = [UIView new];
        [self addSubview:self.lineView];
        self.lineView.el_toHeight(2).el_leftToLeft(titleLable,0).el_rightToRight(titleLable,0).el_topToBottom(titleLable, 5);
        self.lineView.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

-(void)setGameDetailModel:(GameDetailModel *)gameDetailModel{
    
    if (!gameDetailModel) return;
    
    if (!_gameDetailModel) {
        
        _gameDetailModel = gameDetailModel;
        NSArray *tagArray = gameDetailModel.tagArray;
        NSArray *picArray = gameDetailModel.picArray;
        CGFloat tagWidth = 0;
        CGRect tagFrame = CGRectMake(0, 0, 0, 20);
        int tagCount = tagArray.count > 5 ? 5 : (int)tagArray.count;
        for (int i = 0; i < tagCount; i ++) {
            TagsModel *tagsModel = tagArray[i];
            /** 计算tagView宽度 */
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
            label.font = [UIFont systemFontOfSize:17];
            label.text = tagsModel.tagName;
            [label sizeToFit];
            tagFrame.origin.x += tagWidth + 5;
            tagWidth = label.bounds.size.width;
            tagFrame.size.width = tagWidth;
            /** ----------------*/
            
            TagView *tagView = [[TagView alloc] initWithFrame:tagFrame TagType:TagTypeSolidLine BorderColor:[UIColor di_MAIN2]];
            tagView.tagText.text = tagsModel.tagName;
            tagView.tagText.textColor = [UIColor di_MAIN2];
            tagView.tagText.font = [UIFont systemFontOfSize:12];
            CGPoint point = tagView.center;
            point.y = self.tagBackgroundView.centerY;
            tagView.center = point;
            
            CGRect frame = self.tagBackgroundView.frame;
            CGPoint center = self.tagBackgroundView.center;
            frame.size.width = tagFrame.origin.x + tagFrame.size.width + 5;
            center.x = ScreenWidth/2;
            self.tagBackgroundView.frame = frame;
            self.tagBackgroundView.center = center;
            [self.tagBackgroundView addSubview:tagView];
        }
        
        __block CGFloat contentSzieHeight = _imageHeight;
        __block CGFloat contentSizeWidth = _imageWidth;
        __block CGRect frame = self.scrollView.frame;
        [[SDWebImageManager sharedManager] loadImageWithURL:picArray[0] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            NSLog(@" ------- loading");
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            if (image.size.height < image.size.width) {
                contentSzieHeight = _imageWidth;
                contentSizeWidth = _imageHeight;
                frame.size.height = _imageWidth;
                self.scrollView.frame = frame;
            }
            
            if ([_delegate respondsToSelector:@selector(scrollViewHeight:)]) {
                [_delegate scrollViewHeight:contentSzieHeight];
            }
            
            [self.imageArray removeAllObjects];
            
            self.scrollView.contentSize = CGSizeMake(picArray.count * (contentSizeWidth+10) + 10, contentSzieHeight);
            for (int i = 0; i < picArray.count; i ++) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * (contentSizeWidth+10) +10, 0, contentSizeWidth, contentSzieHeight)];
                [imageView sd_setImageWithURL:picArray[i]];
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
                [imageView addGestureRecognizer:tap];
                [self.imageArray addObject:imageView];
                [self.scrollView addSubview:imageView];
            }
        }];
        
        self.describeLB.el_topToTop(self.lineView,20).el_leftToSuperView(20).el_rightToSuperView(20);

        
        [self.describeLB setLabelLineSpace:gameDetailModel.intro spacing:8 withFont:[UIFont systemFontOfSize:16]];
//        self.describeLB.text = gameDetailModel.intro;
        
        
        CGFloat defaultHeight = [gameDetailModel.intro di_getLabelHeightFontSize:16 Width:(ScreenWidth-40) numberOfLines:_defaultLineNum];
        CGFloat totalHeight = [gameDetailModel.intro di_getLabelHeightFontSize:16 Width:(ScreenWidth-40)];
        if (totalHeight > defaultHeight) {
            self.showMoreBtn.el_toSize(CGSizeMake(ScreenWidth, 60)).el_topToBottom(self.describeLB, 5);
        }
    }
}
- (void)clickImage:(UITapGestureRecognizer *)tap{
    [self.imageArray addObject:tap];
    if ([_delegate respondsToSelector:@selector(showImageAction:)]) {
        [_delegate showImageAction:self.imageArray];
    }
}

-(void)buttonAction:(UIButton *)button{
    if ([_delegate respondsToSelector:@selector(showContentButtonAction:)]) {
        [_delegate showContentButtonAction:button];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
