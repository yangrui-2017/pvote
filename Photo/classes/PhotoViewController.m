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
#import <arcstreamsdk/STreamCategoryObject.h>
#import <arcstreamsdk/STreamObject.h>
#import "MBProgressHUD.h"
#import "ImageCache.h"
#import "MainViewController.h"
#import "AppDelegate.h"
@interface PhotoViewController ()
{
   
    int clicked1;
    NSData *imageData1;
    NSData *imageData2;
    STreamFile *file1;
    STreamFile *file2;
    UIToolbar* keyboardDoneButtonView;
}
@end

@implementation PhotoViewController



@synthesize imageView = _imageView;
@synthesize imageView2 = _imageView2;
@synthesize imagePicker = _imagePicker;
@synthesize message = _message;
@synthesize myTableView = _myTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)pickerDoneClicked
{
    UITextView* view = (UITextView*)[self.view viewWithTag:1001];
    [view resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    clicked1 = 0;
    
    self.title = @"拍 照";
    
    keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleDefault;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
//    UIBarButtonItem *SpaceButton=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                               target:nil  action:nil];
//    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成"
//                                                                   style:UIBarButtonItemStyleDone target:self
//                                                                  action:@selector(pickerDoneClicked)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    self.navigationController.navigationItem.backBarButtonItem = NO;

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(selectRightAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStyleDone target:self action:@selector(selectLeftAction:)];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-self.navigationController.navigationBar.bounds.size.height) style:UITableViewStylePlain];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.myTableView];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.myTableView.separatorStyle=NO;//UITableView每个cell之间的默认分割线隐藏掉
    //background
    UIView *backgrdView = [[UIView alloc] initWithFrame:_myTableView.frame];
    backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
    _myTableView.backgroundView = backgrdView;
}
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
        
        UIView *backgrdView = [[UIView alloc] initWithFrame:cell.frame];
        backgrdView.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
        cell.backgroundView = backgrdView;
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 150, 150)];
       // self.imageView .backgroundColor = [UIColor lightGrayColor];
        self.imageView .userInteractionEnabled = YES;
        [self.imageView setImage:[UIImage imageNamed:@"upload.png"]];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [ self.imageView  addGestureRecognizer:singleTap];
        [cell addSubview: self.imageView ];
        
        self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 10, 150, 150)];
        //self.imageView2 .backgroundColor = [UIColor lightGrayColor];
        [self.imageView2 setImage:[UIImage imageNamed:@"upload.png"]];
        self.imageView2 .userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked2:)];
        [ self.imageView2  addGestureRecognizer:singleTap2];
        [cell addSubview: self.imageView2 ];
        
        
        
        _message = [[UITextView alloc]initWithFrame:CGRectMake(20, 160, 280, 100)];
        _message.keyboardType = UIKeyboardTypeASCIICapable;
        _message.font = [UIFont systemFontOfSize:20];
        _message.backgroundColor = [UIColor grayColor];
        _message.text = @"请输入此刻想法40字之内";
        _message.textColor = [UIColor lightGrayColor];
        _message.delegate = self;
        _message.tag =1001;
        _message.inputAccessoryView =keyboardDoneButtonView;
        [cell addSubview:_message];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _myTableView.bounds.size.height+80;//
}
//UITextView
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if (textView.text.length>40)
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入超过40个字了" delegate:nil cancelButtonTitle:@"返回" otherButtonTitles: nil];
        alert.delegate = self;
        [alert show];
        return NO;
    }
    else
    {
        return YES;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        return YES;
    }

}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    _message.text=@"";
    _message.textColor = [UIColor blackColor];
    return YES;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     [_message resignFirstResponder];
}

-(void) selectRightAction:(UIBarButtonItem *)item{
    
    file1 = [[STreamFile alloc] init];
    
    [file1 postData:imageData1 finished:^(NSString *response){
            NSLog(@"res: %@", response);
           file2 = [[STreamFile alloc] init];
           [file2 postData:imageData2 finished:^(NSString *response){
            NSLog(@"res: %@", response);
          }byteSent:^(float percentage){
            NSLog(@"total: %f", percentage);
          }];
        }byteSent:^(float percentage){
            NSLog(@"total: %f", percentage);
     }];
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"提交中...";
    [HUD showAnimated:YES whileExecutingBlock:^{
        [self upload];
    } completionBlock:^{
        if ([file1 fileId] != nil && [file2 fileId] != nil)
            [APPDELEGATE showLoginSucceedView];
    }];
    
}

- (void)upload{
    sleep(5);
    NSString *file1Id = [file1 fileId];
    NSString *file2Id = [file2 fileId];
    int loopCount = 0;
    while(file1Id == nil || file2Id == nil){
        sleep(2);
        loopCount++;
        if (loopCount > 18)
            break;
        file1Id = [file1 fileId];
        file2Id = [file2 fileId];
    }
    
    if (file1Id == nil || file2Id == nil)
        return;
    
    NSDate *now = [[NSDate alloc] init];
    long millionsSecs = [now timeIntervalSince1970];
    int i = arc4random();
    long unique = millionsSecs + i;
    
    NSString *longValue = [NSString stringWithFormat:@"%lu", unique];
    
    ImageCache *cache = [[ImageCache alloc] init];
    NSString *userName = [cache getLoginUserName];
    
    STreamObject *vote = [[STreamObject alloc] init];
    [vote setObjectId:longValue];
    [vote addStaff:@"file1" withObject:file1Id];
    [vote addStaff:@"file2" withObject:file2Id];
    [vote addStaff:@"message" withObject:_message.text];
    [vote addStaff:@"userName" withObject:userName];
    
    STreamCategoryObject *scov = [[STreamCategoryObject alloc] initWithCategory:@"AllVotes"];
    NSMutableArray *av = [[NSMutableArray alloc] init];
    [av addObject:vote];
    [scov updateStreamCategoryObjects:av];
    
    STreamObject *comments = [[STreamObject alloc] init];
    [comments setObjectId:longValue];
    [comments createNewObject:^(BOOL succeed, NSString *response){
        
    }];
    /*NSMutableDictionary *newComment = [[NSMutableDictionary alloc] init];
    [newComment setObject:@"" forKey:@"content"];
    [comments addStaff:longValue withObject:newComment];
    [comments update];*/
    
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
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (clicked1 == 1){
       self.imageView.image = image;
       UIImage *sImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(150.0, 150.0)];
      // imageData1 = UIImageJPEGRepresentation(image, 1);
       imageData1 = UIImageJPEGRepresentation(sImage, 0.3);
    }
    else{
       self.imageView2.image = image;
       UIImage *sImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(150.0, 150.0)];
     //  imageData2 = UIImageJPEGRepresentation(image, 1);
       imageData2 = UIImageJPEGRepresentation(sImage, 0.3);

    }
    
    clicked1 = 0;
    [self dismissViewControllerAnimated:YES completion:NULL];
}


-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
