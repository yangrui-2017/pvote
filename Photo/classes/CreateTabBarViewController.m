//
//  CreateTabBarViewController.m
//  Photo
//
//  Created by wangshuai on 13-9-17.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "CreateTabBarViewController.h"
#import "AppDelegate.h"

@interface CreateTabBarViewController ()

@end

@implementation CreateTabBarViewController
@synthesize creat_viewControler;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithSuggest:(int)isSuggest
{
    self = [super init];
    if (self) {
        self.creat_viewControler = isSuggest;
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    self.tabBar.frame = CGRectMake(0, height+20, 320, 49);
    
    UIView *tabImv = [[UIView alloc]initWithFrame:CGRectMake(0, height-20-44-49, 320, 49)];
    [tabImv setBackgroundColor:[UIColor cyanColor]];
    CGFloat width_btn=0;
    NSInteger buttoncount = 0;
    
    NSInteger flag = 0;
    
    NSMutableArray * btnTitle = [[NSMutableArray alloc] initWithCapacity:0];
    if (APPDELEGATE.loginSuccess == YES) {
        
        flag = 0;
        btnTitle = [NSArray arrayWithObjects:@"主页",@"火",@"拍照",@"#1",@"个人信息", nil];
    } else {
        NSLog(@"<<<<<<<<<<<<<<<<未登录<<<<<<<<<<<<<<<<<<");
        flag = 1;
    }
    width_btn=width/[btnTitle count];
    buttoncount = btnTitle.count;
    for (int i=0; i<buttoncount; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:[btnTitle objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = (i+1)*10000;
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [btn setFrame:CGRectMake(i*width_btn, 0, width_btn, 49)];
        [btn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        [tabImv addSubview:btn];
        
        if (i < buttoncount-1) {
            UIImageView * jgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jg"]];
            jgImageView.frame = CGRectMake(btn.frame.size.width-1, 0, 1, btn.frame.size.height);
            [btn addSubview:jgImageView];
        }
    }
    if (flag == 1)
    {
        UIButton * bb = (UIButton *)[self.view viewWithTag:40000];
        [bb setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [bb setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [bb setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        bb.userInteractionEnabled = NO;     
    }
    [self.view addSubview:tabImv];
}

-(void)selectButton:(UIButton *)btn
{
    NSLog(@"选中%d",self.selectedIndex);
    self.selectedIndex = btn.tag/10000-1;
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    for (int i=1; i<=5; i++) {
        if (btn.tag/10000 != i) {
            UIButton * button = (UIButton * )[self.view viewWithTag:i*10000];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
