//
//  AGLimitedTextView.h
//  AGVideo
//
//  Created by MaoRongsen on 15/12/10.
//  Copyright © 2015年 AppGame. All rights reserved.
//

#import "SZTextView.h"

@interface AGLimitedTextView : SZTextView<UITextViewDelegate>
@property (nonatomic) IBInspectable NSInteger maxWords;
@property (nonatomic) IBInspectable NSInteger maxLineFeed;  //最大换行符数量
@end
