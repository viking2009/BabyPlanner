//
//  BPValuePicker.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BPValuePickerMode) {
    BPValuePickerModeNone = -1,
    BPValuePickerModeDate,
    BPValuePickerModeTime,
    BPValuePickerModeSound,
    BPValuePickerModeLanguage,
    BPValuePickerModeWeight,
    BPValuePickerModeHeight,
    BPValuePickerModeMenstruationLength,
    BPValuePickerModeLastMenstruationDate,
    BPValuePickerModeLastOvulationDate,
    BPValuePickerModeChildBirthday,
    BPValuePickerModeTemperature
};

@interface BPValuePicker : UIControl

@property (nonatomic) BPValuePickerMode valuePickerMode;
@property (nonatomic, strong) id value;

- (void)setValue:(id)value animated:(BOOL)animated;

@end

