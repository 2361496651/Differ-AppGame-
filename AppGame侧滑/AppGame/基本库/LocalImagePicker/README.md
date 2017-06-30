


# ZCJSelectImageViewController.h 本地照片选择查看  

###使用

1.导入头文件
#import "ZCJImagesViewController.h"
#import "ZCJSelectImageViewController.h"

#2.遵守代理  ZCJSelectImageViewControllerDelegate
#@interface ViewController ()<ZCJSelectImageViewControllerDelegate>


#- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
#{
#   ZCJImagesViewController *imagesCtr = [[ZCJImagesViewController alloc] init];

#   imagesCtr.delegate = self;

#   UINavigationController *navigation =    [[UINavigationControlleralloc]initWithRootViewController:imagesCtr];

#   [self presentViewController:navigation animated:YES completion:nil];

#}

#- (void)selectImageViewController:(id)picker didFinishPickingImageWithInfo:(NSArray<UIImage *> *)info
#   {
#       NSLog(@"%@",info);
#   }

