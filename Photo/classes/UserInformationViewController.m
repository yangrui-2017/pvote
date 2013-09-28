//
//  UserInformationViewController.m
//  Photo
//
//  Created by wangshuai on 13-9-17.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "UserInformationViewController.h"

@interface UserInformationViewController ()
{
    UIActivityIndicatorView *imageViewActivity;
}
@end

@implementation UserInformationViewController

@synthesize myTableView;
@synthesize headImage;
@synthesize nameLabel;
@synthesize votesLabel;
@synthesize followButton;

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
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    //background
    UIView *backgrdView = [[UIView alloc] initWithFrame:myTableView.frame];
    backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
    myTableView.backgroundView = backgrdView;

}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
        [imageViewActivity setCenter:CGPointMake(30,30)];
        [imageViewActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [cell addSubview:imageViewActivity];
        [imageViewActivity startAnimating];
        
        headImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        [cell.contentView addSubview:headImage];
        
        nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 100, 40)];
        nameLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
        nameLabel.text = @"wdgvgs";
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nameLabel];
        
        votesLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 100, 30)];
        votesLabel.font = [UIFont fontWithName:@"Arial" size:16.0f];
        votesLabel.text = @"wdgvgs";
        votesLabel.textAlignment = NSTextAlignmentCenter;
        votesLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:votesLabel];
        
        followButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [followButton setFrame:CGRectMake(220, 30, 100, 30)];
        followButton.tag = indexPath.row;
        [followButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [followButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [followButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [followButton addTarget:self action:@selector(followButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:followButton];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)followButton:(UIButton *)button{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
