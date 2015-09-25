//
//  DPIntroFirstView.m
//  DPLaunchIntro
//
//  Created by yxw on 15/7/17.
//  Copyright (c) 2015年 yxw. All rights reserved.
//

#import "DPIntroFirstView.h"
#import "DPMoviePlayerView.h"

@interface DPIntroFirstView()
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UIImageView *textImageView;
@property (nonatomic, strong) DPMoviePlayerView *playView;
@end

@implementation DPIntroFirstView
@synthesize bgImageView;
@synthesize itemImageView;
@synthesize coverImageView;
@synthesize titleImageView;
@synthesize textImageView;
@synthesize playView;
@synthesize animating;

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
        
        itemImageView = [[UIImageView alloc] init];
        [itemImageView setContentMode:UIViewContentModeScaleAspectFill];
        [itemImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_item1_ip%@", isIphone4? @"4":@"6p"]]];
        itemImageView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
        [self addSubview:itemImageView];
        
        coverImageView = [[UIImageView alloc] init];
        [coverImageView setContentMode:UIViewContentModeScaleAspectFill];
        [coverImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_cover_ip%@", isIphone4? @"4":@"6p"]]];
        [self addSubview:coverImageView];
        
        titleImageView = [[UIImageView alloc] init];
        [titleImageView setContentMode:UIViewContentModeScaleAspectFill];
        [titleImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_title1_ip%@", isIphone4? @"4":@"6p"]]];
        [self addSubview:titleImageView];
        
        textImageView = [[UIImageView alloc] init];
        [textImageView setContentMode:UIViewContentModeScaleAspectFill];
        [textImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"welcome_text1_ip%@", isIphone4? @"4":@"6p"]]];
        [self addSubview:textImageView];
        
        __weak typeof(self) weakSelf = self;
        [bgImageView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf);
        }];
        
        if (isIphone4) {
            [itemImageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.top).offset(22);
                make.centerX.equalTo(weakSelf.centerX);
                make.width.equalTo(@(304*640.f/717.f));
                make.height.equalTo(@(304));
            }];
            
            [coverImageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.top).offset(112/480.f*kScreenHeight);
                make.left.equalTo(weakSelf.left).offset(24);
                make.right.equalTo(weakSelf.right).offset(-24);
                make.height.equalTo(@((kScreenWidth - 24*2)*300.f/640.f));
            }];
            
            [titleImageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.centerX).offset(-(kScreenWidth + 115)/2.f);
                make.top.equalTo(weakSelf.bottom).offset(-114);
                make.width.equalTo(@(115));
                make.height.equalTo(@(24));
            }];
            
            [textImageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.centerX).offset((kScreenWidth + 136)/2.f);
                make.top.equalTo(weakSelf.bottom).offset(-66);
                make.width.equalTo(@(136));
                make.height.equalTo(@(29));
            }];
        }else {
            [itemImageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.top).offset(32/667.f*kScreenHeight);
                make.left.equalTo(weakSelf.left);
                make.right.equalTo(weakSelf.right);
                make.height.equalTo(@(kScreenWidth*1210.f/1080.f));
            }];
            
            [coverImageView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(weakSelf.top).offset(156/667.f*kScreenHeight);
                make.left.equalTo(weakSelf.left);
                make.right.equalTo(weakSelf.right);
                make.height.equalTo(@(kScreenWidth*300.f/640.f));
            }];
            
            [titleImageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.centerX).offset(-(kScreenWidth + 130)/2.f);
                make.top.equalTo(weakSelf.bottom).offset(-155/667.f*kScreenHeight);
                make.width.equalTo(@(130));
                make.height.equalTo(@(30));
            }];
            
            [textImageView makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(weakSelf.centerX).offset((kScreenWidth + 190)/2.f);
                make.top.equalTo(weakSelf.bottom).offset(-94/667.f*kScreenHeight);
                make.width.equalTo(@(190));
                make.height.equalTo(@(38));
            }];
        }
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"intro_video_1" withExtension:@"mov"];
        NSDictionary *opts = [[NSDictionary alloc] initWithObjectsAndKeys:@YES, AVURLAssetPreferPreciseDurationAndTimingKey, nil];
        AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:opts];
        if (isIphone4) {
            playView = [[DPMoviePlayerView alloc] initWithFrame:CGRectMake(63, 121, 194, 110) asset:urlAsset];
            playView.repeats = YES;
        }else {
            playView = [[DPMoviePlayerView alloc] initWithFrame:CGRectMake(54/375.f*kScreenWidth, 169/667.f*kScreenHeight, (375- 54 - 52)/375.f*kScreenWidth, 150/667.f*kScreenHeight) asset:urlAsset];
            playView.repeats = YES;
        }
        [self addSubview:playView];
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
    [playView stop];
    playView = nil;
    bgImageView = nil;
    itemImageView = nil;
    coverImageView = nil;
    titleImageView = nil;
    textImageView = nil;
}

#pragma mark - methods
- (void)viewDidShow
{
    [self subviewsAnimation];
    [self playIntroduceVideo];
}

- (void)viewDidDismiss
{
    [self stopIntroduceVideo];
    [self subviewsRecover];
}

- (void)subviewsAnimation
{
    if (!animating) {
        animating = YES;
        itemImageView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
        [titleImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
        }];
        [textImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.centerX);
        }];
        
        [UIView animateWithDuration:1.f animations:^{
            itemImageView.transform = CGAffineTransformMakeScale(1.f, 1.f);
            [titleImageView layoutIfNeeded];
            [textImageView layoutIfNeeded];
            [self layoutIfNeeded];
        }completion:^(BOOL finish){
            animating = NO;
            itemImageView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)subviewsRecover
{
    [titleImageView setNeedsLayout];
    [textImageView setNeedsLayout];
    
    if (IOS_VERSION_8_OR_ABOVE) {
        itemImageView.transform = CGAffineTransformMakeScale(0.75f, 0.75f);
    }
    __weak typeof(self) weakSelf = self;
    if (iPhone4) {
        [titleImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.centerX).offset(-(kScreenWidth + 115)/2.f);
        }];
        [textImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.centerX).offset((kScreenWidth + 136)/2.f);
        }];
    }else {
        [titleImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.centerX).offset(-(kScreenWidth + 130)/2.f);
        }];
        [textImageView updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.centerX).offset((kScreenWidth + 190)/2.f);
        }];
    }
    
    [titleImageView layoutIfNeeded];
    [textImageView layoutIfNeeded];
    [self layoutIfNeeded];
}

- (void)playIntroduceVideo
{
    [playView playOrResume];
}

- (void)stopIntroduceVideo
{
    [playView pause];
}

@end
