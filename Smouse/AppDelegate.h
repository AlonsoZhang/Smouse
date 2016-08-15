//
//  AppDelegate.h
//  Smouse
//
//  Created by Alonso Zhang on 16/8/15.
//  Copyright © 2016年 Alonso Zhang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,NSUserNotificationCenterDelegate>
@property(readwrite, retain) NSStatusItem *statusItem;

@end

