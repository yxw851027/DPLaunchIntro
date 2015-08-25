//
//  DPMoviePlayerView.m
//  DPLaunchIntro
//
//  Created by yxw on 5/6/15.
//  Copyright (c) 2015 yxw. All rights reserved.
//

#import "DPMoviePlayerView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

typedef enum __DPMoviePlayerState : char {
    DPMoviePlayerStateStopped,
    DPMoviePlayerStatePlaying,
    DPMoviePlayerStatePaused
} DPMoviePlayerState;

@interface DPMoviePlayerView () {
    AVPlayer *mPlayer;
    AVPlayerItem *mPlayerItem;
    id mPlayerObserver;
    CMTime mBeginTime;
    CMTime mEndTime;
    id<DPMoviePlayerViewDelegate> mDelegate;
    BOOL mRepeats;
    BOOL mMuted;
    DPMoviePlayerState mState;
}

@end

@implementation DPMoviePlayerView

@dynamic isPlaying;
@dynamic isPaused;
@synthesize muted = mMuted;
@synthesize repeats = mRepeats;
@synthesize delegate = mDelegate;


+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (id)initWithFrame:(CGRect)frame asset:(AVAsset *)asset {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setUserInteractionEnabled:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
        AVPlayerLayer *playerLayer = (AVPlayerLayer *)[self layer];
        
        mPlayerItem = [[AVPlayerItem alloc] initWithAsset:asset];
        mPlayer = [[AVPlayer alloc] initWithPlayerItem:mPlayerItem];
        
        [playerLayer setContentsScale:[[UIScreen mainScreen] scale]];
        [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [playerLayer setPlayer:mPlayer];
        
        mBeginTime = kCMTimeZero;
        mEndTime = kCMTimePositiveInfinity;
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        
        [notificationCenter addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stop];
    [mPlayer release];
    [mPlayerItem release];
    [super dealloc];
}

- (void)_play {
    [mPlayer play];
    if (AVPlayerStatusFailed == [mPlayer status]) {
        [self stop];
    } else {
        mState = DPMoviePlayerStatePlaying;
    }
}

- (void)play {
    if (nil == mPlayerObserver) {
        static const CMTime kCMTimeUpdateDuration = { 250000, 1000000, kCMTimeFlags_Valid, 0 };
        
        mPlayerObserver = [mPlayer addPeriodicTimeObserverForInterval:kCMTimeUpdateDuration queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            //DLog(@"time: %f", CMTimeGetSeconds(time));
            if (CMTIME_COMPARE_INLINE(time, >=, [mPlayerItem duration]) || CMTIME_COMPARE_INLINE(time, >=, mEndTime)) {
                if (DPMoviePlayerStateStopped == mState) {
                    [self stop];
                    [mDelegate moviePlayerViewDidFinishPlaying:self];
                } else {
                    [mPlayer pause];
                    if (mRepeats) {
                        [self performSelector:@selector(play) withObject:nil afterDelay:0.1];
                    } else {
                        mState = DPMoviePlayerStatePaused;
                        [mDelegate moviePlayerViewDidFinishPlaying:self];
                    }
                }
            }
        }];
    }
    
    [mPlayer seekToTime:mBeginTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self _play];
}

- (void)playAtTime:(CMTime)start duration:(CMTime)duration {
    if (DPMoviePlayerStatePlaying == mState) {
        [self stop];
    }
    mBeginTime = start;
    mEndTime = CMTimeAdd(start, duration);
    [self play];
}

- (void)stop {
    if (mPlayerObserver) {
        [mPlayer removeTimeObserver:mPlayerObserver];
        mPlayerObserver = nil;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [mPlayer pause];
    mState = DPMoviePlayerStateStopped;
}

- (void)pause {
    if (DPMoviePlayerStatePlaying == mState) {
        mState = DPMoviePlayerStatePaused;
        [mPlayer pause];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)resume {
    if (DPMoviePlayerStatePaused == mState) {
        mState = DPMoviePlayerStatePlaying;
        [self _play];
    }
}

- (void)playOrResume {
    if (DPMoviePlayerStatePaused == mState) {
        [self resume];
    } else if (DPMoviePlayerStateStopped == mState) {
        [self play];
    }
}

- (void)seekToTime:(CMTime)time {
    [mPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)setMuted:(BOOL)muted {
    if (muted != mMuted) {
        mMuted = muted;
        if (mPlayerItem) {
            [self updatedVolume];
        }
    }
}

- (void)updatedVolume {
    NSArray *audioTracks = [[mPlayerItem asset] tracksWithMediaType:AVMediaTypeAudio];
    
    NSMutableArray *audioParams = [[NSMutableArray alloc] init];
    
    for (AVAssetTrack *track in audioTracks) {
        AVMutableAudioMixInputParameters *audioInputParams =
        [AVMutableAudioMixInputParameters audioMixInputParameters];
        
        [audioInputParams setVolume:(mMuted ? 0 : 1) atTime:kCMTimeZero];
        [audioInputParams setTrackID:[track trackID]];
        [audioParams addObject:audioInputParams];
    }
    
    AVMutableAudioMix *audioMix = [[AVMutableAudioMix alloc] init];
    
    [audioMix setInputParameters:audioParams];
    [audioParams release];
    
    [mPlayerItem setAudioMix:audioMix];
    [audioMix release];
}

- (void)applicationDidEnterBackground {
    if (DPMoviePlayerStatePlaying == mState) {
        [mPlayer pause];
    }
}

- (void)applicationWillEnterForeground {
    if (DPMoviePlayerStatePlaying == mState) {
        [mPlayer play];
    }
}

- (BOOL)isPlaying {
    return (DPMoviePlayerStatePlaying == mState);
}

- (BOOL)isPaused {
    return (DPMoviePlayerStatePaused == mState);
}

@end
