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

@interface PhotoViewController ()
{
   
    int clicked1;
    NSData *imageData1;
    NSData *imageData2;
    STreamFile *file1;
    STreamFile *file2;
 
    
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    clicked1 = 0;
    
    self.title = @"拍 照";
    
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
    
//        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, 130, 130)];
//        self.imageView .backgroundColor = [UIColor grayColor];
//        self.imageView .userInteractionEnabled = YES;
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
//        [ self.imageView  addGestureRecognizer:singleTap];
//        [self.view addSubview: self.imageView ];
//    
//    self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(170, 80, 130, 130)];
//    self.imageView2 .backgroundColor = [UIColor grayColor];
//    self.imageView2 .userInteractionEnabled = YES;
//    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked2:)];
//    [ self.imageView2  addGestureRecognizer:singleTap2];
//    [self.view addSubview: self.imageView2 ];
//    
//    
//    
//    _message = [[UITextField alloc]initWithFrame:CGRectMake(20, 230, 280, 100)];
//    _message.borderStyle =UITextBorderStyleLine;
//    _message.backgroundColor = [UIColor grayColor];
//    _message.delegate = self;
//    [self.view addSubview:_message];
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
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 130, 130)];
        self.imageView .backgroundColor = [UIColor grayColor];
        self.imageView .userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [ self.imageView  addGestureRecognizer:singleTap];
        [cell addSubview: self.imageView ];
        
        self.imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(170, 10, 130, 130)];
        self.imageView2 .backgroundColor = [UIColor grayColor];
        self.imageView2 .userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked2:)];
        [ self.imageView2  addGestureRecognizer:singleTap2];
        [cell addSubview: self.imageView2 ];
        
        
        
        _message = [[UITextField alloc]initWithFrame:CGRectMake(20, 160, 280, 100)];
        _message.borderStyle =UITextBorderStyleLine;
        _message.backgroundColor = [UIColor grayColor];
        _message.delegate = self;
        [cell addSubview:_message];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _myTableView.bounds.size.height;//416
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
    
    file1 = [[STreamFile alloc] init];
    
    [file1 postData:imageData1 finished:^(NSString *response){
            NSLog(@"res: %@", response);
        }byteSent:^(float percentage){
            NSLog(@"total: %f", percentage);
     }];
    

    file2 = [[STreamFile alloc] init];
    
    [file2 postData:imageData2 finished:^(NSString *response){
        NSLog(@"res: %@", response);
    }byteSent:^(float percentage){
        NSLog(@"total: %f", percentage);
    }];
    
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"提交中...";
    [HUD showWhileExecuting:@selector(test) onTarget:self withObject:nil animated:YES];
    
}

- (void)test{
    sleep(5);
    NSString *file1Id = [file1 fileId];
    NSString *file2Id = [file2 fileId];
    while(file1Id == nil || file2Id == nil){
        sleep(2);
        file1Id = [file1 fileId];
        file2Id = [file2 fileId];
    }
    
    NSDate *now = [[NSDate alloc] init];
    long millionsSecs = [now timeIntervalSince1970];
    NSString *longValue = [NSString stringWithFormat:@"%lu", millionsSecs];
    
    ImageCache *cache = [[ImageCache alloc] init];
    NSString *userName = [cache getLoginUserName];
    
    STreamObject *o1 = [[STreamObject alloc] init];
    NSNumber *file1vote = [NSNumber numberWithInt:0];
    NSNumber *file2vote = [NSNumber numberWithInt:0];
    [o1 setObjectId:longValue];
    [o1 addStaff:@"file1" withObject:file1Id];
    [o1 addStaff:@"file2" withObject:file2Id];
    [o1 addStaff:@"file1vote" withObject:file1vote];
    [o1 addStaff:@"file2vote" withObject:file2vote];
    [o1 addStaff:@"message" withObject:_message.text];
    
    STreamObject *vote = [[STreamObject alloc] init];
    [vote setObjectId:longValue];
    [vote addStaff:@"userName" withObject:userName];
    
    
    STreamCategoryObject *sco = [[STreamCategoryObject alloc] initWithCategory:userName];
    NSMutableArray *na = [[NSMutableArray alloc] init];
    [na addObject:o1];
    [sco updateStreamCategoryObjects:na];
    
   
    STreamCategoryObject *scov = [[STreamCategoryObject alloc] initWithCategory:@"allVotes"];
    NSMutableArray *av = [[NSMutableArray alloc] init];
    [av addObject:vote];
    [scov updateStreamCategoryObjects:av];
    
    
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
      // imageData1 = UIImageJPEGRepresentation(image, 0.1);
       imageData1 = UIImageJPEGRepresentation(sImage, 1);
    }
    else{
       self.imageView2.image = image;
       UIImage *sImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(150.0, 150.0)];
     //  imageData2 = UIImageJPEGRepresentation(image, 0.1);
       imageData2 = UIImageJPEGRepresentation(sImage, 1);

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
