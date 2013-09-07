//
//  BPSoundPicker.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSoundPicker.h"

@interface BPSoundPicker ()

@property (nonatomic, strong) NSString *soundName;
@property (nonatomic, strong) NSArray *sounds;

@end


@implementation BPSoundPicker

- (id)init
{
    self = [super init];
    if (self) {
        self.sounds = @[@"Crickets.caf", @"Digital.caf", @"Marimba.caf", @"Old Phone.caf", @"Piano Riff.caf"];
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
    return [self.sounds count];
}

#pragma mark - BPPickerViewDelegate

- (void)pickerView:(BPPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"%i %i", row, component);
    
    NSString *soundName = _sounds[row];
    self.control.value = soundName;
}

- (CGFloat)pickerView:(BPPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 252.f;
}

- (NSString *)pickerView:(BPPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_sounds[row] stringByDeletingPathExtension];
}

- (CGFloat)pickerView:(BPPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.f;
}

- (UIEdgeInsets)pickerView:(BPPickerView *)pickerView textInsetForComponent:(NSInteger)component
{
    return UIEdgeInsetsMake(0, 40.f, 0, 40.f);
}

#pragma mark - BPValuePickerDelegate

- (id)value
{
    return self.soundName;
}

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated
{
    DLog(@"%@ %@ %i", pickerView, value, animated);
    if (_soundName != value && [pickerView.dataSource isKindOfClass:[self class]]) {
        _soundName = value;
                
        DLog(@"_soundName %@", _soundName);
        
        [pickerView selectRow:[self.sounds indexOfObject:_soundName] inComponent:0 animated:animated];
    }
}

@end
