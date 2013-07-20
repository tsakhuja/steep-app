//
//  TYSSettingsManager.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 3/21/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSSettingsManager.h"
#import "TSPlistDataController.h"

@interface TYSSettingsManager ()

@property (nonatomic, strong) TSPlistDataController *dataController;
@property (nonatomic, strong) NSDictionary *settingsDict;

@end

@implementation TYSSettingsManager

static NSString *_celsiusString = @"80° - 90°";
static NSString *_fahrenheitString = @"170° - 185°";

#pragma mark - Singleton methods

+ (TYSSettingsManager *)sharedSettingsManager
{
    static TYSSettingsManager *sharedSettingsManager;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedSettingsManager = [[self alloc] init];
    });
    
    return sharedSettingsManager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.dataController = [[TSPlistDataController alloc] initWithPlistName:@"settings"];
        self.settingsDict = self.dataController.plistDict;
        [self migrate];
    }
    return self;
}

#pragma mark - Settings access

- (NSUInteger)defaultTemp
{
    return [(NSNumber *)[self.settingsDict objectForKey:@"defaultTemp"] integerValue];
}

- (NSUInteger)defaultDuration
{
    return [(NSNumber *)[self.settingsDict objectForKey:@"defaultTime"] integerValue];
}

- (NSUInteger)currentDuration
{
    if ([((NSNumber *)[self.settingsDict objectForKey:@"userTime"]) integerValue] == 0) {
        return [self defaultDuration];
    } else {
        return [(NSNumber *)[self.settingsDict objectForKey:@"userTime"] integerValue];
    }
}

- (NSUInteger)currentTemp
{
    if ([((NSNumber *)[self.settingsDict objectForKey:@"userTemp"]) integerValue] == 0) {
        return [self defaultTemp];
    } else {
        return [(NSNumber *)[self.settingsDict objectForKey:@"userTemp"] integerValue];
    }
}

- (BOOL)isCelsius
{
    return [(NSNumber *)[self.settingsDict objectForKey:@"isCelsius"] boolValue];
}

- (NSString *)tempRangeString
{
    if (self.isCelsius) {
        return _celsiusString;
    } else {
        return _fahrenheitString;
    }
}

- (NSArray *)recentTimes
{
    return [self.settingsDict objectForKey:@"recentTimes"];
}

#pragma mark - Set settings

- (void)setCurrentTemp:(NSUInteger)currentTemp
{
    [self.dataController addValue:[NSNumber numberWithInteger:currentTemp] forKey:@"userTemp"];
    [self.dataController saveCurrentState];
    self.settingsDict = self.dataController.plistDict;
}

- (void)setCurrentDuration:(NSUInteger)currentTime
{
    [self.dataController addValue:[NSNumber numberWithInteger:currentTime] forKey:@"userTime"];
    [self addTempToRecentTimesWithTemp:currentTime];
    [self.dataController saveCurrentState];
    self.settingsDict = self.dataController.plistDict;
}

- (void)setIsCelsius:(BOOL)isCelsius {
    NSNumber *boolAsNum = [NSNumber numberWithBool:isCelsius];
    [self.dataController addValue:boolAsNum forKey:@"isCelsius"];
    [self.dataController saveCurrentState];
    self.settingsDict = self.dataController.plistDict;
}

- (void)addTempToRecentTimesWithTemp:(NSUInteger)temp
{
    NSNumber *number = [NSNumber numberWithInteger:temp];
    NSMutableArray *recentTimes = [NSMutableArray arrayWithArray:self.recentTimes];
    if ([recentTimes containsObject:number]) {
        [recentTimes removeObject:number];
        [recentTimes insertObject:number atIndex:0];
    } else {
        [recentTimes insertObject:number atIndex:0];
        if (recentTimes.count == 4) {
            [recentTimes removeObjectAtIndex:3];
        }
    }
    [self.dataController addValue:[NSArray arrayWithArray:recentTimes] forKey:@"recentTimes"];
}

#pragma mark - Migrations

- (void)migrate
{
    NSArray *recentTimes;
    if (recentTimes && recentTimes.count == 0) {
        NSArray *newrecentTimes = [NSArray arrayWithObject:[NSNumber numberWithInteger:self.defaultTemp]];
        [self.dataController addValue:newrecentTimes forKey:@"recentTimes"];
    }
    
    [self.dataController saveCurrentState];
    self.settingsDict = self.dataController.plistDict;
}

@end
