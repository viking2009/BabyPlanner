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
        _value = nil;

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
        [_toolBar setBackgroundImage:[BPUtils imageNamed:@"toolbar_background"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIImage *blackImage = [BPUtils imageNamed:@"black_button"];
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, 0, blackImage.size.width, blackImage.size.height);
        [cancelButton setBackgroundImage:blackImage forState:UIControlStateNormal];
        [cancelButton setTitle:@"X" forState:UIControlStateNormal];
        [cancelButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        cancelButton.titleLabel.shadowColor = RGBA(0, 0, 0, 0.5);
        cancelButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
        cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [cancelButton addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];

        UIImage *greenImage = [BPUtils imageNamed:@"green_button"];
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(0, 0, greenImage.size.width, greenImage.size.height);
        [doneButton setBackgroundImage:greenImage forState:UIControlStateNormal];
        [doneButton setTitle:@"OK" forState:UIControlStateNormal];
        [doneButton setTitleColor:RGB(255, 255, 255) forState:UIControlStateNormal];
        doneButton.titleLabel.shadowColor = RGBA(0, 0, 0, 0.5);
        doneButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
        doneButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
        [doneButton addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];

        _toolBar.items = @[cancelItem, flexibleItem, doneItem];
        
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
    
    self.toolBar.frame = CGRectMake(0, 0, self.frame.size.width, BPSettingsToolbarHeight);
    _pickerView.frame = CGRectMake(0, _toolBar.frame.size.height, self.frame.size.width, self.frame.size.height - _toolBar.frame.size.height);
}

- (void)cancelPressed:(id)sender;
{
    self.valuePickerMode = BPValuePickerModeNone;
    if (self.superview)
        [self.superview sendSubviewToBack:self];
}

- (void)donePressed:(id)sender;
{
    self.valuePickerMode = BPValuePickerModeNone;
    if (self.superview)
        [self.superview sendSubviewToBack:self];
}

@end
