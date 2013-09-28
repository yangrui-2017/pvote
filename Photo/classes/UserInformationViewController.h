//
//  UserInformationViewController.h
//  Photo
//
//  Created by wangshuai on 13-9-17.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *myTableView;
@property (strong,nonatomic) UIImageView *headImage;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *votesLabel;
@property (strong,nonatomic) UIButton *followButton;

@end
