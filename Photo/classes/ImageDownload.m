//
//  ImageDownload.m
//  Photo
//
//  Created by wang shuai on 16/09/2013.
//  Copyright (c) 2013 wangshuai. All rights reserved.
//

#import "ImageDownload.h"
#import <arcstreamsdk/STreamFile.h>
#import <arcstreamsdk/STreamCategoryObject.h>
#import <arcstreamsdk/STreamObject.h>
#import <arcstreamsdk/STreamQuery.h>
#import "ImageCache.h"

@implementation ImageDownload

@synthesize mainRefesh;

- (void)dowloadFile:(NSString *)file1 withFile2:(NSString *)file2 withObjectId:(NSString *)objectId{
    
    ImageCache *imageCache = [ImageCache sharedObject];
    STreamFile *file1file = [[STreamFile alloc] init];
    [file1file downloadAsData:file1 downloadedData:^(NSData *imageData1){
        STreamFile *file2file = [[STreamFile alloc] init];
        [file2file downloadAsData:file2 downloadedData:^(NSData *imageData2){
            ImageDataFile *dataFile = [[ImageDataFile alloc] init];
            [dataFile setFile1:imageData1];
            [dataFile setFile2:imageData2];
            [imageCache imageDownload:dataFile withObjectId:objectId];
            [mainRefesh reloadTable];
        }];
    }];
    
}

@end
