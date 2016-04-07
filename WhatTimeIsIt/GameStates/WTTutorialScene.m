//
//  WTTutorialScene.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 4/6/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import "WTTutorialScene.h"

@interface WTTutorialScene ()

@property (nonatomic, strong) SKScene* tutorialSceneRef;
@property (nonatomic, assign) int tutorialStep;

@end

@implementation WTTutorialScene

-(void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    //quick and dirty is first play
    self.tutorialStep = -1;
    self.tutorialSceneRef = [WTTutorialScene unarchiveFromFile:@"TutorialScene"];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    NSArray<SKNode*>* nodesAtPoint = [self nodesAtPoint:location];
    //we are playing the game
    for (SKNode* node in nodesAtPoint) {
        //TODO - move the touch handling to the WTClock Class and report to game class if it's a tap
        if ([node isKindOfClass:WTClock.class]) {
            //always the correct clock in tut mode
            [self removeAllChildren];
            [self addChild:self.playerScoreLabel];
            [self addChild:self.timer];
            
            [self incrementPlayerScore];
            [self resetTimerAndStartCountdown:YES];
            break;
        }
    }
    
    [self showNextTutorial];

}

-(void)loadNextTick {
    SKScene* clockPattern = [SKScene unarchiveFromFile:[NSString stringWithFormat:@"BasicClockPattern_0"]];
    SKNode* clockTargetNode = [clockPattern objectForKeyedSubscript:@"clockTargetNode"].firstObject;
    SKNode* clockStartNode = [clockPattern objectForKeyedSubscript:@"clockPlaceholderNode"].firstObject;
    
    WTClock* clockNode = [(WTClock*)[SKScene unarchiveFromFile:@"DefaultClock"].children[0] copy];
    [clockNode windClockToTime:WTTimeCurrentWithBufferTime(0) withContinuousSpinDuration:0 andToFinalTimeDuration:0];
    clockNode.xScale *= 3.0f;
    clockNode.yScale *= 3.0f;
    clockNode.position = clockStartNode.position;
    [self addChild:clockNode];
    [clockNode runAction:[SKAction moveTo:clockTargetNode.position duration:0.4f] completion:^{
        [self showNextTutorial];
    }];
}

#pragma mark - Tutorial Controls
-(void)showNextTutorial {
    self.tutorialStep++;
    if (self.tutorialStep < 3) {
        [self showTutorialStep:self.tutorialStep];
    }
    else {
        //start game
        GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
        [self.scene.view presentScene:scene transition:[SKTransition moveInWithDirection:SKTransitionDirectionRight duration:0.3]];
    }
}
-(void)showTutorialStep:(NSUInteger)step {
    if (self.tutorialSceneRef == nil) {
        return;
    }
    self.scene.speed = 0.0f;
    const NSString * tutStep = [NSString stringWithFormat:@"tut_%lu",(unsigned long)step];
    for (SKNode* childForStep in self.tutorialSceneRef.children) {
        if ([childForStep.name hasPrefix:(NSString*)tutStep]) {
            [self addChild:[childForStep copy]];
        }
    }
}

-(void)hideTutorialStep:(NSUInteger)step {
    if (self.tutorialSceneRef == nil) {
        return;
    }
    const NSString * tutStep = [NSString stringWithFormat:@"tut_%lu",(unsigned long)step];
    for (SKNode* childForStep in self.children) {
        if ([childForStep.name hasPrefix:(NSString*)tutStep]) {
            [childForStep removeFromParent];
        }
    }
    self.scene.speed = 1.0f;
}

@end
