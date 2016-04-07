//
//  KBGeneralUtils.h
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 4/1/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KBGeneralUtils : NSObject

#pragma mark - FilePath Utils
+(NSString*)filePathForDocument:(NSString*)filename;
+(NSURL*)filePathURLForDocument:(NSString*)filename;
+(NSString*)filePathForBundleResource:(NSString*)filename;
+(NSURL*)filePathURLForBundleResource:(NSString*)filename;
+(void)fileRemoveFromPath:(NSString *)fileName;
@end
