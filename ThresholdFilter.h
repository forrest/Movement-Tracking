//
//  ThresholdFilter.m
//  Movement Detection Test
//
//  Created by Forrest Zeisler on 16/01/10.
//  Copyright 2010 Forrest Zeisler. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

@interface ThresholdFilter: CIFilter {
    CIImage   *inputImage;
    NSNumber  *threshold;
}

@end