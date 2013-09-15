//
//  MainViewController.m
//  Photo
//
//  Created by wangshuai on 13-9-12.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "MainViewController.h"
#import <arcstreamsdk/STreamFile.h>
#import <arcstreamsdk/STreamCategoryObject.h>
#import <arcstreamsdk/STreamObject.h>
#import <arcstreamsdk/STreamQuery.h>
#import "MBProgressHUD.h"


@interface MainViewController (){
    STreamCategoryObject *votes;
    NSMutableArray *votesArray;
}

@end

@implementation MainViewController
@synthesize myTableView = _myTableView;
@synthesize myDataArray = _myDataArray;
@synthesize name = _name;
@synthesize message = _message;
@synthesize oneImageView =_oneImageView;
@synthesize twoImageView =_twoImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//init

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"MainPage";
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.view addSubview:self.myTableView];
    self.myDataArray = [[NSMutableArray alloc]init];
    votes = [[STreamCategoryObject alloc] initWithCategory:@"test1"];
  
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        [votes load];
        votesArray = [votes streamObjects];
    
     } completionBlock:^{
        
    
     }];

    
    
      
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 80)];
        [self.imageView setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:self.imageView];
        
        self.name = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, 200, 30)];
        self.name.borderStyle = UITextBorderStyleLine;
        self.name.enabled = NO;
        [cell addSubview:self.name];
        
        self.message = [[UITextField alloc]initWithFrame:CGRectMake(90, 40, 200, 40)];
        self.message.borderStyle = UITextBorderStyleLine;
        self.message.enabled = NO;
        [cell addSubview:self.message];
        
        self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 100, 150, 150)];
        [self.oneImageView setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:self.oneImageView];
        
        self.twoImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(165, 100, 150, 150)];
        [self.twoImageView setBackgroundColor:[UIColor grayColor]];
        [cell addSubview:self.twoImageView];
    }
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
