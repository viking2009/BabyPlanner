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
#import "BPTimePicker.h"
#import "BPSoundPicker.h"

@interface BPValuePicker ()

@property (nonatomic, strong) id<BPValuePickerDelegate> delegate;
@property (nonatomic, readonly, strong) BPPickerView *pickerView;

@end

@implementation BPValuePicker

@synthesize pickerView = _pickerView;

- (id)initWithFrame:(CGRect)frame
{
    DLog();
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.valuePickerMode = -1;
        self.valuePickerMode = BPValuePickerModeTime;
    }
    return self;
}

- (void)dealloc
{
    DLog();
    _pickerView.delegate = nil;
    _pickerView.dataSource = nil;
    
    _delegate = nil;
}

- (void)setValuePickerMode:(BPValuePickerMode)valuePickerMode
{
//    if (_valuePickerMode != valuePickerMode) {
        _valuePickerMode = valuePickerMode;
        _pickerView = nil;
    
        switch (_valuePickerMode) {
            case BPValuePickerModeTime:
                self.delegate = [[BPTimePicker alloc] init];
                self.delegate.control = self;
                break;

            case BPValuePickerModeSound:
                self.delegate = [[BPSoundPicker alloc] init];
                self.delegate.control = self;
                break;

            default:
                break;
        }
//    }
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

- (void)setDelegate:(id<BPValuePickerDelegate>)delegate
{
    if (_delegate != delegate) {
        DLog(@"%@", delegate);
        _delegate = delegate;

        self.pickerView.dataSource = delegate;
        self.pickerView.delegate = delegate;
    }
}


@end
