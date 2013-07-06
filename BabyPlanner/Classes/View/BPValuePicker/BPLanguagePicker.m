//
//  BPLanguagePicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPLanguagePicker.h"

@interface BPLanguagePicker ()

@property (nonatomic, strong) NSString *selectedLanguage;
@property (nonatomic, strong) NSArray *languages;

@end

@implementation BPLanguagePicker

- (id)init
{
    self = [super init];
    if (self) {
        self.languages = @[@"English", @"Русский"];
    }
    
    return self;
}

#pragma mark - BPPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(BPPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(BPPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.languages count];
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"%i %i", row, component);
    
    NSString *selectedLanguage = _languages[row];
    self.control.value = selectedLanguage;
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 252.f;
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
    
    label.text = _languages[row];
    
    return label;
}

- (CGFloat)pickerView:(BPPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.f;
}

#pragma mark - BPValuePickerDelegate

- (id)value
{
    DLog();
    return self.selectedLanguage;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_selectedLanguage != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        _selectedLanguage = value;
        
        [pickerView selectRow:[self.languages indexOfObject:_selectedLanguage] inComponent:0 animated:animated];
    }
}

@end
