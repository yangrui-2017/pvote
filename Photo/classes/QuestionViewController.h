//
//  QuestionViewController.h
//  Photo
//
//  Created by wangsh on 13-10-9.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *mTableView;
@property (strong,nonatomic) NSArray *dataArray;
@end
