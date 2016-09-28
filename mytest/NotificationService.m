//
//  NotificationService.m
//  mytest
//
//  Created by SU on 16/9/28.
//  Copyright © 2016年 SU. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    // 重写一些东西
    self.bestAttemptContent.title = @"我是标题";
    self.bestAttemptContent.subtitle = @"我是子标题";
    self.bestAttemptContent.body = @"来自苏庆林";
    
    //附件
    NSDictionary *dict = self.bestAttemptContent.userInfo;
    NSDictionary *notiDict = dict[@"aps"];
    NSString *imgUrl = [NSString stringWithFormat:@"%@",notiDict[@"imageAbsoluteString"]];
    
    if (!imgUrl.length) {
       
    }
    
    [self loadAttachmentForUrlString:imgUrl withType:@"png" completionHandle:^(UNNotificationAttachment *attach) {
       
        if (attach) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
    }];
    
    self.contentHandler(self.bestAttemptContent);
}

- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}


- (void)loadAttachmentForUrlString:(NSString *)urlStr
                          withType:(NSString *)type
                  completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler
{
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentUrl = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            NSLog(@"%@",error.localizedDescription);
        } else {
            NSFileManager *fileManage = [NSFileManager defaultManager];
            NSURL *localUrl = [NSURL fileURLWithPath:fileExt];
            [fileManage moveItemAtURL:location toURL:localUrl error:&error];
            
            NSError *attachmentError = nil;
            attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localUrl options:nil error:&attachmentError];
            if (attachmentError) {
                NSLog(@"%@",attachmentError.localizedDescription);
            }
        }
        
        completionHandler(attachment);
    }] resume];
}


//文件拓展名
- (NSString *)fileExtensionForMediaType:(NSString *)type
{
    NSString *ext = type;
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    return [@"."stringByAppendingString:ext];
}
@end
