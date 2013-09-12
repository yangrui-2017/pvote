//
//  PickerAlertView.h
//  Photo
//
//  Created by wangshuai on 13-9-12.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerAlertView : UIAlertView
{
    UIDatePicker *datePickerView;
}

@property (nonatomic,retain) UIDatePicker *datePickerView;

- (void)createDatePicker;

@end
