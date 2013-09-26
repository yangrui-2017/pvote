//
//  CommentsViewController.m
//  Photo
//
//  Created by wangsh on 13-9-26.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "CommentsViewController.h"
#import <arcstreamsdk/STreamQuery.h>
#import <arcstreamsdk/STreamObject.h>
#import "ImageCache.h"
#import "MBProgressHUD.h"
@interface CommentsViewController ()
{
    NSString *leftImageId;
    NSString *rightImageId;
}
@end

@implementation CommentsViewController
@synthesize oneImageView;
@synthesize twoImageView;
@synthesize rowObject;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
  self.navigationController.tabBarController.tabBar.hidden = YES;    
    leftImageId = [rowObject getValue:@"file1"];
    rightImageId = [rowObject getValue:@"file2"];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    myTableView.separatorStyle=YES;//UITableView每个cell之间的默认分割线隐藏掉sel
    [self.view addSubview:myTableView];

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(loadComments) onTarget:self withObject:nil animated:YES];
    
}
- (void)loadComments{
    
      [myTableView reloadData];
    
}

//创建cell上控件
-(void)createUIControls:(UITableViewCell *)cell withCellRowAtIndextPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 150, 150)];
        [self.oneImageView setImage:[UIImage imageNamed:@"Placeholder.png"] ];
        [cell addSubview:self.oneImageView];
        
        self.twoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(165, 30, 150, 150)];
        [self.twoImageView setImage:[UIImage imageNamed:@"Placeholder.png"] ];
        [cell addSubview:self.twoImageView];
        
    }else{
       
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self createUIControls:cell withCellRowAtIndextPath:indexPath];
    }
    ImageCache *cache = [ImageCache sharedObject];
    ImageDataFile *dataFile = [cache getImages:[rowObject objectId]];
    self.oneImageView.image = [UIImage imageWithData:[dataFile file1]];
    self.twoImageView.image = [UIImage imageWithData:[dataFile file2]];
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 200;
    }else{
        return 50;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
