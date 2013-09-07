//
//  BPTimePicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPTimePicker.h"
#import "NSDate-Utilities.h"

@interface BPTimePicker ()

@property (nonatomic, strong) NSDate *date;

@end

@implementation BPTimePicker

#pragma mark - BPPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (component == 0 ? 24 : 12);
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"%i %i", row, component);
    
    NSDate *date;
    if (component == 0) {
        date = [[[self.date dateAtStartOfDay] dateByAddingHours:row] dateByAddingMinutes:self.date.minute];
    } else {
        date = [[[self.date dateAtStartOfDay] dateByAddingHours:self.date.hour] dateByAddingMinutes:5*row];
    }
    
//    [self pickerView:pickerView setValue:date animated:NO];
    self.control.value = date;
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 126.f;
}

- (NSString *)pickerView:(BPPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger value = row;
    if (component == 1)
        value *= 5;
    
    return [NSString stringWithFormat:@"%02i", value];
}

- (CGFloat)pickerView:(BPPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.f;
}

- (NSTextAlignment)pickerView:(BPPickerView *)pickerView textAlignmentForComponent:(NSInteger)component
{
    return NSTextAlignmentCenter;
}

#pragma mark - BPValuePickerDelegate

- (id)value
{
    return self.date;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_date != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        _date = value;

        self.date = [self.date dateByAddingMinutes:(self.date.minute % 5 == 0 ? 0 : (5 - self.date.minute % 5))];
        [pickerView selectRow:self.date.hour inComponent:0 animated:animated];
        [pickerView selectRow:self.date.minute/5 inComponent:1 animated:animated];
    }
}

@end
