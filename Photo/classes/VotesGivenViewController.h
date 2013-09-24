//
//  VotesGivenViewController.h
//  Photo
//
//  Created by wangsh on 13-9-24.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import <arcstreamsdk/STreamObject.h>
@interface VotesGivenViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, MainViewTableViewRfresh>
{
    
}

@property (retain,nonatomic) UITableView *myTableView ;
@property (retain,nonatomic) NSMutableArray *ImageArray;
@property (strong ,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UITextField *name;
@property (strong,nonatomic) UILabel *message;
@property (strong,nonatomic) UILabel *vote1Lable;
@property (strong,nonatomic) UILabel *vote2Lable;
@property (strong,nonatomic) UIButton *oneImageView;
@property (strong,nonatomic) UIButton *twoImageView;
@property (strong,nonatomic) UIButton *clickButton;
@property (retain,nonatomic) NSMutableArray *votesGivenArray;
@end
