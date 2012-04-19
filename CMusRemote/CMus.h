//
//  CMus.h
//  CMus Remote Controlling Class
//
//  Created by Diego Caponera on 4/16/12.
//  Copyright (c) 2012 MWLabs. All rights reserved.
//  http://www.diegocaponera.com - diego.caponera@gmail.com
//

#import <Foundation/Foundation.h>

@interface CMus : NSObject{
    NSString* commandPath;
    NSMutableDictionary* status;
    BOOL running;
}

@property (copy) NSString* commandPath;
@property (nonatomic, strong) NSMutableDictionary* status;
@property BOOL running;

-(id)initWithCommandPath:(NSString*)thePath;

-(void)play;
-(void)pause;
-(void)stop;
-(void)prev;
-(void)next;
-(void)volume:(NSInteger)level;
-(void)volumeStep:(BOOL)increase:(NSInteger)percent;
-(void)seekTo:(NSInteger)position;
-(void)updateStatus;
-(void)exec:(NSArray*)args;

@end
