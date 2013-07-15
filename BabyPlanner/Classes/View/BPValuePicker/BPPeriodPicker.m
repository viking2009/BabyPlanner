//
//  BPPeriodPicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 15.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPPeriodPicker.h"

@interface BPPeriodPicker ()

@property (nonatomic, strong) NSNumber *periodLength;

@end

@implementation BPPeriodPicker

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger length = 0;
    length += 100 * [pickerView selectedRowInComponent:0];
    length += 10 * [pickerView selectedRowInComponent:1];
    length += [pickerView selectedRowInComponent:2];
    
//    [self pickerView:pickerView setValue:date animated:NO];
    self.control.value = @(length);
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 84.f;
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
    
    label.text = [NSString stringWithFormat:@"%d", row];
    
    return label;
}

- (CGFloat)pickerView:(BPPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.f;
}

#pragma mark - BPValuePickerDelegate

- (id)value
{
    return self.periodLength;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_periodLength != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        _periodLength = value;
        
        NSInteger length = [self.periodLength integerValue];
        
        [pickerView selectRow:(length / 100) inComponent:0 animated:animated];
        [pickerView selectRow:((length / 10) % 10) inComponent:1 animated:animated];
        [pickerView selectRow:(length % 10) inComponent:2 animated:animated];
        
        DLog(@"_periodLength = %@", _periodLength);
    }
}

@end
