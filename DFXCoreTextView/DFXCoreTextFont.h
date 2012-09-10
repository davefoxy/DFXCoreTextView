//
//  DFXCoreTextFont.h
//  DFXCoreText
//
//  Created by David Fox on 01/09/2012.
//  Copyright (c) 2012 David Fox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

typedef enum {
    DFXTextAlignmentLeft = kCTLeftTextAlignment,
    DFXTextAlignmentCenter = kCTCenterTextAlignment,
    DFXTextAlignmentRight = kCTRightTextAlignment,
    DFXTextAlignmentJustified = kCTJustifiedTextAlignment
} DFXTextAlignment;

@interface DFXCoreTextFont : NSObject

@property (nonatomic, copy) NSString *fontName;
@property (nonatomic, assign) float fontSize;
@property (nonatomic, assign) DFXTextAlignment textAlignment;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) NSNumber *strokeWidth;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) BOOL underlined;

@property (nonatomic, readonly) NSDictionary *ctStringAttributes;

@end
