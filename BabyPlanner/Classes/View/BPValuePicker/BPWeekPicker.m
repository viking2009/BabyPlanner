//
//  BPWeekPicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 5/24/14.
//  Copyright (c) 2014 Mykola Vyshynskyi. All rights reserved.
//

#import "BPWeekPicker.h"
#import "BPUtils.h"

@implementation BPWeekPicker

#pragma mark - BPPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return BPWeekPickerNumberOfWeeks;
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"%i %i", row, component);
    
    self.control.value = @(row + 1);
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 252.f;
}

- (NSString *)pickerView:(BPPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@ %i", BPLocalizedString(@"Week"), row + 1];
}

- (CGFloat)pickerView:(BPPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.f;
}

- (UIEdgeInsets)pickerView:(BPPickerView *)pickerView textInsetForComponent:(NSInteger)component
{
    return UIEdgeInsetsMake(0, 60.f, 0, 40.f);
}

#pragma mark - BPValuePickerDelegate

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (self.value != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        self.value = value;
        
        [pickerView selectRow:([value integerValue] - 1) inComponent:0 animated:animated];
    }
}

@end
