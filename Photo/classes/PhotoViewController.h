//
//  PhotoViewController.h
//  Photo
//
//  Created by wangshuai on 13-9-11.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    
}
@property (strong ,nonatomic) UIImageView * imageView2;
@property (strong ,nonatomic) UIImageView * imageView;
@property (strong ,nonatomic) UIImagePickerController *imagePicker;
@property (strong ,nonatomic) UITextField *message;
@end
