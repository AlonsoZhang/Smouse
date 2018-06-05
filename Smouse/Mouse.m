//
//  Mouse.m
//  VIP
//
//  Created by SSD on 2018/5/23.
//  Copyright © 2018年 baker. All rights reserved.
//

#import "Mouse.h"

@implementation Mouse

- (id)init
{
    self = [super init];
    if (self)
    {
        CGEventMask eventMask = CGEventMaskBit(kCGEventOtherMouseDown);
        CFMachPortRef mouseEventTap = CGEventTapCreate(kCGHIDEventTap, kCGHeadInsertEventTap, kCGEventTapOptionDefault, eventMask, mouseEventCallback, NULL);
        CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, mouseEventTap, 0);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
    }
    return self;
}

CGEventRef myCallBack(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *userInfo)
{
    
    UniCharCount actualStringLength = 0;
    UniChar inputString[128];
    CGEventKeyboardGetUnicodeString(event, 128, &actualStringLength, inputString);
    NSString* inputedString = [[NSString alloc] initWithBytes:(const void*)inputString length:actualStringLength encoding:NSUTF8StringEncoding];
    
    CGEventFlags flag = CGEventGetFlags(event);
    NSLog(@"inputed string:%@, flags:%lld", inputedString, flag);
    return event;
}

static CGEventRef mouseEventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef mevent, void *refcon)
{
    int64_t flag = CGEventGetIntegerValueField(mevent,kCGMouseEventButtonNumber);
//    NSLog(@"%lld",flag);
    if( flag == 4)
    {
       RunCMD(@"123");
    }
    else if (flag == 3)
    {
        RunCMD(@"124");
    }
    else if (flag == 2)
    {
        RunCMD(@"126");
    }
    return NULL;
}


#pragma mark - DIY Functions
void RunEvent( int KeyCode)
{
    CGEventRef event = CGEventCreateKeyboardEvent(NULL,  KeyCode, true);
    CGEventSetFlags(event,  kCGEventFlagMaskControl);
    CGEventPost(kCGSessionEventTap, event);
    CFRelease(event);
    event = CGEventCreateKeyboardEvent(NULL, KeyCode, false);
    CGEventSetFlags(event,  kCGEventFlagMaskControl);
    CGEventPost(kCGSessionEventTap, event);
    CFRelease(event);
}



void RunCMD( NSString *CMD)
{
    NSDictionary *error = [NSDictionary new];
    NSString *script    = [NSString stringWithFormat:@"tell application \"System Events\"\n key code %@ using {control down} \n end tell",CMD ];
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:script];
    [appleScript executeAndReturnError:&error];
}

-(NSString *)RunTask:(NSArray *)arguments ToolPath:(NSString *)Toolpath  {
    
    NSTask *task;
    task = [[NSTask alloc] init];
    [task setLaunchPath: Toolpath];
    
    [task setArguments: arguments];
    NSPipe *pipe;
    pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    
    NSFileHandle *file;
    file = [pipe fileHandleForReading];
    
    [task launch];
    [task waitUntilExit];
    NSData *data;
    data = [file readDataToEndOfFile];
    
    NSString *string;
    string = [[NSString alloc] initWithData: data
                                   encoding: NSUTF8StringEncoding];
    return  string;
}

@end
