//
//  DPAppIntroPanel.m
//  DPLaunchIntro
//
//  Created by yxw on 15-7-27.
//  Copyright (c) 2013年 yxw. All rights reserved.
//

#import "DPAppIntroPanel.h"
#import "AppDelegate.h"
#import "DPIntroFirstView.h"
#import "DPIntroSecondView.h"
#import "DPIntroThirdView.h"

#define kGapX 10
#define kNumberOfAppIntroPages 3

static NSString * const DPAppIntroPage = @"DPAppIntroPage";
static NSString * const DPAppIntroDisplayedPage = @"DPAppIntroDisplayedPage";
static DPAppIntroPanel *_appIntroPanel = nil;

@interface DPAppIntroPanel () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UIView *mContentView;
@property (nonatomic, strong) UIPageControl *mPageControl;
@property (nonatomic, assign) NSInteger mCurrentPage;
@property (nonatomic, strong) DPIntroFirstView *firstView;
@property (nonatomic, strong) DPIntroSecondView *secondView;
@property (nonatomic, strong) DPIntroThirdView *thirdView;
@end

@implementation DPAppIntroPanel
@synthesize mScrollView;
@synthesize mContentView;
@synthesize mPageControl;
@synthesize mCurrentPage;
@synthesize firstView;
@synthesize secondView;
@synthesize thirdView;

#pragma mark - public
+ (BOOL)displayIfNeeded
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    BOOL show = ![[userDefaults objectForKey:[NSString stringWithFormat:@"%@-%@", DPAppIntroPage, version]] boolValue];
    
    if (show) {
        const NSInteger currentPage = [userDefaults integerForKey:DPAppIntroDisplayedPage];
        if (0 <= currentPage && currentPage < kNumberOfAppIntroPages) {
            if (nil == _appIntroPanel) {
                _appIntroPanel = [[DPAppIntroPanel alloc] initWithCurrentPage:currentPage];
            }
        }else {
            if (nil == _appIntroPanel) {
                _appIntroPanel = [[DPAppIntroPanel alloc] initWithCurrentPage:0];
            }
        }
        _appIntroPanel.rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        [_appIntroPanel show];
    }
    return show;
}

#pragma mark - life cycle
- (id)initWithCurrentPage:(NSInteger)currentPage
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setWindowLevel:(UIWindowLevelStatusBar + 1)];
        
        mCurrentPage = currentPage;
        
        mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-kGapX, 0, [[UIScreen mainScreen] bounds].size.width + kGapX * 2, [[UIScreen mainScreen] bounds].size.height)];
        [mScrollView setDelegate:self];
        [mScrollView setBackgroundColor:[UIColor lightGrayColor]];
        [mScrollView setDecelerationRate:UIScrollViewDecelerationRateNormal];
        [mScrollView setShowsVerticalScrollIndicator:NO];
        [mScrollView setShowsHorizontalScrollIndicator:NO];
        [mScrollView setScrollEnabled:YES];
        [mScrollView setPagingEnabled:YES];
        [mScrollView setDirectionalLockEnabled:YES];
        [mScrollView setBounces:NO];
        [mScrollView setAlwaysBounceHorizontal:YES];
        [mScrollView setAlwaysBounceVertical:NO];
        [mScrollView setBouncesZoom:NO];
        
        const CGSize contentSize = { ([[UIScreen mainScreen] bounds].size.width + kGapX * 2) * kNumberOfAppIntroPages, [[UIScreen mainScreen] bounds].size.height };
        
        mContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
        [mContentView setBackgroundColor:[UIColor lightGrayColor]];
        
        for (int i = 0; i < kNumberOfAppIntroPages; ++ i) {
            switch (i) {
                case 0:{
                    firstView = [[DPIntroFirstView alloc] initWithFrame:CGRectMake(kGapX + (kScreenWidth + kGapX * 2) * i, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
                    [mContentView addSubview:firstView];
                }
                    break;
                case 1:{
                    secondView = [[DPIntroSecondView alloc] initWithFrame:CGRectMake(kGapX + (kScreenWidth + kGapX * 2) * i, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
                    [mContentView addSubview:secondView];
                }
                    break;
                case 2:{
                    thirdView = [[DPIntroThirdView alloc] initWithFrame:CGRectMake(kGapX + (kScreenWidth + kGapX * 2) * i, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
                    __weak typeof(self) weakSelf = self;
                    thirdView.joinDuopaiBlock = ^(){
                        [weakSelf onEnterApp];
                    };
                    [mContentView addSubview:thirdView];
                }
                    break;
            }
        }
        
        [mScrollView setContentSize:contentSize];
        [mScrollView setContentOffset:CGPointMake((kScreenWidth + kGapX * 2) * currentPage, 0)];
        [mScrollView addSubview:mContentView];
        [self addSubview:mScrollView];
        
        mPageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 30, [[UIScreen mainScreen] bounds].size.width, 20)];
        [mPageControl setNumberOfPages:kNumberOfAppIntroPages];
        [mPageControl setCurrentPage:currentPage];
        [mPageControl setPageIndicatorTintColor:UIColorFrom0xRGBA(0x1abc9c, 0.5)];
        [mPageControl setCurrentPageIndicatorTintColor:UIColorFrom0xRGBA(0x1abc9c, 1.f)];
        [mPageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [self addSubview:mPageControl];
    }
    return self;
}

- (void)dealloc
{
    mScrollView = nil;
    mContentView = nil;
    mPageControl = nil;
    firstView = nil;
    secondView = nil;
    thirdView = nil;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self calculateCurrentPage];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self calculateCurrentPage];
}

- (void)calculateCurrentPage
{
    const CGPoint contentOffset = [mScrollView contentOffset];
    
    NSInteger currentPage = (contentOffset.x / (kGapX * 2 + self.bounds.size.width));
    if (mCurrentPage != currentPage) {
        mCurrentPage = currentPage;
        [mPageControl setCurrentPage:mCurrentPage];
        [self reloadPageViews];
        [[NSUserDefaults standardUserDefaults] setInteger:mCurrentPage forKey:DPAppIntroDisplayedPage];
    }
}

- (void)reloadPageViews
{
    if (mCurrentPage == 0) {
        [firstView viewDidShow];
        [secondView viewDidDismiss];
    }else if (mCurrentPage == 1) {
        [secondView viewDidShow];
        [firstView viewDidDismiss];
        [thirdView viewDidDismiss];
    }else if (mCurrentPage == 2) {
        [thirdView viewDidShow];
        [secondView viewDidDismiss];
    }
}

#pragma mark - UIPageControl
-(void)changePage:(id)sender
{
    NSInteger page = mPageControl.currentPage;
    
    [UIView animateWithDuration:0.2 animations:^{
        [mScrollView setContentOffset:CGPointMake(([[UIScreen mainScreen] bounds].size.width + kGapX * 2) * page, 0)];
    } completion:^(BOOL finished) {
        [self calculateCurrentPage];
    }];
}

#pragma mark - methods
- (void)show {
    [self setHidden:NO];
    self.rootViewController = nil;
    [self reloadPageViews];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished){
        [self setHidden:YES];
        
        if (_appIntroPanel) {
            _appIntroPanel = nil;
        }
    }];
}

- (void)onEnterApp {
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    [userDefaults setObject:@(1) forKey:[NSString stringWithFormat:@"%@-%@", DPAppIntroPage, version]];
//    [userDefaults setInteger:0 forKey:DPAppIntroDisplayedPage];
//    [userDefaults synchronize];
    
    [self dismiss];
}

@end
