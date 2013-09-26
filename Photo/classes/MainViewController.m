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
#import "VotesShowViewController.h"
#import "InformationViewController.h"
#import "CommentsViewController.h"

@interface MainViewController (){
    STreamCategoryObject *votes;   
    YIFullScreenScroll* _fullScreenDelegate;
    STreamQuery *st;
}

@end

@implementation MainViewController
@synthesize myTableView = _myTableView;
@synthesize name = _name;
@synthesize message = _message;
@synthesize oneImageView =_oneImageView;
@synthesize twoImageView =_twoImageView;
@synthesize vote1Lable = _vote1Lable;
@synthesize vote2Lable = _vote2Lable;
@synthesize clickButton;
@synthesize commentButton;
@synthesize isPush;
@synthesize userName;
@synthesize votesArray;
@synthesize isPushFromVotesGiven;

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
	// Do any additional setup after loading the view.
    self.title = @"主 页";
    if (!isPush) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(selectLeftAction:)];
        leftItem.tintColor = [UIColor blackColor];
        self.navigationItem.leftBarButtonItem = leftItem;
    } 
    
    votes = [[STreamCategoryObject alloc] initWithCategory:@"AllVotes"];
       
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.separatorStyle=YES;//UITableView每个cell之间的默认分割线隐藏掉sel
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview:self.myTableView];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self loadVotes];
    }completionBlock:^{
        [self.myTableView reloadData];
    }];
    
 
//    _fullScreenDelegate = [[YIFullScreenScroll alloc] initWithViewController:self];
//    _fullScreenDelegate.shouldShowUIBarsOnScrollUp = YES;

    
}


-(void)selectLeftAction:(id)sender{
    LoginViewController *loginVC  =[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (void)loadVotes{
    if (isPush) {
        if (!isPushFromVotesGiven){
            st = [[STreamQuery alloc] initWithCategory:@"AllVotes"];
            [st whereEqualsTo:@"userName" forValue:userName];
            votesArray = [st find];
        }
    }else{
        votesArray = [votes load];
        votesArray = [[NSMutableArray alloc] initWithArray:[[votesArray reverseObjectEnumerator]allObjects]];
         st = [[STreamQuery alloc] initWithCategory:@"Voted"];
    }
    ImageCache *imageCache = [ImageCache sharedObject];
   
   
    [st setQueryLogicAnd:FALSE];
    for (STreamObject *allVotes in votesArray){
        [st whereKeyExists:[allVotes objectId]];
    }
    NSMutableArray *results = [st find];
    for (STreamObject *allVotes in votesArray){
        int f1 = 0;
        int f2 = 0;
        for (STreamObject *vote in results){
            NSString *voted = [vote getValue:[allVotes objectId]];
            if (voted != nil && [voted isEqualToString:@"f1voted"])
                f1++;
            if (voted != nil && [voted isEqualToString:@"f2voted"])
                f2++;
        }
        int total = f1 + f2;
        int vote1count;
        int vote2count;
        if (total) {
            vote1count = ((float)f1/total)*100;
            vote2count = ((float)f2/total)*100;
            NSString *vote1 = [NSString stringWithFormat:@"%d%%",vote1count];
            NSString *vote2 = [NSString stringWithFormat:@"%d%%",vote2count];
            VoteResults *vo = [[VoteResults alloc] init];
            [vo setObjectId:[allVotes objectId]];
            [vo setF1:vote1];
            [vo setF2:vote2];
            [imageCache addVotesResults:[allVotes objectId] withVoteResult:vo];
            
        }else{
            vote1count=0;
            vote2count=0;
        }
    }
}
//创建cell上控件
-(void)createUIControls:(UITableViewCell *)cell withCellRowAtIndextPath:(NSIndexPath *)indexPath
{
    
    self.imageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.imageView setFrame:CGRectMake(5, 10, 60, 60)];
    [self.imageView setImage:[UIImage imageNamed:@"headImage.jpg"] forState:UIControlStateNormal];
    [self.imageView setTag:indexPath.row];
    [self.imageView addTarget:self action:@selector(headImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:self.imageView];
    
    self.name = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 200, 30)];
    self.name.enabled = NO;
    [cell.contentView addSubview:self.name];
    
    self.message = [[UITextView alloc]initWithFrame:CGRectMake(90, 40, 200, 40)];
    self.message.font =[UIFont systemFontOfSize:15.0f];
    [self.message setEditable:NO];
    self.message.showsVerticalScrollIndicator= YES;
    self.message.delegate = self;
    self.message .backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:self.message];
    
    self.vote1Lable = [[UILabel alloc]initWithFrame:CGRectMake(110, 90, 40, 20)];
    self.vote1Lable.textColor = [UIColor redColor];
    self.vote1Lable.font = [UIFont fontWithName:@"Arial" size:12];
    self.vote1Lable.textAlignment = NSTextAlignmentCenter;
    self.vote1Lable.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:self.vote1Lable];
    
    self.oneImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.oneImageView setFrame:CGRectMake(5, 110, 150, 150)];
    [self.oneImageView setImage:[UIImage imageNamed:@"ph.png"] forState:UIControlStateNormal];
    [self.oneImageView addTarget:self action:@selector(buttonClickedLeft:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.oneImageView setTag:indexPath.row];
    [cell.contentView addSubview:self.oneImageView];
    
    self.vote2Lable = [[UILabel alloc]initWithFrame:CGRectMake(170, 90, 40, 20)];
    self.vote2Lable.textColor = [UIColor redColor];
    self.vote2Lable.font = [UIFont fontWithName:@"Arial" size:12];
    self.vote2Lable.textAlignment = NSTextAlignmentCenter;
    self.vote2Lable.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:self.vote2Lable];
    
    self.twoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.twoImageView setFrame:CGRectMake(165, 110, 150, 150)];
    [self.twoImageView setImage:[UIImage imageNamed:@"ph.png"] forState:UIControlStateNormal];
    [self.twoImageView addTarget:self action:@selector(buttonClickedRight:withEvent:) forControlEvents:UIControlEventTouchDownRepeat];
    [self.twoImageView setTag:indexPath.row];
    [cell.contentView addSubview:self.twoImageView];
    
    clickButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    clickButton.tag = indexPath.row;
    [clickButton setTitle:@"查看投票" forState:UIControlStateNormal];
    [clickButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    clickButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [clickButton setFrame:CGRectMake(220, 260, 100, 50)];
    [clickButton addTarget:self action:@selector(clickedButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:clickButton];
    
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.tag = indexPath.row;
    [commentButton setTitle:@"评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [commentButton setFrame:CGRectMake(10, 260, 100, 50)];
    [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:commentButton];

}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [votesArray count];
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      STreamObject *so = [votesArray objectAtIndex:indexPath.row];
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
        cell.backgroundView = backgrdView;
        
//        UIImageView *imageview=[[UIImageView alloc] initWithImage:[UIImage  imageNamed:@"one.jpg"]];
//        imageview.frame=cell.frame;
//        cell.backgroundView=imageview;
        
        [self createUIControls:cell withCellRowAtIndextPath:indexPath];
        
    }
    NSString *message = [so getValue:@"message"];
    self.message.text = message;
    self.name.text = [so getValue:@"userName"];
   
    ImageCache *imageCache = [ImageCache sharedObject];
    VoteResults *vo = [imageCache getResults:[so objectId]];
    if (vo){
        self.vote1Lable.text = [vo f1];
        self.vote2Lable.text = [vo f2];
    }else{
        self.vote1Lable.text = @"0%";
        self.vote2Lable.text = @"0%";
    }
    if ([[vo f1] intValue]>= 50) {
        self.vote1Lable.textColor = [UIColor greenColor];
    }
    if ([[vo f2] intValue] >= 50) {
        self.vote2Lable.textColor = [UIColor greenColor];
    }
    [self downloadDoubleImage:so];
    [self loadUserMetadataAndDownloadUserProfileImage];
    
    
    return cell;
}
//查看投票
-(void)clickedButton:(UIButton *)sender
{
    VotesShowViewController *votesView = [[VotesShowViewController alloc]init];
    [votesView setRowObject:[votesArray objectAtIndex:sender.tag]];
    [self.navigationController pushViewController:votesView animated:YES];
    
}
//comments button
-(void)commentButtonClicked:(UIButton *)button
{
    CommentsViewController *commentsView = [[CommentsViewController alloc]init];
    [commentsView setRowObject:[votesArray objectAtIndex:button.tag]];
    commentsView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentsView animated:YES];
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
            [self.imageView setImage:[UIImage imageWithData:[imageCache getImage:pImageId]] forState:UIControlStateNormal];
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
    
    STreamQuery *sq = [[STreamQuery alloc] initWithCategory:@"Voted"];
    ImageCache *cache = [ImageCache sharedObject];
    [sq addLimitId:[cache getLoginUserName]];
    NSMutableArray *vote = [sq find];
    if ([vote count] > 0){
        
        STreamObject *so = [vote objectAtIndex:0];
        STreamObject *sorow = [votesArray objectAtIndex:button.tag];
        NSString *votedKey = [so getValue:[sorow objectId]];
        
        if (votedKey == nil){
            
            //update category voted
            [so addStaff:[sorow objectId] withObject:@"f1voted"];
            [so update];
            
        }else if([votedKey isEqualToString:@"f1voted"]){
          
            //update category voted
            [so removeKey:[sorow objectId] forObjectId:[so objectId]];
            
        }else{
            
            //update category voted
            [so removeKey:[sorow objectId] forObjectId:[so objectId]];
            [so addStaff:[sorow objectId] withObject:@"f1voted"];
            [so update];
            
        }
    }
    [self clickedButton:button];
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
    
    STreamQuery *sq = [[STreamQuery alloc] initWithCategory:@"Voted"];
    ImageCache *cache = [ImageCache sharedObject];
    [sq addLimitId:[cache getLoginUserName]];
    NSMutableArray *vote = [sq find];
    if ([vote count] > 0){
        
        STreamObject *so = [vote objectAtIndex:0];
        STreamObject *sorow = [votesArray objectAtIndex:button.tag];
        NSString *votedKey = [so getValue:[sorow objectId]];
        
        if (votedKey == nil){
            //update category voted
            [so addStaff:[sorow objectId] withObject:@"f2voted"];
            [so update];
        }
        
        else if([votedKey isEqualToString:@"f2voted"]){
            
            //update category voted
            [so removeKey:[sorow objectId] forObjectId:[so objectId]];
            
        }else{
            
            //update category voted
            [so removeKey:[sorow objectId] forObjectId:[so objectId]];
            [so addStaff:[sorow objectId] withObject:@"f2voted"];
            [so update];
        }

    }
    [self clickedButton:button];
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
    return 330;
}

//head image clicked
-(void) headImageClicked:(UIButton *)sender {
    STreamObject *so = [votesArray objectAtIndex:sender.tag];
    InformationViewController *informationView = [[InformationViewController alloc]init];
    informationView.userName = [so getValue:@"userName"];
    informationView.isPush = YES;
    [self.navigationController pushViewController:informationView animated:YES];
}

#pragma mark Full Screen
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
