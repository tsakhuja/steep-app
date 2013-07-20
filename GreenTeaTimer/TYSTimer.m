//
//  TYSTimer.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 4/1/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSTimer.h"

#import "TYSTimeStringFormatter.h"

#define kTimerInterval 1.0

@implementation TYSTimer

NSDate *_startTime;
NSTimer *_timer;
NSDate *_suspendDate;

+ (TYSTimer *)sharedTimer
{
    static TYSTimer *timer;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        timer = [[self alloc] init];
    });
    
    return timer;
}


- (id)initWithDuration:(NSUInteger)duration delegate:(id <TYSTimerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _duration = duration;
        _currentTimeValue = duration;
        _delegate = delegate;
        _displayedTime = [TYSTimeStringFormatter timeStringWithSeconds:_duration];
    }
    
    return self;
}

- (void)resetWithNotification:(BOOL)notification
{
    if ([_timer isValid]) {
        [self stop];
    }
    self.currentTimeValue = self.duration;
    [self timerDidReset];

    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:kTimerInterval target:self selector:@selector(timerDidUpdate) userInfo:nil repeats:YES];
    _timer = timer;
    _startTime = [NSDate date];
    
    if (notification) {
        [self setNotification];
    }
    
    [self.delegate didStartTimer:self];
}

- (void)reset
{
    [self resetWithNotification:YES];
}

- (void)stop
{
    [_timer invalidate];
    
    [self timerDidReset];
    
    // Remove notifications
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    if (oldNotifications.count > 0) {
        [app cancelAllLocalNotifications];
    }
    
    [self.delegate didStopTimer:self];
}

- (BOOL)isRunning
{
    return [_timer isValid];
}

- (void)suspend
{
    _suspendDate = [NSDate date];
    [_timer invalidate];
    _isSuspended = YES;
}

- (void)resume
{
    if (self.isSuspended) {
        NSDate *now = [NSDate date];
        NSTimeInterval suspensionDuration = [now timeIntervalSinceDate:_suspendDate];
        NSUInteger timeRemainingAtSupsension = self.currentTimeValue;
        NSInteger currentTimeRemaining = timeRemainingAtSupsension - suspensionDuration;
        if (currentTimeRemaining <= 0) {
            self.currentTimeValue = 0;
            [self.delegate timer:self didUpdateDisplayedTime:[TYSTimeStringFormatter timeStringWithSeconds:0]];
        } else if (currentTimeRemaining > 0) {
            self.currentTimeValue = currentTimeRemaining;
            self.duration = currentTimeRemaining;
            [self resetWithNotification:NO];
        }
    }
    _isSuspended = NO;
}

#pragma mark Set timer duration

- (void)setDuration:(NSUInteger)duration
{
    if ([_timer isValid]) {
        [self stop];
    }
    _duration = duration;
    self.currentTimeValue = duration;
    [self.delegate timer:self didUpdateDisplayedTime:[TYSTimeStringFormatter timeStringWithSeconds:duration]];
}

- (void)changeDurationWhileActiveWithDuration:(NSUInteger)duration
{
    NSUInteger elapsedTime = [[NSDate date] timeIntervalSinceDate:_startTime];

    if (elapsedTime > duration || ![self isRunning]) {
        return;
    }
    
    // Remove notifications
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *oldNotifications = [app scheduledLocalNotifications];
    if (oldNotifications.count > 0) {
        [app cancelAllLocalNotifications];
    }
    
    _duration = duration;
    
    [self setNotification];
    
}

- (NSUInteger)elapsedTime
{
    return [[NSDate date] timeIntervalSinceDate:_startTime];
}

#pragma mark - Update TYSTimer

- (void)timerDidUpdate {
    NSTimeInterval elapsedTime = [[NSDate date] timeIntervalSinceDate:_startTime];
    uint seconds = fabs(self.duration - elapsedTime + 1);
    self.currentTimeValue = seconds;
    
    NSString *displayedTime = [TYSTimeStringFormatter timeStringWithSeconds:seconds];
    self.displayedTime = displayedTime;
    
    [self.delegate timer:self didUpdateDisplayedTime:self.displayedTime];
    
    if (self.currentTimeValue == 0) {
        [_timer invalidate];
    }
}

- (void)timerDidReset {
    NSString *displayedTime = [TYSTimeStringFormatter timeStringWithSeconds:self.duration];
    self.displayedTime = displayedTime;
    
    self.currentTimeValue = self.duration;
    
    [self.delegate timer:self didUpdateDisplayedTime: displayedTime];
}

#pragma mark - UILocalNotification management

- (void)setNotification
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    if (localNotif == nil) {
        NSLog(@"notification nil");
        return;
    }
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:(_duration - self.elapsedTime)];
    localNotif.timeZone = nil;
    
    localNotif.alertAction = @"View";
    localNotif.alertBody = @"Your tea is ready!";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}


@end
