//
//  RegisterViewController.h
//  Photo
//
//  Created by wangshuai on 13-9-12.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong,nonatomic) UITextField *nameText;
@property (strong,nonatomic) UITextField *passwordText;
@property (strong,nonatomic) UITextField *rePassword;
@property (strong,nonatomic) UITextField *genderText;
@property (strong,nonatomic) UITextField *dateOfBirthText;
@property (strong,nonatomic) UIButton *registerButton;
@property (strong,nonatomic) UIPickerView *selectPicker;
@property(retain,nonatomic) NSArray *genderArray;

@end
