//
//  ImageDownload.h
//  Photo
//
//  Created by wang shuai on 16/09/2013.
//  Copyright (c) 2013 wangshuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewTableViewRfresh.h"

@interface ImageDownload : NSObject

@property (nonatomic, weak) id<MainViewTableViewRfresh> mainRefesh;

- (void)dowloadFile: (NSString *)file1 withFile2:(NSString *)file2 withObjectId:(NSString *)objectId;

@end
