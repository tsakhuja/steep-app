//
//  TYSInfoBackViewController.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/20/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSInfoBackViewController.h"

#import "TYSSettingsManager.h"
#import "TYSTimePickerView.h"
#import "TYSButton.h"

@interface TYSInfoBackViewController ()

@property (nonatomic, strong) TYSTimePickerView *timePicker;
@property (nonatomic, strong) TYSSettingsManager *settingsManager;
@property (nonatomic, strong) UISegmentedControl *tempControl;

@end

@implementation TYSInfoBackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.settingsManager = [TYSSettingsManager sharedSettingsManager];
        self.timerDuration = [self.settingsManager currentDuration];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_noise"]];
    
    self.tempField.keyboardType = UIKeyboardTypeNumberPad;
    self.tempField.text = [NSString stringWithFormat:@"%i", self.settingsManager.currentTemp];
    
    CGRect buttonFrame = CGRectMake(60, 334, 200, 40);
    TYSButton *setDefaultButton = [TYSButton buttonWithType:UIButtonTypeCustom];
    [setDefaultButton setTitle:@"Revert to default" forState:UIControlStateNormal];

    [setDefaultButton addTarget:self action:@selector(setDefaults:) forControlEvents:UIControlEventTouchUpInside];
    setDefaultButton.frame = buttonFrame;
    
    CGRect viewFrame = self.view.frame;
    CGRect pickerFrame = CGRectMake(0, viewFrame.size.height / 3 - 216 / 3, viewFrame.size.width, 216);
    TYSTimePickerView *picker = [[TYSTimePickerView alloc] initWithFrame:pickerFrame];
    [picker setSeconds:self.timerDuration animated:NO];
    self.timePicker = picker;
    
    UIImage *overlay = [UIImage imageNamed:@"picker_overlay-568h"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:overlay];
    imageView.frame = CGRectMake(0, 44, viewFrame.size.width, viewFrame.size.height - 44);
    [imageView setUserInteractionEnabled:NO];
    
    [self.view addSubview:picker];
    [self.view addSubview:imageView];
    [self.view addSubview:setDefaultButton];
    [self drawTemperatureControls];
}

- (void)drawTemperatureControls
{
    float controlWidth = 200;
    CGRect controlFrame = CGRectMake(self.view.frame.size.width / 2 - controlWidth / 2, 390, controlWidth, 40);
    UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"°C", @"°F", nil]];
    control.frame = controlFrame;
    
    if (self.settingsManager.isCelsius) {
        [control setSelectedSegmentIndex:0];
    } else {
        [control setSelectedSegmentIndex:1];
    }
    
    self.tempControl = control;
    [self.view addSubview:control];
}

- (void)saveInputs
{
    BOOL isCelsius = self.tempControl.selectedSegmentIndex == 0;
    [self.settingsManager setIsCelsius:isCelsius];
    [self.settingsManager setCurrentDuration:self.timePicker.seconds];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton actions

- (void)setDefaults:(id)sender {
    NSUInteger defaultTime = self.settingsManager.defaultDuration;
    [self.timePicker setSeconds:defaultTime animated:YES];
}

@end
