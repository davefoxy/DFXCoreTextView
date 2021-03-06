DFXCoreTextView
===============

A CoreText wrapper for the formatting and display of scrollable text in columns. The helper class DFXCoreTextFont is used as a replacement for UIFont, providing many formatting options only available in CoreText.

![DFXCoreTextView Screenshot](https://raw.github.com/davefoxy/DFXCoreTextView/master/screenshot.png "DFXCoreTextView Screenshot")

### Installation
Just drag the "DFXCoreTextView" folder inside the project directory into your own project (tick "Copy items into destination groups' folder") and add the CoreText framework to your project's build phases.

### Usage
First, create an instance of the base view, DFXCoreTextView in either code or by setting a view inside a XIB to DFXCoreTextView. This is where all your text will be rendered. The view extends UIScrollView for pagination and scrolling however you're free to declare yourself as it's delegate.

Default options are in place for presentation however, for customisation, you currently have access to the following properties on an instance:

    @property (nonatomic, assign) int columnsPerPage;
    @property (nonatomic, assign) CGPoint innerPadding;
    @property (nonatomic, assign) float columnSpacing;

When it's all set up, assign text using:

    - (void)setText:(NSString*)text;

### Formatting Using DFXCoreTextFont
The DFXCoreTextFont class is the only way to format text or specific pieces of text in a DFXCoreTextView. It's essentially what you use instead of UIFont and it offers a few more attributes that only be achieved by using CoreText. Currently, the following properties are available:

    @property (nonatomic, copy) NSString *fontName;
    @property (nonatomic, assign) float fontSize;
    @property (nonatomic, assign) DFXTextAlignment textAlignment;
    @property (nonatomic, strong) UIColor *textColor;
    @property (nonatomic, strong) UIColor *strokeColor;
    @property (nonatomic, strong) NSNumber *strokeWidth;
    @property (nonatomic, assign) CGFloat lineSpacing;
    @property (nonatomic, assign) BOOL underlined;
    @property (nonatomic, assign) float kerning;

When you've created your DFXCoreTextFont instance, assign it to your text by using one of the following methods:

    - (void)setFont:(DFXCoreTextFont*)font;
    - (void)setFont:(DFXCoreTextFont*)font forRange:(NSRange)range;
    - (void)setFont:(DFXCoreTextFont*)font forOccurancesOfString:(NSString*)string comparisonMode:(DFXCTComparisonMode)comparisonMode;

### Updating The View
Drawing and layout happens in drawRect: so if you're finding text not updating properly, remember to call setNeedsDisplay on your view.

### Project Requirements
DFXCoreTextView uses ARC and some elements of 'Modern Objective-C' such as auto-synthesize which requires Xcode 4.4