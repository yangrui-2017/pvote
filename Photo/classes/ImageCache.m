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

@implementation ImageCache
@synthesize imageDictionary = _imageDictionary;


-(void)imageDownload:(ImageDataFile *)imageFiles withObjectId:(NSString *)objectId
{
    if (_imageDictionary == nil){
        _imageDictionary = [[NSMutableDictionary alloc] init];
    }
    [_imageDictionary setObject:imageFiles forKey:objectId];
}


-(ImageDataFile *)getImages:(NSString *)objectId{
    return [_imageDictionary objectForKey:objectId];
}

@end
