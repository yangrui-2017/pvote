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
@property (strong,nonatomic) UIImageView *oneImageView;
@property (strong,nonatomic) UIImageView *twoImageView;
@property (strong,nonatomic) UIButton *leftButton;
@property (strong,nonatomic) UIButton *rightButton;
@property (strong,nonatomic) STreamObject *rowObject;
@property (strong,nonatomic) UIButton *commentButton;

@end
