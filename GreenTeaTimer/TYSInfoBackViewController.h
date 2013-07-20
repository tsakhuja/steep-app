//
//  TYSInfoBackViewController.h
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/20/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYSInfoBackViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *tempField;

@property (nonatomic) NSUInteger timerDuration;
@property (nonatomic) NSUInteger brewingTemperature;

- (void)saveInputs;

@end
