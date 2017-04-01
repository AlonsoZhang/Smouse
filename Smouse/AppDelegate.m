//
//  AppDelegate.m
//  Smouse
//
//  Created by Alonso Zhang on 16/8/15.
//  Copyright © 2016年 Alonso Zhang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@end
@implementation AppDelegate


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    ConfigPlist = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"]];
    DefaultType = [ConfigPlist objectForKey:@"DefaultType"];
    
    CGEventMask eventMask = CGEventMaskBit(kCGEventOtherMouseDown);
    CFMachPortRef mouseEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, eventMask, mouseEventCallback, NULL);
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, mouseEventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    
    CFRelease(mouseEventTap);
    CFRelease(runLoopSource);
    
    [self StatusBarItem];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



- (void)StatusBarItem {
    
    self.statusItem= [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    NSMenu *MainMenu = [[NSMenu alloc]init];
    NSMenuItem *Quit = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit) keyEquivalent:@""];
    NSMenuItem *Middle = [[NSMenuItem alloc] initWithTitle:@"默认" action:@selector(middle) keyEquivalent:@""];
    //NSMenuItem *Mission = [[NSMenuItem alloc] initWithTitle:@"多任务" action:@selector(mission) keyEquivalent:@""];
    NSMenuItem *Oulu = [[NSMenuItem alloc] initWithTitle:@"欧路词典" action:@selector(oulu) keyEquivalent:@""];
    NSMenuItem *Dic = [[NSMenuItem alloc] initWithTitle:@"本地字典" action:@selector(dic) keyEquivalent:@""];
    [MainMenu addItem:Middle];
    //[MainMenu addItem:Mission];
    [MainMenu addItem:Oulu];
    [MainMenu addItem:Dic];
    [MainMenu addItem:Quit];
    
    NSImage *menuIcon = [NSImage imageNamed:@"Menu Icon"];
    [menuIcon setTemplate:YES];
    [[self statusItem] setImage:menuIcon];
    self.statusItem.menu = MainMenu;
}

-(void) quit {[NSApp terminate:self];}

-(void)middle{
    [ConfigPlist setValue:@"middle" forKey:@"DefaultType"];
    [ConfigPlist writeToFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"] atomically:YES];
}

-(void)oulu{
    [ConfigPlist setValue:@"oulu" forKey:@"DefaultType"];
    [ConfigPlist writeToFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"] atomically:YES];
}

-(void)dic{
    [ConfigPlist setValue:@"dic" forKey:@"DefaultType"];
    [ConfigPlist writeToFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"] atomically:YES];
}

-(void)mission{
    [ConfigPlist setValue:@"mission" forKey:@"DefaultType"];
    [ConfigPlist writeToFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"] atomically:YES];
}

static CGEventRef mouseEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef mevent, void *refcon)
{
    int64_t flag = CGEventGetIntegerValueField(mevent,kCGMouseEventButtonNumber);
    //NSLog(@"%lld",flag);
    if( flag == 4)
    {
        //Mac OS 10.12
        /*NSDictionary *error = [NSDictionary new];
        NSAppleScript *script= [[NSAppleScript alloc]initWithSource:@"tell application \"System Events\" \n keystroke \"[\" using control down\n end tell"];
        [script executeAndReturnError:&error];*/
        
        CGEventRef event = CGEventCreateKeyboardEvent(NULL, 43, true);
        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
        event = CGEventCreateKeyboardEvent(NULL, 43, false);
        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
    }
    else if (flag == 3)
    {
        //Mac OS 10.12
        /*NSDictionary *error = [NSDictionary new];
        NSAppleScript *script= [[NSAppleScript alloc]initWithSource:@"tell application \"System Events\" \n keystroke \"]\" using control down\n end tell"];
        [script executeAndReturnError:&error];*/
        
        CGEventRef event = CGEventCreateKeyboardEvent(NULL, 47, true);
        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
        event = CGEventCreateKeyboardEvent(NULL, 47, false);
        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
    }
    else if (flag == 2)
    {
        NSString *midbtn = [[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"]]objectForKey:@"DefaultType"];
        if ([midbtn isEqualToString:@"middle"]) {
            return mevent;
        }
        if ([midbtn isEqualToString:@"oulu"]) {
            CGEventRef event = CGEventCreateKeyboardEvent(NULL,  7, true);
            CGEventSetFlags(event,  kCGEventFlagMaskAlternate);
            CGEventPost(kCGSessionEventTap, event);
            CFRelease(event);
            event = CGEventCreateKeyboardEvent(NULL, 7, false);
            CGEventSetFlags(event,  kCGEventFlagMaskAlternate);
            CGEventPost(kCGSessionEventTap, event);
            CFRelease(event);
            return mevent;
        }
        
        if ([midbtn isEqualToString:@"dic"]) {
            CGEventRef event = CGEventCreateKeyboardEvent(NULL,  2, true);
            CGEventSetFlags(event,  (kCGEventFlagMaskControl | kCGEventFlagMaskCommand));
            CGEventPost(kCGSessionEventTap, event);
            CFRelease(event);
            event = CGEventCreateKeyboardEvent(NULL, 2, false);
            CGEventSetFlags(event,  (kCGEventFlagMaskControl | kCGEventFlagMaskCommand));
            CGEventPost(kCGSessionEventTap, event);
            CFRelease(event);
            return mevent;
        }
        
        if ([midbtn isEqualToString:@"mission"]) {
            CGEventRef event = CGEventCreateKeyboardEvent(NULL,  126, true);
            CGEventSetFlags(event,  kCGEventFlagMaskControl);
            CGEventPost(kCGSessionEventTap, event);
            CFRelease(event);
            event = CGEventCreateKeyboardEvent(NULL, 126, false);
            CGEventSetFlags(event,  kCGEventFlagMaskControl);
            CGEventPost(kCGSessionEventTap, event);
            CFRelease(event);
            return mevent;
        }
        
    }
    return NULL;
}

@end
