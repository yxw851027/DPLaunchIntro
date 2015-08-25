//
//  DPMoviePlayerView.h
//  DPLaunchIntro
//
//  Created by yxw on 5/6/15.
//  Copyright (c) 2015 yxw. All rights reserved.
//

#import <UIKit/UIKit.h>

struct CMTime;
@class AVAsset;
@class DPMoviePlayerView;

@protocol DPMoviePlayerViewDelegate <NSObject>

- (void)moviePlayerViewDidFinishPlaying:(DPMoviePlayerView *)moviePlayerView;

@end

@interface DPMoviePlayerView : UIView

@property (nonatomic, assign, readonly) BOOL isPlaying;
@property (nonatomic, assign, readonly) BOOL isPaused;
@property (nonatomic, assign) BOOL repeats;
@property (nonatomic, assign) BOOL muted;
@property (nonatomic, assign) id<DPMoviePlayerViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame asset:(AVAsset *)asset;
- (void)playAtTime:(CMTime)start duration:(CMTime)duration;
- (void)play;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)playOrResume;
- (void)seekToTime:(CMTime)time;

@end
