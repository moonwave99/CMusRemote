//
//  AppDelegate.h
//  CMusRemote
//
//  Created by Diego Caponera on 4/16/12.
//  Copyright (c) 2012 MWLabs. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CMus.h"
#import "HIDRemote.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTextFieldDelegate, HIDRemoteDelegate>{

    NSWindow *window;
    NSTextFieldCell* timeLabel;
    NSTextFieldCell* statusLabel;
    NSButton *playButton;
    NSSlider *volSlider;
    NSSlider *seekSlider;    
    
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;

    BOOL seekReverse;
    
    CMus* cmus;

	HIDRemote *hidRemote;

}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextFieldCell* timeLabel;
@property (assign) IBOutlet NSTextFieldCell* statusLabel;
@property (assign) IBOutlet NSButton *playButton;
@property (assign) IBOutlet NSSlider *volSlider;
@property (assign) IBOutlet NSSlider *seekSlider;

@property BOOL seekReverse;

@property (retain) CMus* cmus;

-(IBAction)toggleStatusWindow:(id)sender;
-(IBAction)playerAction:(id)sender;
-(IBAction)volumeAction:(id)sender;
-(IBAction)seekAction:(id)sender;
-(IBAction)toggleSeekMode:(id)sender;

- (void)startRemote;
- (void)setupRemote;
- (void)updateView;
- (NSString *)buttonNameForButtonCode:(HIDRemoteButtonCode)buttonCode;
- (void)cleanupRemote;

@end
