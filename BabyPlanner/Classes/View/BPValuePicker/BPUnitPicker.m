//
//  BPUnitPicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 15.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPUnitPicker.h"

@interface BPUnitPicker ()

@property (nonatomic, strong) NSNumber *currentValue;

@end

@implementation BPUnitPicker

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 5;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (component == 3 ? 1 : 10);
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    float length = 0;
    length += 100 * [pickerView selectedRowInComponent:0];
    length += 10 * [pickerView selectedRowInComponent:1];
    length += [pickerView selectedRowInComponent:2];
    length += 0.1 * [pickerView selectedRowInComponent:4];

    //    [self pickerView:pickerView setValue:date animated:NO];
    self.control.value = @(length);
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return (component == 3 ? 20.f : 58.f);
}

- (UIView *)pickerView:(BPPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:24];
        label.textAlignment = NSTextAlignmentCenter;
    }
    
    label.text = (component == 3 ? @"." : [NSString stringWithFormat:@"%d", row]);
    
    return label;
}

- (CGFloat)pickerView:(BPPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.f;
}

#pragma mark - BPValuePickerDelegate

- (id)value
{
    return self.currentValue;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_currentValue != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        _currentValue = value;
        
        NSInteger length = [self.currentValue integerValue];
        
        [pickerView selectRow:(length / 100) inComponent:0 animated:animated];
        [pickerView selectRow:((length / 10) % 10) inComponent:1 animated:animated];
        [pickerView selectRow:(length % 10) inComponent:2 animated:animated];
        [pickerView selectRow:(int)([self.currentValue floatValue] * 10) % 10 inComponent:4 animated:animated];

        DLog(@"_periodLength = %@", _currentValue);
    }
}

@end
