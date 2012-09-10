DFXCoreTextView
===============

A CoreText wrapper for the formatting and display of scrollable text in columns. The helper class DFXCoreTextFont is used as a replacement for UIFont, providing many formatting options only available in CoreText.

![DFXCoreTextView Screenshot](https://github.com/davefoxy/DFXCoreTextView/master/screenshot.png "DFXCoreTextView Screenshot")

https://github.com/davefoxy/DFXCoreTextView/blob/master/README.md

### Installation
Just drag the "DFXCoreTextView" folder inside the project directory into your own project (tick 'Copy items into destination groups' folder) and add the CoreText framework to your project's build phases.

### Usage
First, create an instance of the base view, DFXCoreTextView in either code or by setting a view inside a XIB to DFXCoreTextView. This is where all your text will be rendered. The view extends UIScrollView for pagination and scrolling however you're free to declare yourself as it's delegate.

Default options are in place for presentation however, for customisation, you currently have access to the following properties on an instance:

    @property (nonatomic, assign) int columnsPerPage;
    @property (nonatomic, assign) CGPoint innerPadding;
    @property (nonatomic, assign) float columnSpacing;

When it's all set up, assign text using any or a combination of the following methods:

    - (void)setText:(NSString*)text;
    - (void)setFont:(DFXCoreTextFont*)font;
    - (void)setFont:(DFXCoreTextFont*)font forRange:(NSRange)range;
    - (void)setFont:(DFXCoreTextFont*)font forOccurancesOfString:(NSString*)string comparisonMode:(DFXCTComparisonMode)comparisonMode;

### Using DFXCoreTextFont
The DFXCoreTextFont class is the only way to format text or specific pieces of text in a DFXCoreTextView. It's essentially what you use instead of UIFont and it offers a few more attributes that only be achieved by using CoreText. Currently, the following properties are available:

    @property (nonatomic, copy) NSString *fontName;
    @property (nonatomic, assign) float fontSize;
    @property (nonatomic, assign) DFXTextAlignment textAlignment;
    @property (nonatomic, strong) UIColor *textColor;
    @property (nonatomic, strong) UIColor *borderColor;
    @property (nonatomic, assign) CGFloat lineSpacing;
    @property (nonatomic, assign) BOOL underlined;

### Project Requirements
DFXCoreTextView uses ARC and some elements of 'Modern Objective-C' such as auto-synthesize which requires Xcode 4.4