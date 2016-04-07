//
//  SKScene+Unarchive.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/16/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import "SKScene+Unarchive.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    
    [arch finishDecoding];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    return scene;
}

@end
