//
//  CameraController.h
//  Movement Detection Test
//
//  Created by Forrest Zeisler on 16/01/10.
//  Copyright 2010 Forrest Zeisler. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "CameraInterface.h"
#include "ImageAdditions.h"

@interface CameraController : NSObject {
	CameraInterface * camera_interface;
	bool ready;
	
	IBOutlet NSSlider * exposureSlider;
	IBOutlet NSTextField * exposureLabel;
	
	IBOutlet NSSlider * contrastSlider;
	IBOutlet NSTextField * contrastLabel;
	
	IBOutlet NSImageCell * filtered_cell;
	IBOutlet NSImageCell * moving_edges_cell;
}

- (void)frameReady;

@end
