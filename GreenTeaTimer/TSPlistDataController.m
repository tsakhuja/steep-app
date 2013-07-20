//
//  TSPlistDataController.m
//  ForagerDiary
//
//  Created by Timothy Sakhuja on 2/16/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TSPlistDataController.h"

@interface TSPlistDataController ()

@property (nonatomic, strong) NSMutableDictionary *plist;

@end

@implementation TSPlistDataController

# pragma mark - Plist read/write methods

- (void)readPlist:(NSString *)plistName
{
    NSString *pListWithExtention = [NSString stringWithFormat:@"%@.plist", plistName];
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:pListWithExtention];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:plistPath error:nil];
    }
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&format error:nil];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    // Keep reference to pList Array
    self.plist = [NSMutableDictionary dictionaryWithCapacity:temp.allKeys.count];
    [self.plist addEntriesFromDictionary:temp];
}

- (NSDictionary *)sourcePathList:(NSString *)plistName
{
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:sourcePath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization propertyListWithData:plistXML options:NSPropertyListMutableContainersAndLeaves format:&format error:nil];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    return temp;
}

- (void)addValue:(id)value forKey:(NSString *)key;
{
    [self.plist setObject:value forKey:key];
}

- (void)writePlistToFile
{
    NSString *pListName = [NSString stringWithFormat:@"%@.plist", self.plistName];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:pListName];
    
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:self.plist format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
}

- (void)saveCurrentState
{
    [self writePlistToFile];
}

#pragma mark - initialization

- (id)initWithPlistName:(NSString *)plistName
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.plistName = plistName;
    
    // Read in plist
    [self readPlist:plistName];
    
    return self;
}

#pragma mark - Plist dict accessor

- (NSArray *)plistDict
{
    return [NSDictionary dictionaryWithDictionary:self.plist];
}

@end
