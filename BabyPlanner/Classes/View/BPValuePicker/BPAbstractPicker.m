//
//  BPAbstractPicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPAbstractPicker.h"

@implementation BPAbstractPicker

@synthesize control;

- (void)dealloc
{
    DLog("%@", [self class]);
    self.control = nil;
}

#pragma mark - BPPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 0;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 0;
}

#pragma mark - BPValuePickerDelegate

- (id)value
{
    return nil;
}

- (void)setValue:(id)value
{
    // nothing;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated;
{
    // nothing
}

@end
