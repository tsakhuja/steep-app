//
//  TYSSoundEffect.h
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 4/7/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AudioToolbox/AudioToolbox.h>

@interface TYSSoundEffect : NSObject

@property (readwrite)   CFURLRef        soundFileURLRef;
@property (readonly)    SystemSoundID   soundFileObject;

- (id)initWithSoundNamed:(NSString *)soundName;
- (void)playSound:(id)sender;

@end
