//
//  KBGeneralUtils.h
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 4/1/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF000000) >> 24))/255.0 green:((float)((rgbValue & 0xFF0000) >> 16))/255.0 blue:((float)((rgbValue & 0xFF00) >> 8))/255.0 alpha:((float)(rgbValue & 0xFF))/255.0]

@interface KBGeneralUtils : NSObject

#pragma mark - Colors Utils
+(UIColor*)darkenedColorFromColor:(UIColor*)originalColor;
+(UIColor*)darkenedColorFromColor:(UIColor*)originalColor darkenMultiplier:(CGFloat)multiplier;

#pragma mark - FilePath Utils
+(NSString*)filePathForDocument:(NSString*)filename;
+(NSURL*)filePathURLForDocument:(NSString*)filename;
+(NSString*)filePathForBundleResource:(NSString*)filename;
+(NSURL*)filePathURLForBundleResource:(NSString*)filename;
+(void)fileRemoveFromPath:(NSString *)fileName;
@end
