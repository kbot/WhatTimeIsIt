//
//  WTClock.h
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/16/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WTTime.h"

@interface WTClock : SKNode

@property (nonatomic,readonly) WTTime finalTime;

-(NSError*)windClockToTime:(WTTime)time withContinuousSpinDuration:(CGFloat)contSpinDur andToFinalTimeDuration:(CGFloat)toFinalDur;

@end
