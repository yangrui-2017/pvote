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
#import "VoteResults.h"
#import "FileCache.h"

static NSMutableDictionary *_imageDictionary;
static NSMutableDictionary *_selfImageDictionary;
static NSMutableDictionary *_userMetaData;
static NSMutableDictionary *_voteResults;
static NSMutableString *loginUserName;
static NSString *password;
static FileCache *fileCache;
static NSMutableArray *_cachedSelfImageFiles;
static NSMutableArray *_cachedFiles;
static NSMutableSet *_uploadingItems;

@implementation ImageCache


+ (ImageCache *)sharedObject{
    
    static ImageCache *sharedInstance;
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
        
         sharedInstance = [[ImageCache alloc] init];
         fileCache = [FileCache sharedObject];
         _cachedSelfImageFiles = [[NSMutableArray alloc] init];
         _cachedFiles = [[NSMutableArray alloc] init];
         _imageDictionary = [[NSMutableDictionary alloc] init];
         _selfImageDictionary = [[NSMutableDictionary alloc] init];
         _userMetaData = [[NSMutableDictionary alloc] init];
         _voteResults = [[NSMutableDictionary alloc] init];
         _uploadingItems = [[NSMutableSet alloc] init];
         
     });
    
    return sharedInstance;
    
}

- (void)addUploadingItems:(NSString *)fileId{
    [_uploadingItems addObject:fileId];
}

- (void)removeUploadingItem:(NSString *)fileId{
    [_uploadingItems removeObject:fileId];
}

- (BOOL)isUploading:(NSString *)fileId{
    if ([_uploadingItems containsObject:fileId])
        return YES;
    return NO;
}

-(void)setLoginPassword:(NSString *)p{
    password = p;
}

-(NSString *)getLoginPassword{
    return password;
}

-(void)setLoginUserName:(NSString *)userName{
    loginUserName = [[NSMutableString alloc] init];
    [loginUserName appendString:userName];
}

-(NSMutableString *)getLoginUserName{
    return loginUserName;
}

-(NSMutableDictionary *)getUserMetadata:(NSString *)userName{
    return [_userMetaData objectForKey:userName];
}

-(void)saveUserMetadata:(NSString *)userName withMetadata:(NSMutableDictionary *)metaData{
    [_userMetaData setObject:metaData forKey:userName];
}

-(void)imageDownload:(ImageDataFile *)imageFiles withObjectId:(NSString *)objectId
{
    if ([_cachedFiles count] >= 40){
        NSString *oId = [_cachedFiles objectAtIndex:0];
        [_imageDictionary removeObjectForKey:oId];
        [_cachedFiles removeObjectAtIndex:0];
    }
    
    [_cachedFiles addObject:objectId];
    [_imageDictionary setObject:imageFiles forKey:objectId];
    
}

-(ImageDataFile *)getImages:(NSString *)objectId{
    ImageDataFile *dataFile = [_imageDictionary objectForKey:objectId];
    if (dataFile){
    }
    return dataFile;
}

-(void)selfImageDownload:(NSData *)file withFileId:(NSString *)fileId{
    if ([_cachedSelfImageFiles count] >= 50){
        NSString *fId = [_cachedSelfImageFiles objectAtIndex:0];
        [_selfImageDictionary removeObjectForKey:fId];
        [_cachedSelfImageFiles removeObjectAtIndex:0];
        
    }
    [_cachedSelfImageFiles addObject:fileId];
    [_selfImageDictionary setObject:file forKey:fileId];
}

-(NSData *)getImage:(NSString *)fileId{
    NSData *data =  [_selfImageDictionary objectForKey:fileId];
    if (data){
    //    NSLog(@"read self image file from memory %d", [data length]);
    }
    else{
        data = [fileCache readFromFile:fileId];
        if (data)
            [_selfImageDictionary setObject:data forKey:fileId];
     //   if (data)
   //         NSLog(@"read self image file from file %d", [data length]);
    }
    
    return data;
}

-(void)addVotesResults:(NSString *)objectId withVoteResult:(VoteResults *)results{
    [_voteResults setObject:results forKey:objectId];
}

-(VoteResults *)getResults:(NSString *)objectId{
    return [_voteResults objectForKey:objectId];
}

@end
