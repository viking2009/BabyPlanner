//
//  BPTemperaturePicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 13.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPTemperaturePicker.h"
#import "BPLanguageManager.h"
#import "BPUtils.h"

#define kBPTemperaturePickerMinTemperature 34
#define kBPTemperaturePickerMaxTemperature 42

@interface BPTemperaturePicker ()

@property (nonatomic, strong) NSNumber *currentValue;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger maxValue;

@end

@implementation BPTemperaturePicker

- (id)init {
    self = [super init];
    if (self) {
        if ([BPLanguageManager sharedManager].currentMetric == 0) {
            self.minValue = floorf([BPUtils celsiusToFahrenheit:kBPTemperaturePickerMinTemperature]);
            self.maxValue = floorf([BPUtils celsiusToFahrenheit:kBPTemperaturePickerMaxTemperature]);
        } else {
            self.minValue = kBPTemperaturePickerMinTemperature;
            self.maxValue = kBPTemperaturePickerMaxTemperature;
        }
    }
    
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRowsInComponent = 10;
        
    switch (component) {
        case 0:
            numberOfRowsInComponent = self.maxValue - self.minValue + 1;
            break;
        case 1:
            numberOfRowsInComponent = 1;
            break;
        default:
            break;
    }
    
    return numberOfRowsInComponent;
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    float length = 0;
    length += self.minValue + [pickerView selectedRowInComponent:0];
    length += 0.1 * [pickerView selectedRowInComponent:2];
    length += 0.01 * [pickerView selectedRowInComponent:3];
    
    self.control.value = @(length);
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 62.f;
    
    switch (component) {
        case 0:
            width = 108.f;
            break;
        case 1:
            width = 20.f;
            break;
        default:
            break;
    }
    
    return width;
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
    
    switch (component) {
        case 0:
            label.text = [NSString stringWithFormat:@"%d", self.minValue + row];
            break;
        case 1:
            label.text = @".";
            break;
        default:
            label.text = [NSString stringWithFormat:@"%d", row];
            break;
    }
    
    return label;
}

- (CGFloat)pickerView:(BPPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.f;
}

#pragma mark - BPValuePickerDelegate

- (id)value
{
    if ([BPLanguageManager sharedManager].currentMetric == 0)
        return @([BPUtils fahrenheitToCelsius:[self.currentValue floatValue]]);
    else
        return self.currentValue;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_currentValue != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        if ([BPLanguageManager sharedManager].currentMetric == 0)
            _currentValue =  @([BPUtils celsiusToFahrenheit:[value floatValue]]);
        else
            _currentValue = value;

        
        // TODO: fix value: v = @(floorf(v*100)/100);??
        
//        float floatValue = MIN(kBPTemperaturePickerMaxTemperature + 0.99f, MAX([self.currentValue floatValue], kBPTemperaturePickerMinTemperature));
//        _currentValue = @(floatValue);
        NSInteger length = [self.currentValue integerValue];
        
        // TODO: fix bug with conversion
        [pickerView selectRow:length - self.minValue inComponent:0 animated:animated];
        [pickerView selectRow:(int)([self.currentValue floatValue] * 10) % 10 inComponent:2 animated:animated];
        [pickerView selectRow:(int)([self.currentValue floatValue] * 100) % 10 inComponent:3 animated:animated];
        
        DLog(@"_temperature = %@", _currentValue);
    }
}

@end
