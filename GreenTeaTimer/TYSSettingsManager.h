//
//  TYSSettingsManager.h
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/21/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYSSettingsManager : NSObject

+ (TYSSettingsManager *)sharedSettingsManager;

@property (nonatomic, readonly) NSUInteger defaultTemp;
@property (nonatomic, readonly) NSUInteger defaultDuration;
@property (nonatomic) NSUInteger currentTemp;
@property (nonatomic) NSUInteger currentDuration;
@property (nonatomic) BOOL isCelsius;
@property (nonatomic, readonly) NSString *tempRangeString;
@property (nonatomic, readonly) NSArray *recentTimes;
- (void)addTempToRecentTimesWithTemp:(NSUInteger)temp;

@end
