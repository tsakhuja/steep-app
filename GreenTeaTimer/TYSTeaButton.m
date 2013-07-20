//
//  TYSTeaButton.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 4/14/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSTeaButton.h"

#import <QuartzCore/QuartzCore.h>

@implementation TYSTeaButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawButton];
    }
    return self;
}

- (void)drawButton
{
    [self setImage:[UIImage imageNamed:@"teacup_letterpress"] forState:UIControlStateNormal];
    CGRect labelFrame = self.bounds;
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    label.textColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    label.font = [UIFont boldSystemFontOfSize:14.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    _teaCupLabel = label;
}


@end
