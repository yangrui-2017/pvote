//
//  VotesShowViewController.m
//  Photo
//
//  Created by wangsh on 13-9-22.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "VotesShowViewController.h"
#import <arcstreamsdk/STreamQuery.h>
#import <arcstreamsdk/STreamObject.h>
#import "ImageCache.h"
#import "YIFullScreenScroll.h"
#import "MainViewController.h"
#import "MBProgressHUD.h"
#import "InformationViewController.h"
#import "CommentsViewController.h"
@interface VotesShowViewController (){
    NSMutableArray *result;
    NSMutableArray *leftVoters;
    NSMutableArray *rightVoters;
    NSString *leftImageId;
    NSString *rightImageId;
    int vote1count;
    int vote2count;
    YIFullScreenScroll *_fullScreenDelegate;
    UIView *cellView;
}

@end

@implementation VotesShowViewController

@synthesize countLable;
@synthesize vote1Lable;
@synthesize vote2Lable;
@synthesize leftButton;
@synthesize rightButton;
@synthesize oneImageView;
@synthesize twoImageView;
@synthesize rowObject;
@synthesize commentButton;

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
  
//    _fullScreenDelegate = [[YIFullScreenScroll alloc] initWithViewController:self];
//    _fullScreenDelegate.shouldShowUIBarsOnScrollUp = YES;
    leftImageId = [rowObject getValue:@"file1"];
    rightImageId = [rowObject getValue:@"file2"];
    
    /*float allcount = [[rowObject getValue:@"file1vote"] floatValue]+[[rowObject getValue:@"file2vote"] floatValue];
    if (allcount) {
        vote1count = ([[rowObject getValue:@"file1vote"] floatValue]/allcount)*100;
        vote2count = ([[rowObject getValue:@"file2vote"] floatValue]/allcount)*100;
     }else{
         vote1count=0;
         vote2count=0;
     }*/
    leftVoters = [[NSMutableArray alloc] init];
    rightVoters = [[NSMutableArray alloc] init];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    
    [HUD showWhileExecuting:@selector(loadVotes) onTarget:self withObject:nil animated:YES];
}
- (void)loadVotes{
    
    ImageCache *imageCache = [ImageCache sharedObject];
    STreamQuery *sqq = [[STreamQuery alloc] initWithCategory:@"Voted"];
    [sqq setQueryLogicAnd:FALSE];
    NSString *objectId  = [rowObject objectId];
    
    [sqq whereEqualsTo:objectId forValue:@"f1voted"];
    [sqq whereEqualsTo:objectId forValue:@"f2voted"];
    result = [sqq find];
    for (STreamObject *so in result){
        NSString *vote = [so getValue:objectId];
        if ([vote isEqualToString:@"f1voted"])
            [leftVoters addObject:[so objectId]];
        if ([vote isEqualToString:@"f2voted"])
            [rightVoters addObject:[so objectId]];
    }
    int leftCount = [leftVoters count];
    int rightCount = [rightVoters count];
    
    int total = [leftVoters count] + [rightVoters count];
    
    vote1count = ((float)leftCount/total)*100;
    vote2count = ((float)rightCount/total)*100;
    
    NSString *vote1 = [NSString stringWithFormat:@"%d%%",vote1count];
    NSString *vote2 = [NSString stringWithFormat:@"%d%%",vote2count];
    VoteResults *vo = [[VoteResults alloc] init];
    [vo setObjectId:[rowObject objectId]];
    [vo setF1:vote1];
    [vo setF2:vote2];
    [imageCache addVotesResults:[rowObject objectId] withVoteResult:vo];
    
    [self.tableView reloadData];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [leftVoters count] > [rightVoters count] ? [leftVoters count] + 1 : [rightVoters count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cellView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
            self.vote1Lable = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 80, 40)];
            self.vote1Lable.textColor = [UIColor redColor];
            self.vote1Lable.font = [UIFont fontWithName:@"Arial" size:22];
            self.vote1Lable.backgroundColor = [UIColor whiteColor];
            [cellView addSubview:self.vote1Lable];
            
            self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 40, 150, 150)];
            [self.oneImageView setImage:[UIImage imageNamed:@"Placeholder.png"] ];
            [cellView addSubview:self.oneImageView];

            
            self.vote2Lable = [[UILabel alloc]initWithFrame:CGRectMake(230, 0, 80, 40)];
            self.vote2Lable.textColor = [UIColor greenColor];
            self.vote2Lable.font = [UIFont fontWithName:@"Arial" size:22];
            self.vote2Lable.textAlignment = NSTextAlignmentRight;
            self.vote2Lable.backgroundColor = [UIColor whiteColor];
            [cellView addSubview:self.vote2Lable];
            
            self.twoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(165, 40, 150, 150)];
            [self.twoImageView setImage:[UIImage imageNamed:@"Placeholder.png"] ];
            [cellView addSubview:self.twoImageView];
            
            
            self.countLable = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, 100, 40)];
            self.countLable.textColor = [UIColor blackColor];
            self.countLable.textAlignment = NSTextAlignmentCenter;
            self.countLable.font = [UIFont fontWithName:@"Arial" size:24];
            self.countLable.textAlignment = NSTextAlignmentCenter;
            self.countLable.backgroundColor = [UIColor whiteColor];
            [cellView addSubview:self.countLable];
            
            self.commentButton = [[UIButton alloc]initWithFrame:CGRectMake(120, 190, 80,40)];
            self.commentButton.titleLabel.font =[UIFont fontWithName:@"Arial" size:24];
            [self.commentButton setTitle:@"评 论" forState:UIControlStateNormal];
            [self.commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:self.commentButton];
            [cell.contentView addSubview:cellView];
        }else{
            self.leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80,40)];
            self.leftButton.titleLabel.font =[UIFont fontWithName:@"Arial" size:22];
            [self.leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self.leftButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.leftButton];
            
            self.rightButton = [[UIButton alloc]initWithFrame:CGRectMake(245, 0, 80,40)];
            self.rightButton.titleLabel.font =[UIFont fontWithName:@"Arial" size:22];
            [self.rightButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            [self.rightButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.rightButton];
        }
        
    }
    
    self.vote1Lable.text=[NSString stringWithFormat:@"%d%%",vote1count];
    self.vote2Lable.text=[NSString stringWithFormat:@"%d%%",vote2count];

    if (indexPath.row != 0) {
    
        if ([leftVoters count]!=0 && [leftVoters count] - 1 >= (indexPath.row - 1))
            [self.leftButton setTitle:[leftVoters objectAtIndex:(indexPath.row-1 )] forState:UIControlStateNormal];
        if ([rightVoters count]!=0 &&[rightVoters count] - 1 >= (indexPath.row - 1))
            [self.rightButton setTitle:[rightVoters objectAtIndex:(indexPath.row-1 )] forState:UIControlStateNormal];

    }
    ImageCache *cache = [ImageCache sharedObject];
    ImageDataFile *dataFile = [cache getImages:[rowObject objectId]];
    self.oneImageView.image = [UIImage imageWithData:[dataFile file1]];
    self.twoImageView.image = [UIImage imageWithData:[dataFile file2]];
    self.countLable.text=[NSString stringWithFormat:@"投票数:%d", [result count]];
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 230;
    }else{
        return 40;
    }
}
//comment
-(void)commentButtonClicked:(UIButton *)button{
    CommentsViewController * commentsView = [[CommentsViewController alloc] init];
    commentsView.cellView = cellView;
    [self.navigationController pushViewController:commentsView animated:YES];
    NSLog(@"comment");
}
//
-(void)buttonClicked:(UIButton *)button{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    [HUD showAnimated:YES whileExecutingBlock:^{    } completionBlock:^{
        InformationViewController * informationVC = [[InformationViewController alloc]init];
        informationVC.userName = button.titleLabel.text;
        informationVC.isPush = YES;
      [self.navigationController pushViewController:informationVC animated:YES];
    }];

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


@end