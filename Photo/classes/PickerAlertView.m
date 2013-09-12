//
//  PickerAlertView.m
//  Photo
//
//  Created by wangshuai on 13-9-12.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "PickerAlertView.h"

@implementation PickerAlertView

@synthesize datePickerView;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createDatePicker];
    }
    return self;
}

- (void)setFrame:(CGRect)rect {
	[super setFrame:CGRectMake(0, 0, 320, 300)];//width 默认 284
	self.center = CGPointMake(320/2, 280);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	for (UIView *view in self.subviews) {
		if (view.frame.size.height == 43) {
			view.frame = CGRectMake(view.frame.origin.x, 232, 127, 43);
		}
	}
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
}

#pragma mark -
#pragma mark UIPickerView - Date/Time

- (void)createDatePicker
{
	datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	datePickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	datePickerView.frame = CGRectMake(10, 10, 300, 216);//216
	datePickerView.datePickerMode = UIDatePickerModeDate;
	
	[self addSubview:datePickerView];
}

@end
