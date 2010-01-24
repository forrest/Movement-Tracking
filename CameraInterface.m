//
//  camera_interface.m
//  Movement Detection Test
//
//  Created by Forrest Zeisler on 16/01/10.
//  Copyright 2010 Forrest Zeisler. All rights reserved.
//

#import "CameraInterface.h"


@implementation CameraInterface

- (id) init;
{
	self = [super init];
	
	// Start recording
	counter = 1;
	camera = [[CSGCamera alloc] init];
	[camera setDelegate:self];
	[camera startWithSize:NSMakeSize(640, 480)];	
	
	return self;
}

//TODO: dealloc should stop camera


-(void)setDelegate:(NSObject*)reciever;
{
	camera_controller = reciever;
}


// CSGCamera delegate
- (void)camera:(CSGCamera *)aCamera didReceiveFrame:(CSGImage *)aFrame;
{
	previous_frame = frame;
	frame = aFrame;
	[camera_controller frameReady];
}


-(NSString* )getDetails;
{
	if(frame == nil)
		return @"nil";
	
	NSString * description = [frame description];
	return description;
}

-(CSGImage* )frame;
{
	return frame;
}

-(CSGImage* )previous_frame;
{
	return previous_frame;
}

@end
