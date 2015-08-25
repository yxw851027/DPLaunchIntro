//
//  DPLaunchAnimationPanel.m
//  DPLaunchIntro
//
//  Created by yxw on 15/8/10.
//  Copyright (c) 2015年 yxw. All rights reserved.
//

#import "DPLaunchAnimationPanel.h"
#import "DPLaunchAnimationView.h"

@interface DPLaunchAnimationPanel ()
@property (nonatomic, strong) UIImageView           *backgroundView;
@property (nonatomic, strong) DPLaunchAnimationView *rotationView;
@property (nonatomic, strong) LaunchCompleteBlock   block;
@end

static DPLaunchAnimationPanel *launchAnimtionPanel = nil;

@implementation DPLaunchAnimationPanel
@synthesize backgroundView;
@synthesize rotationView;
@synthesize block;

#pragma mark - public
+ (void)displayWithCompleteBlock:(LaunchCompleteBlock)aBlock
{
    if (launchAnimtionPanel == nil) {
        launchAnimtionPanel = [[DPLaunchAnimationPanel alloc] init];
    }
    launchAnimtionPanel.block = aBlock;
    [launchAnimtionPanel show];
}

#pragma mark - life cycle
- (id)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        self.windowLevel = UIWindowLevelStatusBar + 100;
        
        backgroundView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        CGFloat padding = 18;
        if (iPhone4) {
            backgroundView.image = [UIImage imageNamed:@"Default.png"];
            padding = 18;
        }else if (iPhone5) {
            backgroundView.image = [UIImage imageNamed:@"Default-568h.png"];
            padding = 20;
        }else if (iPhone6) {
            backgroundView.image = [UIImage imageNamed:@"Default-667h.png"];
            padding = 24;
        }else if (iPhone6Plus) {
            backgroundView.image = [UIImage imageNamed:@"Default-736h.png"];
            padding = 38;
        }
        
        CGFloat width = 60.f /375.f * [[UIScreen mainScreen] bounds].size.width;
        rotationView = [[DPLaunchAnimationView alloc] initWithFrame:CGRectMake(backgroundView.frame.size.width / 2.f - width/2.f, backgroundView.frame.size.height / 2.f - 28 - padding - width, width, width)];
        [backgroundView addSubview:rotationView];
        
        [self addSubview:backgroundView];
        [self bringSubviewToFront:backgroundView];
    }
    return self;
}

- (void)dealloc
{
    backgroundView = nil;
    rotationView = nil;
    block = nil;
}

#pragma mark - methods
- (void)show
{
    [rotationView startAnimation];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2.f];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(launchAnimationDone)];
    backgroundView.alpha = 0.99f;
    [UIView commitAnimations];
    
    [self setHidden:NO];
}

- (void)launchAnimationDone
{
    if (self.block) {
        block();
    }
    
    [rotationView stopAnimation];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2f];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(launchTransitionDone)];
    backgroundView.alpha = 0.f;
    [UIView commitAnimations];
}

- (void)launchTransitionDone
{
    [rotationView removeFromSuperview];
    [backgroundView removeFromSuperview];
    [self setHidden:YES];
    
    if (launchAnimtionPanel) {
        launchAnimtionPanel = nil;
    }
}

@end
