//
//  FireViewController.m
//  Photo
//
//  Created by wangsh on 13-9-29.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "FireViewController.h"
#import <arcstreamsdk/STreamCategoryObject.h>
#import <arcstreamsdk/STreamObject.h>
#import <arcstreamsdk/STreamQuery.h>
#import "ImageCache.h"
#import "ImageDownload.h"
#import "MBProgressHUD.h"
#import "SingleImageViewController.h"

@interface FireViewController ()
{
    STreamCategoryObject *votes;
    STreamQuery *st;
    NSMutableDictionary *loggedInUserVotesResults;
    NSMutableArray *votesArray;
    ImageCache *imageCache;
    UIActivityIndicatorView *firstLeftActivity;
    UIActivityIndicatorView *firstRightActivity;
    UIActivityIndicatorView *secondLeftActivity;
    UIActivityIndicatorView *secondRightActivity;
    STreamObject *leftSo;
     STreamObject *rightSo;
}
@end

@implementation FireViewController

@synthesize leftView;
@synthesize rightView;
@synthesize firstLeftButton;
@synthesize firstRightButton;
@synthesize secondLeftButton;
@synthesize secondRightButton;

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

    UIView *backgrdView = [[UIView alloc] initWithFrame:self.tableView.frame];
    backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
    self.tableView.backgroundView = backgrdView;
    self.tableView.separatorStyle = NO;
    imageCache = [ImageCache sharedObject];
    
    __block MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self loadVotes];
    }completionBlock:^{
        [self.tableView reloadData];
         [HUD removeFromSuperview];
        HUD = nil;
    }];

}
-(void)loadVotes
{
    votes = [[STreamCategoryObject alloc] initWithCategory:@"AllVotes"];
    loggedInUserVotesResults = [[NSMutableDictionary alloc] init];
    votesArray = [votes load];
    votesArray = [[NSMutableArray alloc] initWithArray:[[votesArray reverseObjectEnumerator]allObjects]];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//创建cell上控件
-(void)createUIControls:(UITableViewCell *)cell withCellRowAtIndextPath:(NSIndexPath *)indexPath
{
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 150, 80)];
    leftView.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:leftView];
    
    rightView = [[UIView alloc]initWithFrame:CGRectMake(165, 5, 150, 80)];
    rightView.backgroundColor = [UIColor whiteColor];
    if ((2*indexPath.row+1)< [votesArray count]) {
        [cell.contentView addSubview:rightView];
    }
    firstLeftActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [firstLeftActivity setCenter:CGPointMake(38, 40)];
    [firstLeftActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [leftView addSubview:firstLeftActivity];
    [firstLeftActivity startAnimating];
    
    firstRightActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [firstRightActivity setCenter:CGPointMake(112, 40)];
    [firstRightActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [leftView addSubview:firstRightActivity];
    [firstRightActivity startAnimating];
    
    secondLeftActivity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [secondLeftActivity setCenter:CGPointMake(38, 40)];
    [secondLeftActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [rightView addSubview:secondLeftActivity];
    [secondLeftActivity startAnimating];
    secondRightActivity= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [secondRightActivity setCenter:CGPointMake(112, 40)];
    [secondRightActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [rightView addSubview:secondRightActivity];
    [secondRightActivity startAnimating];
    

    firstLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstLeftButton setFrame:CGRectMake(3, 5, 70, 70)];
    [firstLeftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:firstLeftButton];
    firstRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [firstRightButton setFrame:CGRectMake(77, 5, 70, 70)];
    [firstRightButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:firstRightButton];
    firstLeftButton.tag = indexPath.row *2;
    firstRightButton.tag =indexPath.row *2;
    
    secondLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondLeftButton setFrame:CGRectMake(3, 5, 70, 70)];
    [secondLeftButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:secondLeftButton];
    secondRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondRightButton setFrame:CGRectMake(77, 5, 70, 70)];
    [secondRightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:secondRightButton];
    secondLeftButton.tag = 2*indexPath.row+1;
    secondRightButton.tag = 2*indexPath.row+1;

}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [votesArray count]%2==0 ?[votesArray count]/2:[votesArray count]/2+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
        cell.backgroundView = backgrdView;

        [self createUIControls:cell withCellRowAtIndextPath:indexPath];
    }
    leftSo = [votesArray objectAtIndex:indexPath.row *2];
     [self loadLeftImage:leftSo];
    int row = 2*indexPath.row+1;
    if (row <[votesArray count]) {
        rightSo = [votesArray objectAtIndex:row];
        [self loadRightImage:rightSo];
    }
    return cell;
}
-(void)loadLeftImage:(STreamObject *)so
{
    NSString *file1 = [so getValue:@"file1"];
    NSString *file2 = [so getValue:@"file2"];
    //download double image
    if ([imageCache getImages:[so objectId]] != nil){
        ImageDataFile *files = [imageCache getImages:[so objectId]];
        [firstLeftButton setImage:[UIImage imageWithData:[files file1]] forState:UIControlStateNormal];
        [firstRightButton setImage:[UIImage imageWithData:[files file2]] forState:UIControlStateNormal];
        [firstLeftActivity startAnimating];
        [firstRightActivity stopAnimating];
    }else{
        ImageDownload *imageDownload = [[ImageDownload alloc] init];
        [imageDownload dowloadFile:file1 withFile2:file2 withObjectId:[so objectId]];
        [imageDownload setMainRefesh:self];
    }
}
-(void)loadRightImage:(STreamObject *)so
{
    NSString *file1 = [so getValue:@"file1"];
    NSString *file2 = [so getValue:@"file2"];
    //download double image
    if ([imageCache getImages:[so objectId]] != nil){
        ImageDataFile *files = [imageCache getImages:[so objectId]];
        [secondLeftButton setImage:[UIImage imageWithData:[files file1]] forState:UIControlStateNormal];
        [secondRightButton setImage:[UIImage imageWithData:[files file2]] forState:UIControlStateNormal];
        [secondLeftActivity stopAnimating];
        [secondRightActivity stopAnimating];
    }else{
        ImageDownload *imageDownload = [[ImageDownload alloc] init];
        [imageDownload dowloadFile:file1 withFile2:file2 withObjectId:[so objectId]];
        [imageDownload setMainRefesh:self];
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
-(void)reloadTable
{
    [self.tableView reloadData];
}
-(void)leftButtonClicked:(UIButton *)leftButton
{
    SingleImageViewController *singleView = [[SingleImageViewController alloc]init];
    leftSo = [votesArray objectAtIndex:leftButton.tag];
    [singleView setSo:leftSo];
    [self.navigationController pushViewController:singleView animated:YES];
}
-(void)rightButtonClicked:(UIButton *)rightButton
{
    SingleImageViewController *singleView = [[SingleImageViewController alloc]init];
    rightSo = [votesArray objectAtIndex:rightButton.tag];
    [singleView setSo:rightSo];
    [self.navigationController pushViewController:singleView animated:YES];
}
@end
