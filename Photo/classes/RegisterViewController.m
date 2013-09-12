//
//  RegisterViewController.m
//  Photo
//
//  Created by wangshuai on 13-9-12.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "RegisterViewController.h"
#import "MBProgressHUD.h"
#import "PickerAlertView.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize nameText = _nameText;
@synthesize passwordText = _passwordText;
@synthesize rePassword = _rePassword;
@synthesize dateOfBirthText = _dateOfBirthText;
@synthesize genderText = _genderText;
@synthesize registerButton = _registerButton;
@synthesize selectPicker =_selectPicker;
@synthesize genderArray = _genderArray;

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
    
//    NSArray *array = [[NSArray alloc]initWithObjects:@"--Select Gender--",@"Male",@"Female", nil];
    
    self.genderArray = [[NSArray alloc]initWithObjects:@"--Select Gender--",@"Male",@"Female", nil];
    self.selectPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 100)];
    self.selectPicker.delegate = self;
    self.selectPicker.dataSource = self;
    self.selectPicker.showsSelectionIndicator = YES;
    [self.view addSubview:self.selectPicker];
//
    self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 40)];
    self.nameText.placeholder = @"E-mail Name";
    self.nameText.borderStyle = UITextBorderStyleLine;
    self.nameText.delegate = self;
    [self.view addSubview:self.nameText];
    
    self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40,40)];
    self.passwordText.placeholder = @"Password";
    self.passwordText.borderStyle =UITextBorderStyleLine;
    self.passwordText.delegate = self;
    [self.view addSubview:self.passwordText];
    
    self.rePassword = [[UITextField alloc]initWithFrame:CGRectMake(20, 140, self.view.frame.size.width - 40, 40)];
    self.rePassword.placeholder = @"Re_type Password";
    self.rePassword.borderStyle = UITextBorderStyleLine;
    self.rePassword.delegate = self;
    [self.view addSubview:self.rePassword];
    
    self.dateOfBirthText = [[UITextField alloc]initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40, 40)];
    self.dateOfBirthText.placeholder = @"Date of birth";
    self.dateOfBirthText.borderStyle = UITextBorderStyleLine;
    self.dateOfBirthText.delegate = self;
    [self.view addSubview:self.dateOfBirthText];
    
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = CGRectMake(20, 200, self.view.frame.size.width - 40, 40);
	[button addTarget:self action:@selector(pickerAction) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:button];
    
    self.genderText = [[UITextField alloc]initWithFrame:CGRectMake(20, 260, self.view.frame.size.width - 40, 40)];
    self.genderText.placeholder = @"Gender";
    self.genderText.borderStyle = UITextBorderStyleLine;
    self.genderText.inputView = self.selectPicker;
    self.genderText.delegate = self;
    
    [self.view addSubview:self.genderText];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.registerButton setFrame:CGRectMake(20, 320, self.view.frame.size.width - 40, 40)];
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchDragInside];
    [self.view addSubview:self.registerButton];
    
    
    
}
//registerButton
-(void) registerClicked:(UIButton *)button {

    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText = @"注册中...";
    [self.view addSubview:HUD];
    [HUD showWhileExecuting:@selector(test) onTarget:self withObject:nil animated:YES];
    //    STreamUser *user = [[STreamUser alloc] init];
    //    NSMutableDictionary *metaData = [[NSMutableDictionary alloc] init];
    //    [user signUp:self.name.text withPassword:self.password.text withMetadata:metaData response:^(BOOL succeed, NSString *response){
    //        if (succeed)
    //            NSLog(@"userSignup passed OK");
    //        else{
    //
    //        }
    //    }];
}
- (void)test{
    sleep(5);
}
//* UIPickerView
-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.genderArray count];
    
}
-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.genderArray objectAtIndex:row];
}
-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.genderText.text = [self.genderArray objectAtIndex:row];
}
//UITextFied
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
    [self.rePassword resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.dateOfBirthText]) {
        [self.view setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
    if ([textField isEqual:self.genderText]) {
    
        [self.view setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
        
    }
}

- (void)pickerAction {
	PickerAlertView *pickerAlertView = [[PickerAlertView alloc] initWithTitle:@" " message:@" " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[pickerAlertView show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(PickerAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	NSString *dateFromData = [NSString stringWithFormat:@"%@",alertView.datePickerView.date];
	NSString *date = [dateFromData substringWithRange:NSMakeRange(0, 10)];
	self.dateOfBirthText.text = date;
	NSLog(@"date %@...%@",date,alertView.datePickerView.date);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
