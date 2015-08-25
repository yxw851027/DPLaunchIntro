//
//  DPLaunchAnimationPanel.h
//  DPLaunchIntro
//
//  Created by yxw on 15/8/10.
//  Copyright (c) 2015年 yxw. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LaunchCompleteBlock)(void);

@interface DPLaunchAnimationPanel : UIWindow

/**
 *  显示动画页面
 *
 *  @param aBlock 动画完成后的回调
 */
+ (void)displayWithCompleteBlock:(LaunchCompleteBlock)aBlock;

@end
