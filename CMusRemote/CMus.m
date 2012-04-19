//
//  CMus.m
//  CMus Remote Controlling Class
//
//  Created by Diego Caponera on 4/16/12.
//  Copyright (c) 2012 MWLabs. All rights reserved.
//  http://www.diegocaponera.com - diego.caponera@gmail.com
//

#import "CMus.h"

@implementation CMus

@synthesize commandPath, status, running;

/**

 Inits CMus object with cmus-remote command path [usually "/usr/local/bin/cmus-remote"].
 
*/
-(id)initWithCommandPath:(NSString*)thePath{
    
    self.commandPath = thePath;
    self.running = NO;

    [self updateStatus];
    
    return self;
    
}

/**
    
 Triggers play action on cmus.
 
*/
-(void)play{
    
    [self exec: [NSArray arrayWithObjects: @"-Q", @"--play", nil]];
    
}

/**
 
 Triggers pause action on cmus.
 
*/
-(void)pause{
    
    [self exec: [NSArray arrayWithObjects: @"-Q", @"--pause", nil]];
    
}

/**
 
 Triggers stop action on cmus.
 
 */
-(void)stop{

    [self exec: [NSArray arrayWithObjects: @"-Q", @"--stop", nil]];
    
}

/**
 
 Triggers prev action on cmus.
 
*/
-(void)prev{
    
    [self exec: [NSArray arrayWithObjects: @"-Q", @"--prev", nil]]; 
    
}

/**
 
 Triggers next action on cmus.
 
*/
-(void)next{
    
    [self exec: [NSArray arrayWithObjects: @"-Q", @"--next", nil]];
    
}

/**
 
 Triggers volume action with given level [0-100] on cmus.
 
*/
-(void)volume:(NSInteger)level{
    
    NSString* vol = [NSString stringWithFormat:@"%d", level];
    
    [self exec: [NSArray arrayWithObjects: @"-Q", @"--volume", vol, nil]];
    
}

/**
 
 Triggers volume action with given percentual increment [+/- n%] on cmus.
 
*/
-(void)volumeStep:(BOOL)increase :(NSInteger)percent{
    
    NSString* vol = [NSString stringWithFormat:@"%@%d%", increase == YES ? @"+" : @"-", percent];
    
    [self exec: [NSArray arrayWithObjects: @"-Q", @"--volume", vol, nil]];    
    
}

/**
 
 Triggers seek action with given position on cmus.
 
*/
-(void)seekTo:(NSInteger)position{
    
    [self exec: [NSArray arrayWithObjects: @"-Q", @"--seek", [NSString stringWithFormat:@"%d", position], nil]];    
    
}

/**
 
 Fetches cmus status to own key-value dictionary.
 
*/
-(void) updateStatus{
    
    [self exec: [NSArray arrayWithObjects: @"-Q", nil]];    
    
}

/**
 
 Launches "cmus-remote" command with given argument list [ex. "-Q --pause"], and if "-Q" argument is passed, cmus status is stored.
 
*/
-(void)exec:(NSArray*)args {
    
    NSTask *task = [[NSTask alloc] init];
    
    [task setLaunchPath: commandPath];    
    [task setArguments: args];
    
    NSPipe *pipe = [NSPipe pipe];

    [task setStandardOutput: pipe];
    [task setStandardError: [task standardOutput]];
    [task launch];
    [task waitUntilExit];
    
    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
    NSString *output = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
    
    [task release];
    
    NSArray* split = [output componentsSeparatedByString:@"\n"];
    
    NSArray* row;
    
    status = [[NSMutableDictionary alloc] init];
    [status setValue: @"" forKey: @"file"];
    [status setValue: @"0" forKey: @"position"];    
    [status setValue: @"1" forKey: @"duration"];
    
    if(split.count <= 2 && [args containsObject:@"-Q"] ){
        
        running = NO;
        return;
        
    }
    
    if([args containsObject:@"-Q"]){
     
        for( int i = 0; i < split.count; i++){
            
            row = [[split objectAtIndex:i] componentsSeparatedByString:@" "];
            
            if(row.count == 2){
                
                [status setValue: [row objectAtIndex: 1] forKey: [row objectAtIndex: 0]];
                
            }else if([[row objectAtIndex:0] isEqualToString:@"file"]){
                
                NSMutableArray* mut = [NSMutableArray arrayWithArray:row ];
                
                [mut removeObjectAtIndex:0];
                
                [status setValue: [mut componentsJoinedByString:@" "] forKey: @"file"];
                
            }else if([[row objectAtIndex:0] isEqualToString:@"set"]){
                
                [status setValue: [row objectAtIndex: 2] forKey: [row objectAtIndex: 1]];
                
            }
            
        }         
        
    }
    
    running = YES;
    
}

@end
