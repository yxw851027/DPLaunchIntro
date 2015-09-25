//
//  DPIntroThirdView.m
//  DPLaunchIntro
//
//  Created by yxw on 15/7/18.
//  Copyright (c) 2015年 yxw. All rights reserved.
//

#import "DPIntroThirdView.h"

@interface DPIntroThirdView()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIImageView *slogonImageView;
@property (nonatomic, strong) UIButton *joinButton;
@property (nonatomic, strong) UIImageView *textImageView;
@end

@implementation DPIntroThirdView
@synthesize joinDuopaiBlock;
@synthesize animating;
@synthesize bgImageView;
@synthesize logoImageView;
@synthesize slogonImageView;
@synthesize joinButton;
@synthesize textImageView;

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        BOOL isIphone4 = iPhone4;
        animating = NO;
        
        bgImageView = [[UIImageView alloc] init];
        [bgImageView setContentMode:UIViewContentModeScaleAspectFill];
        [bgImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_bg_ip%@", isIphone4? @"4":@"6p"]]];
        [self addSubview:bgImageView];
        
        logoImageView = [[UIImageView alloc] init];
        [logoImageView setContentMode:UIViewContentModeScaleAspectFill];
        [logoImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_Logo_ip%@", isIphone4? @"4":@"6p"]]];
        [self addSubview:logoImageView];
        
        slogonImageView = [[UIImageView alloc] init];
        [slogonImageView setContentMode:UIViewContentModeScaleAspectFill];
        [slogonImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_item3_ip%@", isIphone4? @"4":@"6p"]]];
        [self addSubview:slogonImageView];
        
        joinButton = [[UIButton alloc] init];
        [joinButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_join_ip%@", isIphone4? @"4":@"6p"]] forState:UIControlStateNormal];
        [joinButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_join_ip%@_HL", isIphone4? @"4":@"6p"]] forState:UIControlStateHighlighted];
        [joinButton addTarget:self action:@selector(joinButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:joinButton];
        
        textImageView = [[UIImageView alloc] init];
        [textImageView setContentMode:UIViewContentModeScaleAspectFill];
        [textImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_text3_ip%@", isIphone4? @"4":@"6p"]]];
        [self addSubview:textImageView];
        
        __weak typeof(self) weakSelf = self;
        [bgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        if (isIphone4) {
            [logoImageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.top).offset(78);
                make.centerX.equalTo(weakSelf.centerX);
                make.width.equalTo(@(130));
                make.height.equalTo(@(39));
            }];
            
            [slogonImageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.top).offset(240/667.f*kScreenHeight);
                make.centerX.equalTo(weakSelf.centerX);
                make.width.equalTo(@(kScreenWidth*200.f/375.f));
                make.height.equalTo(@(kScreenWidth*125.f/375.f));
            }];
            
            [joinButton makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.centerX).offset(-(kScreenWidth + 144)/2.f);
                make.top.equalTo(weakSelf.bottom).offset(-108);
                make.width.equalTo(@(144));
                make.height.equalTo(@(36));
            }];
            
            [textImageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.centerX).offset((kScreenWidth + 144)/2.f);
                make.top.equalTo(weakSelf.bottom).offset(-50);
                make.width.equalTo(@(144));
                make.height.equalTo(@(14));
            }];
        }else {
            [logoImageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.top).offset(110/667.f*kScreenHeight);
                make.centerX.equalTo(weakSelf.centerX);
                make.width.equalTo(@(kScreenWidth*180.f/375.f));
                make.height.equalTo(@(kScreenHeight*54.f/667.f));
            }];
            
            [slogonImageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.top).offset(240/667.f*kScreenHeight);
                make.centerX.equalTo(weakSelf.centerX);
                make.width.equalTo(@(kScreenWidth*200.f/375.f));
                make.height.equalTo(@(kScreenWidth*125.f/375.f));
            }];
            
            [joinButton makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.centerX).offset(-(kScreenWidth + 200)/2.f);
                make.top.equalTo(weakSelf.bottom).offset(-150/667.f*kScreenHeight);
                make.width.equalTo(@(200));
                make.height.equalTo(@(48));
            }];
            
            [textImageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.centerX).offset((kScreenWidth + 200)/2.f);
                make.top.equalTo(weakSelf.bottom).offset(-70/667.f*kScreenHeight);
                make.width.equalTo(@(200));
                make.height.equalTo(@(18));
            }];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)didMoveToWindow
{
    [self layoutIfNeeded];
}

- (void)dealloc
{
    bgImageView = nil;
    logoImageView = nil;
    slogonImageView = nil;
    joinButton = nil;
    joinDuopaiBlock = nil;
    textImageView = nil;
}

#pragma mark - methods
- (void)joinButtonClicked
{
    if (joinDuopaiBlock) {
        joinDuopaiBlock();
    }
}

- (void)viewDidShow
{
    [self subviewsAnimation];
}

- (void)viewDidDismiss
{
    [self subviewsRecover];
}

- (void)subviewsAnimation
{
    if (!animating) {
        animating = YES;
        [joinButton updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
        }];
        [textImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
        }];
        
        [UIView animateWithDuration:1.f animations:^{
            [joinButton layoutIfNeeded];
            [textImageView layoutIfNeeded];
            [self layoutIfNeeded];
        }completion:^(BOOL finish){
            animating = NO;
        }];
    }
}

- (void)subviewsRecover
{
    [joinButton setNeedsLayout];
    [textImageView setNeedsLayout];
    
    __weak typeof(self) weakSelf = self;
    if (iPhone4) {
        [joinButton updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.centerX).offset(-(kScreenWidth + 144)/2.f);
        }];
        [textImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.centerX).offset((kScreenWidth + 144)/2.f);
        }];
    }else {
        [joinButton updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.centerX).offset(-(kScreenWidth + 200)/2.f);
        }];
        [textImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.centerX).offset((kScreenWidth + 200)/2.f);
        }];
    }
    
    [joinButton layoutIfNeeded];
    [textImageView layoutIfNeeded];
    [self layoutIfNeeded];
}

@end
