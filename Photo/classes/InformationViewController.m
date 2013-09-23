//
//  InformationViewController.m
//  Photo
//
//  Created by wangshuai on 13-9-17.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "InformationViewController.h"
#import "ImageCache.h"
#import <arcstreamsdk/STreamQuery.h>
#import <arcstreamsdk/STreamObject.h>
@interface InformationViewController ()
{
    ImageCache *cache;
    STreamQuery *sq;
    NSMutableArray *arrayCount;
    STreamObject *so;
}
@end

@implementation InformationViewController

@synthesize myTableView;
@synthesize nameLablel;
@synthesize lable;
@synthesize countLable;
@synthesize imageView;

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
	// Do any additional setup after loading the view.
    cache = [ImageCache sharedObject];
    sq = [[STreamQuery alloc] initWithCategory:@"voted"];
    [sq addLimitId:[cache getLoginUserName]];
    arrayCount = [sq find];
    if (arrayCount!= nil && [arrayCount count] == 1)
        so = [arrayCount objectAtIndex:0];

    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        if (indexPath.row ==0) {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
            imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            [cell.contentView addSubview:imageView];
            
            nameLablel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 80, 30)];
            nameLablel.textColor = [UIColor blackColor];
            nameLablel.textAlignment = NSTextAlignmentCenter;
            nameLablel.font = [UIFont fontWithName:@"Arial" size:20];
            nameLablel.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:nameLablel];
        }else{
            lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont fontWithName:@"Arial" size:16];
            lable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:lable];
            
            countLable = [[UILabel alloc]initWithFrame:CGRectMake(240, 0, 80, 30)];
            countLable.textAlignment = NSTextAlignmentCenter;
            countLable.font = [UIFont fontWithName:@"Arial" size:16];
            countLable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:countLable];
            
        }
        
    }
    nameLablel.text = [cache getLoginUserName];
    NSMutableDictionary *userMetaData = [cache getUserMetadata:[cache getLoginUserName]];
    NSString *pImageId = [userMetaData objectForKey:@"profileImageId"];
    imageView.image = [UIImage imageWithData:[cache getImage:pImageId]];
    sq = [[STreamQuery alloc] initWithCategory:[cache getLoginUserName]];
    NSMutableArray * array = [sq find];
    
    NSArray * dataArray =[[NSArray alloc]initWithObjects:@"上传数",@"投票数", nil];
   

    if (indexPath.row ==1) {
      
        lable.text = [dataArray objectAtIndex:indexPath.row-1];
        countLable.text =[NSString stringWithFormat:@"%d",[array count]];
    }
    if (indexPath.row ==2) {
        lable.text = [dataArray objectAtIndex:indexPath.row-1];
        if ([so size]==0 || [so size]==1) {
            countLable.text = @"0";
        }else{
            countLable.text = [NSString stringWithFormat:@"%d",[so size]-1];
        }
        
    }
    
    return cell;
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }else{
        return 30;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath!=0) {
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
