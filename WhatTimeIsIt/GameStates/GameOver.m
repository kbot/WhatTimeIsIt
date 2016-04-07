//
//  GameOver.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/19/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"
#import "MainMenu.h"

@implementation GameOver

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self loadSceneMusicWithBundleFile:@"funky.wav" autoPlay:YES numLoops:0];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        NSArray<SKNode*>* nodesAtPoint = [self nodesAtPoint:location];
        for (SKNode* node in nodesAtPoint) {
            if ([node.name hasPrefix:@"BTN_"]) {
                if ([node.name isEqualToString:@"BTN_Retry"]) {
                    GameScene* gameScene = [GameScene unarchiveFromFile:@"GameScene"];
                    [self.scene.view presentScene:gameScene transition:[SKTransition crossFadeWithDuration:0.3]];
                }
                else if ([node.name isEqualToString:@"BTN_Quit"]) {
                    MainMenu* mainMenuScene = [MainMenu unarchiveFromFile:@"MainMenu"];
                    [self.scene.view presentScene:mainMenuScene transition:[SKTransition moveInWithDirection:SKTransitionDirectionLeft duration:0.3]];
                }
                break;
            }
        }
    }
}
@end
