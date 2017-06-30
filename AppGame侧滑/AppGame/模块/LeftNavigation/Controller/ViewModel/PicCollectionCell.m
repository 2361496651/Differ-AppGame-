//
//  PicCollectionCell.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/23.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "PicCollectionCell.h"
#import <UIImageView+WebCache.h>

@interface PicCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImage;

@end

@implementation PicCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"PicCollectionCell" owner:nil options:nil]firstObject];
    }
    self.frame = frame;
    return self;
}

- (void)setPicUrl:(NSURL *)picUrl
{
    _picUrl = picUrl;
    
    [self.picImage sd_setImageWithURL:picUrl];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
