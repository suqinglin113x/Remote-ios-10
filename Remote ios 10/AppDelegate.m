//
//  AppDelegate.m
//  Remote ios 10
//
//  Created by SU on 16/9/22.
//  Copyright © 2016年 SU. All rights reserved.
//

#import "AppDelegate.h"

//ios10 推送
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //ios 10 远程推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //iOS10特有
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        
        //必须写代理，不然无法监听通知的接收和点击
        center.delegate = self;
        [center requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
           
            if (granted) {
                //点击允许
                NSLog(@"注册成功");
                [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"%@",settings);
                }];
            } else {
                //点击不允许
                NSLog(@"注册失败");
            }
        }];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] > 8.0) {
        //ios8- ios10
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    } else if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0){
        //ios8 下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    }
    //注册获得device token
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    
    
    return YES;
}

- (void) addLocalNotification
{
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"test";
    content.subtitle = @"ios10 推送";
    content.body = @"看看瞧瞧，笑笑";
    content.badge = @1;
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"];
    UNNotificationAttachment *attachment = [UNNotificationAttachment attachmentWithIdentifier:@"att" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    if (error) {
        NSLog(@"attachment error %@",error);
    }
    content.attachments = @[attachment];
    content.launchImageName = @"2.png";
    //2.设置声音
    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    content.sound = sound;
    //3.触发模式
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:6. repeats:NO];
    //4. 设置request
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"request" content:content trigger:trigger];
    //5.发送本地通知
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}


//接受device token的方法没变
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken
{
    NSLog(@"%@",[NSString stringWithFormat:@"Device Token :%@", deviceToken]);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"获取失败");
}

#pragma mark 通知的接收和点击事件(ios10 新增代理方法)
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
//{
//    NSDictionary *userinfo = notification.request.content.userInfo;
//    UNNotificationRequest *request = notification.request; //收到的推送请求
//    UNNotificationContent *content = request.content; //收到的推送消息内容
//    NSNumber *badge = content.badge; //推送消息的角标
//    NSString *body = content.body; //推送消息的实体
//    UNNotificationSound *sound = content.sound; //推送消息的声音
//    NSString *subtitle = content.subtitle; //推送消息的副标题
//    NSString *title = content.title; //推送消息的标题
//    
//    
//    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]){
//        NSLog(@"ios 10 前台收到远程通知");
//    }else {
//        //本地通知
//        
//    }
//    //需要执行这个方法，选择是否提醒用户有badge，alert ，sound
//    completionHandler(UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound);
//}
//
//- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
//{
//    NSDictionary *userinfo = response.notification.request.content.userInfo;
//    
//    
//    completionHandler(); //在点击事件中，如果我们不写completionHandler（）这个方法，可能会报一下的错误
//}













- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //添加本地通知
    [self addLocalNotification];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
