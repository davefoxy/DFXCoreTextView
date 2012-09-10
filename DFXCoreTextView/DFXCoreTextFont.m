//
//  DFXCoreTextFont.m
//  DFXCoreText
//
//  Created by David Fox on 01/09/2012.
//  Copyright (c) 2012 David Fox. All rights reserved.
//

#import "DFXCoreTextFont.h"

@interface DFXCoreTextFont ()
@property (nonatomic, readwrite) NSDictionary *ctStringAttributes;
@end

@implementation DFXCoreTextFont

- (NSDictionary*)ctStringAttributes {
    
    NSAssert(self.fontName != nil, @"DFXCoreTextFont - Font name must be specified");
    NSAssert(self.fontSize, @"DFXCoreTextFont - Font size must be specified");
    
    NSMutableDictionary *atts = [[NSMutableDictionary alloc] init];
    
    // font name and size and optional underline
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.fontSize, NULL);
    [atts setObject:(__bridge id)fontRef forKey:(NSString *)kCTFontAttributeName];
    if (self.underlined) {
        [atts setObject:[NSNumber numberWithInt:1] forKey:(NSString*)kCTUnderlineStyleAttributeName];
    }
    
    // font color
    CGColorRef color = self.textColor.CGColor ?  self.textColor.CGColor : [UIColor blackColor].CGColor;
    [atts setObject:(__bridge id)color forKey:(NSString*)kCTForegroundColorAttributeName];
    
    // font stroke color
    if (self.strokeColor != nil && self.strokeWidth != nil) {
        [atts setObject:(__bridge id)self.strokeColor.CGColor forKey:(NSString*)kCTStrokeColorAttributeName];
        [atts setObject:(id)self.strokeWidth forKey:(NSString*)kCTStrokeWidthAttributeName];
    }
    
    // line height and alignment
    if (!self.lineSpacing) self.lineSpacing = self.fontSize * 1.208; // 1.208 is the photoshop equivilent of 'auto'
    if (!self.textAlignment) self.textAlignment = DFXTextAlignmentLeft;
    
    CTParagraphStyleSetting paragraphStyleSettings[3] = {
        {kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &_lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &_lineSpacing},
        {kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &_textAlignment}
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(paragraphStyleSettings, 3);
    [atts setObject:(__bridge id)paragraphStyle forKey:(NSString*)kCTParagraphStyleAttributeName];
    
    _ctStringAttributes = [NSDictionary dictionaryWithDictionary:atts];
    
    return _ctStringAttributes;
}

@end