//
//  CameraController.m
//  Movement Detection Test
//
//  Created by Forrest Zeisler on 16/01/10.
//  Copyright 2010 Forrest Zeisler. All rights reserved.
//

#import "CameraController.h"
#include "ThresholdFilter.h"

@implementation CameraController

- (void)awakeFromNib;
{
	ready = true;
	camera_interface = [[CameraInterface alloc] init];
	[camera_interface setDelegate:self];

	//threshold filter must be initialized
	[ThresholdFilter class];
}

/* This will get triggered by the camera everytime a enw frame is ready. 
 Controller will use the "ready" variable to decide when to use the frame.*/
- (void)frameReady;
{
	if(!ready)
		return;
	ready = false;
	
	NSImage* initial_image = (NSImage*) [camera_interface frame];
	NSImage* previous_image = (NSImage*) [camera_interface previous_frame];
	NSImage* filtered_image;
	
	if(previous_image)
	{
		float noise = 0.22;
		
		float exp = [exposureSlider doubleValue];
		[exposureLabel setFloatValue:exp];
		
		float cont = [contrastSlider doubleValue];
		[contrastLabel setFloatValue:cont];
		
		filtered_image = [initial_image preFilter:previous_image noiseReduction:noise andExposure:exp andContrast:cont];
		[filtered_cell setImage:filtered_image];

		initial_image = [initial_image pipeLine:previous_image noiseReduction:noise andExposure:exp andContrast:cont];
		[moving_edges_cell setImage:initial_image];
	}	
	ready = true;
}

@end
