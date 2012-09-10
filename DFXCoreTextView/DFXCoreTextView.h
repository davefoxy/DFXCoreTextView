//
//  DFXCoreTextView.h
//  DFXCoreText
//
//  Created by David Fox on 30/08/2012.
//  Copyright (c) 2012 David Fox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "DFXCoreTextFont.h"

typedef enum {
    DFXCTComparisonCaseSensitiveWholeWords = 0,
    DFXCTComparisonCaseSensitiveAnyOccurance,
    DFXCTComparisonCaseInsensitiveWholeWords,
    DFXCTComparisonCaseInsensitiveAnyOccurance
} DFXCTComparisonMode;

@interface DFXCoreTextView : UIScrollView

@property (nonatomic, assign) int columnsPerPage;
@property (nonatomic, assign) CGPoint innerPadding;
@property (nonatomic, assign) float columnSpacing;

- (void)setText:(NSString*)text;
- (void)setFont:(DFXCoreTextFont*)font;
- (void)setFont:(DFXCoreTextFont*)font forRange:(NSRange)range;
- (void)setFont:(DFXCoreTextFont*)font forOccurancesOfString:(NSString*)string comparisonMode:(DFXCTComparisonMode)comparisonMode;

@end