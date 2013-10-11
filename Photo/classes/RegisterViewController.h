//
//  RegisterViewController.h
//  Photo
//
//  Created by wangshuai on 13-9-12.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    UIDatePicker *datePicker;
    NSLocale *datelocale;
    UIToolbar *toolBar;
}
@property (strong,nonatomic) UITextField *nameText;
@property (strong,nonatomic) UITextField *passwordText;
@property (strong,nonatomic) UITextField *rePassword;
@property (strong,nonatomic) UITextField *genderText;
@property (strong,nonatomic) UITextField *dateOfBirthText;
@property (strong,nonatomic) UITextField *nicknameText;
@property (strong,nonatomic) UIButton *registerButton;
@property (retain,nonatomic) NSArray *genderArray;
@property (strong,nonatomic) UIImageView *imageview;
@property (strong,nonatomic) UITableView *myTableView;
@property(nonatomic,retain)UIActionSheet* actionSheet;
@end
