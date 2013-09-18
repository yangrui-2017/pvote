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
static NSMutableDictionary *_selfImageDictionary;
static NSMutableDictionary *_userMetaData;

@implementation ImageCache



+ (ImageCache *)sharedObject{
    
    static ImageCache *sharedInstance;
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
        
         sharedInstance = [[ImageCache alloc] init];
         _imageDictionary = [[NSMutableDictionary alloc] init];
         _selfImageDictionary = [[NSMutableDictionary alloc] init];
         _userMetaData = [[NSMutableDictionary alloc] init];
         
     });
    
    return sharedInstance;
    
}

-(NSMutableDictionary *)getUserMetadata:(NSString *)userName{
    return [_userMetaData objectForKey:userName];
}

-(void)saveUserMetadata:(NSString *)userName withMetadata:(NSMutableDictionary *)metaData{
    [_userMetaData setObject:metaData forKey:userName];
}

-(void)imageDownload:(ImageDataFile *)imageFiles withObjectId:(NSString *)objectId
{
    [_imageDictionary setObject:imageFiles forKey:objectId];
}

-(void)selfImageDownload:(NSData *)file withFileId:(NSString *)fileId{
    [_selfImageDictionary setObject:file forKey:fileId];
}

-(NSData *)getImage:(NSString *)fileId{
    return [_selfImageDictionary objectForKey:fileId];
}

-(ImageDataFile *)getImages:(NSString *)objectId{
    return [_imageDictionary objectForKey:objectId];
}

@end
