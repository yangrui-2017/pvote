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
@synthesize ImageArray = _ImageArray;

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
//        [self.message setLineBreakMode:NSLineBreakByWordWrapping];
//        self.message .highlightedTextColor = [UIColor whiteColor];
//        self.message.adjustsLetterSpacingToFitWidth = YES;
//        self.message .numberOfLines = 0;
//        self.message .opaque = NO; // 选中Opaque表示视图后面的任何内容都不应该绘制
        self.message .backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:self.message];
        
        self.oneImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 100, 150, 150)];
        [self.oneImageView setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:self.oneImageView];
        
        self.twoImageView = [[UIImageView  alloc]initWithFrame:CGRectMake(165, 100, 150, 150)];
        [self.twoImageView setBackgroundColor:[UIColor grayColor]];
        [cell.contentView addSubview:self.twoImageView];
    }
    STreamObject *so = [allVotes objectAtIndex:indexPath.row];
    NSString *message = [so getValue:@"message"];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];

    CGRect cellFrame = [cell frame];
    cellFrame.origin = CGPointMake(0, 0);
    
    label.text = message;
    CGRect rect = CGRectInset(cellFrame, 2, 2);
    label.frame = rect;
    [label sizeToFit];
    if (label.frame.size.height > 30) {
        cellFrame.size.height = 50 + label.frame.size.height - 46;
    }
    else {
        cellFrame.size.height = 300;
    }
    [cell setFrame:cellFrame];
    
    self.message.text = message;
    self.name.text = [self.myDataArray objectAtIndex:indexPath.row];
    
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
    UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView = backView;
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];

    return cell;
}

- (void)reloadTable{
    [self.myTableView reloadData];
}
-(CGFloat)getCellHeight:(NSInteger)row
{
    // 列寬
    CGFloat contentWidth =self.view.frame.size.width-90;
    CGFloat height = 0.0;
    // 设置字体
    UIFont *font = [UIFont fontWithName:@"CourierNewPSMT" size:14];
    
    if (allVotes.count != 0) {
        STreamObject *so = [allVotes objectAtIndex:row];
        // 显示的内容
        NSString *message = [so getValue:@"message"];        
        // 计算出显示完內容需要的最小尺寸
        CGSize size = [message sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 3000)];
        
        
        if (size.height+200<300) {
            height = 300;
        }else
        {
            height = size.height+60;//40
        }
    }    // 返回需要的高度
    return height;
    
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self getCellHeight:indexPath.row];

//    return 300;
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
