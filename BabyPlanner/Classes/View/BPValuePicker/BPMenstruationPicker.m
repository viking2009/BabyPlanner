//
//  BPMenstruationPicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 18.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPMenstruationPicker.h"

#define kBPMenstruationPickerMinPeriod 3
#define kBPMenstruationPickerMaxPeriod 7

@interface BPMenstruationPicker ()

@property (nonatomic, strong) NSNumber *periodLength;

@end

@implementation BPMenstruationPicker

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return kBPMenstruationPickerMaxPeriod - kBPMenstruationPickerMinPeriod + 1;
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.control.value = @(kBPMenstruationPickerMinPeriod + row);
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 126.f;
}

- (NSString *)pickerView:(BPPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%i", kBPMenstruationPickerMinPeriod + row];
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
    return self.periodLength;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_periodLength != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        _periodLength = value;
        
        NSInteger length = [self.periodLength integerValue];
        [pickerView selectRow:length - kBPMenstruationPickerMinPeriod inComponent:0 animated:animated];
    }
}
@end
