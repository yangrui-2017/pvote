//
//  AppDelegate.m
//  Photo
//
//  Created by wangshuai on 13-9-11.
//  Copyright (c) 2013年 wangshuai. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"
#import "PhotoViewController.h"
#import "FireViewController.h"
#import "UserInformationViewController.h"
#import "InformationViewController.h"
#import <arcstreamsdk/STreamSession.h>

@implementation AppDelegate

@synthesize loginSuccess;

-(void)showLoginSucceedView{
    MainViewController * mainVC = [[MainViewController alloc]init];
    PhotoViewController *photoVC = [[PhotoViewController alloc]init];
    FireViewController * fireVC = [[FireViewController alloc]init];
    UserInformationViewController * userInfoVC = [[UserInformationViewController alloc]init];
    InformationViewController * myInfoVC = [[InformationViewController alloc]init];
    mainVC.title=@"主页";
    photoVC.title=@"拍照";
    fireVC.title=@"流行";
    userInfoVC.title=@"投票排行榜";
    myInfoVC.title=@"个人信息";
    
    UITabBarItem *mainBar=[[UITabBarItem alloc] initWithTitle:@"主页" image: [UIImage imageNamed:@"home.png"]tag:10001];
    UITabBarItem *fireBar=[[UITabBarItem alloc] initWithTitle:@"流行" image:[UIImage imageNamed:@"thumb.png"] tag:1002];
    UITabBarItem *photoBar=[[UITabBarItem alloc] initWithTitle:@"拍照" image: [UIImage imageNamed:@"photo.png"]tag:10001];
    UITabBarItem *userBar=[[UITabBarItem alloc] initWithTitle:@"排行榜" image:[UIImage imageNamed:@"trophy.png"] tag:1002];
    UITabBarItem *myBar=[[UITabBarItem alloc] initWithTitle:@"个人信息" image:[UIImage imageNamed:@"infor.png"] tag:1002];
    
    mainVC.tabBarItem=mainBar;
    fireVC.tabBarItem=fireBar;
    photoVC.tabBarItem=photoBar;
    userInfoVC.tabBarItem=userBar;
    myInfoVC.tabBarItem = myBar;
    
    NSMutableArray *array=[[NSMutableArray alloc] initWithCapacity:0];
    
    UINavigationController *nav1=[[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *nav2=[[UINavigationController alloc] initWithRootViewController:fireVC];
    UINavigationController *nav3=[[UINavigationController alloc] initWithRootViewController:photoVC];
    UINavigationController *nav4=[[UINavigationController alloc] initWithRootViewController:userInfoVC];
    UINavigationController *nav5=[[UINavigationController alloc] initWithRootViewController:myInfoVC];
    
    [array addObject:nav1];
    [array addObject:nav2];
    [array addObject:nav3];
    [array addObject:nav4];
    [array addObject:nav5];
    
    UITabBarController *tabBar=[[UITabBarController alloc] init];
    tabBar.viewControllers=array;
    [self.window setRootViewController:tabBar];
}
-(void)showMainView{
    
    MainViewController * mainVC = [[MainViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:mainVC];
    [self.window setRootViewController:nav];
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    客户key: 01D901D6EFBA42145E54F52E465F407B
//    安全key: 4EF482C15D849D04BA5D7BC940526EA3
//    应用ID/key: 0093D2FD61600099DE1027E50C6C3F8D


    /*[STreamSession authenticate:@"9E6DA8D4057467427D0797BC2B12AFCE" secretKey:@"270740EE21B6F02F0FE69007F86E5B1D" clientKey:@"04869E41CCA70DD5F3500F00B6D83ACA" response:^(BOOL succeed, NSString *response){
        
    }];*/
    [STreamSession authenticate:@"0093D2FD61600099DE1027E50C6C3F8D" secretKey:@"4EF482C15D849D04BA5D7BC940526EA3" clientKey:@"01D901D6EFBA42145E54F52E465F407B" response:^(BOOL succeed, NSString *response){
            NSLog(@"res: %@", response);
    }];
    
    //
    loginSuccess = NO;
    
    LoginViewController *loginView = [[LoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginView];
    [self.window setRootViewController:nav];
    
    self.window.backgroundColor = [UIColor colorWithRed:218.0/255.0 green:242.0/255.0 blue:230.0/255.0 alpha:1.0];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
