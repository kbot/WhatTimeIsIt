//
//  KBGeneralUtils.m
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 4/1/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#import "KBGeneralUtils.h"

@implementation KBGeneralUtils

#pragma mark - FilePath Utils
+(NSString*)filePathForDocument:(NSString*)filename {
    return [KBGeneralUtils filePathURLForDocument:filename].absoluteString;
}
+(NSURL*)filePathURLForDocument:(NSString*)filename {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:filename];
    NSURL *fileURL = [NSURL fileURLWithPath:fullPath];
    return fileURL;
}
+(NSString*)filePathForBundleResource:(NSString*)filename {
    if ([filename stringByDeletingPathExtension].length == 0 || [filename pathExtension].length == 0) {
        return nil;
    }
    return [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
}
+(NSURL*)filePathURLForBundleResource:(NSString*)filename {
    return [NSURL fileURLWithPath:[KBGeneralUtils filePathForBundleResource:filename]];
}

+ (void)fileRemoveFromPath:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [KBGeneralUtils filePathURLForDocument:fileName].absoluteString;
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"Remove %@ successful.", fileName);
    }
    else {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

@end
