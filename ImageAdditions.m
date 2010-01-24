//
//  ImageAdditions.m
//  Movement Detection Test
//
//  Created by Forrest Zeisler on 16/01/10.
//  Copyright 2010 Forrest Zeisler. All rights reserved.
//

#import <QuartzCore/CIFilter.h>
#include "ImageAdditions.h"
#include "ThresholdFilter.h"

@implementation NSImage (Difference) 

- (NSBitmapImageRep *) toBitMap
{
	NSBitmapImageRep * bitmapRep = (NSBitmapImageRep *) [self bestRepresentationForDevice:nil];
	return bitmapRep;
}

- (CIImage *) toCIImage
{
	NSBitmapImageRep * bitmapRep = [self toBitMap];
	CIImage *ciImage = [[CIImage alloc] initWithBitmapImageRep:bitmapRep];
	return ciImage;
}

/*this performs only the first part of the pipeline so that we can view how things look.*/
- (NSImage *) preFilter:(NSImage *) otherImage noiseReduction:(float) noise andExposure:(float)exp andContrast:(float)cont
{
	float scaler = 0.5f;
	NSSize size = [self size];
	size.width = size.width*scaler;
	size.height = size.height*scaler;
	
	CIImage * baseImage = [[self toCIImage] imageByApplyingTransform:CGAffineTransformMakeScale(-scaler, scaler)];
	CIImage * mono = [baseImage prefilterWithNoiseReduction:noise andExposure:exp andContrast:cont];	
	NSBitmapImageRep * bitmap = [mono toRGBABitmapImageRep];
	
	return [bitmap toNSImage];
}

/*this performs the entire pipeline. Lots of duplicated code with preFilter method. Should be cleaned!*/
- (NSImage *) pipeLine:(NSImage *) otherImage noiseReduction:(float) noise andExposure:(float)exp andContrast:(float)cont
{
	float scaler = 0.5f;
	NSSize size = [self size];
	size.width = size.width*scaler;
	size.height = size.height*scaler;
	
	CIImage * baseImage = [[self toCIImage] imageByApplyingTransform:CGAffineTransformMakeScale(-scaler, scaler)];
	CIImage * otherBaseImage = [[otherImage toCIImage] imageByApplyingTransform:CGAffineTransformMakeScale(-scaler, scaler)];
	
	CIImage * mono = [baseImage prefilterWithNoiseReduction:noise andExposure:exp andContrast:cont];
	CIImage * prev_mono = [otherBaseImage prefilterWithNoiseReduction:noise andExposure:exp andContrast:cont];
	
	CIImage * diff = [mono differenceFromImage:prev_mono];
	diff = [diff noiseReduction:0.25];
	diff = [diff changeExposure:1.1];
	
	CIImage * edges = [mono toEdges];
	
	CIImage * moving_edges = [diff darkenBlendImages:edges];
	moving_edges = [moving_edges multiplyCompositingImages:diff];
	
	CIImage * outputImage = moving_edges;
	outputImage = [outputImage noiseReduction:0.25];
	outputImage = [outputImage runThreshold:0.01];
	
	
	NSBitmapImageRep * bitmap = [outputImage toRGBABitmapImageRep];
	return [bitmap toNSImage];
}

@end



@implementation CIImage (easyFilters)

- (CIImage *) prefilterWithNoiseReduction:(float)red andExposure:(float) exp andContrast:(float)contrast
{
	CIImage * mono = [self toMonochrome];
	mono = [mono noiseReduction:red];
	mono = [mono changeExposure:exp];
	mono = [mono changeContrast:contrast];
	return mono;
}

- (CIImage *) toMonochrome
{
	CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
	[monochromeFilter setValue:self forKey:@"inputImage"];             
	[monochromeFilter setValue:[CIColor colorWithRed:1 green:1 blue:1] forKey:@"inputColor"];
	[monochromeFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
	return [monochromeFilter valueForKey:@"outputImage"];
}

- (CIImage *) toEdges
{
	CIFilter *edgeFilter = [CIFilter filterWithName:@"CIEdges"];
	[edgeFilter setValue:self forKey:@"inputImage"];             
	[edgeFilter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputIntensity"];
	return [edgeFilter valueForKey:@"outputImage"]; 
}

- (CIImage *) differenceFromImage:(CIImage *) otherImage
{
	CIFilter *edgeFilter = [CIFilter filterWithName:@"CIDifferenceBlendMode"];
	[edgeFilter setValue:self forKey:@"inputImage"];            
	[edgeFilter setValue:otherImage forKey:@"inputBackgroundImage"];            
	return [edgeFilter valueForKey:@"outputImage"]; 	
}

- (CIImage *) multiplyCompositingImages:(CIImage *) otherImage
{
	CIFilter *edgeFilter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
	[edgeFilter setValue:self forKey:@"inputImage"];            
	[edgeFilter setValue:otherImage forKey:@"inputBackgroundImage"];            
	return [edgeFilter valueForKey:@"outputImage"]; 	
}

- (CIImage *) darkenBlendImages:(CIImage *) otherImage
{
	CIFilter *edgeFilter = [CIFilter filterWithName:@"CIDarkenBlendMode"];
	[edgeFilter setValue:self forKey:@"inputImage"];            
	[edgeFilter setValue:otherImage forKey:@"inputBackgroundImage"];            
	return [edgeFilter valueForKey:@"outputImage"]; 	
}

- (CIImage *) changeExposure:(float) amount
{
	CIFilter *edgeFilter = [CIFilter filterWithName:@"CIExposureAdjust"];
	[edgeFilter setValue:self forKey:@"inputImage"];            
	[edgeFilter setValue:[NSNumber numberWithFloat:amount] forKey:@"inputEV"];            
	return [edgeFilter valueForKey:@"outputImage"]; 
}

- (CIImage *) changeContrast:(float) amount
{
	CIFilter *edgeFilter = [CIFilter filterWithName:@"CIColorControls"];
	[edgeFilter setValue:self forKey:@"inputImage"];            
	[edgeFilter setValue:[NSNumber numberWithFloat:amount] forKey:@"inputContrast"];            
	return [edgeFilter valueForKey:@"outputImage"]; 
}

- (CIImage *) runThreshold:(float) amount
{	
	CIFilter * filter = [CIFilter filterWithName: @"ThresholdFilter"];	
	
	[filter setValue:self forKey:@"inputImage"];            
	[filter setValue:[NSNumber numberWithFloat:amount] forKey:@"threshold"];            
	
	return [filter valueForKey: @"outputImage"];	
}

- (CIImage *) noiseReduction:(float) amount
{
	CIFilter *edgeFilter = [CIFilter filterWithName:@"CINoiseReduction"];
	[edgeFilter setValue:self forKey:@"inputImage"];            
	[edgeFilter setValue:[NSNumber numberWithFloat:amount] forKey:@"inputNoiseLevel"];
//	[edgeFilter setValue:[NSNumber numberWithFloat:amount] forKey:@"inputSharpness"];
	return [edgeFilter valueForKey:@"outputImage"]; 
}

- (NSImage *) toNSImageWithSize:(NSSize)size andRect: (NSRect)bounds
{
	NSImage *scratch = [[NSImage alloc] initWithSize:size];
	[scratch lockFocus];
	[self drawAtPoint:NSZeroPoint
					fromRect:bounds
				   operation:NSCompositeCopy
					fraction:1.0];
	
	[scratch unlockFocus];
	
	return [scratch autorelease];
}

- (NSBitmapImageRep *)toRGBABitmapImageRep
{
	return [[NSBitmapImageRep alloc] initWithCIImage:self];
}

@end



@implementation NSBitmapImageRep (imageConversion)

-(NSImage *) toNSImage
{
	NSImage *image = [[NSImage alloc] init];
	[image addRepresentation:self];
	return image;
}

@end
