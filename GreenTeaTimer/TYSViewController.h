//
//  TYSViewController.h
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/20/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYSTimer.h"

@interface TYSViewController : UIViewController <TYSTimerDelegate>

@property (nonatomic, readonly) BOOL isTimerRunning;

- (IBAction)saveSettings:(id)sender;
- (IBAction)dismissSettings:(id)sender;

- (void)resetTimer;
- (void)stopTimer;
- (void)toggleTimerLabel;

@end
