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
#import <arcstreamsdk/STreamUser.h>
#import <arcstreamsdk/STreamSession.h>
#import "MBProgressHUD.h"
#import "ImageCache.h"
#import "ImageDownload.h"
#import "YIFullScreenScroll.h"
#import "LoginViewController.h"

@interface MainViewController (){
    STreamCategoryObject *votes;
    NSMutableArray *votesArray;
    NSMutableArray *allVotes;
    YIFullScreenScroll* _fullScreenDelegate;
}

@end

@implementation MainViewController
@synthesize myTableView = _myTableView;
@synthesize myDataArray = _myDataArray;
@synthesize name = _name;
@synthesize message = _message;
@synthesize oneImageView =_oneImageView;
@synthesize twoImageView =_twoImageView;
@synthesize ImageArray = _ImageArray;
@synthesize vote1Lable = _vote1Lable;
@synthesize vote2Lable = _vote2Lable;
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
    self.title = @"主 页";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(selectLeftAction:)];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.myDataArray = [[NSMutableArray alloc]init];
    self.ImageArray = [[NSMutableArray alloc]init];
    
    votes = [[STreamCategoryObject alloc] initWithCategory:@"allVotes"];
       
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    [self.myTableView setBackgroundColor:[UIColor grayColor]];
    self.myTableView.separatorStyle=NO;//UITableView每个cell之间的默认分割线隐藏掉
    [self.view addSubview:self.myTableView];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    
    [HUD showWhileExecuting:@selector(loadVotes) onTarget:self withObject:nil animated:YES];
    allVotes = [[NSMutableArray alloc] init];
    _fullScreenDelegate = [[YIFullScreenScroll alloc] initWithViewController:self];
    _fullScreenDelegate.shouldShowUIBarsOnScrollUp = YES;

    
}
-(void)selectLeftAction:(id)sender{
    LoginViewController *loginVC  =[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)loadVotes{
    
    votesArray = [votes load];

    int count = [votesArray count];
    
    for (int i=count-1; i >=0; i--){
        
        STreamObject *so = [votesArray objectAtIndex:i];
        STreamQuery *query = [[STreamQuery alloc] initWithCategory:[so getValue:@"userName"]];
        [self.myDataArray addObject:[so getValue:@"userName"]];
        [query addLimitId:[so objectId]];
        NSMutableArray *objects = [query find];
        [allVotes addObject:[objects objectAtIndex:0]];
        
    }
    
    [self.myTableView reloadData];
}


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [votesArray count];
  
}
     
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      STreamObject *so = [allVotes objectAtIndex:indexPath.row];
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 80)];
        self.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        [cell.contentView addSubview:self.imageView];
        
        self.name = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, 200, 30)];
        self.name.enabled = NO;
        [cell.contentView addSubview:self.name];
        
        self.message = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 200, 30)];
        self.message .backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.message];
        
        self.vote1Lable = [[UILabel alloc]initWithFrame:CGRectMake(110, 80, 40, 20)];
        self.vote1Lable.textColor = [UIColor redColor];
        self.vote1Lable.font = [UIFont fontWithName:@"Arial" size:12];
        self.vote1Lable.textAlignment = NSTextAlignmentCenter;
        self.vote1Lable.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:self.vote1Lable];
        
        self.oneImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.oneImageView setFrame:CGRectMake(5, 100, 150, 150)];
        [self.oneImageView setImage:[UIImage imageNamed:@"Placeholder.png"] forState:UIControlStateNormal];
        [self.oneImageView addTarget:self action:@selector(buttonClickedLeft:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
        [self.oneImageView setTag:indexPath.row];
        [cell.contentView addSubview:self.oneImageView];
        
        self.vote2Lable = [[UILabel alloc]initWithFrame:CGRectMake(170, 80, 40, 20)];
        self.vote2Lable.textColor = [UIColor redColor];
        self.vote2Lable.font = [UIFont fontWithName:@"Arial" size:12];
        self.vote2Lable.textAlignment = NSTextAlignmentCenter;
        self.vote2Lable.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:self.vote2Lable];
        
        self.twoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.twoImageView setFrame:CGRectMake(165, 100, 150, 150)];
        [self.twoImageView setImage:[UIImage imageNamed:@"Placeholder.png"] forState:UIControlStateNormal];
        [self.twoImageView addTarget:self action:@selector(buttonClickedRight:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
        [self.twoImageView setTag:indexPath.row];
        [cell.contentView addSubview:self.twoImageView];
    }
    NSString *message = [so getValue:@"message"];
    self.message.text = message;
    self.name.text = [self.myDataArray objectAtIndex:indexPath.row];
    float allcount = [[so getValue:@"file1vote"] floatValue]+[[so getValue:@"file2vote"] floatValue];
    int vote1count;
    int vote2count;
    if (allcount) {
        vote1count = ([[so getValue:@"file1vote"] floatValue]/allcount)*100;
        vote2count = ([[so getValue:@"file2vote"] floatValue]/allcount)*100;
    }else{
        vote1count=0;
        vote2count=0;
    }
    self.vote1Lable.text =[NSString stringWithFormat:@"%d%%",vote1count];
    self.vote2Lable.text =[NSString stringWithFormat:@"%d%%",vote2count];

    [self downloadDoubleImage:so];
    [self loadUserMetadataAndDownloadUserProfileImage];
    
    
    return cell;
}

- (void)downloadDoubleImage: (STreamObject *)so{
    
    NSString *file1 = [so getValue:@"file1"];
    NSString *file2 = [so getValue:@"file2"];
     ImageCache *imageCache = [ImageCache sharedObject];
    //download double image
    if ([imageCache getImages:[so objectId]] != nil){
        ImageDataFile *files = [imageCache getImages:[so objectId]];
        [self.oneImageView setImage:[UIImage imageWithData:[files file1]] forState:UIControlStateNormal];
        [self.twoImageView setImage:[UIImage imageWithData:[files file2]] forState:UIControlStateNormal];
    }else{
        ImageDownload *imageDownload = [[ImageDownload alloc] init];
        [imageDownload dowloadFile:file1 withFile2:file2 withObjectId:[so objectId]];
        [imageDownload setMainRefesh:self];
    }
}


- (void)loadUserMetadataAndDownloadUserProfileImage{
    
    ImageCache *imageCache = [ImageCache sharedObject];

    //load user metadata and profile image
    if ([imageCache getUserMetadata:self.name.text] != nil){
        NSMutableDictionary *userMetaData = [imageCache getUserMetadata:self.name.text];
        NSString *pImageId = [userMetaData objectForKey:@"profileImageId"];
        if ([imageCache getImage:pImageId] == nil){
            ImageDownload *imageDownload = [[ImageDownload alloc] init];
            [imageDownload downloadFile:pImageId];
            [imageDownload setMainRefesh:self];
        }else{
            self.imageView.image = [UIImage imageWithData:[imageCache getImage:pImageId]];
        }
    }else{
        STreamUser *user = [[STreamUser alloc] init];
        [user loadUserMetadata:self.name.text response:^(BOOL succeed, NSString *error){
            if ([error isEqualToString:self.name.text]){
                NSMutableDictionary *dic = [user userMetadata];
                [imageCache saveUserMetadata:self.name.text withMetadata:dic];
                [self.myTableView reloadData];
            }
        }];
    }

}

-(void)voteTheTopicLeft:(UIButton *)button{
    
    STreamQuery *sq = [[STreamQuery alloc] initWithCategory:@"voted"];
    ImageCache *cache = [ImageCache sharedObject];
    [sq addLimitId:[cache getLoginUserName]];
    NSMutableArray *vote = [sq find];
    if ([vote count] > 0){
        
        STreamObject *so = [vote objectAtIndex:0];
        STreamObject *sorow = [allVotes objectAtIndex:button.tag];
        NSString *votedKey = [so getValue:[sorow objectId]];
        
        if (votedKey == nil){
            
            //update category voted
            [so addStaff:[sorow objectId] withObject:@"f1voted"];
            int total = [so size];
            [so addStaff:@"total" withObject:[NSNumber numberWithInt:total]];
            [so updateInBackground];
            
            //update category username
            NSNumber *fileVote1 = [sorow  getValue:@"file1vote"];
            int newVote = [fileVote1 intValue] + 1;
            [sorow  addStaff:@"file1vote" withObject:[NSNumber numberWithInt:newVote]];
            [self.myTableView reloadData];
            [sorow updateInBackground];
            
        }
        /*STreamQuery *sqq = [[STreamQuery alloc] initWithCategory:@"voted"];
        [sqq setQueryLogicAnd:FALSE];
        [sqq whereEqualsTo:[sorow objectId] forValue:@"f1voted"];
        [sqq whereEqualsTo:[sorow objectId] forValue:@"f2voted"];
        NSMutableArray *result = [sqq find];*/
        
    }
}

-(void)buttonClickedLeft:(UIButton *)button withEvent:(UIEvent*)event {
    
    UITouch* touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"投票中...";
        [self.view addSubview:HUD];
        [HUD showWhileExecuting:@selector(voteTheTopicLeft:) onTarget:self withObject:button animated:YES];
    }
}
-(void)voteTheTopicRight:(UIButton *)button{
    
    STreamQuery *sq = [[STreamQuery alloc] initWithCategory:@"voted"];
    ImageCache *cache = [ImageCache sharedObject];
    [sq addLimitId:[cache getLoginUserName]];
    NSMutableArray *vote = [sq find];
    if ([vote count] > 0){
        
        STreamObject *so = [vote objectAtIndex:0];
        STreamObject *sorow = [allVotes objectAtIndex:button.tag];
        NSString *votedKey = [so getValue:[sorow objectId]];
        
        if (votedKey == nil){
            //update category voted
            [so addStaff:[sorow objectId] withObject:@"f2voted"];
            int total = [so size];
            [so addStaff:@"total" withObject:[NSNumber numberWithInt:total]];
            [so updateInBackground];
            
            //update category username
            NSNumber *fileVote1 = [sorow  getValue:@"file2vote"];
            int newVote = [fileVote1 intValue] + 1;
            [sorow  addStaff:@"file2vote" withObject:[NSNumber numberWithInt:newVote]];
            [self.myTableView reloadData];
            [sorow updateInBackground];
            
        }
    }
}

-(void)buttonClickedRight:(UIButton *)button withEvent:(UIEvent*)event {
    
    UITouch* touch = [[event allTouches] anyObject];
    if (touch.tapCount == 2) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"投票中...";
        [self.view addSubview:HUD];
        [HUD showWhileExecuting:@selector(voteTheTopicRight:) onTarget:self withObject:button animated:YES];
    }
}
- (void)reloadTable{
    [self.myTableView reloadData];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}
#pragma mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // hide tabBar when pushed & show again when popped
    self.hidesBottomBarWhenPushed = YES;
    
    double delayInSeconds = UINavigationControllerHideShowBarDuration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.hidesBottomBarWhenPushed = NO;
    });
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_fullScreenDelegate scrollViewWillBeginDragging:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_fullScreenDelegate scrollViewDidScroll:scrollView];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    return [_fullScreenDelegate scrollViewShouldScrollToTop:scrollView];;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [_fullScreenDelegate scrollViewDidScrollToTop:scrollView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
