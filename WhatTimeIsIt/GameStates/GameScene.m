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
#define kClockSpawnPatternCount 12

#define kClockSwayDuration 2

#define DEBUG_ALWAYS_CORRECT 1

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

//Game Controls
@property (nonatomic, strong) KBSpriteButton* pauseButton;

@end

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    self.difficulty = 1;
    
    self.playerScoreLabel = (SKLabelNode*)[self childNodeWithName:@"PlayerScore"];
    self.playerScoreLabel.alpha = 0.1f;
    
    self.timer = (SKSpriteNode*)[self childNodeWithName:@"Timer"];

    [self loadNextTick];
    
    [self setPlayerScoreValue:0];
    
    [self resetTimerAndStartCountdown:YES];
    
    self.pauseButton = [KBSpriteButton buttonWithIconImage:@"pause" backgroundColor:UIColorFromRGB(0x7E8B8E) shape:[SKShapeNode shapeNodeWithCircleOfRadius:30]];
    SKNode* pauseButtonNode = [self childNodeWithName:@"BTN_Pause"];
    [pauseButtonNode addChild:self.pauseButton];
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
                if (DEBUG_ALWAYS_CORRECT || WTTimeEqualsTime(((WTClock*)node).finalTime,self.correctTime) ) {
                    //dismiss and run next iteration
                    [self loadNextTick];
                    [self incrementPlayerScore];
                    [self resetTimerAndStartCountdown:YES];
                }
                else {
                    [self failGame];
                }
                break;
            }
            else {
                [node touchesBegan:touches withEvent:event];
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
    //remove all the previous clocks
    [self removeChildrenInArray:[self objectForKeyedSubscript:@"/*Clock"]];
    
    if (self.playerScoreValue > 0 && self.playerScoreValue % kClockSpawnPatternCount == 0) {
        self.difficulty++;
    }
    
    SKScene* clockPattern = [SKScene unarchiveFromFile:[self sceneFilePrefixForCurrentDifficulty:self.difficulty andPlayerScore:self.playerScoreValue]];
    WTClock* clockNode = (WTClock*)[SKScene unarchiveFromFile:@"SimpleMasked"].children[0];
    NSArray<SKNode*>* arrClockTargetNodes = [clockPattern objectForKeyedSubscript:@"clockTargetNode"];
    NSArray<SKNode*>* arrClockStartNodes = [clockPattern objectForKeyedSubscript:@"clockPlaceholderNode"];
    
    WTClock* newClockNode;
    int correctClockIndex = arc4random() % arrClockStartNodes.count;
    BOOL flipXPos = NO;//arc4random() % 2;
    SKNode* startNode,* targetNode;
    NSArray<SKNode*>* arrSpringFields;
    
    for (int i = 0; i < arrClockStartNodes.count && i < arrClockTargetNodes.count; ++i) {
        newClockNode = [clockNode copy];
        startNode = arrClockStartNodes[i];
        targetNode = arrClockTargetNodes[i];
        arrSpringFields = [targetNode objectForKeyedSubscript:@"clockSpringField"];
        
        //set start position
        newClockNode.position = CGPointMake((flipXPos?-1.0f:1.0f) * startNode.position.x, startNode.position.y);
        
        WTClock* blockNode = newClockNode;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [blockNode runAction:[SKAction moveTo:targetNode.position duration:0.5] completion:^{
                
                //if difficulty is high enough, add a endless repeating sway to some clocks
                if (self.difficulty >= 2 && arrSpringFields.count) {
                    uint32_t fieldMask = (uint32_t)1 << i;
                    
                    SKFieldNode* spring = [arrSpringFields[0] copy];
                    spring.region = [[SKRegion alloc] initWithRadius:400];
                    spring.position = targetNode.position;
                    spring.enabled = true;
                    spring.strength = 0.5f;
                    spring.categoryBitMask = fieldMask;
//                    [spring addChild:[SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(10, 10)]];
                    [self addChild:spring];
                    
                    //setup clock physics
                    newClockNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:newClockNode.calculateAccumulatedFrame.size.width/2.0f];
                    newClockNode.physicsBody.dynamic = true;
                    newClockNode.physicsBody.affectedByGravity = false;
                    newClockNode.physicsBody.allowsRotation = false;
                    newClockNode.physicsBody.mass = 0.3f;
                    newClockNode.physicsBody.fieldBitMask = fieldMask;
                    [newClockNode.physicsBody applyImpulse:CGVectorMake(90.0f * (targetNode.position.x < startNode.position.x ? -1.0f : 1.0f), 0)];
                }
                
                //wind the clock to either the correct time or a random time
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

#pragma TODO - move this logic to a LevelBehaviorFactory
-(NSString*)sceneFilePrefixForCurrentDifficulty:(NSUInteger)difficulty andPlayerScore:(NSUInteger)playerScore {
    NSString* sceneFileName = @"BasicClockPattern_0";
    switch (difficulty) {
        //basic layout
        case 1:
        case 2:
        case 3: {
            NSUInteger nextPatternIndex = MIN(kClockSpawnPatternCount,1 + playerScore/3);
            sceneFileName = [NSString stringWithFormat:@"BasicClockPattern_%lu",nextPatternIndex];
        }
            break;
        //movement layout
        case 4:
        case 5:
        case 6: {
            
        }
            break;
        default:
            break;
    }
    return sceneFileName;
}

-(NSArray<WTClock*>*)clockTypesForDifficulty:(NSUInteger)difficulty andPlayerScore:(NSUInteger)playerScore {
    NSMutableArray* arrClockTypes = [NSMutableArray arrayWithCapacity:kClockSpawnPatternCount];
    switch (difficulty) {
        case 1:
        case 2:
        case 3:{
            [arrClockTypes addObject:[SKScene unarchiveFromFile:@"DefaultClock"].children[0]];
        }
            break;
        default:
            break;
    }
    return arrClockTypes;
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
    return;
    if (bStartCountdown) {
        NSUInteger preCountDownScore = self.playerScoreValue;
        [self.timer runAction:[SKAction scaleXTo:0 duration:kSpinDuration + 2.5f] completion:^{
            if (preCountDownScore == self.playerScoreValue) {
                [self failGame];
            }
        }];
    }
}


@end
