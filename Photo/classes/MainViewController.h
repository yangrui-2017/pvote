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
@property (retain,nonatomic) NSMutableArray *myDataArray;
@property (strong ,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UITextField *name;
@property (strong,nonatomic) UITextField *message;
@property (strong,nonatomic) UIImageView *oneImageView;
@property (strong,nonatomic) UIImageView *twoImageView;

@end
