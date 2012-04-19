//
//  TimeTextFieldCell.m
//  CMusRemote
//
//  Created by Diego Caponera on 4/19/12.
//  Copyright (c) 2012 MWLabs. All rights reserved.
//

#import "TimeTextField.h"

@implementation TimeTextField

- (void)mouseDown:(NSEvent *)theEvent {
 
    [self.delegate toggleSeekMode:self];
    
}

- (BOOL)acceptsFirstResponder {
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}
@end