//
//  BPUtils.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPLanguageManager.h"

@interface BPUtils : NSObject

+ (UIImage *)imageNamed:(NSString *)name;

+ (NSString *)shortStringFromDate:(NSDate *)date;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)timeFromDate:(NSDate *)date;
+ (NSString *)monthStringFromDate:(NSDate *)date;
+ (NSString *)monthOnlyStringFromDate:(NSDate *)date;

+ (NSString *)weightFromNumber:(NSNumber *)number;
+ (NSString *)heightFromNumber:(NSNumber *)number;
+ (NSString *)temperatureFromNumber:(NSNumber *)number;
+ (NSString *)shortTemperatureFromNumber:(NSNumber *)number;

+ (NSNumber *)weightFromString:(NSString *)string;
+ (NSNumber *)heightFromString:(NSString *)string;
+ (NSNumber *)temperatureFromString:(NSString *)string;

+ (NSString *)ordinalStringFromNumber:(NSNumber *)number;

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
