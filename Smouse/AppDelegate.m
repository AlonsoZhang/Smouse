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
    
    [MainMenu addItem:Quit];
    
    NSImage *menuIcon = [NSImage imageNamed:@"Menu Icon"];
    [menuIcon setTemplate:YES];
    [[self statusItem] setImage:menuIcon];
    self.statusItem.menu = MainMenu;
}

-(void) quit {[NSApp terminate:self];}


static CGEventRef mouseEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef mevent, void *refcon)
{
    int64_t flag = CGEventGetIntegerValueField(mevent,kCGMouseEventButtonNumber);
    //NSLog(@"%lld",flag);
    if( flag == 4)
    {
        CGEventRef event = CGEventCreateKeyboardEvent(NULL, 123, true);
        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
        event = CGEventCreateKeyboardEvent(NULL, 123, false);
        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
    }
    else if (flag == 3)
    {
        CGEventRef event = CGEventCreateKeyboardEvent(NULL, 124, true);
        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
        event = CGEventCreateKeyboardEvent(NULL, 124, false);
        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        CGEventPost(kCGSessionEventTap, event);
        CFRelease(event);
    }
    else if (flag == 2)
    {
        //        CGEventRef event = CGEventCreateKeyboardEvent(NULL,  126, true);
        //        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        //        CGEventPost(kCGSessionEventTap, event);
        //        CFRelease(event);
        //        event = CGEventCreateKeyboardEvent(NULL, 126, false);
        //        CGEventSetFlags(event,  kCGEventFlagMaskControl);
        //        CGEventPost(kCGSessionEventTap, event);
        //        CFRelease(event);
        return mevent;
    }
    return NULL;
}

@end