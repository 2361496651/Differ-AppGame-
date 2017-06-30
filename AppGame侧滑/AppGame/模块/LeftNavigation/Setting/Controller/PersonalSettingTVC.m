//
//  PersonalSettingTVC.m
//  AppGame
//
//  Created by zengchunjun on 2017/5/4.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "PersonalSettingTVC.h"
#import "DifferSettingItem.h"
#import "DifferSettingGroup.h"

#import "DiffUtil.h"

#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "DifferNetwork.h"

#import "UserModel.h"
#import "SexPickerTool.h"
#import "DatePickerTool.h"

#import "PrivacySettingTVC.h"
#import "RemarkViewController.h"

#import "DifferSettingCell.h"
#import <SVProgressHUD.h>
#import "NSDate+CJTime.h"

@interface PersonalSettingTVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

//@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UIImagePickerController *imagePickerController;

@property (nonatomic,copy)NSString *screenName;
@property (nonatomic,copy)NSString *sexText;
@property (nonatomic,copy)NSString *birthday;
@property (nonatomic,copy)NSString *remark;

// 断网headerView
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,assign)AFNetworkReachabilityStatus isReachable;

@property (nonatomic,strong)UITextField *textField;


@end

@implementation PersonalSettingTVC

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentRight;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _textField.delegate = self;
        _textField.text = self.screenName;
    }
    return _textField;
}

- (UIButton *)button
{
    if (_button == nil) {
        _button = [[UIButton alloc]init];
        _button.backgroundColor = [UIColor colorWithRed:234/255.0 green:186/255.0 blue:186/255.0 alpha:1/1.0];
        [_button setImage:[UIImage imageNamed:@"mobile_icon"] forState:UIControlStateNormal];
        [_button setTitle:@"网络不给力，请检查网络设置" forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _button;
}


// 照片选择器
- (UIImagePickerController *)imagePickerController
{
    if (_imagePickerController == nil) {
        
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.delegate  =self;
        _imagePickerController.allowsEditing = YES;// 可编辑
    }
    
    return _imagePickerController;
}

#pragma mark:设置展示信息
- (void)setupDisplayInformation
{
    UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];

    NSString *nickName = account.nickname;
    NSString *sex = account.sex;
    NSString *birth = account.birthday
    ;
    
    if (account.nickname == nil || [account.nickname isEqualToString:@""]) {
        nickName = @"未设置";
    }
    
    switch ([account.sex integerValue]) {
        case 0:
            sex = @"未知";
            break;
        case 1:
            sex = @"男";
            break;
        case 2:
            sex = @"女";
            break;
            
        default:
            break;
    }
    
    if (account.birthday == nil || [account.birthday isEqualToString:@""]) {
        birth = [[NSDate date] dateStrWithYMD];
    }
    
    self.screenName = nickName;
    self.sexText = sex;
    self.birthday = birth;
    self.remark = account.remark;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    int length = 20;//限制的字数
    NSString *toBeString = textField.text;
    
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    NSString *lang = textField.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position || !selectedRange)
        {
            if (toBeString.length > length)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:length];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }else{
        if (toBeString.length > length) {
            textField.text = [toBeString substringToIndex:length];
        }
    }
    
    
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textField.returnKeyType = UIReturnKeyDone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __weak typeof(self) weakSelf = self;
    if (textField.text == nil || [textField.text isEqualToString:@""]) {
        [DiffUtil showAlertControllerWithTitle:@"" message:@"昵称不能为空" presenViewController:weakSelf];
        return NO;
    }
    self.screenName = textField.text;
    [self setupSourceData];
    
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    
    [self setupDisplayInformation];// 先更新展示数据
//
     [self setupSourceData];// 设置数据源
    
    self.navigationItem.rightBarButtonItem = [DiffUtil initButtonItemWithTitle:@"保存" action:@selector(saveInfomation) delegate:self];
    
    //监听网络
    __weak typeof(self) weakSelf = self;
    [DiffUtil monitorNetwork:^(AFNetworkReachabilityStatus status) {
        weakSelf.isReachable = status;
        [weakSelf.tableView reloadData];
    }];

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.isReachable == AFNetworkReachabilityStatusNotReachable) {
        return 44;
    }
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.isReachable == AFNetworkReachabilityStatusNotReachable) {
        return self.button;
    }
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 5) { //个性签名
        
        CGSize size = [DiffUtil sizeWithText:self.remark width:[UIScreen mainScreen].bounds.size.width * 0.6 textFont:16];
        CGFloat superHeight = [super tableView:tableView heightForRowAtIndexPath:indexPath];
        CGFloat height  =  (size.height + 30) < superHeight ? superHeight : (size.height + 30);
        return height;
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) { // 昵称
        
        DifferSettingCell *cell = [DifferSettingCell cellWithTableView:tableView];
        
        cell.accessoryView = self.textField;
        //获取组的模型数据
        DifferSettingGroup *group = self.cellDatas[indexPath.section];

        //获取行的模型数据
        DifferSettingItem *item = group.differSettingItems[indexPath.row];
        
        //设置模型 显示数据
        cell.item = item;
        
        return cell;
    }
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark:保存信息
- (void)saveInfomation
{
    self.screenName = self.textField.text;
    __weak typeof(self) weakSelf = self;
    if (self.screenName == nil || [self.screenName isEqualToString:@""]) {
        [DiffUtil showAlertControllerWithTitle:@"" message:@"昵称不能为空" presenViewController:weakSelf];
        return ;
    }
    
    UserModel *accountModel = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];

    DifferAccount *account = [DifferAccountTool account];
    
    NSString *sexStr = nil;
    if ([self.sexText isEqualToString:@"女"]) {
        sexStr = @"2";
    }else if ([self.sexText isEqualToString:@"男"]){
        sexStr = @"1";
    }else{
        sexStr = @"0";
    }
    
    NSDictionary *dict = @{
                           @"access_token":account.access_token,
                           @"nickname":self.screenName,
                           @"sex":sexStr,
                           @"birthday":self.birthday,
                           };
    
    
    [[[DifferNetwork shareInstance] requestChangeUserInformationParamet:dict] subscribeNext:^(id x) {
        accountModel.nickname = self.screenName;
        accountModel.sex = sexStr;
        accountModel.birthday = self.birthday;
        
        [NSKeyedArchiver archiveRootObject:accountModel toFile:[DiffUtil getUserPathAtDocument]];
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];
        
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];

    } error:^(NSError *error) {
        NSString *noticeStr = [error description] ? [error description] : @"保存失败";
        [DiffUtil showInCenterWithTitle:noticeStr backgroundColor:nil textColor:nil];
        NSLog(@"保存失败：%@",error);
    }];
        

}



- (void)setupSourceData
{
    [self.cellDatas removeAllObjects];
    
    __weak typeof(self) weakSelf = self;
    
    DifferSettingItem *item1 = [DifferSettingImageItem itemWithIcon:nil title:@"头像"];
    item1.operation = ^{
        [weakSelf iconImageClick];
    };
    
    DifferSettingItem *item2 = [DifferSettingItem itemWithIcon:nil title:@"昵称"];
    
    DifferSettingItem *item3 = [DifferSettingItem itemWithIcon:nil title:@"性别"];
    item3.subTitle = self.sexText;
    item3.operation = ^{
        [weakSelf pickerSex];
    };
    DifferSettingItem *item4 = [DifferSettingItem itemWithIcon:nil title:@"生日"];
    item4.subTitle = self.birthday;
    item4.operation = ^{
        [weakSelf pickerBirthday];
    };
    DifferSettingItem *item5 = [DifferSettingArrowItem itemWithIcon:nil title:@"隐私设置" vcClass:[PrivacySettingTVC class]];
    
    DifferSettingItem *item6 = [DifferSettingItem itemWithIcon:nil title:@"个性签名" vcClass:[RemarkViewController class]];
    item6.subTitle = self.remark;
    item6.operation = ^{
        
        RemarkViewController *vc = [[RemarkViewController alloc]init];
        vc.remark = weakSelf.remark;
        vc.RemarkCompleteBlock = ^(NSString *remark) {
            weakSelf.remark = remark;
            [weakSelf setupSourceData];
//            [SVProgressHUD showSuccessWithStatus:@"保存成功"];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    
    DifferSettingGroup *group1 = [[DifferSettingGroup alloc] init];
    
    group1.differSettingItems = @[item1,item2,item3,item4,item5,item6];
    
    [self.cellDatas addObject:group1];
    
    [self.tableView reloadData];
}


#pragma mark:滑动屏幕退出选择器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField endEditing:YES];
    
    UIView *sexView = [self.view viewWithTag:101];
    if (sexView) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            sexView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [sexView removeFromSuperview];
        }];
    }
    
    UIView *dateView = [self.view viewWithTag:102];
    if (dateView) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            dateView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [dateView removeFromSuperview];
        }];
    }
    
}

#pragma mark: 选择性别
- (void)pickerSex
{
    [self scrollViewWillBeginDragging:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    
    SexPickerTool *sexPick = [[SexPickerTool alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    sexPick.tag = 101;
    __block SexPickerTool *blockPicker = sexPick;
    sexPick.callBlock = ^(NSString *pickDate) {

        if (pickDate) {
            weakSelf.sexText = pickDate;
            [weakSelf setupSourceData];
        }
        
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            blockPicker.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [blockPicker removeFromSuperview];
        }];
    };
    [self.view addSubview:sexPick];
    
    [UIView animateWithDuration:0.4 animations:^{
        sexPick.transform = CGAffineTransformMakeTranslation(0, -200);
    } completion:^(BOOL finished) {
        
    }];
}



#pragma mark: 选择生日
- (void)pickerBirthday
{
    [self scrollViewWillBeginDragging:self.tableView];
    
    __weak typeof(self) weakSelf = self;
    
    DatePickerTool *datePicker = [[DatePickerTool alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    datePicker.tag = 102;
    __block DatePickerTool *blockPicker = datePicker;
    datePicker.callBlock = ^(NSString *pickDate) {
        
        if (pickDate) {
            weakSelf.birthday = pickDate;
            [weakSelf setupSourceData];
        }
        
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            blockPicker.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [blockPicker removeFromSuperview];
        }];
    };
    
    [self.view addSubview:datePicker];
    
    [UIView animateWithDuration:0.4 animations:^{
        datePicker.transform = CGAffineTransformMakeTranslation(0, -200);
    } completion:^(BOOL finished) {
        
    }];
}



#pragma mark:点击头像
- (void)iconImageClick
{
    __weak typeof(self) weakSelf = self;
    
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [weakSelf presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    
    
    UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"拍一张照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [DiffUtil showAlertControllerWithTitle:@"警告" message:@"请检查相机是否损坏或该设备不存在" presenViewController:weakSelf];
        }
        else
        {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [weakSelf presentViewController:self.imagePickerController animated:YES completion:nil];
            
        }
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertContr addAction:photos];
    [alertContr addAction:takePicture];
    [alertContr addAction:cancel];
    
    [self presentViewController:alertContr animated:YES completion:nil];
}


#pragma mark:选择头像的回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage * image = info[UIImagePickerControllerEditedImage];
    if (image == nil)
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *imageToSend = [self scaleFromImage:image toSize:CGSizeMake(128, 128)];
    
    DifferAccount *account = [DifferAccountTool account];
    [[DifferNetwork shareInstance] updateUserIconImage:imageToSend accessToken:account.access_token success:^(id responseObj) {
        
        //保存头像
        [DifferAccountTool savaAvata:imageToSend];
        
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"上传头像失败：%@",error);
        [DiffUtil showAlertControllerWithTitle:@"" message:@"头像上传失败，请再次尝试" presenViewController:weakSelf];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// 内存优化测试
- (void)dealloc{
    
    NSLog(@"%@ dealloc###已经销毁differ",NSStringFromClass([self class]));
}



//#pragma mark:输入昵称
//- (void)inputScreenName
//{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入昵称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
//    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//        textField.placeholder = @"请输入昵称";
//    }];
//
//    __weak typeof(self) weakSelf = self;
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UITextField *screenField = alertController.textFields.firstObject;
//        // 获取到了用户昵称
//        NSLog(@"%@",screenField.text);
//        if (screenField.text == nil || [screenField.text isEqualToString:@""]) {
//            [DiffUtil showAlertControllerWithTitle:@"" message:@"昵称不能为空" presenViewController:weakSelf];
//            return ;
//        }
//        self.screenName = screenField.text;
//        [self setupSourceData];
//    }];
//
//    [alertController addAction:okAction];
//
//    [self presentViewController:alertController animated:YES completion:nil];
//}


@end
