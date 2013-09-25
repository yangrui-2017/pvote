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
#import "MainViewController.h"
#import "VotesGivenViewController.h"
#import "MBProgressHUD.h"
@interface InformationViewController ()
{
    ImageCache *cache;
    STreamQuery *sq;
    NSMutableArray *arrayCount;
    STreamObject *so;
    NSMutableDictionary *userMetaData;
    int count;
    BOOL isFollowing;
    STreamObject *following;
    STreamObject *follower;
    NSArray *allFollowingKey;
    NSArray *allFollowerKey;
    NSArray *followerKey;
    NSString *pageUserName;
    NSMutableArray *array;
    NSArray *loggedInUserFollowing;
}
@end

@implementation InformationViewController

@synthesize myTableView;
@synthesize nameLablel;
@synthesize lable;
@synthesize countLable;
@synthesize imageView;
@synthesize userName;
@synthesize isPush;
@synthesize followerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated{
    [self.myTableView reloadData];
    NSLog(@"");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cache = [ImageCache sharedObject];
    if (userName != nil)
        pageUserName = userName;
    else
        pageUserName = [cache getLoginUserName];
	// Do any additional setup after loading the view.
       myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    
    
    sq = [[STreamQuery alloc] initWithCategory:@"Voted"];
    [sq addLimitId:pageUserName];
    arrayCount = [sq find];
    if (arrayCount!= nil && [arrayCount count] == 1)
        so = [arrayCount objectAtIndex:0];

    
    follower = [[STreamObject alloc]init];
    [follower loadAll:[NSString stringWithFormat:@"%@Follower", pageUserName]];
    allFollowerKey = [follower getAllKeys];
    
    following  = [[STreamObject alloc]init];
    [following loadAll:[NSString stringWithFormat:@"%@Following",pageUserName]];
    allFollowingKey = [following getAllKeys];

    sq = [[STreamQuery alloc] initWithCategory:@"AllVotes"];
    [sq whereEqualsTo:@"userName" forValue:pageUserName];
    array = [sq find];
    
    STreamObject *loggedInUserFollowingStream = [[STreamObject alloc] init];
    [loggedInUserFollowingStream loadAll:[NSString stringWithFormat:@"%@Following",[cache getLoginUserName]]];
    loggedInUserFollowing = [loggedInUserFollowingStream getAllKeys];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
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
            
            nameLablel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 80, 50)];
            nameLablel.textColor = [UIColor blackColor];
            
            nameLablel.textAlignment = NSTextAlignmentCenter;
            nameLablel.font = [UIFont fontWithName:@"Arial" size:20];
            nameLablel.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:nameLablel];
            followerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [followerButton setFrame:CGRectMake(210, 10, 120, 50)];
            [followerButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
            [followerButton addTarget:self action:@selector(followButton:) forControlEvents:UIControlEventTouchUpInside];
            if (isPush && ![userName isEqualToString:[cache getLoginUserName]]) {
                [cell.contentView addSubview:followerButton];
            }else{
            }
        }else{
            lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240, 50)];
            lable.textAlignment = NSTextAlignmentCenter;
            lable.font = [UIFont fontWithName:@"Arial" size:24];
            lable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:lable];
            
            countLable = [[UILabel alloc]initWithFrame:CGRectMake(240, 0, 80, 50)];
            countLable.textAlignment = NSTextAlignmentCenter;
            countLable.font = [UIFont fontWithName:@"Arial" size:24];
            countLable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:countLable];
        }
    }
    
    if ([loggedInUserFollowing containsObject:pageUserName]) {
        [followerButton setTitle:@"取消关注" forState:UIControlStateNormal];
    }else{
        [followerButton setTitle:@"关注" forState:UIControlStateNormal];
    }
    
    NSArray * dataArray =[[NSArray alloc]initWithObjects:@"上传数",@"投票数",@"关注数",@"粉丝数",nil];
    if (indexPath.row ==1) {
        lable.text = [dataArray objectAtIndex:indexPath.row-1];
        countLable.text =[NSString stringWithFormat:@"%d",[array count]];
        count = [countLable.text intValue];
    }
    if (indexPath.row ==2) {
        lable.text = [dataArray objectAtIndex:indexPath.row-1];
        if ([so size]==0) {
            countLable.text = @"0";
        }else{
            countLable.text = [NSString stringWithFormat:@"%d",[so size]];
        }
    }
    if (indexPath.row ==3) {
        lable.text = [dataArray objectAtIndex:indexPath.row-1];
        countLable.text =[NSString stringWithFormat:@"%d",[allFollowingKey count]];
    }
    if (indexPath.row ==4) {
        lable.text = [dataArray objectAtIndex:indexPath.row-1];
        countLable.text =[NSString stringWithFormat:@"%d",[allFollowerKey count]];
    }
    return cell;
}
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }else{
        return 50;
    }
}
//follow
-(void)followButton:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"关注"]){
            STreamObject *loggedInUser = [[STreamObject alloc] init];
            [loggedInUser setObjectId:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
            [loggedInUser addStaff:pageUserName withObject:@""];
            [loggedInUser update];
        
            [follower addStaff:[cache getLoginUserName] withObject:@""];
            [follower update];
        
            [button setTitle:@"取消关注" forState:UIControlStateNormal];
    }
   
    
    if ([button.titleLabel.text isEqualToString:@"取消关注"]) {
        STreamObject *loggedInUser = [[STreamObject alloc] init];
        [loggedInUser removeKey:pageUserName forObjectId:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
        
        [following removeKey:[cache getLoginUserName] forObjectId:[NSString stringWithFormat:@"%@Follower", pageUserName]];
        [button setTitle:@"关注" forState:UIControlStateNormal];
    }
   
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        if (count!=0) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.labelText = @"读取中...";
            [self.view addSubview:HUD];
            MainViewController * mainVC = [[MainViewController alloc]init];
            [HUD showAnimated:YES whileExecutingBlock:^{
                mainVC.isPush = YES;
                mainVC.userName = nameLablel.text;
             } completionBlock:^{
                 [self.navigationController pushViewController:mainVC animated:YES];
            }];
        }
    }
    if (indexPath.row == 2) {
        if ([countLable.text intValue]!=0) {
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.labelText = @"读取中...";
            [self.view addSubview:HUD];
              VotesGivenViewController *votesGiven = [[VotesGivenViewController alloc]init];
            [HUD showAnimated:YES whileExecutingBlock:^{
              
                STreamQuery *queryVotes = [[STreamQuery alloc]initWithCategory:@"Voted"];
                if (isPush){
                    [queryVotes addLimitId:userName];
                }else{
                    [queryVotes addLimitId:[cache getLoginUserName]];
                }
                NSMutableArray *votesResult = [queryVotes find];
                STreamObject *result = [votesResult objectAtIndex:0];
                NSArray *keys = [result getAllKeys];
                STreamQuery *sqq = [[STreamQuery alloc] initWithCategory:@"AllVotes"];
                for (NSString *key in keys){
                    [sqq addLimitId:key];
                }
                NSMutableArray *resultVotes = [sqq find];
                [votesGiven setVotesGivenArray:resultVotes];
                
            } completionBlock:^{
                
                [self.navigationController pushViewController:votesGiven animated:YES];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
