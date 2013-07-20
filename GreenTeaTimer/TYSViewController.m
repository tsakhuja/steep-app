//
//  TYSViewController.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/20/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSViewController.h"

#import "TYSInfoBackViewController.h"
#import "TYSSettingsManager.h"
#import "TYSTimer.h"
#import "TYSPushButton.h"
#import "TYSButton.h"
#import "TYSTeaButton.h"
#import "TYSTimeStringFormatter.h"
#import <QuartzCore/QuartzCore.h>

@interface TYSViewController ()

@property (nonatomic) UILabel *timerLabel;
@property (nonatomic) TYSTimer *timer;

@property (nonatomic) TYSSettingsManager *settingsManager;

@property (nonatomic) UIButton *startButton;
@property (nonatomic) UIButton *stopButton;
@property (nonatomic) UIButton *rebrewButton;
@property (nonatomic) UILabel *tempLabel;

@property (nonatomic) NSMutableArray *recentTimers;

@end

@implementation TYSViewController

float titleLabelOpacity = 1.0f;
float titleLabelWhite = 0.8f;
float inactiveTimerWhite = 0.5f;
float activeTimerWhite = 0.3f;
BOOL isRebrewDisplayed = NO;
uint _timerDuration;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        TYSSettingsManager *settingsManager = [TYSSettingsManager sharedSettingsManager];
        self.settingsManager = settingsManager;
        
//        TYSTimer *timer = [[TYSTimer alloc] initWithDuration:self.timerLength delegate:self];
        TYSTimer *timer = [TYSTimer sharedTimer];
        timer.delegate = self;
        timer.duration = self.settingsManager.currentDuration;
        _timerDuration = self.settingsManager.currentDuration;
        self.timer = timer;
        
        self.recentTimers = [[NSMutableArray alloc] initWithCapacity:3];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_noise"]];
    
    [self drawTimer];
    [self drawTitleLabel];
    [self drawTempLabel];
    [self.timer reset];
    
}

- (void)viewDidLayoutSubviews
{
    // Add info button
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.frame = CGRectMake(self.view.frame.size.width - 33, self.view.frame.size.height - 34, 18, 19);
    [self.view addSubview:infoButton];
    [infoButton addTarget:self action:@selector(segueToSettings) forControlEvents:UIControlEventTouchUpInside];
    
//    [self drawTeaCup];
    [self drawRecentTimers];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button configuration and management

- (void)configureStartStopButtons
{
    CGRect buttonFrame = CGRectMake(110, 265, 100, 50);
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setImage:[UIImage imageNamed:@"tea_icon"] forState:UIControlStateNormal];
    startButton.frame = buttonFrame;
    [startButton addTarget:self action:@selector(resetTimer) forControlEvents:UIControlEventTouchUpInside];
    self.startButton = startButton;
    
    UIButton *stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopButton setImage:[UIImage imageNamed:@"tea_icon_empty"] forState:UIControlStateNormal];
    stopButton.frame = buttonFrame;
    [stopButton addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
    self.stopButton = stopButton;
    [self.view addSubview:stopButton];
}

- (void)displayRebrewButton
{
    if (!self.rebrewButton) {
        UIButton *rebrewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rebrewButton setImage:[UIImage imageNamed:@"tea_icon"] forState:UIControlStateNormal];
        rebrewButton.frame = CGRectMake(110, 265, 100, 50);
        [rebrewButton addTarget:self action:@selector(rebrew) forControlEvents:UIControlEventTouchUpInside];
        self.rebrewButton = rebrewButton;
    }
        
    [self.view addSubview:self.rebrewButton];
    
    isRebrewDisplayed = YES;
}

- (void)updateTimerButtonEnabledStates
{
    for (TYSTeaButton *button in self.recentTimers) {
        if ([self.timer isRunning]) {
            if (button.tag < self.timer.elapsedTime) {
                [button setEnabled:NO];
            }
        } else {
            [button setEnabled:YES];
        }

    }
}


#pragma mark - Timer actions

- (void)resetTimer
{
    // Reset duration
    self.timer.duration = _timerDuration;
    
    // Set label color
    self.timerLabel.textColor = [UIColor colorWithWhite:activeTimerWhite alpha:1.0f];
    
    [self.timer reset];
}

- (void)stopTimer
{
    self.timer.duration = _timerDuration;
    [self.timer stop];
}

- (void)toggleTimer
{
    if ([self.timer isRunning]) {
        [self stopTimer];
    } else {
        [self resetTimer];
    }
}

- (void)startTimerWithDuration:(id)sender
{
    TYSTeaButton *button = (TYSTeaButton *)sender;
    if (![self.timer isRunning]) {
        [self.timer setDuration:button.tag];
        _timerDuration = button.tag;
        [self.timer reset];
    } else {
        [self.timer changeDurationWhileActiveWithDuration:button.tag];
        _timerDuration = button.tag;
    }
    [self.settingsManager setCurrentDuration:button.tag];
    
//    [self drawRecentTimers];
    self.tempLabel.text = [TYSTimeStringFormatter timeStringWithSeconds:_timerDuration];

}

#pragma mark - Timer configuration

- (void)configureTimerView
{
    CGRect timerLabelFrame = CGRectMake(30, 185, self.view.frame.size.width - 60, 100);
    UILabel *timerLabel = [[UILabel alloc] initWithFrame:timerLabelFrame];
    
    timerLabel.backgroundColor = [UIColor clearColor];
    
    timerLabel.text = self.timer.displayedTime;
    timerLabel.textAlignment = NSTextAlignmentCenter;
    timerLabel.font = [UIFont boldSystemFontOfSize:60.0];
    timerLabel.textColor = [UIColor colorWithWhite:activeTimerWhite alpha:1.0f];
    timerLabel.shadowColor = [UIColor whiteColor];
    timerLabel.shadowOffset = CGSizeMake(0, 1.0);

    self.timerLabel = timerLabel;
    [self.view addSubview:timerLabel];
}

- (void)drawTimer
{
    CGRect buttonFrame = CGRectMake(15, 150, self.view.frame.size.width - 30, 180);
    
//    TYSPushButton *button = [[TYSPushButton alloc] initWithFrame:buttonFrame];
    TYSButton *button = [[TYSButton alloc] initWithFrame:buttonFrame];
    [button addTarget:self action:@selector(toggleTimer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    [self configureTimerView];
}

- (void)drawTempLabel
{
    int labelWidth = 200;
    CGRect labelFrame = CGRectMake(self.view.frame.size.width / 2 - labelWidth / 2, 50, labelWidth, 25);
    UILabel *tempLabel = [[UILabel alloc] initWithFrame:labelFrame];
    tempLabel.font = [UIFont boldSystemFontOfSize:20.0];
    tempLabel.textColor = [UIColor colorWithWhite:titleLabelWhite alpha:titleLabelOpacity];
    tempLabel.backgroundColor = [UIColor clearColor];
    tempLabel.text = [TYSTimeStringFormatter timeStringWithSeconds:_timerDuration];
    tempLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tempLabel = tempLabel;
    [self.view addSubview:tempLabel];
}

- (void)drawTitleLabel
{
    int labelWidth = 200;
    CGRect labelFrame = CGRectMake(self.view.frame.size.width / 2 - labelWidth / 2, 15, labelWidth, 40);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    
    label.font = [UIFont boldSystemFontOfSize:36.0];
    label.textColor = [UIColor colorWithWhite:titleLabelWhite alpha:titleLabelOpacity];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"Steep";
    label.textAlignment = NSTextAlignmentCenter;
    label.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.6];
    label.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    [self.view addSubview:label];
}

- (void)drawTeaCup
{
    CGRect viewFrame = self.view.frame;
    UIImage *teaCup = [UIImage imageNamed:@"teacup_letterpress"];
    UIImageView *teaCupView = [[UIImageView alloc] initWithImage:teaCup];
    CGRect teaCupFrame = teaCupView.frame;
    teaCupFrame.origin.x = viewFrame.size.width / 2 - teaCupFrame.size.width / 2;
    teaCupFrame.origin.y = viewFrame.size.height - 15 - teaCup.size.height;
//    teaCupFrame.origin.y = 15;
    teaCupView.frame = teaCupFrame;
    
    [self.view addSubview:teaCupView];
}

- (void)drawRecentTimers {
    if (self.recentTimers.count > 0) {
        for (TYSTeaButton *button in self.recentTimers) {
            [button removeFromSuperview];
        }
    }
    
    NSArray *recentTimers = self.settingsManager.recentTimes;
    CGRect viewFrame = self.view.frame;
    
    CGRect teaCupFrame = CGRectMake(0, 0, 100, 54);
    TYSTeaButton *teaButton;
    for (int i = recentTimers.count - 1; i >= 0; i--) {
        NSNumber *time = recentTimers[i];
        teaCupFrame.origin.x = viewFrame.size.width - teaCupFrame.size.width * (recentTimers.count - i) - 10;
        teaCupFrame.origin.y = viewFrame.size.height - 45 - teaCupFrame.size.height;
        
        teaButton = [[TYSTeaButton alloc] initWithFrame:teaCupFrame];
        [teaButton.teaCupLabel setText:[TYSTimeStringFormatter timeStringWithSeconds:time.intValue]];
        teaButton.tag = time.intValue;
        [teaButton addTarget:self action:@selector(startTimerWithDuration:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:teaButton];
        [self.recentTimers addObject:teaButton];
    }
    
    [self updateTimerButtonEnabledStates];
}

- (void)toggleTimerLabel
{
    self.timerLabel.hidden = !self.timerLabel.hidden;
}


#pragma mark - TYSTimerDelegate methods

- (void)timer:(TYSTimer *)timer didUpdateDisplayedTime:(NSString *)displayTime
{
    self.timerLabel.text = displayTime;
    [self updateTimerButtonEnabledStates];
}

- (void)didStopTimer:(TYSTimer *)timer
{
//    [self toggleStartStopButtons];
    self.timerLabel.textColor = [UIColor colorWithWhite:inactiveTimerWhite alpha:1.0f];
    [self updateTimerButtonEnabledStates];

}

- (void)didStartTimer:(TYSTimer *)timer
{
    self.timerLabel.textColor = [UIColor colorWithWhite:activeTimerWhite alpha:1.0f];
}

- (BOOL)isTimerRunning {
    return [self.timer isRunning];
}

#pragma mark - Segue

- (void)segueToSettings
{
    TYSInfoBackViewController *settingsController = [[TYSInfoBackViewController alloc] initWithNibName:nil bundle:nil];
    
    settingsController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:settingsController animated:YES completion:nil];
}

- (IBAction)saveSettings:(id)sender
{
    if (self.presentedViewController) {
        TYSInfoBackViewController *settingsController = (TYSInfoBackViewController *) self.presentedViewController;
        [settingsController saveInputs];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    [self drawRecentTimers];

    _timerDuration = self.settingsManager.currentDuration;
//    self.tempLabel.text = self.settingsManager.tempRangeString;
}

- (IBAction)dismissSettings:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSUInteger)timerLength
{
    return self.settingsManager.currentDuration;
}

@end
