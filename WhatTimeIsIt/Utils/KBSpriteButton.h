//
//  KBSpriteButton.h
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 4/10/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface KBSpriteButton : SKSpriteNode

+(KBSpriteButton*)buttonWithTitle:(NSString*)title backgroundColor:(UIColor*)bgColor;
+(KBSpriteButton*)buttonWithIconImage:(NSString*)filename backgroundColor:(UIColor*)bgColor shape:(SKShapeNode*)shape;
@end
