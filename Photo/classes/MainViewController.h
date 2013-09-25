//
//  MainViewController.h
//  Photo
//
//  Created by wangshuai on 13-9-12.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewTableViewRfresh.h"

@interface MainViewController : UIViewController <UITableViewDelegate,UITableViewDataSource, MainViewTableViewRfresh>
{
   
}

@property (retain,nonatomic) UITableView *myTableView ;
@property (retain,nonatomic) NSMutableArray *ImageArray;
@property (strong ,nonatomic) UIButton *imageView;
@property (strong,nonatomic) UITextField *name;
@property (strong,nonatomic) UILabel *message;
@property (strong,nonatomic) UILabel *vote1Lable;
@property (strong,nonatomic) UILabel *vote2Lable;
@property (strong,nonatomic) UIButton *oneImageView;
@property (strong,nonatomic) UIButton *twoImageView;
@property (strong,nonatomic) UIButton *clickButton;
@property (assign)BOOL isPush;
@property (strong,nonatomic) NSString * userName;
@end
