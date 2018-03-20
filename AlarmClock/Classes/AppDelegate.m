//
//  AppDelegate.m
//  AlarmClock
//
//  Created by Michael on 2017/8/3.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "AppDelegate.h"
#import "VC_AlarmClock.h"

#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()<UIAlertViewDelegate>{
    SystemSoundID ID;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
     
    VC_AlarmClock *vc_alrmClock = [[VC_AlarmClock alloc] initWithNibName:@"VC_AlarmClock" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc_alrmClock];
    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //注册本地通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) { // iOS8
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:setting];
    }
    
    if (launchOptions[UIApplicationLaunchOptionsLocalNotificationKey]) {
        // 这里添加处理代码
        NSLog(@"notificationnotificationnotification");
    }
    
    return YES;
}



/// 程序没有被杀死（处于前台或后台），点击通知后会调用此程序
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    // 这里添加处理代码
    NSLog(@"%@",notification);
    NSString *message = notification.alertBody;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil ,nil];
    [alert show];
    [self playVoice];
}

//播放系统声音
- (void)playVoice{
    //开启音效
    NSString *path =[[NSBundle mainBundle]pathForResource:@"jiancha" ofType:@"m4a"];
    NSURL *url = [NSURL fileURLWithPath:path];
    // 声明需要播放的音频文件ID[unsigned long]
    // 创建系统声音，同时返回一个ID
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &ID);
    //播放
    AudioServicesPlaySystemSound(ID);
}

- (void)stopVoice{
    AudioServicesDisposeSystemSoundID(ID);
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self stopVoice];
}

@end
