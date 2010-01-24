//
//  ImageAdditions.h
//  Movement Detection Test
//
//  Created by Forrest Zeisler on 16/01/10.
//  Copyright 2010 Forrest Zeisler. All rights reserved.
//

@interface NSImage (toCIImage)

- (NSBitmapImageRep *) toBitMap;
- (CIImage *) toCIImage;

- (NSImage *) pipeLine:(NSImage *) otherImage noiseReduction:(float) noise andExposure:(float)exp andContrast:(float)cont;
- (NSImage *) preFilter:(NSImage *) otherImage noiseReduction:(float) noise andExposure:(float)exp andContrast:(float)cont;

@end

@interface CIImage (easyFilters)

- (CIImage *) toMonochrome;
- (CIImage *) toEdges;
- (CIImage *) differenceFromImage:(CIImage *) otherImage;
- (CIImage *) darkenBlendImages:(CIImage *) otherImage;
- (CIImage *) multiplyCompositingImages:(CIImage *) otherImage;
- (CIImage *) changeExposure:(float) amount;
- (CIImage *) runThreshold:(float) amount;
- (CIImage *) changeContrast:(float) amount;
- (CIImage *) noiseReduction:(float) amount;

- (CIImage *) prefilterWithNoiseReduction:(float)red andExposure:(float) exp andContrast:(float)contrast;

- (NSBitmapImageRep *)toRGBABitmapImageRep;
- (NSImage *) toNSImageWithSize:(NSSize)size andRect: (NSRect)bounds;

@end

@interface NSBitmapImageRep (imageConversion)
- (NSImage *) toNSImage;
@end