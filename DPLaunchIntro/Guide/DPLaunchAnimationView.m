//
//  DPLaunchAnimationView.m
//  DuoPai
//
//  Created by yxw on 15/7/17.
//  Copyright (c) 2015年 Jacky. All rights reserved.
//

#import "DPLaunchAnimationView.h"

@interface DPLaunchAnimationView()
@property (nonatomic, strong) UIImageView *demoImgView1;
@property (nonatomic, strong) UIImageView *demoImgView2;
@end

@implementation DPLaunchAnimationView
@synthesize demoImgView1;
@synthesize demoImgView2;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        demoImgView1 = [[UIImageView alloc] initWithFrame:self.bounds];
        demoImgView1.image = [UIImage imageNamed:@"launch_1.png"];
        demoImgView1.layer.anchorPoint = CGPointMake(78.f/138.f, 0.5);
        
        demoImgView2 = [[UIImageView alloc] initWithFrame:self.bounds];
        demoImgView2.image = [UIImage imageNamed:@"launch_2.png"];
        demoImgView2.layer.anchorPoint = CGPointMake(73.f/138.f, 0.5);
        
        [self addSubview:demoImgView1];
        [self addSubview:demoImgView2];
    }
    return self;
}

- (void)startAnimation
{
    CGFloat duration = 2.f;
    CABasicAnimation *rotation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation1.fromValue = @(0);
    rotation1.toValue = @(M_PI*4);
    rotation1.duration = duration;
    rotation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.demoImgView1.layer addAnimation:rotation1 forKey:@"one_roate"];
    
    CAKeyframeAnimation *Animation1 = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    Animation1.values = @[@(1.0),@(1.0),@(1.4),@(1.0),@(1.0)];
    Animation1.keyTimes = @[@(0.0),@(0.2/duration),@(1.0/duration),@(1.8/duration),@(2.0/duration)];
    Animation1.calculationMode = kCAAnimationLinear;
    Animation1.duration = duration;
    Animation1.removedOnCompletion = NO;
    Animation1.fillMode = kCAFillModeForwards;
    Animation1.delegate = self;
    
    CAKeyframeAnimation *Animation2 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    Animation2.values = @[@(1.0),@(1.0),@(0.5),@(1.0),@(1.0)];
    Animation2.keyTimes = @[@(0.0),@(0.2/duration),@(1.0/duration),@(1.8/duration),@(2.0/duration)];
    Animation2.calculationMode = kCAAnimationLinear;
    Animation2.duration = duration;
    Animation2.removedOnCompletion = NO;
    Animation2.fillMode = kCAFillModeForwards;
    Animation2.delegate = self;
    
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.animations = @[ Animation1, Animation2 ];
    group.duration = duration;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [self.demoImgView2.layer addAnimation:group forKey:@"two_animte"];
}

- (void)stopAnimation
{
    [self.demoImgView1.layer removeAllAnimations];
    [self.demoImgView2.layer removeAllAnimations];
    self.demoImgView1.transform = CGAffineTransformIdentity;
    self.demoImgView2.transform = CGAffineTransformIdentity;
}

- (void)dealloc
{
    demoImgView1 = nil;
    demoImgView2 = nil;
}

@end
