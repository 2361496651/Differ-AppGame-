//
//  PersonalTableViewController.m
//  AppGame
//
//  Created by zengchunjun on 2017/4/20.
//  Copyright © 2017年 zengchunjun. All rights reserved.
//

#import "PersonalTableViewController.h"
#import "PrivacyTableViewController.h"
#import "DiffUtil.h"
#import "NSDate+CJTime.h"

#import "SexPickerTool.h"
#import "DatePickerTool.h"
#import "DifferNetwork.h"
#import "DifferAccount.h"
#import "DifferAccountTool.h"
#import "UserModel.h"

@interface PersonalTableViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UIImagePickerController *imagePickerController;

@property (nonatomic,copy)NSString *screenName;
@property (nonatomic,copy)NSString *sexText;
@property (nonatomic,copy)NSString *birthday;

@property (nonatomic,strong)UserModel *account;

@end

@implementation PersonalTableViewController

#pragma mark:懒加载

// 个人账户
- (UserModel *)account
{
    if (_account == nil) {
        _account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    }
    return _account;
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
// 个人cell照片
- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.frame = CGRectMake(0, 0, 44, 44);
        _iconImageView.layer.cornerRadius = 22;
        _iconImageView.layer.masksToBounds = YES;
        
    }
    UIImage *image = [UIImage imageWithContentsOfFile:[DiffUtil getAccountAvataPath]];
    image = image == nil ? [UIImage imageNamed:@"mobile_icon"] : image;
    _iconImageView.image = image;// [UIImage imageNamed:@"mobile_icon"];
    return _iconImageView;
}

#pragma mark:系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveInfomation)];
    
    // 设置展示信息
    [self setupDisplayInformation];
}

#pragma mark:设置展示信息
- (void)setupDisplayInformation
{
//    UserModel *account = [NSKeyedUnarchiver unarchiveObjectWithFile:[DiffUtil getUserPathAtDocument]];
    UserModel *account = self.account;
    
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
        birth = @"未设置";
    }
    
    self.screenName = nickName;
    self.sexText = sex;
    self.birthday = birth;
}

#pragma mark:保存信息
- (void)saveInfomation
{
    UserModel *accountModel = self.account;
    DifferAccount *account = [DifferAccountTool account];
    
    NSString *sexStr = nil;
    if ([self.sexText isEqualToString:@"未知"]) {
        sexStr = @"0";
    }else if ([self.sexText isEqualToString:@"男"]){
        sexStr = @"1";
    }else{
        sexStr = @"2";
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
        
        [DiffUtil showAlertControllerWithTitle:@"" message:@"保存成功" presenViewController:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAccount" object:nil];

    } error:^(NSError *error) {
        NSLog(@"保存失败：%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source 数据源及代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"personalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"头像";
        cell.accessoryView = self.iconImageView;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = self.screenName;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"性别";
        cell.detailTextLabel.text = self.sexText;
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"生日";
        cell.detailTextLabel.text = self.birthday;
    }
    else if (indexPath.row == 4){
        cell.textLabel.text = @"隐私设置";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self iconImageClick];
    }else if (indexPath.row == 1){
       
        [self inputScreenName];
        
    }else if (indexPath.row == 2){
        
        [self pickerSex];
        
    }
    else if (indexPath.row == 3){
        
        [self pickerBirthday];
    }
    else if (indexPath.row == 4){
        
        PrivacyTableViewController *privacy = [[PrivacyTableViewController alloc] init];
        [self.navigationController pushViewController:privacy animated:YES];
    }
}
#pragma mark:滑动屏幕退出选择器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
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
    SexPickerTool *sexPick = [[SexPickerTool alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    sexPick.tag = 101;
    __block SexPickerTool *blockPicker = sexPick;
    sexPick.callBlock = ^(NSString *pickDate) {
        NSLog(@"%@",pickDate);
        
        if (pickDate) {
            self.sexText = pickDate;
        }
        
        [self.tableView reloadData];
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
    DatePickerTool *datePicker = [[DatePickerTool alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200)];
    datePicker.tag = 102;
    __block DatePickerTool *blockPicker = datePicker;
    datePicker.callBlock = ^(NSString *pickDate) {
        
        NSLog(@"%@",pickDate);
        
        if (pickDate) {
            self.birthday = pickDate;
            [self.tableView reloadData];
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


#pragma mark:输入昵称
- (void)inputScreenName
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入昵称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入昵称";
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *screenField = alertController.textFields.firstObject;
        // 获取到了用户昵称
        NSLog(@"%@",screenField.text);
        if (screenField.text == nil || [screenField.text isEqualToString:@""]) {
            [DiffUtil showAlertControllerWithTitle:@"" message:@"昵称不能为空" presenViewController:self];
            return ;
        }
        self.screenName = screenField.text;
        [self.tableView reloadData];
    }];
    
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark:点击头像
- (void)iconImageClick
{
    UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"请选择图片来源" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
        
    }];
    
    UIAlertAction *takePicture = [UIAlertAction actionWithTitle:@"拍一张照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [DiffUtil showAlertControllerWithTitle:@"警告" message:@"请检查相机是否损坏或该设备不存在" presenViewController:self];
        }
        else
        {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:self.imagePickerController animated:YES completion:nil];
            
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
        [DiffUtil showAlertControllerWithTitle:@"" message:@"头像上传失败，请再次尝试" presenViewController:self];
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



@end
