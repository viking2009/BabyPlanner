//
//  BPDatePicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 15.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDatePicker.h"
#import "NSDate-Utilities.h"
#import "BPLanguageManager.h"

#define BPYearRadius 50

@interface BPDatePicker ()

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSRange yearRange;

@end

@implementation BPDatePicker

#pragma mark - BPPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger numberOfRowsInComponent = 0;
    
    switch (component) {
        case 0:
            if (self.date) {
                NSRange dayRange = [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self.date];
                numberOfRowsInComponent = dayRange.length;
            }
            break;
        case 1:
            numberOfRowsInComponent = 12;
            break;
        case 2:
            numberOfRowsInComponent = self.yearRange.length;
            break;
        default:
            break;
    }

    return numberOfRowsInComponent;
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"%i %i", row, component);
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                   fromDate:self.date];
    
    switch (component) {
        case 0:
            dateComponents.day = row + 1;
            break;
        case 1:
            dateComponents.month = row + 1;
            break;
        case 2:
            dateComponents.year = row + self.yearRange.location;
            break;
            
        default:
            break;
    }
    
    NSDate *date = [calendar dateFromComponents:dateComponents];

    //    [self pickerView:pickerView setValue:date animated:NO];
    self.control.value = date;
    
    if (component == 1)
        [pickerView reloadComponent:0];
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat width = 0.f;
    switch (component) {
        case 0:
            width = 40.f;
            break;
        case 1:
            width = 138.f;
            break;
        case 2:
            width = 74.f;
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
    }
    
    label.textAlignment = (component == 1 ? NSTextAlignmentLeft : NSTextAlignmentCenter);
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    dateFormatter.locale = [BPLanguageManager sharedManager].currentLocale;
    
    switch (component) {
        case 0:
            label.text = [NSString stringWithFormat:@"%d", (row + 1)];
            break;
        case 1:
            label.text = [[dateFormatter monthSymbols] objectAtIndex:row];
            break;
        case 2:
            label.text = [NSString stringWithFormat:@"%d", (self.yearRange.location + row)];
            break;
        default:
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
    return self.date;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_date != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        _date = value;
        
        NSDate *today = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)
                                                       fromDate:today];
        
        NSRange range;
        range.location = dateComponents.year - BPYearRadius;
        range.length = 2*BPYearRadius + 1;
        self.yearRange = range;
        
        self.date = [value dateAtStartOfDay];
        [pickerView selectRow:self.date.day - 1 inComponent:0 animated:animated];
        [pickerView selectRow:self.date.month - 1 inComponent:1 animated:animated];
        [pickerView selectRow:self.date.year - self.yearRange.location inComponent:2 animated:animated];
        
        DLog(@"self.date = %@", self.date);
    }
}

@end
