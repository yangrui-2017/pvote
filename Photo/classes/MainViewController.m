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
#import "MBProgressHUD.h"
#import "ImageCache.h"
#import "ImageDownload.h"


@interface MainViewController (){
    STreamCategoryObject *votes;
    NSMutableArray *votesArray;
    NSMutableArray *allVotes;
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
    self.title = @"MainPage";
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
    static NSString *cellName = @"cellName";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 80)];
        [self.imageView setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:self.imageView];
        
        self.name = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, 200, 30)];
        self.name.enabled = NO;
        [cell.contentView addSubview:self.name];
        
        self.message = [[UILabel alloc]initWithFrame:CGRectMake(90, 40, 200, 30)];
        self.message .backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.message];
        
        self.vote1Lable = [[UILabel alloc]initWithFrame:CGRectMake(110, 80, 40, 20)];
        self.vote1Lable.textColor = [UIColor redColor];
        self.vote1Lable.textAlignment = NSTextAlignmentCenter;
        self.vote1Lable.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:self.vote1Lable];
        
        self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 100, 150, 150)];
        [self.oneImageView setBackgroundColor:[UIColor grayColor]];
        self.oneImageView.userInteractionEnabled = YES;
        [cell.contentView addSubview:self.oneImageView];
        
        self.vote2Lable = [[UILabel alloc]initWithFrame:CGRectMake(170, 80, 40, 20)];
        self.vote2Lable.textColor = [UIColor redColor];
        self.vote2Lable.textAlignment = NSTextAlignmentCenter;
        self.vote2Lable.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:self.vote2Lable];
        
        self.twoImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(165, 100, 150, 150)];
        [self.twoImageView setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:self.twoImageView];
    }
    STreamObject *so = [allVotes objectAtIndex:indexPath.row];
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
        self.oneImageView.image = [UIImage imageWithData:[files file1]];
        self.twoImageView.image = [UIImage imageWithData:[files file2]];
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

- (void)reloadTable{
    [self.myTableView reloadData];
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
