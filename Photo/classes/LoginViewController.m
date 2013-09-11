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
@interface LoginViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //test commit
    
    self.title = @"login";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"next" style:UIBarButtonItemStyleDone target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.name = [[UITextField alloc]initWithFrame:CGRectMake(30, 20, 260, 40)];
    self.name.placeholder=@"E-mail";
    self.name.borderStyle = UITextBorderStyleLine;
    self.name.delegate =self;
    [self.view addSubview: self.name];
    
    self.password = [[UITextField alloc]initWithFrame:CGRectMake(30, 80, 260, 40)];
    self.password.placeholder=@"Password";
    self.password.borderStyle = UITextBorderStyleLine;
    self.password.delegate =self;
    [self.view addSubview: self.password];
    //loginbutton 
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.loginButton setFrame:CGRectMake(30, 160, 260, 40)];
    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    //注册 registerButton
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.registerButton setFrame:CGRectMake(30, 220, 260,40)];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];

    
}
//loginButton
-(void)loginButtonClicked{
    STreamUser *user = [[STreamUser alloc] init];
    
    [user logIn:self.name.text withPassword:self.password.text response:^(BOOL succeed, NSString *response){
        
        if (succeed){
            
            NSLog(@"登陆成功");
        
            MainViewController *mainView = [[MainViewController alloc]init];
            [self.navigationController pushViewController:mainView animated:YES];
        
        }else {
            
            NSLog(@"登陆失败");
            
        }
        
    }];
    
    MainViewController *mainView = [[MainViewController alloc]init];
    [self.navigationController pushViewController:mainView animated:YES];
}
//registerButtonClicked
-(void)registerButtonClicked{
    STreamUser *user = [[STreamUser alloc] init];
    NSMutableDictionary *metaData = [[NSMutableDictionary alloc] init];
    
    [user signUp:self.name.text withPassword:self.password.text withMetadata:metaData response:^(BOOL succeed, NSString *response){
        
        if (succeed)
            NSLog(@"userSignup passed OK");
        else{
            
        }
        
    }];
    
}
//UITextFied
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.name resignFirstResponder];
    [self.password resignFirstResponder];
    return YES;
}
-(void) selectRightAction:(UIBarButtonItem *)item{
    PhotoViewController * photoView = [[PhotoViewController alloc]init];
    [self.navigationController pushViewController:photoView animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
