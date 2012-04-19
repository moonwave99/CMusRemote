//
//  AppDelegate.m
//  CMusRemote
//
//  Created by Diego Caponera on 4/16/12.
//  Copyright (c) 2012 MWLabs. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window, playButton, volSlider, seekSlider, cmus, timeLabel, statusLabel, seekReverse;

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupRemote];
    
    [self startRemote];    
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    [window setLevel:NSFloatingWindowLevel];
    [window setBackgroundColor:NSColor.blackColor];
    [window setAlphaValue:0.85];
    [window setOpaque:NO];
    
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];     
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"C*"];
    
    seekReverse = NO;    
    
    cmus = [[CMus alloc] initWithCommandPath:@"/usr/local/bin/cmus-remote"];
    [self updateView];    
    [self performSelectorInBackground:@selector(updateViewJob) withObject:nil];  
    
}

-(void) updateViewJob
{
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
    
    while(YES){
        
        [cmus updateStatus];
        [self updateView];        
        [NSThread sleepForTimeInterval:1];        
        
    }
    
    [pool release];
    
}

-(void) updateView
{
    
    if(cmus.running){
        
        [playButton setTitle: [[cmus.status valueForKey:@"status"] isEqualToString:@"playing"] ? @"▮▮" : @"▶"];
        
        [volSlider setIntegerValue: [[cmus.status valueForKey:@"vol_left"] intValue]];
        
        [seekSlider setIntegerValue:
         (int)([[cmus.status valueForKey:@"position"] intValue] * 100 / [[cmus.status valueForKey:@"duration"] intValue])
         ];  
        
        [statusLabel setTitle: [cmus.status valueForKey:@"file"]]; 
        
        [timeLabel setTitle:
         
         self.seekReverse == NO ? [self formatTime: [[cmus.status valueForKey:@"position"] intValue]] :
         [NSString stringWithFormat:@"-%@",[self formatTime: [[cmus.status valueForKey:@"duration"] intValue] - [[cmus.status valueForKey:@"position"] intValue]]]
         
         ];        
        
    }else{
        
        [statusLabel setTitle:@"cmus is not running!"];
        
    }
    
}

-(void) startRemote
{
    
    // HID Remote has not been started yet. Start it.
    HIDRemoteMode remoteMode = kHIDRemoteModeExclusive;
    
    // Fancy GUI stuff
    // Check whether the installation of Candelair is required to reliably operate in this mode
    if ([HIDRemote isCandelairInstallationRequiredForRemoteMode:remoteMode])
    {
        // Reliable usage of the remote in this mode under this operating system version
        // requires the Candelair driver to be installed. Tell the user about it.
        NSAlert *alert;
        
        if ((alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Candelair driver installation necessary", @"")
                                     defaultButton:NSLocalizedString(@"Download", @"")
                                   alternateButton:NSLocalizedString(@"More information", @"")
                                       otherButton:NSLocalizedString(@"Cancel", @"")
                         informativeTextWithFormat:NSLocalizedString(@"An additional driver needs to be installed before %@ can reliably access the remote under the OS version installed on your computer.", @""), [[NSBundle mainBundle] objectForInfoDictionaryKey:(id)kCFBundleNameKey]]) != nil)
        {
            switch ([alert runModal])
            {
                case NSAlertDefaultReturn:
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.candelair.com/download/"]];
                    break;
                    
                case NSAlertAlternateReturn:
                    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.candelair.com/"]];
                    break;
            }
        }
    }	
    else{
        
        [hidRemote startRemoteControl:remoteMode];
        
    }
    
}

-(IBAction)toggleStatusWindow:(id)sender
{
    
    [window isVisible] == YES ? [window orderOut:self] : [window makeKeyAndOrderFront:nil];
    
}

-(IBAction)playerAction:(id)sender
{
    
    switch([sender tag]){
            
        case 0:
            
            [cmus prev];
            
            break;
            
        case 1:
            
            if([[cmus.status valueForKey:@"status"] isEqualToString:@"stopped"]){
                
                [cmus play];
                
            }else{
                
                [cmus pause];
                
            }
            
            [sender setTitle: [[cmus.status valueForKey:@"status"] isEqualToString:@"playing"] ? @"▮▮" : @"▶" ];
            
            break;
            
        case 2:
            
            [cmus next];
            
            break;            
            
            
    }
    
    [self updateView];        
    
}

-(IBAction)volumeAction:(id)sender {
    
    [cmus volume:[sender intValue]];
    
}

-(IBAction)seekAction:(id)sender {
    
    
    [cmus seekTo: (int)([[cmus.status valueForKey:@"duration"] intValue] * [sender intValue] * 0.01) ];
    [self updateView];
    
}

-(IBAction)toggleSeekMode:(id)sender {
    
    self.seekReverse = !self.seekReverse;
    [self updateView];        
    
}

#pragma mark -- Remote control code --
- (void)setupRemote
{
    
	if (!hidRemote){
		
        if ((hidRemote = [[HIDRemote alloc] init]) != nil){
            
			[hidRemote setDelegate:self];
            
		}
        
	}
    
}

- (NSString *)buttonNameForButtonCode:(HIDRemoteButtonCode)buttonCode
{
    
	switch (buttonCode)
	{
		case kHIDRemoteButtonCodeUp:
			return (@"Up");
            break;
            
		case kHIDRemoteButtonCodeDown:
			return (@"Down");
            break;
            
		case kHIDRemoteButtonCodeLeft:
			return (@"Left");
            break;
            
		case kHIDRemoteButtonCodeRight:
			return (@"Right");
            break;
            
		case kHIDRemoteButtonCodeCenter:
			return (@"Center");
            break;
            
		case kHIDRemoteButtonCodePlay:
			return (@"Play/Pause");
            break;
            
		case kHIDRemoteButtonCodeMenu:
			return (@"Menu");
            break;
            
		case kHIDRemoteButtonCodeUpHold:
			return (@"Up (hold)");
            break;
            
		case kHIDRemoteButtonCodeDownHold:
			return (@"Down (hold)");
            break;
            
		case kHIDRemoteButtonCodeLeftHold:
			return (@"Left (hold)");
            break;
            
		case kHIDRemoteButtonCodeRightHold:
			return (@"Right (hold)");
            break;
            
		case kHIDRemoteButtonCodeCenterHold:
			return (@"Center (hold)");
            break;
            
		case kHIDRemoteButtonCodePlayHold:
			return (@"Play/Pause (hold)");
            break;
            
		case kHIDRemoteButtonCodeMenuHold:
			return (@"Menu (hold)");
            break;
        default:
            break;
            
	}
	
	return ([NSString stringWithFormat:@"Button %x", (int)buttonCode]);
    
}

- (void)hidRemote:(HIDRemote *)theHidRemote
  eventWithButton:(HIDRemoteButtonCode)buttonCode
        isPressed:(BOOL)isPressed
fromHardwareWithAttributes:(NSMutableDictionary *)attributes
{
	
    NSString *remoteModel = nil;
    
	switch ([theHidRemote lastSeenModel])
	{
		case kHIDRemoteModelUndetermined:
			remoteModel = [NSString stringWithFormat:@"Undetermined:%d", [theHidRemote lastSeenRemoteControlID]];
            break;
            
		case kHIDRemoteModelAluminum:
			remoteModel = [NSString stringWithFormat:@"Aluminum:%d", [theHidRemote lastSeenRemoteControlID]];
            break;
            
		case kHIDRemoteModelWhitePlastic:
			remoteModel = [NSString stringWithFormat:@"White Plastic:%d", [theHidRemote lastSeenRemoteControlID]];
            break;
	}
    
	if (isPressed){
		
        switch (buttonCode)
        {
            case kHIDRemoteButtonCodeUp:
                
                [cmus volumeStep: YES : 5];
                
                break;
                
            case kHIDRemoteButtonCodeDown:
                
                [cmus volumeStep: NO : 5];       
                
                break;
                
            case kHIDRemoteButtonCodeLeft:
                
                [cmus prev];
                
                break;
                
            case kHIDRemoteButtonCodeRight:
                
                [cmus next];
                
                break;
                
            case kHIDRemoteButtonCodeCenter:
                
                if([[cmus.status valueForKey:@"status"] isEqualToString:@"stopped"]){
                    
                    [cmus play];
                    
                }else{
                    
                    [cmus pause];
                    
                }
                
                [playButton setTitle: [[cmus.status valueForKey:@"status"] isEqualToString:@"playing"] ? @"▮▮" : @"▶" ];                
                
                break;
                
            case kHIDRemoteButtonCodePlay:
                
                break;
                
            case kHIDRemoteButtonCodeMenu:
                
                [self toggleStatusWindow:nil];
                
                break;
                
            case kHIDRemoteButtonCodeUpHold:
                
                [cmus volume:100];
                
                break;
                
            case kHIDRemoteButtonCodeDownHold:
                
                [cmus volume:0];                
                
                break;
                
            case kHIDRemoteButtonCodeLeftHold:
                
                break;
                
            case kHIDRemoteButtonCodeRightHold:
                
                break;
                
            case kHIDRemoteButtonCodeCenterHold:
                
                break;
                
            case kHIDRemoteButtonCodePlayHold:
                
                break;
                
            case kHIDRemoteButtonCodeMenuHold:
                
                break;
                
            default:
                break;                
                
        }
        
        NSLog(@"%@ pressed (%@, %@)", [self buttonNameForButtonCode:buttonCode], remoteModel, [attributes objectForKey:kHIDRemoteProduct]);
		
        [self updateView];
        
	}else{
        
        NSLog(@"%@ released (%@, %@)", [self buttonNameForButtonCode:buttonCode], remoteModel, [attributes objectForKey:kHIDRemoteProduct]);
        
	}
    
    
    
}

- (void)cleanupRemote
{
    
	if ([hidRemote isStarted]){
        
        [hidRemote stopRemoteControl];
        
	}
    
	[hidRemote setDelegate:nil];
	[hidRemote release];
	hidRemote = nil;
    
}

- (NSString*)formatTime:(NSInteger)seconds{
    
    NSInteger minutes = (int)(seconds / 60);
    
    return [NSString stringWithFormat:@"%d:%@%d",
            minutes,
            [NSString stringWithFormat:@"%@", seconds % 60 < 10 ? @"0" : @""],
            seconds % 60
            ];
    
}

@end
