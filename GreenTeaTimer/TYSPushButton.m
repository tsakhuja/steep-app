//
//  TYSPushButton.m
//  GreenTeaTimer
//
//  Created by Timothy Sakhuja on 4/7/13.
//  Copyright (c) 2013 Timothy Sakhuja. All rights reserved.
//

#import "TYSPushButton.h"

#import "TYSSoundEffect.h"
#import <QuartzCore/QuartzCore.h>

@interface TYSPushButton ()

@property (nonatomic) UIView *normalBackgroundView;
@property (nonatomic) UIView *highlightBackgroundView;
@property (nonatomic) TYSSoundEffect *downSoundEffect;
@property (nonatomic) TYSSoundEffect *upSoundEffect;

@end

@implementation TYSPushButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self drawButton];
        [self drawBackgroundView];
        [self drawHighlightBackgroundView];
        [self setSoundEffects];
        
        self.highlightBackgroundView.hidden = YES;
    }
    return self;
}

+ (id)buttonWithType:(UIButtonType)type
{
    return [super buttonWithType:UIButtonTypeCustom];
}

#pragma mark - Layout

- (void)drawButton
{
//    CALayer *layer = self.layer;
    
//    layer.cornerRadius = 4.5f;
//    layer.borderWidth = 1;
//    layer.borderColor = [UIColor colorWithWhite:0.3f alpha:1.0f].CGColor;
    self.clipsToBounds = YES;
}

- (UIView *)drawViewWithFrame:(CGRect)frame andColor:(UIColor *)color
{
//    NSArray *colors = [NSArray arrayWithObjects:
//                       (id)[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor,
//                       (id)[UIColor colorWithWhite:0.6f alpha:1.0f].CGColor,
//                       nil];
//    CAGradientLayer *layer = [self drawBackgroundLayerWithGradient:colors atIndex:0];
//    self.backgroundLayer = layer;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.userInteractionEnabled = NO;
    view.backgroundColor = color;
    view.opaque = NO;
    view.clipsToBounds = YES;
    view.layer.cornerRadius = 4.5f;
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.0f;
    
    return view;
}

- (void)drawBackgroundView
{
    if (self.normalBackgroundView) {
        return;
    }
    
    CGRect viewFrame = self.bounds;
    UIColor *color = [UIColor colorWithWhite:0.4f alpha:0.4f];
    UIView *view = [self drawViewWithFrame:viewFrame andColor:color];
    
    [self addSubview:view];
    self.normalBackgroundView = view;
}

- (void)drawHighlightBackgroundView
{
    if (self.highlightBackgroundView) {
        return;
    }
    
    CGRect buttonFrame = self.bounds;
    CGRect viewFrame = CGRectMake(buttonFrame.origin.x + 5, buttonFrame.origin.y + 5, buttonFrame.size.width - 10, buttonFrame.size.height - 10);
    UIColor *color = [UIColor colorWithWhite:0.3f alpha:0.4f];
    UIView *view = [self drawViewWithFrame:viewFrame andColor:color];

    [self addSubview:view];
    self.highlightBackgroundView = view;
}

- (void)layoutSubviews
{
//    // Set inner glow frame (1pt inset)
//    self.innerGlow.frame = CGRectInset(self.bounds, 1, 1);
    
    // Set gradient frame (fill the whole button))
    self.normalBackgroundView.frame = self.bounds;
    
    // Set inverted gradient frame
    self.highlightBackgroundView.frame = CGRectInset(self.bounds, 2.0f, 2.0f);
//    UIView *view = self.highlightBackgroundView;
//    view.layer.masksToBounds = NO;
//    view.layer.shadowColor = [UIColor blackColor].CGColor;
//    view.layer.shadowRadius = 5.0f;
//    view.layer.shadowOffset = CGSizeMake(-15.0f, 20.0f);
    
    [super layoutSubviews];
}

#pragma mark - button effects

- (void)setSoundEffects
{
    self.downSoundEffect = [[TYSSoundEffect alloc] initWithSoundNamed:@"click_down"];
    self.upSoundEffect = [[TYSSoundEffect alloc] initWithSoundNamed:@"click_up"];
    
    [self addTarget:self.downSoundEffect action:@selector(playSound:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self.upSoundEffect action:@selector(playSound:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)setHighlighted:(BOOL)highlighted
{
    // Hide/show inverted gradient
    self.highlightBackgroundView.hidden = !highlighted;
    self.normalBackgroundView.hidden = highlighted;
        
    [super setHighlighted:highlighted];
}


@end
