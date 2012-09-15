//
//  DFXCoreTextColumnView.m
//  DFXCoreText
//
//  Created by David Fox on 01/09/2012.
//  Copyright (c) 2012 David Fox. All rights reserved.
//

#import "DFXCoreTextColumnView.h"

@implementation DFXCoreTextColumnView

-(void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((__bridge CTFrameRef)self.coreTextView, context);
}

@end
