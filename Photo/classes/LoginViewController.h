//
//  LoginViewController.h
//  Photo
//
//  Created by wangshuai on 13-9-11.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlService.h"
@interface LoginViewController : UIViewController<UITextFieldDelegate>
{

    NSMutableArray *listData;
    sqlTestList *sqlValue;
}
@property (retain,nonatomic) UITextField *name;
@property (retain,nonatomic) UITextField *password;
@property (retain,nonatomic) UIButton *loginButton;
@property (retain,nonatomic) UIButton *registerButton;
@end
