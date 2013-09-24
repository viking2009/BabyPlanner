//
//  BPUtils.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPUtils.h"
#import "BPLanguageManager.h"

#import <sys/types.h>
#import <sys/sysctl.h>

#define BPMultiplierKg2Lb   2.20462262
#define BPMultiplierCm2Ft   0.032808399
#define BPMultiplierC2F     1.8

static NSDateFormatter *_dateFormatter = nil;
static NSNumberFormatter *_numberFormatter = nil;

@implementation BPUtils

+ (UIImage *)imageNamed:(NSString *)name
{
    return [UIImage imageNamed:[@"BPImages.bundle" stringByAppendingPathComponent:name]];
}

+ (NSString *)shortStringFromDate:(NSDate *)date
{
    if (!date)
        return nil;
    
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    if (!date)
        return nil;
    
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)timeFromDate:(NSDate *)date
{
    if (!date)
        return nil;
    
    NSDateFormatter *dateFormatter = [self dateFormatter];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)weightFromNumber:(NSNumber *)number
{
    if (!number || ![number integerValue])
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    [numberFormatter setMinimumFractionDigits:1];
    [numberFormatter setMaximumFractionDigits:1];
    if ([BPLanguageManager sharedManager].currentMetric == 0)
        [numberFormatter setMultiplier:@(BPMultiplierKg2Lb)];
    
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)heightFromNumber:(NSNumber *)number
{
    if (!number || ![number integerValue])
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    [numberFormatter setMinimumFractionDigits:1];
    [numberFormatter setMaximumFractionDigits:1];
    if ([BPLanguageManager sharedManager].currentMetric == 0)
        [numberFormatter setMultiplier:@(BPMultiplierCm2Ft)];
    
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)temperatureFromNumber:(NSNumber *)number
{
    if (!number || ![number integerValue])
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    if ([BPLanguageManager sharedManager].currentMetric == 0) {
        number = @([self celsiusToFahrenheit:[number floatValue]]);
        [numberFormatter setPositiveSuffix:@"°F"];
    } else
        [numberFormatter setPositiveSuffix:@"°C"];
    
    return [numberFormatter stringFromNumber:number];
}

+ (NSNumber *)weightFromString:(NSString *)string
{
    if (!string)
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    if ([BPLanguageManager sharedManager].currentMetric == 0)
        [numberFormatter setMultiplier:@(BPMultiplierKg2Lb)];
    
    return [numberFormatter numberFromString:string];
}

+ (NSNumber *)heightFromString:(NSString *)string
{
    if (!string)
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    if ([BPLanguageManager sharedManager].currentMetric == 0)
        [numberFormatter setMultiplier:@(BPMultiplierCm2Ft)];
    
    return [numberFormatter numberFromString:string];
}

+ (NSNumber *)temperatureFromString:(NSString *)string
{
    if (!string)
        return nil;
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    if ([BPLanguageManager sharedManager].currentMetric == 0)
        [numberFormatter setPositiveSuffix:@"°F"];
    else
        [numberFormatter setPositiveSuffix:@"°C"];
    
    NSNumber *temperature = [numberFormatter numberFromString:string];
    
    if ([BPLanguageManager sharedManager].currentMetric == 0)
        temperature = @([self fahrenheitToCelsius:[temperature floatValue]]);

    return temperature;
}

+ (NSString *)ordinalStringFromNumber:(NSNumber *)number
{
    if (!number || [number integerValue] < 0)
        return nil;
    
    NSString *suffix = nil;
    
    if ([[BPLanguageManager sharedManager].currentLanguage isEqualToString:@"ru"])
        suffix = @"й";
    else {
        // If number % 100 is 11, 12, or 13
        if (NSLocationInRange([number integerValue] % 100, NSMakeRange(11, 3)))
            suffix = @"th";
        else {
            switch ([number integerValue] % 10) {
                case 1:
                    suffix = @"st";
                    break;
                case 2:
                    suffix = @"nd";
                    break;
                case 3:
                    suffix = @"rd";
                    break;
                default:
                    suffix = @"th";
                    break;
            }
        }
    }
    
    return [NSString stringWithFormat:@"%i%@", [number integerValue], suffix];
}

+ (float)kgToLb:(float)weight
{
    return BPMultiplierKg2Lb * weight;
}

+ (float)lbToKg:(float)weight
{
    return weight / BPMultiplierKg2Lb;
}

+ (float)cmToFt:(float)length
{
    return BPMultiplierCm2Ft * length;
}

+ (float)ftToCm:(float)length
{
    return length / BPMultiplierCm2Ft;
}

+ (float)celsiusToFahrenheit:(float)temperature
{
    return temperature*9/5 + 32.f;
}

+ (float)fahrenheitToCelsius:(float)temperature
{
    return (temperature - 32.f)*5/9;
}

+ (NSDateFormatter *)dateFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc] init];
    });
    
    [_dateFormatter setLocale:[BPLanguageManager sharedManager].currentLocale];

    return _dateFormatter;
}

+ (NSNumberFormatter *)numberFormatter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _numberFormatter = [[NSNumberFormatter alloc] init];
//        [_numberFormatter setRoundingMode:NSNumberFormatterRoundCeiling];
        [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    });
    
    [_numberFormatter setLocale:[BPLanguageManager sharedManager].currentLocale];
    [_numberFormatter setMultiplier:@1];
    [_numberFormatter setMinimumFractionDigits:0];
    [_numberFormatter setMaximumFractionDigits:0];
    [_numberFormatter setPositiveSuffix:nil];

    return _numberFormatter;
}

+ (NSString *)deviceModelName {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    //    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    //    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    //    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    //    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    //    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (CDMA)";
    //    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    //    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    //    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    //    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    //    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    //    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    //    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    //    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    //    if ([platform isEqualToString:@"x86_64"])         return @"Simulator";
    
    return platform;
}

@end
