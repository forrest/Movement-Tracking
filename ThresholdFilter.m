//
//  ThresholdFilter.m
//  Movement Detection Test
//
//  Created by Forrest Zeisler on 16/01/10.
//  Copyright 2010 Forrest Zeisler. All rights reserved.
//

#import "ThresholdFilter.h"


@implementation ThresholdFilter

static CIKernel *thresholdKernel = nil;


+ (void)initialize
{
    [CIFilter registerFilterName: @"ThresholdFilter"
					 constructor: self
				 classAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								   @"ThresholdFilter", kCIAttributeFilterDisplayName,
								   [NSArray arrayWithObjects:
									kCICategoryColorAdjustment, kCICategoryVideo,
									kCICategoryStillImage,kCICategoryInterlaced,
									kCICategoryNonSquarePixels,nil], kCIAttributeFilterCategories,
								   nil]
	 ];
}

- (id)init
{
    if(thresholdKernel == nil)// 1	
    {
        NSBundle    *bundle = [NSBundle bundleForClass: [self class]];
        NSString    *code = [NSString stringWithContentsOfFile: [bundle pathForResource: @"ThresholdFilter" ofType: @"cikernel"]];
        NSArray     *kernels = [CIKernel kernelsWithString: code];
        thresholdKernel = [[kernels objectAtIndex:0] retain];
    }
	
    return [super init];	
}

- (NSDictionary *)customAttributes
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSDictionary dictionaryWithObjectsAndKeys:
			 [NSNumber numberWithDouble:  0.0], kCIAttributeMin,
			 [NSNumber numberWithDouble:  1.0], kCIAttributeMax,
			 [NSNumber numberWithDouble:  0.5], kCIAttributeDefault,
			 kCIAttributeTypeScalar,            kCIAttributeType,
			 nil],                              @"threshold",
			nil];	
}	


- (CIImage *)outputImage
{
    CISampler *src = [CISampler samplerWithImage: inputImage];
	
    return [self apply: thresholdKernel, src, threshold, kCIApplyOptionDefinition, [src definition], nil];
}

+ (CIFilter *)filterWithName: (NSString *)name
{
    CIFilter  * filter = [[self alloc] init];	
    return [filter autorelease];
}


@end
