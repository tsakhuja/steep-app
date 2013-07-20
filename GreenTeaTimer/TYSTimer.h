//
//  TYSTimer.h
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 4/1/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYSTimerDelegate;

@interface TYSTimer : NSObject

- (id)initWithDuration:(NSUInteger)duration delegate:(id <TYSTimerDelegate>)delegate;
- (void)reset;
- (void)stop;
+ (TYSTimer *)sharedTimer;
- (void)suspend;
- (void)resume;
- (void)changeDurationWhileActiveWithDuration:(NSUInteger)duration;

@property (nonatomic) id <TYSTimerDelegate> delegate;
@property (nonatomic) NSUInteger duration;
@property (nonatomic) NSString *displayedTime;
@property (nonatomic) NSUInteger currentTimeValue;
@property (nonatomic, readonly) BOOL isRunning;
@property (nonatomic, readonly) BOOL isSuspended;
@property (nonatomic, readonly) NSUInteger elapsedTime;


@end

@protocol TYSTimerDelegate

@required

- (void)timer:(TYSTimer *)timer didUpdateDisplayedTime:(NSString *)displayTime;
- (void)didStopTimer:(TYSTimer *)timer;
- (void)didStartTimer:(TYSTimer *)timer;

@end
