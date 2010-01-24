//
//  camera_interface.h
//  Movement Detection Test
//
//  Created by Forrest Zeisler on 16/01/10.
//  Copyright 2010 Forrest Zeisler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "CSGCamera.h"


@interface CameraInterface : NSObject {
	int counter;
	CSGCamera * camera;
	CSGImage * frame;
	CSGImage * previous_frame;
	NSObject * camera_controller;
}

-(void)setDelegate:(NSObject*)reciever;
-(NSString*)getDetails;
-(CSGImage* )frame;
-(CSGImage* )previous_frame;

@end
