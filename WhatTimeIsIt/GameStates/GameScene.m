//
//  GameScene.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/14/16.
//  Copyright (c) 2016 Kevin Bloom. All rights reserved.
//

#import "GameScene.h"
#import "WTClock.h"
#import "GameOver.h"
#import "WTTutorialScene.h"

#define kSpinDuration 2
#define kClockSpawnPatternCount 4

//TODO - rename this to something that makes sense for the game type
//Create new scenes for other types of gameplay
@interface GameScene ()

@property (nonatomic, assign) NSUInteger currentCorrect;
@property (nonatomic, assign) NSUInteger currentLevel;
@property (nonatomic, assign) WTTime correctTime;

@property (nonatomic, assign) NSUInteger playerScoreValue;
@property (nonatomic, strong) SKLabelNode* playerScoreLabel;

@property (nonatomic, strong) SKSpriteNode* timer;

@property (nonatomic, assign) int difficulty;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    /* Setup your scene here */
    self.playerScoreLabel = (SKLabelNode*)[self childNodeWithName:@"PlayerScore"];
    self.playerScoreLabel.alpha = 0.1f;
    
    self.timer = (SKSpriteNode*)[self childNodeWithName:@"Timer"];

    [self loadNextTick];
    
    [self setPlayerScoreValue:0];
    
    [self resetTimerAndStartCountdown:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];

        NSArray<SKNode*>* nodesAtPoint = [self nodesAtPoint:location];
        for (SKNode* node in nodesAtPoint) {
            //TODO - move the touch handling to the WTClock Class and report to game class if it's a tap
            if ([node isKindOfClass:WTClock.class]) {
                //check for correct clock
                if (WTTimeEqualsTime(((WTClock*)node).finalTime,self.correctTime) ) {
                    //dismiss and run next iteration
                    //TODO - Rewrite this
                    //                    [self removeChildrenInArray:[self objectForKeyedSubscript:@"DefaultClock"]];
                    [self removeAllChildren];
                    [self addChild:self.playerScoreLabel];
                    [self addChild:self.timer];
                    ////
                    
                    
                    [self loadNextTick];
                    [self incrementPlayerScore];
                    [self resetTimerAndStartCountdown:YES];
                }
                else {
                    [self failGame];
                }
                break;
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

#pragma mark - GameStates

-(void)failGame {
    GameOver* gamOverScene = [GameOver unarchiveFromFile:@"GameOver"];
    [self.view presentScene:gamOverScene transition:[SKTransition crossFadeWithDuration:0.3]];
}

#pragma mark - Tick Load
-(void)loadNextTick {
    
    if (self.playerScoreValue > 0 && self.playerScoreValue % kClockSpawnPatternCount == 0) {
        self.difficulty = MIN(self.difficulty + 1, kClockSpawnPatternCount-1);
    }
    
    SKScene* clockPattern = [SKScene unarchiveFromFile:[NSString stringWithFormat:@"BasicClockPattern_%i",self.difficulty]];
    WTClock* clockNode = (WTClock*)[SKScene unarchiveFromFile:@"DefaultClock"].children[0];
    NSArray<SKNode*>* arrClockStartTargetNodes = [clockPattern objectForKeyedSubscript:@"clockTargetNode"];
    NSArray<SKNode*>* arrClockStartNodes = [clockPattern objectForKeyedSubscript:@"clockPlaceholderNode"];
    
    WTClock* newClockNode;
    int correctClockIndex = arc4random() % arrClockStartNodes.count;
    for (int i = 0; i < arrClockStartNodes.count && i < arrClockStartTargetNodes.count; ++i) {
        newClockNode = [clockNode copy];
        newClockNode.position = arrClockStartNodes[i].position;
        WTClock* blockNode = newClockNode;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [blockNode runAction:[SKAction moveTo:arrClockStartTargetNodes[i].position duration:0.5] completion:^{
                WTTime toTime;
                if (i == correctClockIndex) {
                    self.correctTime = toTime = WTTimeCurrentWithBufferTime(kSpinDuration);
                }
                else {
                    toTime = WTTimeMake(arc4random()%12,arc4random()%60);
                }
                [blockNode windClockToTime:toTime withContinuousSpinDuration:kSpinDuration andToFinalTimeDuration:0.4];
            }];
        });
        [self addChild:newClockNode];
    }
}

#pragma mark - PlayerScore
-(void)setPlayerScoreValue:(NSUInteger)score {
    _playerScoreValue = score;
    [self.playerScoreLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)score]];
}
-(void)incrementPlayerScore {
    self.playerScoreValue++;
    [self.playerScoreLabel setText:[NSString stringWithFormat:@"%lu",(unsigned long)self.playerScoreValue]];
}

#pragma mark - 
-(void)resetTimerAndStartCountdown:(BOOL)bStartCountdown {
    [self.timer removeAllActions];
    self.timer.xScale = 1.0f;
    NSUInteger preCountDownScore = self.playerScoreValue;
    [self.timer runAction:[SKAction scaleXTo:0 duration:kSpinDuration + 2.5f] completion:^{
        if (preCountDownScore == self.playerScoreValue) {
            [self failGame];
        }
    }];
}


@end
