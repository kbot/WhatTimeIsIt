//
//  GameScene.h
//  WhatTimeIsIt
//

//  Copyright (c) 2016 Kevin Bloom. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "WTBaseScene.h"
#import "WTClock.h"
#import "KBSpriteButton.h"

@interface GameScene : WTBaseScene

@property (nonatomic, readonly, assign) NSUInteger currentCorrect;
@property (nonatomic, readonly, assign) NSUInteger currentLevel;
@property (nonatomic, readonly, assign) WTTime correctTime;

@property (nonatomic, readonly, assign) NSUInteger playerScoreValue;
@property (nonatomic, readonly, strong) SKLabelNode* playerScoreLabel;

@property (nonatomic, readonly, strong) SKSpriteNode* timer;

@property (nonatomic, readonly, assign) int difficulty;

@property (nonatomic, assign) BOOL pauseButtonVisible;

@property (nonatomic, strong, readonly) KBSpriteButton* pauseButton;

#pragma mark - GameStates
-(void)failGame;

#pragma mark - Tick Load
-(void)loadNextTick;

#pragma mark - PlayerScore
-(void)setPlayerScoreValue:(NSUInteger)score;
-(void)incrementPlayerScore;

#pragma mark -
-(void)resetTimerAndStartCountdown:(BOOL)bStartCountdown;

@end
