//
//  BPValuePickerDelegate.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 06.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPPickerView.h"
#import "BPValuePicker.h"

@protocol BPValuePickerDelegate <BPPickerViewDataSource,BPPickerViewDelegate>

@property (nonatomic, weak) BPValuePicker *control;
@property (nonatomic, strong) id value;

- (void)pickerView:(BPPickerView *)pickerView setValue:(id)value animated:(BOOL)animated;

@end
