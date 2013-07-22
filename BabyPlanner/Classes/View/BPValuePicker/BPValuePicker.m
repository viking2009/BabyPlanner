//
//  BPValuePicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPValuePicker.h"
#import "BPValuePickerDelegate.h"
#import "BPPickerView.h"
#import "BPDatePicker.h"
#import "BPTimePicker.h"
#import "BPSoundPicker.h"
#import "BPLanguagePicker.h"
#import "BPPeriodPicker.h"
#import "BPUnitPicker.h"

#import "BPUtils.h"

@interface BPValuePicker ()

@property (nonatomic, strong) id<BPValuePickerDelegate> delegate;
@property (nonatomic, readonly, strong) BPPickerView *pickerView;
@property (nonatomic, readonly, strong) UIToolbar *toolBar;

@end

@implementation BPValuePicker

@synthesize pickerView = _pickerView;
@synthesize toolBar = _toolBar;

- (id)initWithFrame:(CGRect)frame
{
    DLog();
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      _valuePickerMode = BPValuePickerModeNone;
    }
    return self;
}

- (void)dealloc
{
    DLog();
    _delegate = nil;

    _pickerView.delegate = nil;
    _pickerView.dataSource = nil;
}

- (void)setValuePickerMode:(BPValuePickerMode)valuePickerMode
{
    if (_valuePickerMode != valuePickerMode) {
        _valuePickerMode = valuePickerMode;

        _delegate = nil;
//        _pickerView.dataSource = nil;
//        _pickerView.delegate = nil;
        [_pickerView removeFromSuperview];
        _pickerView = nil;

        switch (_valuePickerMode) {
            case BPValuePickerModeDate:
            case BPValuePickerModeLastMenstruationDate:
            case BPValuePickerModeLastOvulationDate:
            case BPValuePickerModeChildBirthday:
                self.delegate = [[BPDatePicker alloc] init];
                self.delegate.control = self;
                break;
               
            case BPValuePickerModeTime:
                self.delegate = [[BPTimePicker alloc] init];
                self.delegate.control = self;
                break;

            case BPValuePickerModeSound:
                self.delegate = [[BPSoundPicker alloc] init];
                self.delegate.control = self;
                break;

            case BPValuePickerModeLanguage:
                self.delegate = [[BPLanguagePicker alloc] init];
                self.delegate.control = self;
                break;

            case BPValuePickerModeMenstruationLength:
                self.delegate = [[BPPeriodPicker alloc] init];
                self.delegate.control = self;
                break;

            case BPValuePickerModeWeight:
            case BPValuePickerModeHeight:
                self.delegate = [[BPUnitPicker alloc] init];
                self.delegate.control = self;
                break;
                
            default:
                break;
        }
        
        _toolBar.hidden = !_pickerView;
        if (self.superview) {
            if (!_pickerView)
                [self.superview sendSubviewToBack:self];
            else
                [self.superview bringSubviewToFront:self];
        }
    }
}

- (void)setValue:(id)value
{
    [self setValue:value animated:NO];
}

- (void)setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %i", value, animated);
    if (_value != value) {
        _value = value;
        
        [self.delegate pickerView:self.pickerView setValue:value animated:animated];
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

- (BPPickerView *)pickerView
{
    if (!_pickerView) {
        DLog();
        _pickerView = [[BPPickerView alloc] init];
        _pickerView.showsSelectionIndicator = YES;
        [self addSubview:_pickerView];
    }
    
    return _pickerView;
}

- (UIToolbar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] init];
        _toolBar.hidden = YES;
        [_toolBar setBackgroundImage:[BPUtils imageNamed:@"toolbar_background"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:BPLocalizedString(@"Done") style:UIBarButtonItemStyleBordered target:self action:@selector(donePressed)];
        
//        UIImage *greenImage = [[BPUtils imageNamed:@"green_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10.f, 0, 10.f) resizingMode:UIImageResizingModeStretch];
        UIImage *greenImage = [BPUtils imageNamed:@"green_button"];
        [doneItem setBackgroundImage:greenImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        NSDictionary *titleTextAttributes = @{UITextAttributeTextColor: RGB(255, 255, 255),
                                              UITextAttributeTextShadowColor: RGBA(0, 0, 0, 0.5),
                                              UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
                                              UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:12]};
        
        [doneItem setBackgroundImage:greenImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [doneItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];

        _toolBar.items = @[flexibleItem, doneItem];
        
        [self addSubview:_toolBar];
    }
    
    return _toolBar;
}

- (void)setDelegate:(id<BPValuePickerDelegate>)delegate
{
    if (_delegate != delegate) {
        DLog(@"%@", delegate);
        _delegate = delegate;

        self.pickerView.dataSource = delegate;
        self.pickerView.delegate = delegate;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.toolBar.frame = CGRectMake(0, 0, self.frame.size.width, 44.f);
    _pickerView.frame = CGRectMake(0, _toolBar.frame.size.height, self.frame.size.width, self.frame.size.height - _toolBar.frame.size.height);
}

- (void)donePressed
{
    self.valuePickerMode = BPValuePickerModeNone;
    if (self.superview)
        [self.superview sendSubviewToBack:self];
}

@end
