//
//  MDCAppDelegate.m
//  FullScreenDetector
//
//  Created by Mark Christian on 1/19/13.
//  Copyright (c) 2013 Mark Christian. All rights reserved.
//
/*
 @shinypb invisible dummy window of kUtilityWindowClass + kHIWindowBitHideOnFullScreen to tell if front app has menubar. Ugly but worked…

 */

#import "MDCAppDelegate.h"

@implementation MDCAppDelegate

NSDate *lastAlert;

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchedToFullScreenApp:) name:kMDCFullScreenDetectorSwitchedToFullScreenApp object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchedToRegularSpace:) name:kMDCFullScreenDetectorSwitchedToRegularSpace object:nil];
}

- (void)showNotification:(NSString *)message {
  NSLog(@"%@", message);
  NSUserNotification *notification = [[NSUserNotification alloc] init];
  notification.title = @"WARNING!!!";
  notification.informativeText = message;
  notification.soundName = nil;

  [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

- (void)switchedToFullScreenApp:(NSNotification *)n {
    NSTimeInterval timeInterval = [lastAlert timeIntervalSinceNow];
    
    NSLog(@"%f", timeInterval);
    
    if (timeInterval == 0.0 || timeInterval < -60) {
        NSLog(@"Show alert!");
        lastAlert = [NSDate date];
        
        NSString *message = @"REMEMBER TO START SCREEN RECORDING";
        NSAlert *alert = [NSAlert alertWithMessageText: message
                                         defaultButton: @"Ok"
                                       alternateButton: nil
                                           otherButton: nil
                             informativeTextWithFormat: @"Make sure you future self is happy. Open QuickTime and start recorging the screen."];
        
        
        
        // Show notification center message
        [self showNotification: message];
        
        // Make sound
        NSSound *sound = [[NSSound alloc] initWithContentsOfFile:[[NSBundle mainBundle]
                                                 pathForResource:@"alarm"
                                                          ofType:@"mp3"] byReference:NO];
        [sound play];
        
        // Say messsage
        NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:@"com.apple.speech.synthesis.voice.Alex"];
        [synth startSpeakingString:message];
        
        // Bounce dock icon
        [NSApp requestUserAttention:NSCriticalRequest];
        
        // Show modal alert
        [alert runModal];
        
        // Active app
        [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
        [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    } else {
        NSLog(@"Dont't show alert!");
    }
}

- (void)switchedToRegularSpace:(NSNotification *)n {
  // [self showNotification:@"On a regular space"];
}

@end
