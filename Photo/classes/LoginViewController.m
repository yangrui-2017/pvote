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
#import "MBProgressHUD.h"
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
    //test commit from second edward
    
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
    [self.password setSecureTextEntry:YES];
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
    
    if (([self.name.text length]==0) && ([self.password.text length]==0)) {
        
        UIAlertView * view = [[UIAlertView alloc]initWithTitle:nil message:@"用户名和密码不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [view show];
        
    }else{
        
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"登录中...";
        [self.view addSubview:HUD];
        [HUD showWhileExecuting:@selector(loginUser) onTarget:self withObject:nil animated:YES];
    }
    
}
-(void)loginUser
{
    STreamUser *user = [[STreamUser alloc] init];
    [user logIn:self.name.text withPassword:self.password.text];
    NSString *error = [user errorMessage];
    NSLog(@"error = %@",error);
    if ([error length] == 0) {
        
        //初始化数据库
        sqlService *sqlSer = [[sqlService alloc] init];
        
        //数据库插入
		
		sqlTestList *sqlInsert = [[sqlTestList alloc]init];
		sqlInsert.name = self.name.text;
		sqlInsert.password = self.password.text;
		
		//调用封装好的数据库插入函数
		if ([sqlSer insertTestList:sqlInsert]) {
            NSLog(@"插入数据成功");
            //			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
            //															message:@"插入数据成功"
            //														   delegate:self
            //											      cancelButtonTitle:@"好"
            //											      otherButtonTitles:nil];
            //			[alert show];
		}else {
            NSLog(@"插入数据失败");
            //			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
            //															message:@"插入数据失败"
            //														   delegate:self
            //											      cancelButtonTitle:@"好"
            //											      otherButtonTitles:nil];
            //			[alert show];
        }
        MainViewController * mainView = [[MainViewController alloc]init];
        [self.navigationController pushViewController:mainView animated:YES];
        
    }else{
        
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"错误信息" message:@"该用户不存在，请先注册，谢谢" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
    }
}

//registerButtonClicked
-(void)registerButtonClicked{
    
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
    
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
