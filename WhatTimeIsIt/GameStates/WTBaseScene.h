//
//  WTBaseScene.h
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 4/1/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SKScene+Unarchive.h"
#import "KBGeneralUtils.h"

@interface WTBaseScene : SKScene
@property (nonatomic,readonly) AVAudioPlayer* sceneMusicPlayer;

#pragma mark - Simple Scene Music
-(NSError*)loadSceneMusicWithBundleFile:(NSString*)filename;
-(NSError*)loadSceneMusicWithBundleFile:(NSString*)filename autoPlay:(BOOL)autoPlay numLoops:(NSInteger)numLoops;

@end
