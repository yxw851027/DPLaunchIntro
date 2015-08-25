//
//  DPIntroFirstView.h
//  DPLaunchIntro
//
//  Created by yxw on 15/7/17.
//  Copyright (c) 2015年 yxw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPIntroFirstView : UIView
@property (nonatomic, readonly, assign) BOOL animating;

/**
 *  view开始显示，开始动画效果
 */
- (void)viewDidShow;

/**
 *  view已经消失，子视图复原
 */
- (void)viewDidDismiss;

@end
