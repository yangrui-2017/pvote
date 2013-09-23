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

static NSMutableDictionary *_imageDictionary;
static NSMutableDictionary *_selfImageDictionary;
static NSMutableDictionary *_userMetaData;
static NSMutableDictionary *_voteResults;
static NSMutableString *loginUserName;

@implementation ImageCache



+ (ImageCache *)sharedObject{
    
    static ImageCache *sharedInstance;
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
        
         sharedInstance = [[ImageCache alloc] init];
         _imageDictionary = [[NSMutableDictionary alloc] init];
         _selfImageDictionary = [[NSMutableDictionary alloc] init];
         _userMetaData = [[NSMutableDictionary alloc] init];
         _voteResults = [[NSMutableDictionary alloc] init];
         
     });
    
    return sharedInstance;
    
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

-(void)addVotesResults:(NSString *)objectId withVoteResult:(VoteResults *)results{
    [_voteResults setObject:results forKey:objectId];
}

-(VoteResults *)getResults:(NSString *)objectId{
    return [_voteResults objectForKey:objectId];
}

@end
