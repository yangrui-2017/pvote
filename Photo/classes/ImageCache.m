//
//  ImageDownload.m
//  Photo
//
//  Created by wangshuai on 13-9-16.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "ImageCache.h"
#import <arcstreamsdk/STreamFile.h>
#import "ImageDataFile.h"

static NSMutableDictionary *_imageDictionary;

@implementation ImageCache



+ (ImageCache *)sharedObject{
    
    static ImageCache *sharedInstance;
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
        
         sharedInstance = [[ImageCache alloc] init];
         _imageDictionary = [[NSMutableDictionary alloc] init];
         
     });
    
    return sharedInstance;
    
}

-(void)imageDownload:(ImageDataFile *)imageFiles withObjectId:(NSString *)objectId
{
    [_imageDictionary setObject:imageFiles forKey:objectId];
}


-(ImageDataFile *)getImages:(NSString *)objectId{
    return [_imageDictionary objectForKey:objectId];
}

@end
