//
//  AGBaseViewController.h
//  test
//
//  Created by supozheng on 2017/5/3.
//  Copyright © 2016年 hunter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
- (void)displayShareView;
-(BOOL)isLoginWithLoginWindow;
-(void)showDialog:(NSString*)title content:(NSString*)content leftButtonText:(NSString*)leftButtonText;
-(void)showDialog:(NSString*)title content:(NSString*)content leftButtonText:(NSString*)leftButtonText rightButtonText:(NSString*)rightButtonText;
@end
