//
//  TYSTimeStringFormatter.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 4/14/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSTimeStringFormatter.h"

@implementation TYSTimeStringFormatter

#pragma mark - Time string formatting

+ (NSString *)timeStringWithSeconds:(uint)seconds
{
    uint minutes = seconds / 60;
    seconds = seconds % 60;
    
    return [NSString stringWithFormat:@"%02u:%02u", minutes, seconds];
}

@end
