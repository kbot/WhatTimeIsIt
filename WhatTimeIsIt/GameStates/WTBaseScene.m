//
//  WTBaseScene.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 4/1/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import "WTBaseScene.h"

@interface WTBaseScene ()
@property (nonatomic,strong) AVAudioPlayer* sceneMusicPlayer;
@end

@implementation WTBaseScene

-(NSError*)loadSceneMusicWithBundleFile:(NSString*)filename {
    return [self loadSceneMusicWithBundleFile:filename autoPlay:YES numLoops:-1];
}
-(NSError*)loadSceneMusicWithBundleFile:(NSString*)filename autoPlay:(BOOL)autoPlay numLoops:(NSInteger)numLoops {
    if (filename.length <= 0 || filename.pathExtension.length <= 0) {
        return [NSError errorWithDomain:@"WTBaseScene.scene.music" code:-1 userInfo:@{@"msg":@"Filename Invalid"}];
    }
    //load music
    NSError* error;
    self.sceneMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[KBGeneralUtils filePathURLForBundleResource:filename] fileTypeHint:AVFileTypeWAVE error:&error];
    if (error) {
        NSLog(@"error = %@",error);
        return error;
    }
    else {
        self.sceneMusicPlayer.numberOfLoops = numLoops;
        if (autoPlay) {
            [self.sceneMusicPlayer play];
        }
    }
    
    return nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSArray<SKNode*>* nodesAtPoint = [self nodesAtPoint:location];
        for (SKNode* node in nodesAtPoint) {
            if (node.isUserInteractionEnabled) {
                [node touchesBegan:touches withEvent:event];
            }
        }
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSArray<SKNode*>* nodesAtPoint = [self nodesAtPoint:location];
        for (SKNode* node in nodesAtPoint) {
            if (node.isUserInteractionEnabled) {
                [node touchesEnded:touches withEvent:event];
            }
        }
    }
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        NSArray<SKNode*>* nodesAtPoint = [self nodesAtPoint:location];
        for (SKNode* node in nodesAtPoint) {
            if (node.isUserInteractionEnabled) {
                [node touchesCancelled:touches withEvent:event];
            }
        }
    }
}

@end
