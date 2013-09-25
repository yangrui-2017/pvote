//
//  InformationViewController.h
//  Photo
//
//  Created by wangshuai on 13-9-17.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (strong,nonatomic) UITableView *myTableView;
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *nameLablel;
@property (strong,nonatomic) UILabel *lable;
@property (strong,nonatomic) UILabel *countLable;
@property (copy,nonatomic) NSString *userName;
@property (assign) BOOL isPush;
@property (strong,nonatomic) UIButton * followerButton;
@end
