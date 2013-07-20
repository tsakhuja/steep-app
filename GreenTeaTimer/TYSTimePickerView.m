//
//  TYSTimePickerView.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/27/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSTimePickerView.h"
#import <QuartzCore/QuartzCore.h>

#define labelHeight 20.0

@interface TYSTimePickerView ()

@property (nonatomic, strong) UILabel *minLabel;

@end

@implementation TYSTimePickerView

NSUInteger rowLength = 60 * 10000;

@synthesize seconds = _seconds;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsSelectionIndicator = YES;
    }
    return self;
}

- (void) didAddSubview:(UIView *)subview {
    if (self.subviews.count == 15) {
        UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, self.frame.size.height / 2 - labelHeight / 2, 50, labelHeight)];
        minLabel.backgroundColor = [UIColor clearColor];
        minLabel.font = [UIFont boldSystemFontOfSize:20.0];

//        minLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
//        minLabel.shadowOffset = CGSizeMake(0.0, 0.5);
        minLabel.text = @"mins";
        
        UILabel *secLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, self.frame.size.height / 2 - labelHeight / 2, 50, labelHeight)];
        secLabel.backgroundColor = [UIColor clearColor];
        secLabel.font = [UIFont boldSystemFontOfSize:20.0];
//        secLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
//        secLabel.shadowOffset = CGSizeMake(0.0, 0.5);
        secLabel.text = @"secs";
        
        [self insertSubview:minLabel atIndex:7];
        [self insertSubview:secLabel atIndex:13];
        self.minLabel = minLabel;
    }
}

#pragma mark - Data source methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 6;
    } else {
        return rowLength;
    }
}

#pragma mark - picker view delegate methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSUInteger rowNumber;
    if (component == 0) {
        rowNumber = row;
    } else {
        rowNumber = row % 60;
    }
    
    if (row < 10) {
        return [NSString stringWithFormat:@"  %i", rowNumber];
    }
    return [NSString stringWithFormat:@"%i", rowNumber];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    return;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 120;
}

#pragma mark - Time getters and setters

- (void)setSeconds:(NSUInteger)seconds animated:(BOOL)animated
{
    _seconds = seconds;
    NSUInteger displayedMinutes = seconds / 60;
    NSUInteger displayedSeconds = rowLength / 2 + seconds % 60;
    [self selectRow:displayedMinutes inComponent:0 animated:animated];
    [self selectRow:displayedSeconds inComponent:1 animated:animated];
}

- (NSUInteger)seconds{
    NSUInteger minutes = [self selectedRowInComponent:0];
    NSUInteger seconds = [self selectedRowInComponent:1] % 60;
    return 60 * minutes + seconds;
}


@end
