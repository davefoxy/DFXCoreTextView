//
//  DFXCoreTextView.m
//  DFXCoreText
//
//  Created by David Fox on 30/08/2012.
//  Copyright (c) 2012 David Fox. All rights reserved.
//

#import "DFXCoreTextView.h"
#import "DFXCoreTextColumnView.h"

@interface DFXCoreTextView ()
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) NSDictionary *currentAttributes;
- (void)commonInit;
@end

@implementation DFXCoreTextView

// initialization options
- (id)init {
    if ((self = [super init])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.columnsPerPage = 1;
    self.innerPadding = CGPointMake(20, 20);
    self.columnSpacing = 20;
}

// drawing and formatting methods
- (void)setText:(NSString*)text {
    self.attributedString = [[NSAttributedString alloc] initWithString:text];
}

- (void)setFont:(DFXCoreTextFont*)font {
    self.attributedString = [[NSAttributedString alloc] initWithString:self.attributedString.string attributes:font.ctStringAttributes];
}

- (void)setFont:(DFXCoreTextFont*)font forRange:(NSRange)range {
    NSMutableAttributedString *mutable = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedString];
    [mutable addAttributes:font.ctStringAttributes range:range];
    self.attributedString = [[NSAttributedString alloc] initWithAttributedString:mutable];
}

- (void)setFont:(DFXCoreTextFont*)font forOccurancesOfString:(NSString*)string comparisonMode:(DFXCTComparisonMode)comparisonMode {
    int caratPosition = 0;
    BOOL shouldContinue = YES;
    while (shouldContinue) {
        
        NSStringCompareOptions compareOption = comparisonMode == DFXCTComparisonCaseInsensitiveAnyOccurance || comparisonMode == DFXCTComparisonCaseInsensitiveWholeWords ? NSCaseInsensitiveSearch : NSLiteralSearch;
        
        NSRange occuranceRange = [self.attributedString.string rangeOfString:string options:compareOption range:NSMakeRange(caratPosition, [self.attributedString.string length] - caratPosition)];
        
        if (occuranceRange.location == NSNotFound) {
            shouldContinue = NO;
        }
        else {
            BOOL shouldFormat = YES;
            if ((comparisonMode == DFXCTComparisonCaseInsensitiveWholeWords || comparisonMode == DFXCTComparisonCaseSensitiveWholeWords) &&
                ![[self.attributedString.string substringWithRange:NSMakeRange(occuranceRange.location + occuranceRange.length, 1)] isEqualToString:@" "]) {
                shouldFormat = NO;
            }
            if (shouldFormat) {
                [self setFont:font forRange:occuranceRange];
                
            }
        }
        
        caratPosition += occuranceRange.length;
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    // remove all existing columns (in case of a redraw such as after an orientation change)
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[DFXCoreTextColumnView class]]) [obj removeFromSuperview];
    }];
    
    // splitting the drawing into a separate method for just one column as the code and view behaviour is quite different
    if (self.columnsPerPage == 1) {
        [self buildPlainTextView];
    }
    else {
        [self buildColumnedTextView];
    }
}

- (void)buildPlainTextView {
    [self setPagingEnabled:NO];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, [self.attributedString.string length]), nil, CGSizeMake(CGRectGetWidth(self.bounds) - (self.innerPadding.x * 2), MAXFLOAT), nil);
    
    CGMutablePathRef textPath = CGPathCreateMutable();
    CGPathAddRect(textPath, NULL, CGRectMake(0, 0, CGRectGetWidth(self.bounds) - (self.innerPadding.x * 2), textSize.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.attributedString.string length]), textPath, nil);
    
    DFXCoreTextColumnView *columnView = [[DFXCoreTextColumnView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
    [columnView setCoreTextView:(__bridge id)frame];
    [columnView setBackgroundColor:[UIColor clearColor]];
    [columnView setFrame:CGRectMake(self.innerPadding.x, self.innerPadding.y, CGRectGetWidth(self.bounds) - (self.innerPadding.x * 2), textSize.height)];
    [self addSubview:columnView];
    
    [self setContentSize:CGSizeMake(CGRectGetWidth(self.bounds), textSize.height + (self.innerPadding.y * 2))];
    
    CFRelease(frame);
    CFRelease(textPath);
    CFRelease(framesetter);
}

- (void)buildColumnedTextView {
    
    [self setPagingEnabled:YES];
    
    // base framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attributedString);
    
    // column dimensions
    float columnWidth = (CGRectGetWidth(self.bounds) - (self.innerPadding.x * 2) - ((self.columnsPerPage - 1) * self.columnSpacing)) / self.columnsPerPage;
    float columnHeight = CGRectGetHeight(self.bounds) - (self.innerPadding.y * 2);
    
    // create a reusable path for all the columns
    CGMutablePathRef columnPath = CGPathCreateMutable();
    CGPathAddRect(columnPath, NULL, CGRectMake(0, 0, columnWidth, columnHeight));
    
    // work out how much we can put in each column
    NSMutableArray *columnStrings = [NSMutableArray array];
    int caratPosition = 0;
    
    while (caratPosition < [self.attributedString.string length]) {
        CTFrameRef columnPlaceholderFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(caratPosition, 0), columnPath, NULL);
        CFRange columnTextRange = CTFrameGetVisibleStringRange(columnPlaceholderFrame);
        [columnStrings addObject:[self.attributedString.string substringWithRange:NSMakeRange(columnTextRange.location, columnTextRange.length)]];
        
        caratPosition += columnTextRange.length;
        
        CFRelease(columnPlaceholderFrame);
    }
    
    // now draw all the columns with the calculated text
    int currentColumn = 0;
    float currentXPosition = self.innerPadding.x;
    
    for (NSString *columnText in columnStrings) {
        
        // create a frame for this particular piece of text
        CFRange cfStringRange = CFRangeMake([self.attributedString.string rangeOfString:columnText].location, [self.attributedString.string rangeOfString:columnText].length);
        CTFrameRef columnFrame = CTFramesetterCreateFrame(framesetter, cfStringRange, columnPath, NULL);
        
        // draw a view containing the text
        DFXCoreTextColumnView *columnView = [[DFXCoreTextColumnView alloc] initWithFrame:CGRectMake(currentXPosition, 0, columnWidth, columnHeight)];
        [columnView setCoreTextView:(__bridge id)columnFrame];
        [columnView setBackgroundColor:[UIColor clearColor]];
        [columnView setFrame:CGRectMake(currentXPosition, self.innerPadding.y, columnWidth, columnHeight)];
        [self addSubview:columnView];
        
        // update currentXPosition to draw the next column
        currentXPosition += columnWidth + self.columnSpacing;
        if (fmodf((float)currentColumn + 1, self.columnsPerPage) == 0) currentXPosition = currentXPosition - self.columnSpacing + (self.innerPadding.x * 2);
        
        currentColumn++;
        
        CFRelease(columnFrame);
    }
    
    CFRelease(columnPath);
    CFRelease(framesetter);
    
    // update the scrollview's contentsize
    int numberOfPages = ceil((float)currentColumn / (float)self.columnsPerPage);
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * numberOfPages, CGRectGetHeight(self.bounds));
    
    // after a rotation change, we might be 'in-between' pages so round it off
    int currentPage = roundf(self.contentOffset.x / CGRectGetWidth(self.bounds));
    self.contentOffset = CGPointMake(currentPage * CGRectGetWidth(self.bounds), 0);
}

@end