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
#import "ObjectiveSugar.h"

@interface BPTemperaturePicker ()

@property (nonatomic, strong) NSString *currentValue;
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
    self.control.value = [NSString stringWithFormat:@"%i%@%i%i%@",
                          self.minValue + [pickerView selectedRowInComponent:0],
                          [[BPUtils numberFormatter] decimalSeparator],
                          [pickerView selectedRowInComponent:2],
                          [pickerView selectedRowInComponent:3],
                          ([BPLanguageManager sharedManager].currentMetric == 0 ? @"°F" : @"°C")];
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 62.f;
    
    switch (component) {
        case 0:
            width = 108.f;
            break;
        case 1:
            width = 24.f;
            break;
        default:
            break;
    }
    
    return width;
}

- (NSString *)pickerView:(BPPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = nil;
    switch (component) {
        case 0:
            title = [NSString stringWithFormat:@"%i", self.minValue + row];
            break;
        case 1:
            title = [[BPUtils numberFormatter] decimalSeparator];
            break;
        default:
            title = [NSString stringWithFormat:@"%i", row];
            break;
    }
    
    return title;
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
    return self.currentValue;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_currentValue != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        NSNumber *valueNumber = [BPUtils temperatureFromString:value];

        // fix range
        float floatValue = MIN(kBPTemperaturePickerMaxTemperature + 0.99f, MAX([valueNumber floatValue], kBPTemperaturePickerMinTemperature));
        value = [BPUtils temperatureFromNumber:@(floatValue)];
        
        // BUG: when on value was fixed for range closed to kBPTemperaturePickerMinTemperature or kBPTemperaturePickerMaxTemperature _ 0.99f;
        
        // remove suffix
        _currentValue = [value split:@"°"].first;

        // select rows
        [pickerView selectRow:[self.currentValue integerValue] - self.minValue inComponent:0 animated:animated];
        NSString *lastChar = [self.currentValue substringWithRange:NSMakeRange([self.currentValue length] - 2, 1)];
        [pickerView selectRow:[lastChar integerValue] inComponent:2 animated:animated];
        lastChar = [self.currentValue substringFromIndex:[self.currentValue length] - 1];
        [pickerView selectRow:[lastChar integerValue] inComponent:3 animated:animated];
        
        DLog(@"_temperature = %@", _currentValue);
    }
}

@end
