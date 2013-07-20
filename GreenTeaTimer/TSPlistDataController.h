//
//  TSPlistDataController.h
//  ForagerDiary
//
//  Created by Timothy Sakhuja on 2/16/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSPlistDataController : NSObject

@property (nonatomic, strong) NSString *plistName;

- (id)initWithPlistName:(NSString *)plistName;
- (void)saveCurrentState;
- (void)addValue:(id)value forKey:(NSString *)key;
- (NSDictionary *)plistDict;
- (NSArray *)sourcePathList:(NSString *)plistName;

@end
