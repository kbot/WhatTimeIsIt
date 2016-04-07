//
//  WTClock.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/16/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import "WTClock.h"

@interface WTClock ()
@property (nonatomic,assign) WTTime finalTime;
@property (nonatomic,weak) SKAction* infinteAction;
@end

@implementation WTClock

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    return self;
}

-(NSError*)windClockToTime:(WTTime)time withContinuousSpinDuration:(CGFloat)contSpinDur andToFinalTimeDuration:(CGFloat)toFinalDur {
    
    self.finalTime = time;
    
    SKSpriteNode* hourHand = (SKSpriteNode*)[self childNodeWithName:@"WTHourHand"];
    SKSpriteNode* minuteHand = (SKSpriteNode*)[self childNodeWithName:@"WTMinuteHand"];
    
    [hourHand runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:5 duration:1 + 0.1 * (arc4random()%10)]]];

    [minuteHand runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:20 duration:1 + 0.1 * (arc4random()%10)]]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(contSpinDur * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [hourHand removeAllActions];
        [minuteHand removeAllActions];
        
        CGFloat degHour = WTTimeHourToDegrees(time.hour);
        CGFloat degMinutes = WTTimeMinutesToDegrees(time.minute);

        [hourHand runAction:[SKAction rotateToAngle:DegToRad(degHour) duration:toFinalDur shortestUnitArc:YES]];
        [minuteHand runAction:[SKAction rotateToAngle:DegToRad(degMinutes) duration:toFinalDur shortestUnitArc:YES]];

    });
    
    return nil;
}

@end
