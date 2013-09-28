//
//  FollowingViewController.m
//  Photo
//
//  Created by wangsh on 13-9-27.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "FollowingViewController.h"
#import "InformationViewController.h"
#import "ImageCache.h"
#import "MBProgressHUD.h"
#import <arcstreamsdk/STreamObject.h>

@interface FollowingViewController ()
{
    ImageCache * cache;
    NSMutableDictionary *userMetaData;
    NSMutableArray *loggedInUserFollowing;
    UIActivityIndicatorView *imageViewActivity;
}
@end

@implementation FollowingViewController
@synthesize imageView;
@synthesize nameLabel;
@synthesize followingButton;
@synthesize pImageId;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    cache = [ImageCache sharedObject];
    
    STreamObject *loggedInUserFollowingStream = [[STreamObject alloc] init];
    [loggedInUserFollowingStream loadAll:[NSString stringWithFormat:@"%@Following",[cache getLoginUserName]]];
    loggedInUserFollowing = [NSMutableArray arrayWithArray:[loggedInUserFollowingStream getAllKeys]];
    
    UIView *backgrdView = [[UIView alloc] initWithFrame:self.tableView.frame];
    backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.tableView.backgroundView = backgrdView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [loggedInUserFollowing count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
        cell.backgroundView = backgrdView;
        
        imageViewActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [imageViewActivity setCenter:CGPointMake(30,22)];
        [imageViewActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [cell addSubview:imageViewActivity];
        [imageViewActivity startAnimating];

        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 40, 40)];
        [cell.contentView addSubview:imageView];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 40)];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nameLabel];
        
        followingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [followingButton setFrame:CGRectMake(220, 10, 100, 40)];
        followingButton.tag = indexPath.row;
        [followingButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [followingButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [followingButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [followingButton addTarget:self action:@selector(followingButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:followingButton];
    }
    userMetaData = [cache getUserMetadata:[loggedInUserFollowing objectAtIndex:indexPath.row]];
    pImageId = [userMetaData objectForKey:@"profileImageId"];
    if ([cache getImage:pImageId]){
        imageView.image = [UIImage imageWithData:[cache getImage:pImageId]];
        [imageViewActivity stopAnimating];
    }else{
        [imageView setImage:[UIImage imageNamed:@"headImage.jpg"]];
    }
    nameLabel.text = [loggedInUserFollowing objectAtIndex:indexPath.row];
    return cell;
}
-(void)followingButton:(UIButton *)button
{
    NSString * pageUserName = [loggedInUserFollowing objectAtIndex:button.tag];
    STreamObject *loggedInUser = [[STreamObject alloc] init];
    STreamObject *follower = [[STreamObject alloc]init];
    [loggedInUser removeKey:pageUserName forObjectId:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
    [follower removeKey:[cache getLoginUserName] forObjectId:[NSString stringWithFormat:@"%@Follower",pageUserName]];
    //for table view update
    [loggedInUserFollowing removeObject:pageUserName];
    [loggedInUser loadAll:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationViewController *inforView = [[InformationViewController alloc]init];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        [inforView setUserName:[loggedInUserFollowing objectAtIndex:indexPath.row]];
    } completionBlock:^{
        [self.navigationController pushViewController:inforView animated:YES];
    }];

}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


@end
