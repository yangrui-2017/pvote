//
//  FollowerViewController.m
//  Photo
//
//  Created by wangsh on 13-9-27.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "FollowerViewController.h"
#import "InformationViewController.h"
#import "ImageCache.h"
#import "MBProgressHUD.h"
#import <arcstreamsdk/STreamObject.h>

@interface FollowerViewController ()
{
    ImageCache *cache;
    NSMutableDictionary *userMetaData;
    NSMutableArray *loggedInUserFollowing;
    NSString *pageUserName;
}
@end

@implementation FollowerViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
@synthesize imageView;
@synthesize nameLabel;
@synthesize followerButton;
@synthesize followerArray;
@synthesize pImageId;
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
    return [followerArray count];
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
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 2, 40, 40)];
        [cell.contentView addSubview:imageView];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 40)];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nameLabel];
        
        followerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [followerButton setFrame:CGRectMake(220, 10, 100, 40)];
        followerButton.tag = indexPath.row;
        [followerButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [followerButton addTarget:self action:@selector(followerButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:followerButton];
    }
    userMetaData = [cache getUserMetadata:[followerArray objectAtIndex:indexPath.row]];
    pImageId = [userMetaData objectForKey:@"profileImageId"];
    if ([cache getImage:pImageId]){
        imageView.image = [UIImage imageWithData:[cache getImage:pImageId]];
    }else{
        [imageView setImage:[UIImage imageNamed:@"headImage.jpg"]];
    }
    nameLabel.text = [followerArray objectAtIndex:indexPath.row];
    if ([loggedInUserFollowing containsObject:[followerArray objectAtIndex:indexPath.row]]) {
        [followerButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [followerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }else{
        [followerButton setTitle:@"关注" forState:UIControlStateNormal];
        [followerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }

    return cell;
}

-(void)followerButton:(UIButton *)button
{
    pageUserName = [followerArray objectAtIndex:button.tag];
    STreamObject *loggedInUser = [[STreamObject alloc] init];
    STreamObject *follower = [[STreamObject alloc]init];
    [follower loadAll:[NSString stringWithFormat:@"%@Follower", pageUserName]];
    
    if ([button.titleLabel.text isEqualToString:@"取消关注"]) {
        [loggedInUser removeKey:pageUserName forObjectId:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
        [follower removeKey:[cache getLoginUserName] forObjectId:[NSString stringWithFormat:@"%@Follower",pageUserName]];
        //for table view update
        [loggedInUserFollowing removeObject:pageUserName];
        [loggedInUser loadAll:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
    }
    if ([button.titleLabel.text isEqualToString:@"关注"]) {
        
        [loggedInUser setObjectId:[NSString stringWithFormat:@"%@Following", [cache getLoginUserName]]];
        [loggedInUser addStaff:pageUserName withObject:@""];
        [loggedInUser update];
        
        [follower addStaff:[cache getLoginUserName] withObject:@""];
        [follower update];
        
        //for table view update
        [loggedInUserFollowing addObject:pageUserName];
    }
    [self.tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationViewController *inforView = [[InformationViewController alloc]init];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        [inforView setUserName:[followerArray objectAtIndex:indexPath.row]];
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


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

@end