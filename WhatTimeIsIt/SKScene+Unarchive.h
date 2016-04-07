//
//  SKScene+Unarchive.h
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/16/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file;

@end
