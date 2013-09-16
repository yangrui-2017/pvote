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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//init

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"MainPage";
    
    votes = [[STreamCategoryObject alloc] initWithCategory:@"allVotes"];
       
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.view addSubview:self.myTableView];
    self.myDataArray = [[NSMutableArray alloc]init];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"读取中...";
    [self.view addSubview:HUD];
    
    [HUD showWhileExecuting:@selector(loadVotes) onTarget:self withObject:nil animated:YES];
    allVotes = [[NSMutableArray alloc] init];
    
}

- (void)loadVotes{
    
    votesArray = [votes load];

  
    for (STreamObject *so in votesArray){
        STreamQuery *query = [[STreamQuery alloc] initWithCategory:[so getValue:@"userName"]];
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
    
//    NSString *message = [so getValue:@"message"];
//    
//    NSString *file1 = [so getValue:@"file1"];
//    NSString *file2 = [so getValue:@"file2"];
    
    /*STreamFile *file1file = [[STreamFile alloc] init];
    [file1file downloadAsData:file1 downloadedData:^(NSData *imageData){
        
    }];*/
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 80)];
        [self.imageView setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:self.imageView];
        
        self.name = [[UITextField alloc]initWithFrame:CGRectMake(90, 5, 200, 30)];
        self.name.borderStyle = UITextBorderStyleLine;
        self.name.enabled = NO;
        [cell.contentView addSubview:self.name];
        
        self.message = [[UITextField alloc]initWithFrame:CGRectMake(90, 40, 200, 40)];
        self.message.borderStyle = UITextBorderStyleLine;
        //     self.message.text = [so getValue:@"message"];
        self.message.enabled = NO;
        [cell.contentView addSubview:self.message];
        
        self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 100, 150, 150)];
        [self.oneImageView setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:self.oneImageView];
        
        self.twoImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(165, 100, 150, 150)];
        [self.twoImageView setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:self.twoImageView];

    }
    STreamObject *so = [allVotes objectAtIndex:indexPath.row];
    self.message.text = [so getValue:@"message"];
    
    NSString *file1 = [so getValue:@"file1"];
    NSString *file2 = [so getValue:@"file2"];
    
    ImageCache *imageCache = [ImageCache sharedObject];
    
       
    if ([imageCache getImages:[so objectId]] != nil){
        ImageDataFile *files = [imageCache getImages:[so objectId]];
        self.oneImageView.image = [UIImage imageWithData:[files file1]];
        self.twoImageView.image = [UIImage imageWithData:[files file2]];
    }else{
        ImageDownload *imageDownload = [[ImageDownload alloc] init];
        [imageDownload dowloadFile:file1 withFile2:file2 withObjectId:[so objectId]];
        [imageDownload setMainRefesh:self];
    }
    
    //取消选中颜色
//    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
//    cell.selectedBackgroundView = backView;
//    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
   

    return cell;
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
