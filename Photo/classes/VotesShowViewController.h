//
//  VotesShowViewController.h
//  Photo
//
//  Created by wangsh on 13-9-22.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <arcstreamsdk/STreamObject.h>

@interface VotesShowViewController : UITableViewController
{
    
}
@property (strong,nonatomic) UILabel *countLable;
@property (strong,nonatomic) UILabel *vote1Lable;
@property (strong,nonatomic) UILabel *vote2Lable;
@property (strong,nonatomic) UILabel *leftLable;
@property (strong,nonatomic) UILabel *rightLable;
@property (strong,nonatomic) UIImageView *oneImageView;
@property (strong,nonatomic) UIImageView *twoImageView;
@property (strong,nonatomic) UILabel *votes1;
@property (strong,nonatomic) UILabel *votes2;
@property (strong,nonatomic) STreamObject *rowObject;


@end
