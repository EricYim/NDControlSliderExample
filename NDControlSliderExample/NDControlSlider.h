/*
 * NDControlSlider.h
 *
 * Copyright 2011 Eric Yim.
 * Created by Eric Yim on 11-08-29.
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

#import "CCControl.h"

@class NDControlButton;

/*
 * @class
 * NDControlSlider is a subclass of CCControl. This basic iOS slider control 
 * supports the horizontal orientation and allows the user to tap the slider or 
 * drag the tab to set the slider value.
 */
@interface NDControlSlider : CCControl {
@public
    /** Tags for accessing node's children. */
    enum {
        kFrameNormalSpriteTag,
        kFrameDisabledSpriteTag,
        kTabButtonTag,
    };
@private
    float value_;
    // min & max x position offsets relative to slider's center
    float minX_;
    float maxX_;
}

/** Current slider value; 0.0f <= value <= 1.0f */
@property (nonatomic) float value;

#pragma mark Contructors

/** Creates slider with frame's normal sprite and tab button. 
 *
 * @see initWithFrameNormalSprite:tabButton:
 */
+ (id)sliderWithFrameNormalSprite:(CCSprite *)frameNormalSprite tabButton:(NDControlButton *)tab;

/** Creates slider with frame's normal and disabled sprites and tab button. 
 *
 * @see initWithFrameNormalSprite:frameDisabledSprite:tabButton:
 */
+ (id)sliderWithFrameNormalSprite:(CCSprite *)frameNormalSprite frameDisabledSprite:(CCSprite *)frameDisabledSprite tabButton:(NDControlButton *)tab;

/** Convenient init - takes only slider's normal frame sprite and tab button as
 * parameters; duplicates normal sprite to create disabled sprite and calls 
 * initWithFrameNormalSprite:frameDisabledSprite:tabButton: internally.
 *
 * @see initWithFrameNormalSprite:frameDisabledSprite:tabButton:
 */
- (id)initWithFrameNormalSprite:(CCSprite *)frameNormalSprite tabButton:(NDControlButton *)tab;

/** Designated init.
 *
 * @param frameNormalSprite CCSprite that is used as slider's normal frame graphics. 
 *
 * @param frameDisabledSprite CCSprite that is used as slider's disabled frame graphics. 
 *
 * @param tab NDControlButton that is used as slider's tab button.
 */
- (id)initWithFrameNormalSprite:(CCSprite *)frameNormalSprite frameDisabledSprite:(CCSprite *)frameDisabledSprite tabButton:(NDControlButton *)tab;

#pragma mark Public methods

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
/** Returns the [0,1] saturated slider value given touch instance.
 *
 * @param touch UITouch that is passed from touch events.
 */
- (float)valueForTouch:(UITouch *)touch;
#endif

@end
