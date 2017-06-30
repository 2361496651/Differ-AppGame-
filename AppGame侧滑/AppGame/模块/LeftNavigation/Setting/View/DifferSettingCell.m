//
//  EcmSettingCell.m
//  ecmSetting
//
//  Created by zengchunjun on 16/12/2.
//  Copyright © 2016年 zengchunjun. All rights reserved.
//

#import "DifferSettingCell.h"
#import "DifferSettingItem.h"
#import "DiffUtil.h"
#import "UserModel.h"
#import "DifferNetwork.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"

@interface DifferSettingCell ()

/**
 *  箭头
 */
@property(nonatomic,strong)UIImageView *mArrow;


/**
 *  开关
 */
@property(nonatomic,strong)UISwitch *mSwitch;



//2个segment
@property (nonatomic,strong)UIImageView *customimageView;

@property (nonatomic,strong)UserModel *accountModel;

@end

@implementation DifferSettingCell

#pragma mark:懒加载

- (UserModel *)accountModel
{
    if (_accountModel == nil) {
        _accountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    }
    return _accountModel;
}

- (UIImageView *)customimageView
{
    if (!_customimageView) {
        _customimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        _customimageView.layer.cornerRadius = 22;
        _customimageView.layer.masksToBounds = YES;
    }
    return _customimageView;
}


-(UIImageView *)mArrow{
    if (!_mArrow) {
        _mArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellArrow"]];
    }
    
    return _mArrow;
}


-(UISwitch *)mSwitch{
    if (!_mSwitch) {
        _mSwitch = [[UISwitch alloc] init];
        
        //监听事件
        [_mSwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    return _mSwitch;
}


- (void)segmentValueChange:(UISegmentedControl *)segment
{
    NSLog(@"%s",__func__);
}

-(void)valueChange:(UISwitch *)mSwitchs{

    BOOL value = mSwitchs.isOn;
    
    if ([self.item.title isEqualToString:@"公开我的粉丝"]) {
        
        self.accountModel.public_follower = value ? 1 : 0;
        
        [self saveInfomationPublicFolower];
        
    }else if ([self.item.title isEqualToString:@"公开我的关注"]){
        
        self.accountModel.public_following = value ? 1 : 0;
        
        [self saveInfomationPublicFolower];
    }
    
}

#pragma mark:更改用户隐私信息
- (void)saveInfomationPublicFolower
{
    //    UserModel *accountModel = self.accountModel;
    NSString *publicFollower = [NSString stringWithFormat:@"%ld",self.accountModel.public_follower];
    NSString *publicFollowering = [NSString stringWithFormat:@"%ld",self.accountModel.public_following];
    
    DifferAccount *account = [DifferAccountTool account];
    
    NSDictionary *dict = @{
                           @"access_token":account.access_token,
                           @"public_follower":publicFollower,
                           @"public_following":publicFollowering,
                           };
    [[[DifferNetwork shareInstance] requestChangeUserInformationParamet:dict]subscribeNext:^(id x) {
        
        [NSKeyedArchiver archiveRootObject:self.accountModel toFile:[DiffUtil getUserPathAtDocument]];
            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];

    } error:^(NSError *error) {
        NSString *noticeStr = [error description] ? [error description] : @"保存失败";
        [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
        NSLog(@"保存失败：%@",error);
    }];
}


+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"DifferSettingCell";
    DifferSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        cell = [[DifferSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.textLabel.font = [DiffUtil getDifferFont:15.5];
        cell.detailTextLabel.font = [DiffUtil getDifferFont:15.5];
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
//        [cell.detailTextLabel sizeToFit];
        
        cell.textLabel.alpha = 0.8;
        cell.detailTextLabel.alpha = 0.8;
        
        cell.layer.borderColor = [DiffUtil colorWithHexString:@"#EEEEEE"].CGColor;
        cell.layer.borderWidth = 0.5;
    }
    
    return cell;
}

-(void)setItem:(DifferSettingItem *)item{
    _item = item;
    
    //显示图片和标题
    self.textLabel.text = item.title;
    
    if (item.icon) {
    
        self.imageView.image = [UIImage imageNamed:item.icon];
        
        CGSize itemSize = CGSizeMake(25, 25);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [self.imageView.image drawInRect:imageRect];
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    //设置子标题
    self.detailTextLabel.text = item.subTitle;
    
    
    //设置箭头
    if ([item isKindOfClass:[DifferSettingArrowItem class]]) {//箭头
        
        self.accessoryView = self.mArrow;
        //箭头可以选中
        self.selectionStyle = UITableViewCellSelectionStyleDefault;
    }else if([item isKindOfClass:[DifferSettingSwitchItem class]]){//开关
        
//        UserModel *accountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
        
        //设置开关的状态
        if ([item.title isEqualToString:@"公开我的粉丝"]) {
            self.mSwitch.on = self.accountModel.public_follower == 0 ? NO : YES;
        }else if ([item.title isEqualToString:@"公开我的关注"]){
            self.mSwitch.on = self.accountModel.public_following == 0 ? NO : YES;;
        }

        self.accessoryView = self.mSwitch;
        
        //开关的cell不能选中
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if([item isKindOfClass:[DifferSettingCenterItem class]]){
        // 文字居中
        self.textLabel.text = @"";
        
        if ([self.contentView viewWithTag:99]) {
            [[self.contentView viewWithTag:99] removeFromSuperview];
        }
        
        UILabel *center = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
        center.text = item.title;
        center.tag = 99;
        center.font = [UIFont systemFontOfSize:15];
        center.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:center];
        
    }else if([item isKindOfClass:[DifferSettingImageItem class]]){
        
        if ([item.title isEqualToString:@"头像"]) {
            
            UIImage *image = [DifferAccountTool getAvata];//[UIImage imageWithContentsOfFile:[DiffUtil getAccountAvataPath]];
            image = image == nil ? [UIImage imageNamed:@"mobile_icon"] : image;
            self.customimageView.image = image;
        }
        
        self.accessoryView = self.customimageView;

    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
