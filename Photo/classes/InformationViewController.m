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
#import "MBProgressHUD.h"
#import "FollowingViewController.h"
#import "FollowerViewController.h"
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
    NSMutableArray *loggedInUserFollowing;
    NSString *pImageId;
    int threeCount;
    int fourCount;
    UIActivityIndicatorView *imageViewActivity;
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
    
    UIView *backgrdView = [[UIView alloc] initWithFrame:myTableView.frame];
    backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
    myTableView.backgroundView = backgrdView;
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self loadDetails];
     }completionBlock:^{
        [self.myTableView reloadData];
     }];

}

- (void)loadDetails{
   
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
    loggedInUserFollowing = [NSMutableArray arrayWithArray:[loggedInUserFollowingStream getAllKeys]];

}

//创建cell上控件
-(void)createUIControls:(UITableViewCell *)cell withCellRowAtIndextPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0) {
        imageViewActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [imageViewActivity setCenter:CGPointMake(50, 50)];
        [imageViewActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [cell addSubview:imageViewActivity];
        [imageViewActivity startAnimating];
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
        cell.backgroundView = backgrdView;
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        imageView.image = [UIImage imageNamed:@"headImage.jpg"];
        [cell.contentView addSubview:imageView];
        
        nameLablel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 80, 50)];
        nameLablel.textColor = [UIColor blackColor];
//        nameLablel.textAlignment = NSTextAlignmentCenter;
//        nameLablel.font = [UIFont fontWithName:@"Arial" size:20];
        nameLablel.backgroundColor = [UIColor clearColor];
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
        cell.backgroundView = backgrdView;
        
        lable = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 240, 50)];
//        lable.textAlignment = NSTextAlignmentCenter;
//        lable.font = [UIFont fontWithName:@"Arial" size:24];
        lable.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lable];
        
        countLable = [[UILabel alloc]initWithFrame:CGRectMake(230, 0, 60, 50)];
        countLable.textAlignment = NSTextAlignmentRight;
//        countLable.font = [UIFont fontWithName:@"Arial" size:24];
        countLable.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:countLable];
    }

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
        [self createUIControls:cell withCellRowAtIndextPath:indexPath];
    }
    
    userMetaData = [cache getUserMetadata:pageUserName];
    pImageId = [userMetaData objectForKey:@"profileImageId"];
    if ([cache getImage:pImageId]){
        imageView.image = [UIImage imageWithData:[cache getImage:pImageId]];
        [imageViewActivity stopAnimating];
    }else{
        [imageView setImage:[UIImage imageNamed:@"headImage.jpg"]];
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
        threeCount = [countLable.text intValue];
    }
    if (indexPath.row ==4) {
        lable.text = [dataArray objectAtIndex:indexPath.row-1];
        countLable.text =[NSString stringWithFormat:@"%d",[allFollowerKey count]];
        fourCount = [countLable.text intValue];
    }
    nameLablel.text = pageUserName;
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

- (void)followAction{
 
    STreamObject *loggedInUser = [[STreamObject alloc] init];
    [loggedInUser setObjectId:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
    [loggedInUser addStaff:pageUserName withObject:@""];
    [loggedInUser update];
    
    [follower addStaff:[cache getLoginUserName] withObject:@""];
    [follower update];
    
    
    //for table view update
    allFollowerKey = [follower getAllKeys];
    [loggedInUserFollowing addObject:pageUserName];

}

- (void)unFollowAction{
    
    STreamObject *loggedInUser = [[STreamObject alloc] init];
    [loggedInUser removeKey:pageUserName forObjectId:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
    [follower removeKey:[cache getLoginUserName] forObjectId:[NSString stringWithFormat:@"%@Follower", pageUserName]];
    //for table view update
    [loggedInUserFollowing removeObject:pageUserName];
    allFollowingKey = [following getAllKeys];
    allFollowerKey = [follower getAllKeys];
    
}

//follow/unfollow
-(void)followButton:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"关注"]){
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.labelText = @"读取中...";
            [self.view addSubview:HUD];
        
            [HUD showAnimated:YES whileExecutingBlock:^{
                [self followAction];
            }completionBlock:^{
               [self.myTableView reloadData];
            }];
        return;
    }
   
    
    if ([button.titleLabel.text isEqualToString:@"取消关注"]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"读取中...";
        [self.view addSubview:HUD];
        [HUD showAnimated:YES whileExecutingBlock:^{
            [self unFollowAction];
        }completionBlock:^{
            [self.myTableView reloadData];
        }];
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
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.labelText = @"读取中...";
            [self.view addSubview:HUD];
            MainViewController * mainVC = [[MainViewController alloc]init];
            [HUD showAnimated:YES whileExecutingBlock:^{
                STreamQuery *queryVotes = [[STreamQuery alloc]initWithCategory:@"Voted"];
               [queryVotes addLimitId:pageUserName];
                NSMutableArray *votesResult = [queryVotes find];
                STreamObject *result = [votesResult objectAtIndex:0];
                NSArray *keys = [result getAllKeys];
                STreamQuery *sqq = [[STreamQuery alloc] initWithCategory:@"AllVotes"];
                for (NSString *key in keys){
                    [sqq addLimitId:key];
                }
                NSMutableArray *resultVotes = [sqq find];
                [mainVC setVotesArray:resultVotes];
                mainVC.isPush = YES;
                mainVC.isPushFromVotesGiven = YES;
            } completionBlock:^{
                [self.navigationController pushViewController:mainVC animated:YES];
            }];
        
    }
    //following
    if (indexPath.row == 3) {
        if (threeCount) {
            FollowingViewController *followingView = [[FollowingViewController alloc]init];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.labelText = @"读取中...";
            [self.view addSubview:HUD];
            [HUD showAnimated:YES whileExecutingBlock:^{

            } completionBlock:^{
                [self.navigationController pushViewController:followingView animated:YES];
             }];
        }
    }
    //follower
    if (indexPath.row == 4) {
        if (fourCount) {
            FollowerViewController *followerView = [[FollowerViewController alloc]init];
            MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
            HUD.labelText = @"读取中...";
            [self.view addSubview:HUD];
            [HUD showAnimated:YES whileExecutingBlock:^{
                [followerView setFollowerArray:allFollowerKey];
            } completionBlock:^{
                [self.navigationController pushViewController:followerView animated:YES];
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
