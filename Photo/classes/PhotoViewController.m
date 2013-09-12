//
//  PhotoViewController.m
//  Photo
//
//  Created by wangshuai on 13-9-11.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "PhotoViewController.h"
#import "LoginViewController.h"
#import <arcstreamsdk/STreamSession.h>
#import <arcstreamsdk/STreamFile.h>

@interface PhotoViewController ()
{
   
    int clicked1;
    
}
@end

@implementation PhotoViewController



@synthesize imageView = _imageView;
@synthesize imageView2 = _imageView2;
@synthesize imagePicker = _imagePicker;
@synthesize message = _message;
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
    clicked1 = 0;
   
    
   
	// Do any additional setup after loading the view.
    
    self.title = @"Create a Decision";
    
    self.navigationController.navigationItem.backBarButtonItem = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(selectLeftAction:)];
    self.navigationItem.leftBarButtonItem = leftItem;
            
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 130, 130)];
        self.imageView .backgroundColor = [UIColor grayColor];
        self.imageView .userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [ self.imageView  addGestureRecognizer:singleTap];
        [self.view addSubview: self.imageView ];
    
    self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(170, 10, 130, 130)];
    self.imageView2 .backgroundColor = [UIColor grayColor];
    self.imageView2 .userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked2:)];
    [ self.imageView2  addGestureRecognizer:singleTap2];
    [self.view addSubview: self.imageView2 ];
    
    
    
       _message = [[UITextField alloc]initWithFrame:CGRectMake(20, 150, 280, 100)];
    _message.borderStyle =UITextBorderStyleLine;
    _message.backgroundColor = [UIColor grayColor];
    _message.delegate = self;
    [self.view addSubview:_message];
}
//UITextFied
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.message resignFirstResponder];
    return YES;
}
-(void) selectLeftAction:(UIBarButtonItem *)item {
//    LoginViewController *loginView = [[LoginViewController alloc]init];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) selectRightAction:(UIBarButtonItem *)item{
    
            STreamFile * file = [[STreamFile alloc]init];
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"two" ofType:@"jpg"];
            //    NSLog(@"imsgePath = %@",imagePath);
            [file postFile:imagePath finished:^(NSString *response){
                NSLog(@"res:%@",response);
            }byteSent:^(float percentage){
                NSLog(@"total:%f",percentage);
            }];
            
            NSString *test = _message.text;
            NSData *data = [test dataUsingEncoding:NSUTF8StringEncoding];
            NSMutableDictionary *metaData = [[NSMutableDictionary alloc]init];
            [metaData setObject:@"a" forKey:@"c"];
            [file setFileMetadata:metaData];
            [file postData:data finished:^(NSString *response){
                NSLog(@"res: %@", response);
                
            }byteSent:^(float percentage){
                NSLog(@"total: %f", percentage);
            }];
    NSLog(@"提交成功");
}

-(void) imageClicked:(UIImageView *)View{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==NO ) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera Unavailable" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (self.imagePicker == nil) {
        
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.delegate = self;
   }
//    if (View.tag == 10001) {
//        frame = self.imageView.frame;
//    }else{
//         frame = self.imageView.frame;
//    }
    clicked1 = 1;
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

-(void) imageClicked2:(UIImageView *)View{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==NO ) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Camera Unavailable" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    if (self.imagePicker == nil) {
        
        self.imagePicker = [[UIImagePickerController alloc]init];
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.delegate = self;
    }
   
   
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (clicked1 == 1)
       self.imageView.image = image;
    else
       self.imageView2.image = image;
    
    clicked1 = 0;
    
    NSData * imageData = UIImageJPEGRepresentation(image, 0.1);
//    NSData * imageData = UIImagePNGRepresentation(image);
//    STreamFile *file = [[STreamFile alloc] init];
//    
//    [file postData:imageData finished:^(NSString *response){
//        
//        NSLog(@"res: %@", response);
    
//
//    }byteSent:^(float percentage){
//        
//        NSLog(@"total: %f", percentage);
//        
//    }]; 
  
    
    self.imageView.contentMode =UIViewContentModeScaleAspectFill;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
