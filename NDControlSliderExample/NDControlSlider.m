//
//  NDControlSlider.m
//  PhysicsDemo
//
//  Created by Eric Yim on 11-08-29.
//  Copyright 2011 N/A. All rights reserved.
//

#import "NDControlSlider.h"
#import "NDControlButton.h"

@interface NDControlSlider (PrivateMethods)
/** Releases slider from selected state */
- (void)resetState;
@end

@implementation NDControlSlider

@synthesize value = value_;

+ (id)sliderWithFrameNormalSprite:(CCSprite *)frameNormalSprite tabButton:(NDControlButton *)tab {
    return [[[self alloc] initWithFrameNormalSprite:frameNormalSprite tabButton:tab] autorelease];
}

+ (id)sliderWithFrameNormalSprite:(CCSprite *)frameNormalSprite frameDisabledSprite:(CCSprite *)frameDisabledSprite tabButton:(NDControlButton *)tab {
    return [[[self alloc] initWithFrameNormalSprite:frameNormalSprite frameDisabledSprite:frameDisabledSprite tabButton:tab] autorelease];
}

- (id)initWithFrameNormalSprite:(CCSprite *)frameNormalSprite tabButton:(NDControlButton *)tab {
    // Duplicates normalSprite since no disabled sprite is provided.
    CCSprite *frameDisabledSprite = [CCSprite spriteWithTexture:frameNormalSprite.texture];
    // Makes disabledSprite translucent
    frameDisabledSprite.opacity = 128;
    return [self initWithFrameNormalSprite:frameNormalSprite frameDisabledSprite:frameDisabledSprite tabButton:tab];
}

// Designated init
- (id)initWithFrameNormalSprite:(CCSprite *)frameNormalSprite frameDisabledSprite:(CCSprite *)frameDisabledSprite tabButton:(NDControlButton *)tab {
    // Prohibits nil params
    NSAssert(frameNormalSprite != nil, @"Attempt to initialize slider with nil normal frame sprite.");
    NSAssert(frameDisabledSprite != nil, @"Attempt to initialize slider with nil disabled frame sprite.");
    NSAssert(tab != nil, @"Attempt to initialize slider with nil tab button");
    self = [super init];
    if (self) {
        // Sets slider's content size as normal frame sprite's
        self.contentSize =  frameNormalSprite.contentSize;
        // Cetners frame on node's anchor
        frameNormalSprite.position = self.childrenAnchorPointInPixels;
        [self addChild:frameNormalSprite z:1 tag:kFrameNormalSpriteTag];
        
        frameDisabledSprite.position = self.childrenAnchorPointInPixels;
        // Hides disabled frame sprite
        frameDisabledSprite.visible = NO;
        [self addChild:frameDisabledSprite z:1 tag:kFrameDisabledSpriteTag];
        
        minX_ = -0.5f * self.contentSize.width;
        maxX_ = 0.5f * self.contentSize.width;
        
        [self addChild:tab z:2 tag:kTabButtonTag];
        value_ = -1;
        [self setValue:0];
    }
    
    return self;
}

#pragma mark Properties

- (void)setEnabled:(BOOL)enabled {
    if (enabled != enabled_) {
        enabled_ = enabled;
        
        NDControlButton *tab = (NDControlButton *)[self getChildByTag:kTabButtonTag];
        tab.enabled = enabled;
        
        CCSprite *normalSprite = (CCSprite *)[self getChildByTag:kFrameNormalSpriteTag];
        CCSprite *disabledSprite = (CCSprite *)[self getChildByTag:kFrameDisabledSpriteTag];
        
        // Sets correct state
        if (!enabled) {
            state_ = CCControlStateDisabled;
        }
        else {
            state_ = CCControlStateNormal;
        }
        // Shows and hides the appropriate sprites
        normalSprite.visible = enabled;
        disabledSprite.visible = !enabled;
    }
}

- (void)setValue:(float)newValue {
    // Bounds newValue to [0,1] 
    if (newValue < 0) {
        newValue = 0;
    }
    else if (newValue > 1.0f) {
        newValue = 1.0f;
    }
    if (value_ != newValue) {
        value_ = newValue;
        
        // Positions tab proportional to newValue
        NDControlButton *tab = (NDControlButton *)[self getChildByTag:kTabButtonTag];
        CGPoint tabPosition = CGPointMake(self.childrenAnchorPointInPixels.x + minX_ + value_ * (maxX_ - minX_), self.childrenAnchorPointInPixels.y);
        tab.position = tabPosition;
        
        // Sends value changed event related actions
        [self sendActionsForControlEvents:CCControlEventValueChanged];
    }
}

#pragma mark Public methods

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

- (float)valueForTouch:(UITouch *)touch {
    float retVal;
    
    CGPoint touchLocation = [self convertTouchToNodeSpaceAR:touch];
    
    if (touchLocation.x < minX_)
    {
        touchLocation.x = minX_;
    } else if (touchLocation.x > maxX_)
    {
        touchLocation.x = maxX_;
    }
    
    retVal = (touchLocation.x - minX_) / (maxX_ - minX_);
    
    return retVal;
}

#endif

#pragma mark -
#pragma mark Touch Handling

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    BOOL retVal = NO;
    NDControlButton *tab = (NDControlButton *)[self getChildByTag:kTabButtonTag];
    
    if (self.enabled && ([self isTouchInside:touch] || [tab isTouchInside:touch])) {
        [self sendActionsForControlEvents:CCControlEventTouchDown];
        [tab select];
        retVal = YES;
        self.selected = YES;
        state_ = CCControlStateSelected;
        self.value = [self valueForTouch:touch];
    }
    
    return retVal;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    self.value = [self valueForTouch:touch];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    [self sendActionsForControlEvents:CCControlEventTouchUpInside | CCControlEventTouchUpOutside];
    [self resetState];
    self.value = [self valueForTouch:touch];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    [self resetState];
    [self sendActionsForControlEvents:CCControlEventTouchCancel];
}

#endif


@end

@implementation NDControlSlider (PrivateMethods)

- (void)resetState {
    NDControlButton *tab = (NDControlButton *)[self getChildByTag:kTabButtonTag];
    [tab unselect];
    self.selected = NO;
    state_ = CCControlStateNormal;
}

@end