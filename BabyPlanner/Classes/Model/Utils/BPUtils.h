//
//  BPUtils.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPLanguageManager.h"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define BPLocalizedString(key) [[BPLanguageManager sharedManager] localizedStringForKey:(key)]

#define BPDefaultCellInset 10.f

#define BPAlarmGuid 100
#define BPPickerViewHeight (216.f + 44.f)

@interface BPUtils : NSObject

+ (UIImage *)imageNamed:(NSString *)name;

+ (NSString *)shortStringFromDate:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)timeFromDate:(NSDate *)date;

+ (NSString *)weightFromNumber:(NSNumber *)number;
+ (NSString *)heightFromNumber:(NSNumber *)number;
+ (NSString *)temperatureFromNumber:(NSNumber *)number;

+ (NSNumber *)weightFromString:(NSString *)string;
+ (NSNumber *)heightFromString:(NSString *)string;
+ (NSNumber *)temperatureFromString:(NSString *)string;

+ (float)kgToLb:(float)weight;
+ (float)lbToKg:(float)weight;
+ (float)cmToFt:(float)length;
+ (float)ftToCm:(float)length;
+ (float)fahrenheitToCelsius:(float)temperature;
+ (float)celsiusToFahrenheit:(float)temperature;

+ (NSDateFormatter *)dateFormatter;
+ (NSNumberFormatter *)numberFormatter;

/**
 * @return device full model name in human readable strings
 */
+ (NSString*)deviceModelName;


@end
