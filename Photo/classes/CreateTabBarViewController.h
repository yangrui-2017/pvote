//
//  CreateTabBarViewController.h
//  Photo
//
//  Created by wangshuai on 13-9-17.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateTabBarViewController : UITabBarController <UITabBarControllerDelegate,UITabBarDelegate>

@property NSInteger creat_viewControler;

-(id)initWithSuggest:(int)isSuggest;

@end
