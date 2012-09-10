//
//  ViewController.m
//  DFXCoreText
//
//  Created by David Fox on 30/08/2012.
//  Copyright (c) 2012 David Fox. All rights reserved.
//

#import "ViewController.h"
#import "DFXCoreTextFont.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet DFXCoreTextView *ctView;
- (IBAction)spacingSliderUpdated:(id)sender;
- (IBAction)paddingSliderUpdated:(id)sender;
- (IBAction)columnsSegControlUpdated:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // get some sample text from the bundle's text file
    NSString* text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"SampleText" ofType:@"txt"]
                                               encoding:NSUTF8StringEncoding error:NULL];
    
    // create a font with some sample attributes
    DFXCoreTextFont *font = [[DFXCoreTextFont alloc] init];
    font.fontName = @"Futura-Medium";
    font.fontSize = 20.0f;
    font.textAlignment = DFXTextAlignmentLeft;
    font.lineSpacing = 30.0f;
    font.textColor = [UIColor lightGrayColor];

    // apply some options to our coretext view
    [self.ctView setInnerPadding:CGPointMake(20, 20)];
    [self.ctView setColumnSpacing:20];
    [self.ctView setColumnsPerPage:2];
    
    // set the text then it's font
    [self.ctView setText:text];
    [self.ctView setFont:font];
    
    // update the font name then apply it to any instances of some apple-related strings
    font.fontName = @"AmericanTypewriter-Bold";
    font.textColor = [UIColor whiteColor];
    font.strokeColor = [UIColor blueColor];
    font.strokeWidth = [NSNumber numberWithInt:-3];
    [self.ctView setFont:font forOccurancesOfString:@"apple" comparisonMode:DFXCTComparisonCaseInsensitiveAnyOccurance];
    [self.ctView setFont:font forOccurancesOfString:@"iphone" comparisonMode:DFXCTComparisonCaseInsensitiveAnyOccurance];
    [self.ctView setFont:font forOccurancesOfString:@"ipad" comparisonMode:DFXCTComparisonCaseInsensitiveAnyOccurance];
    [self.ctView setFont:font forOccurancesOfString:@"ios" comparisonMode:DFXCTComparisonCaseInsensitiveAnyOccurance];
}

#pragma mark - Actions
- (IBAction)spacingSliderUpdated:(id)sender {
    UISlider *slider = (UISlider*)sender;
    self.ctView.columnSpacing = ceilf(slider.value);
    [self.ctView setNeedsDisplay];
}

- (IBAction)paddingSliderUpdated:(id)sender {
    UISlider *slider = (UISlider*)sender;
    self.ctView.innerPadding = CGPointMake(ceilf(slider.value), ceilf(slider.value));
    [self.ctView setNeedsDisplay];
}

- (IBAction)columnsSegControlUpdated:(id)sender {
    UISegmentedControl *segControl = (UISegmentedControl*)sender;
    self.ctView.columnsPerPage = segControl.selectedSegmentIndex + 1;
    [self.ctView setNeedsDisplay];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self.ctView setNeedsDisplay];
    return YES;
}

@end

