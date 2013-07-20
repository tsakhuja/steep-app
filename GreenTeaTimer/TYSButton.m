//
//  TYSButton.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 4/6/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSButton.h"

#import <QuartzCore/QuartzCore.h>

@interface TYSButton ()

@property (nonatomic) CAGradientLayer *backgroundLayer, *highlightBackgroundLayer;
@property (nonatomic) CALayer *innerGlow;

@end

@implementation TYSButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawButton];
//        [self drawInnerGlow];
        [self drawBackgroundLayer];
        [self drawHighlightBackgroundLayer];
        
        self.highlightBackgroundLayer.hidden = YES;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self drawButton];
//        [self drawInnerGlow];
        [self drawBackgroundLayer];
        [self drawHighlightBackgroundLayer];
    }
    return self;
}

+ (id)buttonWithType:(UIButtonType)type
{
    return [super buttonWithType:UIButtonTypeCustom];
}

- (void)drawButton
{
    CALayer *layer = self.layer;
    
    layer.cornerRadius = 4.5f;
    layer.borderWidth = 1;
    layer.borderColor = [UIColor colorWithWhite:0.3f alpha:1.0f].CGColor;
    self.clipsToBounds = YES;
}

- (CAGradientLayer *)drawBackgroundLayerWithGradient:(NSArray *)colors atIndex:(NSUInteger)index
{
    CAGradientLayer *backgroundLayer = [CAGradientLayer layer];
    
    // Set colors
    backgroundLayer.colors = colors;
    
    // Set the stops
    backgroundLayer.locations = [NSArray arrayWithObjects:@0.0f, @1.0f, nil];
    
    [self.layer insertSublayer:backgroundLayer atIndex:index];
    
    return backgroundLayer;
}

- (void)drawBackgroundLayer
{
    if (self.backgroundLayer) {
        return;
    }
    
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor,
                       (id)[UIColor colorWithWhite:0.6f alpha:1.0f].CGColor,
                       nil];
    CAGradientLayer *layer = [self drawBackgroundLayerWithGradient:colors atIndex:0];
    self.backgroundLayer = layer;
}

- (void)drawHighlightBackgroundLayer
{
    if (self.highlightBackgroundLayer) {
        return;
    }
    
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithWhite:0.2f alpha:1.0f].CGColor,
                       (id)[UIColor colorWithWhite:0.25f alpha:1.0f].CGColor,
                       nil];
    CAGradientLayer *layer = [self drawBackgroundLayerWithGradient:colors atIndex:1];
    self.highlightBackgroundLayer = layer;
}

- (void)drawInnerGlow
{
    if (self.innerGlow) {
        return;
    }
    
    // Instantiate the innerGlow layer
    CALayer *innerGlow = [CALayer layer];
    
    innerGlow.cornerRadius= 4.5f;
    innerGlow.borderWidth = 1;
    innerGlow.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0].CGColor;
    innerGlow.opacity = 0.5;
    
    self.innerGlow = innerGlow;
    [self.layer insertSublayer:self.innerGlow atIndex:2];
}

- (void)layoutSubviews
{
    // Set inner glow frame (1pt inset)
    self.innerGlow.frame = CGRectInset(self.bounds, 1, 1);
    
    // Set gradient frame (fill the whole button))
    self.backgroundLayer.frame = self.bounds;
    
    // Set inverted gradient frame
    self.highlightBackgroundLayer.frame = self.bounds;
    
    [super layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted
{
    // Hide/show inverted gradient
    self.highlightBackgroundLayer.hidden = !highlighted;
    
    [super setHighlighted:highlighted];
}

@end
