//
//  SettingViewController.m
//  Photo
//
//  Created by wangsh on 13-10-10.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "SettingViewController.h"
#import "SetDetailViewController.h"
#import "AppDelegate.h"
#import "UserDB.h"

@interface SettingViewController ()
{
    UITableView *myTableView;
    NSArray * dataArray;
    NSArray * array;
}
@end

@implementation SettingViewController

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
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(10, 0, 300, 460) style:UITableViewStyleGrouped];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    [self.view addSubview:myTableView];
    //background
    UIView *backgrdView = [[UIView alloc] initWithFrame:myTableView.frame];
    backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
    myTableView.backgroundView = backgrdView;
    dataArray = [[NSArray alloc]initWithObjects:@"删除上传",@"关于",@"注销登录", nil];
    array = [[NSArray alloc]initWithObjects:@"修改昵称",@"修改密码",@"修改头像", nil];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [array objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [dataArray objectAtIndex:indexPath.section-1];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SetDetailViewController * detailView = [[SetDetailViewController alloc]init];
        [detailView setString:[array objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:detailView animated:YES];
    }
    if (indexPath.section == 3) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"您确定要退出吗？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        alertView.delegate = self;
        [alertView show];
    }
}
#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UserDB *userDB = [[UserDB alloc] init];
        [userDB logout];
        [APPDELEGATE showLoginView];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
