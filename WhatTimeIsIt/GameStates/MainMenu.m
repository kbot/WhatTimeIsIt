//
//  MainMenu.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/19/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"
#import "WTTutorialScene.h"
#import "WTClock.h"
#import "WTTime.h"

@interface MainMenu ()
//@property (nonatomic,assign) SKNode*
@property (nonatomic,assign) WTClock* backgroundClockNode;
@end

@implementation MainMenu

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */

    self.backgroundClockNode = (WTClock*)[self childNodeWithName:@"WTClockRef"].children[0].children[0];
    self.backgroundClockNode.keepsRealTime = YES;
    [self.backgroundClockNode windClockToTime:WTTimeCurrentWithBufferTime(0) withContinuousSpinDuration:0 andToFinalTimeDuration:0];
    
    SKAudioNode* node = [[SKAudioNode alloc] initWithFileNamed:@"elevator.wav"];
    node.autoplayLooped = YES;
    [self addChild:node];
    
//    [self loadSceneMusicWithBundleFile:@"elevator.wav"];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self enumerateChildNodesWithName:@"Title_BG" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
//            SKSpriteNode* spritNode = (SKSpriteNode*)node;
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(rand()%4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [spritNode runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction resizeToWidth:320 duration:1.4f],[SKAction resizeToWidth:spritNode.size.width duration:1.4f]]]]];
//                });
//        }];
//    });
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKNode* nodeAtPoint = [self nodeAtPoint:location];
        if ([nodeAtPoint.name hasPrefix:@"BTN_"]) {
            if ([nodeAtPoint.name isEqualToString:@"BTN_PlayGame"]) {
//                SKAudioNode
//                [[[AVAudioPlayer alloc] initWithContentsOfURL:[KBGeneralUtils filePathURLForBundleResource:@"pup3.wav"] fileTypeHint:AVFileTypeWAVE error:nil] play];
            }
        }
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKNode* nodeAtPoint = [self nodeAtPoint:location];
        if ([nodeAtPoint.name hasPrefix:@"BTN_"]) {
            if ([nodeAtPoint.name isEqualToString:@"BTN_PlayGame"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@(1) forKey:@"isFirstTimePlayer"];
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstTimePlayer"] boolValue]) {
                    WTTutorialScene *scene = [WTTutorialScene unarchiveFromFile:@"GameScene"];
                    [self.scene.view presentScene:scene transition:[SKTransition moveInWithDirection:SKTransitionDirectionRight duration:0.3]];
                }
                else {
                    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
                    [self.scene.view presentScene:scene transition:[SKTransition moveInWithDirection:SKTransitionDirectionRight duration:0.3]];
                }
            }
        }
    }
}

@end
