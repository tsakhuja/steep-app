//
//  TYSTimePickerView.h
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/27/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYSTimePickerView : UIPickerView <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, readonly) NSUInteger seconds;

- (void)setSeconds:(NSUInteger)seconds animated:(BOOL)animated;

@end
