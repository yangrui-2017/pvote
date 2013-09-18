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
@synthesize data1;
@synthesize data2;

- (void)downloadFile:(NSString *)fileId{
    
    NSLog(@"CALL DOWNLOADING SINGLE DATA");
    
    ImageCache *imageCache = [ImageCache sharedObject];
    STreamFile *file = [[STreamFile alloc] init];
    [file downloadAsData:fileId downloadedData:^(NSData *imageData, NSString *oId) {
        [imageCache selfImageDownload:imageData withFileId:fileId];
    }];
}

- (void)dowloadFile:(NSString *)file1 withFile2:(NSString *)file2 withObjectId:(NSString *)objectId{
    
    NSLog(@"CALL DOWNLOADING DATA");
    
    ImageCache *imageCache = [ImageCache sharedObject];
    STreamFile *file1file = [[STreamFile alloc] init];
    [file1file downloadAsData:file1 downloadedData:^(NSData *imageData, NSString *oId){
        NSLog(@"");
    }];
    
    STreamFile *file2file = [[STreamFile alloc] init];
    [file2file downloadAsData:file2 downloadedData:^(NSData *imageData, NSString *oId){
        if ([file1 isEqualToString:oId])
            data1 = imageData;
        if ([file2 isEqualToString:oId])
            data2 = imageData;
        
        if (data1 != nil && data2 != nil){
            ImageDataFile *dataFile = [[ImageDataFile alloc] init];
            [dataFile setFile1:data1];
            [dataFile setFile2:data2];
            [imageCache imageDownload:dataFile withObjectId:objectId];
            [mainRefesh reloadTable];
        }
        
       
    }];
    
}

@end
