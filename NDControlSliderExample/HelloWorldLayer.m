/*
 * HelloWorldLayer.m
 * 
 * Copyright 2011 Eric Yim.
 * Created by Eric Yim on 11-09-14.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to 
 * deal in the Software without restriction, including without limitation the 
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or 
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING 
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
 * IN THE SOFTWARE.
 *
 */


// Import the interfaces
#import "HelloWorldLayer.h"
#import "NDControlSlider.h"
#import "NDControlButton.h"

// HelloWorldLayer implementation
@implementation HelloWorldLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		sliderTouchDownValue_ = 0;
        updateOnTouchUp_ = YES;
        
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"0.00" fontName:@"Marker Felt" fontSize:64];
        
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label z:1 tag:kLabelTag];
        
        CCSprite *normal = [CCSprite spriteWithFile:@"Icon.png"];
        CCSprite *selected = [CCSprite spriteWithFile:@"Icon.png"];
        selected.opacity = 180;
        // create slider with above sprites
        NDControlButton *tabButton = [NDControlButton buttonWithNormalSprite:normal 
                                                           selectedSprite:selected];
        NDControlSlider *slider = [NDControlSlider sliderWithFrameNormalSprite:[CCSprite spriteWithFile:@"slider-frame.png"] 
                                                               tabButton:tabButton];
        // position slider
        slider.position = ccp(0.5 * size.width, 100.0f);
        // add slider to layer
        [self addChild:slider z:1 tag:kSliderTag];
        
        // setup event handlers
        [slider addTarget:self action:@selector(touchDown:) forControlEvents:CCControlEventTouchDown];
        [slider addTarget:self action:@selector(touchCancel:) forControlEvents:CCControlEventTouchCancel];
        [slider addTarget:self action:@selector(valueChanged:) forControlEvents:CCControlEventValueChanged];
        [slider addTarget:self action:@selector(touchUpInside:) forControlEvents:CCControlEventTouchUpInside | CCControlEventTouchUpOutside];
        // NDControlSlider doesn't support the following events
        [slider addTarget:self action:@selector(touchDragInside:) forControlEvents:CCControlEventTouchDragInside];
        [slider addTarget:self action:@selector(touchDragOutside:) forControlEvents:CCControlEventTouchDragOutside];
        [slider addTarget:self action:@selector(touchDragEnter:) forControlEvents:CCControlEventTouchDragEnter];
        [slider addTarget:self action:@selector(touchDragExit:) forControlEvents:CCControlEventTouchDragExit];
        
        normal = [CCSprite spriteWithFile:@"Icon-Small.png"];
        // this button toggles the slider's enabled state
        NDControlButton *sliderOnOffButton = [NDControlButton buttonWithNormalSprite:normal];
        sliderOnOffButton.position = ccp(0.5 * size.width, 30.0f);
        [self addChild:sliderOnOffButton z:1 tag:kOnOffButton];
        [sliderOnOffButton addTarget:self action:@selector(touchUpInside:) forControlEvents:CCControlEventTouchUpInside];
	}
	return self;
}

#pragma Event Handlers

- (void)touchDown:(CCControl *)sender {
    // if updateOnTouchUp_, save starting position so that we may return
    // tab to original position if touch is cancelled
    if (updateOnTouchUp_) {
        NDControlSlider *slider = (NDControlSlider *)sender;
        sliderTouchDownValue_ = slider.value;
    }
}

- (void)touchDragInside:(CCControl *)sender {
    CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:kLabelTag];
    label.string = [NSString stringWithFormat:@"Drag inside."];
}

- (void)touchDragOutside:(CCControl *)sender {
    CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:kLabelTag];
    label.string = [NSString stringWithFormat:@"Drag outside."];
}

- (void)touchDragEnter:(CCControl *)sender {
    CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:kLabelTag];
    label.string = [NSString stringWithFormat:@"Drag enter."];
}

- (void)touchDragExit:(CCControl *)sender {
    CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:kLabelTag];
    label.string = [NSString stringWithFormat:@"Drag exit."];
}

- (void)touchUpInside:(CCControl *)sender {
    // if sender is kind of slider and updateOnTouchUp_, update 
    // label.string
    if ([sender isKindOfClass:[NDControlSlider class]]) {
        if (updateOnTouchUp_) {
            NDControlSlider *slider = (NDControlSlider *)sender;
            CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:kLabelTag];
            label.string = [NSString stringWithFormat:@"%.2f", slider.value];
        }
    }
    // else if sender is kind of button, toggle slider
    else if ([sender isKindOfClass:[NDControlButton class]]) {
        NDControlSlider *slider = (NDControlSlider *)[self getChildByTag:kSliderTag];
        slider.enabled = !slider.enabled;
    }
}

- (void)touchUpOutside:(CCControl *)sender {
    CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:kLabelTag];
    label.string = [NSString stringWithFormat:@"Touch up outside."];
}

- (void)touchCancel:(CCControl *)sender {
    // if updateOnTouchUp_, return tab to starting position
    if (updateOnTouchUp_) {
        NDControlSlider *slider = (NDControlSlider *)sender;
        slider.value = sliderTouchDownValue_;
        CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:kLabelTag];
        label.string = [NSString stringWithFormat:@"%.2f", sliderTouchDownValue_];
    }
}

- (void)valueChanged:(CCControl *)sender {
    // if !updateOnTouchUp_, update label.string
    if (!updateOnTouchUp_) {
        NDControlSlider *slider = (NDControlSlider *)sender;
        CCLabelTTF *label = (CCLabelTTF *)[self getChildByTag:kLabelTag];
        label.string = [NSString stringWithFormat:@"%.2f", slider.value];
    }
}

@end