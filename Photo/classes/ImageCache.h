//
//  ImageDownload.h
//  Photo
//
//  Created by wangshuai on 13-9-16.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageDataFile.h"

@interface ImageCache : NSObject
{
    
}
@property (retain,nonatomic) NSMutableDictionary *imageDictionary;

-(void)imageDownload:(ImageDataFile *)imageFiles withObjectId:(NSString *)objectId;

-(ImageDataFile *)getImages:(NSString *)objectId;

@end
