 //
//  LoginViewController.m
//  Photo
//
//  Created by wangshuai on 13-9-11.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "LoginViewController.h"
#import "PhotoViewController.h"
#import "RegisterViewController.h"
#import "MainViewController.h"
#import <arcstreamsdk/STreamUser.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UserInformationViewController.h"
#import "InformationViewController.h"
#import "FireViewController.h"
#import "ImageCache.h"
#import "UserDB.h"


@interface LoginViewController ()
{
    MBProgressHUD *HUD;
    STreamUser *user;
//    NSMutableArray *dataArray;
}
@end

@implementation LoginViewController
@synthesize name = _name;
@synthesize password =_password;
@synthesize loginButton = _loginButton;
@synthesize registerButton = _registerButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSString *)dataFilePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:KFilename];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //test commit from second edward
    self.title = @"登录";
    self.name = [[UITextField alloc]initWithFrame:CGRectMake(30, 70, 260, 40)];
    self.name.placeholder=@"E-mail";
    self.name.borderStyle = UITextBorderStyleLine;
    self.name.delegate =self;
    [self.view addSubview: self.name];
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(30, 120, 260, 40)];
    self.password.placeholder=@"Password";
    self.password.borderStyle = UITextBorderStyleLine;
    [self.password setSecureTextEntry:YES];
    self.password.delegate =self;
    [self.view addSubview: self.password];
    //loginbutton 
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton setFrame:CGRectMake(30, 170, 260, 40)];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    //注册 registerButton
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.registerButton setFrame:CGRectMake(30, 230, 260,40)];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
//
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        
        NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
        self.name.text = [array objectAtIndex:[array count]-2];
        self.password.text = [array objectAtIndex:[array count]-1];
    }
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:app];
    
}
-(void)applicationWillResignActive:(NSNotification *) notification{
    
    NSMutableArray * array = [[NSMutableArray alloc]init];
    [array addObject:self.name.text];
    [array addObject:self.password.text];
    [array writeToFile:[self dataFilePath] atomically:YES];
    
}
//loginButton
-(void)loginButtonClicked{
    
    if (([self.name.text length]==0) && ([self.password.text length]==0)) {
        
        UIAlertView * view = [[UIAlertView alloc]initWithTitle:nil message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
        
    }else{
        
        
        
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"登录中...";
        [self.view addSubview:HUD];
        user = [[STreamUser alloc] init];
        
       // UserDB *userDB = [[UserDB alloc] init];
       // [userDB logout];
        
        ImageCache *cache = [ImageCache sharedObject];
        NSString *userName = [cache getLoginUserName];
        NSLog(@"%@", userName);
        
        [cache setLoginUserName:_name.text];
        
        [HUD showAnimated:YES whileExecutingBlock:^{
            [self loginUser];
        } completionBlock:^{
           if ([[user errorMessage] length] == 0) {
               APPDELEGATE.loginSuccess = YES;
               [APPDELEGATE showLoginSucceedView];
            }else{
               UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误信息" message:@"该用户不存在，请先注册，谢谢" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertview show];
            }
            [HUD removeFromSuperview];
            HUD = nil;
        }];
    }
    
}
-(void)loginUser
{
    NSLog(@"name = %@,pass= %@",self.name.text,self.password.text);
    [user logIn:self.name.text withPassword:self.password.text];
    UserDB *userDB = [[UserDB alloc] init];
    [userDB insertDB:0 name:self.name.text withPassword:self.password.text];
    
    NSString *error = [user errorMessage];
    NSLog(@"error = %@",error);

}

//registerButtonClicked
-(void)registerButtonClicked{
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}
//UITextFied
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
