//
//  TYSSoundEffect.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 4/7/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSSoundEffect.h"

@implementation TYSSoundEffect

- (id)initWithSoundNamed:(NSString *)soundName
{
    self = [super init];
    if (self) {
        NSURL *sound   = [[NSBundle mainBundle] URLForResource: soundName
                                                    withExtension: @"mp3"];
        
        // Store the URL as a CFURLRef instance
        self.soundFileURLRef = (__bridge CFURLRef)(sound);
        
        // Create a system sound object representing the sound file.
        AudioServicesCreateSystemSoundID(self.soundFileURLRef,&_soundFileObject);
    }
    
    return self;
    
}

- (void)playSound:(id)sender
{
    AudioServicesPlaySystemSound(self.soundFileObject);
}

@end
