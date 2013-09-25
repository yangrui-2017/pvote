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
#import <arcstreamsdk/STreamUser.h>
#import <arcstreamsdk/STreamCategoryObject.h>
#import <arcstreamsdk/STreamFile.h>


@interface RegisterViewController ()
{
    BOOL isAddImage;
    UIAlertView *alertview;
}
@end

@implementation RegisterViewController
@synthesize nameText = _nameText;
@synthesize passwordText = _passwordText;
@synthesize rePassword = _rePassword;
@synthesize dateOfBirthText = _dateOfBirthText;
@synthesize genderText = _genderText;
@synthesize registerButton = _registerButton;
@synthesize genderArray = _genderArray;
@synthesize imageview =_imageview;
@synthesize myTableView = _myTableView;
@synthesize actionSheet = _actionSheet;

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
    
    self.title = @"注册";
    self.genderArray = [[NSArray alloc]initWithObjects:@"--Select Gender--",@"Male",@"Female", nil];
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height) style:UITableViewStylePlain];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorStyle=NO;//UITableView每个cell之间的默认分割线隐藏掉
    
    // 建立 UIDatePicker
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, -(self.view.bounds.size.height), self.view.bounds.size.width, 100)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    // 建立 UIToolbar
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0, 320, 44)];
     UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(cancelPicker)];
    toolBar.items = [NSArray arrayWithObject:right];

}
#pragma mark-------------tableView-------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellName =@"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, 20, 100, 100)];
        self.imageview.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        self.imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked)];
        [ self.imageview  addGestureRecognizer:singleTap];
        [self.myTableView addSubview:self.imageview];
        
        self.nameText = [[UITextField alloc]initWithFrame:CGRectMake(20, 140, self.view.frame.size.width - 40, 40)];
        self.nameText.placeholder = @"E-mail Name";
        self.nameText.borderStyle = UITextBorderStyleLine;
        self.nameText.delegate = self;
        [self.myTableView addSubview:self.nameText];
        
        self.passwordText = [[UITextField alloc]initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40,40)];
        self.passwordText.placeholder = @"Password";
        self.passwordText.borderStyle =UITextBorderStyleLine;
        self.passwordText.delegate = self;
        [self.passwordText setSecureTextEntry:YES];//
        [self.myTableView addSubview:self.passwordText];
        
        self.rePassword = [[UITextField alloc]initWithFrame:CGRectMake(20, 260, self.view.frame.size.width - 40, 40)];
        self.rePassword.placeholder = @"Re_type Password";
        self.rePassword.borderStyle = UITextBorderStyleLine;
        [self.rePassword setSecureTextEntry:YES];
        self.rePassword.delegate = self;
        [self.myTableView addSubview:self.rePassword];
        
        self.dateOfBirthText = [[UITextField alloc]initWithFrame:CGRectMake(20, 320, self.view.frame.size.width - 40, 40)];
        self.dateOfBirthText.placeholder = @"Date of birth";
        self.dateOfBirthText.borderStyle = UITextBorderStyleLine;
        self.dateOfBirthText.inputView = datePicker;
        self.dateOfBirthText.inputAccessoryView = toolBar;
        self.dateOfBirthText.delegate = self;
        [self.myTableView addSubview:self.dateOfBirthText];
//        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(20, 320, self.view.frame.size.width - 40, 40);
//        [button addTarget:self action:@selector(pickerAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.myTableView addSubview:button];
        
        self.genderText = [[UITextField alloc]initWithFrame:CGRectMake(20, 380, self.view.frame.size.width - 40, 40)];
        self.genderText.placeholder = @"Gender";
        self.genderText.borderStyle = UITextBorderStyleLine;
        self.genderText.delegate = self;
        [self.myTableView addSubview:self.genderText];
        
        UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dateButton.frame = CGRectMake(20, 380, self.view.frame.size.width - 40, 40);
        [dateButton addTarget:self action:@selector(dateButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.myTableView addSubview:dateButton];
        
        self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.registerButton setFrame:CGRectMake(20, 440, self.view.frame.size.width - 40, 40)];
        [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [self.registerButton addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.myTableView addSubview:self.registerButton];
    }
    
    return cell;
    
}
//done
-(void) cancelPicker {
    if ([self.view endEditing:NO]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:datelocale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:datelocale];
        self.dateOfBirthText.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _myTableView.bounds.size.height+150;//416
}
//registerButton
-(void) registerClicked:(UIButton *)button {
    if ([self.passwordText.text isEqualToString:self.rePassword.text]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.labelText = @"注册中...";
        [self.view addSubview:HUD];
        [HUD showWhileExecuting:@selector(registerUser) onTarget:self withObject:nil animated:YES];
       
    }else{
        alertview = [[UIAlertView alloc]initWithTitle:@"Error" message:@"两次输入密码不同，请重新输入" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(performDismiss:) userInfo:nil repeats:YES];
        [alertview show];
    }
    
}

-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)registerUser{
    
    UIImage *sImage = [self imageWithImageSimple:self.imageview.image scaledToSize:CGSizeMake(120.0, 120.0)];
    NSData *postData = UIImageJPEGRepresentation(sImage, 0.1);
    STreamFile *file = [[STreamFile alloc] init];
    __block NSString *res;
    [file postData:postData finished:^(NSString *response){
        NSLog(@"res: %@", response);
        res = response;
    }byteSent:^(float percentage){
        NSLog(@"total: %f", percentage);
    }];

    while (res== nil){
        sleep(3);
    }
    if ([res isEqualToString:@"ok"]){
        STreamUser *user = [[STreamUser alloc] init];
        NSMutableDictionary *metaData = [[NSMutableDictionary alloc] init];
        [metaData setValue:self.nameText.text forKey:@"name"];
        [metaData setValue:self.passwordText.text forKey:@"password"];
        [metaData setValue:self.genderText.text forKey:@"gender"];
        [metaData setValue:self.dateOfBirthText.text forKey:@"dateOfBirth"];
        [metaData setValue:[file fileId] forKey:@"profileImageId"];
        [user signUp:self.nameText.text withPassword:self.passwordText.text withMetadata:metaData];
    
        NSString *error = [user errorMessage];
        if ([error isEqualToString:@""]){
            STreamCategoryObject *scov = [[STreamCategoryObject alloc] initWithCategory:@"Voted"];
            STreamObject *so = [[STreamObject alloc] init];
            [so setObjectId:self.nameText.text];
            NSMutableArray *allvoted = [[NSMutableArray alloc] init];
            [allvoted addObject:so];
            [scov updateStreamCategoryObjects:allvoted];
            STreamObject *follower = [[STreamObject alloc]init];
            STreamObject *following = [[STreamObject alloc]init];
            [follower setObjectId:[NSString stringWithFormat:@"%@Follower",self.nameText.text]];
            [following setObjectId:[NSString stringWithFormat:@"%@Following",self.nameText.text]];
            [follower createNewObject:^(BOOL succeed, NSString *response){
                if (!succeed)
                    NSLog(@"res: %@", response);
            }];
            [following createNewObject:^(BOOL succeed, NSString *response){
                if (!succeed)
                    NSLog(@"res: %@", response);
            }];
        }else{
        
        }
        NSLog(@"%@", error);
        
    }
    
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
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
-(void)performDismiss:(NSTimer *)timer{
    
    [alertview dismissWithClickedButtonIndex:0 animated:YES];

}
- (void)pickerAction {
	PickerAlertView *pickerAlertView = [[PickerAlertView alloc] initWithTitle:@" " message:@" " delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[pickerAlertView show];
}
//----pick actionsheet
- (void)dateButton:(UIButton *)btn {
	self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    UIPickerView * pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 80)] ;
    pickerView.tag = 101;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [self.actionSheet addSubview:pickerView];
    
    UISegmentedControl* button = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Done",nil]];
    button.tintColor = [UIColor grayColor];
    [button setSegmentedControlStyle:UISegmentedControlStyleBar];
    [button setFrame:CGRectMake(250, 10, 50,30 )];
    [button addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.actionSheet addSubview:button];
    [self.actionSheet showInView:self.view];
    [self.actionSheet setBounds:CGRectMake(0, 0, 320,300)];
    [self.actionSheet setBackgroundColor:[UIColor whiteColor]];
}
-(void)segmentAction:(UISegmentedControl*)seg{
    NSInteger index = seg.selectedSegmentIndex;
    NSLog(@"%d",index);
    [self.actionSheet dismissWithClickedButtonIndex:index animated:YES];
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(PickerAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
	
    if (isAddImage) {
        if (buttonIndex == 1)
        {
            [self addPhoto];
        }
        else if(buttonIndex == 2)
        {
            [self takePhoto];
        }
        isAddImage = NO;

    }else{
        NSString *dateFromData = [NSString stringWithFormat:@"%@",alertView.datePickerView.date];
        NSString *date = [dateFromData substringWithRange:NSMakeRange(0, 10)];
        self.dateOfBirthText.text = date;
        NSLog(@"date %@...%@",date,alertView.datePickerView.date);
    }
    
}

//image
-(void) imageClicked{
    isAddImage = YES;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"插入图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"系统相册",@"拍摄", nil];
    [alert show];
    
}
#pragma mark - Tool Methods
- (void)addPhoto
{
    UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.navigationBar.tintColor = [UIColor colorWithRed:72.0/255.0 green:106.0/255.0 blue:154.0/255.0 alpha:1.0];
	imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	imagePickerController.delegate = self;
	imagePickerController.allowsEditing = NO;
	[self presentViewController:imagePickerController animated:YES completion:NULL];
    

}

- (void)takePhoto
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"该设备不支持拍照功能"
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"好", nil];
        [alert show];
    }
    else
    {
        UIImagePickerController * imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = NO;
        [self presentViewController:imagePickerController animated:YES completion:NULL];
      
    }
}


#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage * image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.imageview.image = image;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
