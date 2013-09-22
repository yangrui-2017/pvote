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
@interface VotesShowViewController (){
    NSMutableArray *result;
    NSMutableArray *leftVoters;
    NSMutableArray *rightVoters;
    NSString *leftImageId;
    NSString *rightImageId;
    int vote1count;
    int vote2count;
    YIFullScreenScroll *_fullScreenDelegate;
}

@end

@implementation VotesShowViewController

@synthesize countLable;
@synthesize vote1Lable;
@synthesize vote2Lable;
@synthesize votes1;
@synthesize votes2;
@synthesize oneImageView;
@synthesize twoImageView;
@synthesize rowObject;
@synthesize leftLable;
@synthesize rightLable;

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
    float allcount = [[rowObject getValue:@"file1vote"] floatValue]+[[rowObject getValue:@"file2vote"] floatValue];
    if (allcount) {
        vote1count = ([[rowObject getValue:@"file1vote"] floatValue]/allcount)*100;
        vote2count = ([[rowObject getValue:@"file2vote"] floatValue]/allcount)*100;
     }else{
         vote1count=0;
         vote2count=0;
     }
    leftVoters = [[NSMutableArray alloc] init];
    rightVoters = [[NSMutableArray alloc] init];
    STreamQuery *sqq = [[STreamQuery alloc] initWithCategory:@"voted"];
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
        
        if (indexPath.row == 0) {
            self.vote1Lable = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 40, 20)];
            self.vote1Lable.textColor = [UIColor redColor];
            self.vote1Lable.font = [UIFont fontWithName:@"Arial" size:12];
            self.vote1Lable.textAlignment = NSTextAlignmentCenter;
            self.vote1Lable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:self.vote1Lable];
            
            self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 25, 150, 150)];
            [self.oneImageView setImage:[UIImage imageNamed:@"Placeholder.png"] ];
            [cell.contentView addSubview:self.oneImageView];

            
            self.vote2Lable = [[UILabel alloc]initWithFrame:CGRectMake(170, 5, 40, 20)];
            self.vote2Lable.textColor = [UIColor greenColor];
            self.vote2Lable.font = [UIFont fontWithName:@"Arial" size:12];
            self.vote2Lable.textAlignment = NSTextAlignmentCenter;
            self.vote2Lable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:self.vote2Lable];
            
            self.twoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(165, 25, 150, 150)];
            [self.twoImageView setImage:[UIImage imageNamed:@"Placeholder.png"] ];
            [cell.contentView addSubview:self.twoImageView];
            
            
            self.countLable = [[UILabel alloc]initWithFrame:CGRectMake(120, 180, 80, 20)];
            self.countLable.textColor = [UIColor blackColor];
            self.countLable.textAlignment = NSTextAlignmentCenter;
            self.countLable.font = [UIFont fontWithName:@"Arial" size:20];
            self.countLable.textAlignment = NSTextAlignmentCenter;
            self.countLable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:self.countLable];
            
            self.leftLable = [[UILabel alloc]initWithFrame:CGRectMake(30, 180, 40, 20)];
            self.leftLable.textColor = [UIColor redColor];
            self.leftLable.font = [UIFont fontWithName:@"Arial" size:16];
            self.leftLable.textAlignment = NSTextAlignmentCenter;
            self.leftLable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:self.leftLable];
            
            self.rightLable = [[UILabel alloc]initWithFrame:CGRectMake(250, 180, 40, 20)];
            self.rightLable.textColor = [UIColor greenColor];
            self.rightLable.textAlignment = NSTextAlignmentRight;
            self.rightLable.font = [UIFont fontWithName:@"Arial" size:16];
            self.rightLable.textAlignment = NSTextAlignmentCenter;
            self.rightLable.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:self.rightLable];
            
        }else{
            self.votes1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
            self.votes1.textColor = [UIColor redColor];
            self.votes1.font = [UIFont fontWithName:@"Arial" size:14];
            self.votes1.textAlignment = NSTextAlignmentCenter;
            self.votes1.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:self.votes1];
            
            self.votes2 = [[UILabel alloc]initWithFrame:CGRectMake(220, 0, 100, 30)];
            self.votes2.textColor = [UIColor greenColor];
            self.votes2.textAlignment = NSTextAlignmentRight;
            self.votes2.font = [UIFont fontWithName:@"Arial" size:14];
            self.votes2.textAlignment = NSTextAlignmentCenter;
            self.votes2.backgroundColor = [UIColor whiteColor];
            [cell.contentView addSubview:self.votes2];
        }
        
    }
    
    self.vote1Lable.text=[NSString stringWithFormat:@"%d%%",vote1count];
    self.vote2Lable.text=[NSString stringWithFormat:@"%d%%",vote2count];
    self.leftLable.text=[NSString stringWithFormat:@"%d%%",vote1count];
    self.rightLable.text=[NSString stringWithFormat:@"%d%%",vote2count];;

    if (indexPath.row != 0) {
        if ([leftVoters count] - 1 >= (indexPath.row - 1))
            self.votes1.text=[leftVoters objectAtIndex:(indexPath.row-1 )];
        if ([rightVoters count] - 1 >= (indexPath.row - 1))
           self.votes2.text=[rightVoters objectAtIndex:(indexPath.row-1 )];

    }
    ImageCache *cache = [ImageCache sharedObject];
    ImageDataFile *dataFile = [cache getImages:[rowObject objectId]];
    self.oneImageView.image = [UIImage imageWithData:[dataFile file1]];
    self.twoImageView.image = [UIImage imageWithData:[dataFile file2]];
    
    
           self.countLable.text=[NSString stringWithFormat:@"%d", [result count]];
    return cell;
}
-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 200;
    }else{
        return 30;
    }
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
