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

@implementation BPUtils

+ (UIImage *)imageNamed:(NSString *)name
{
    return [UIImage imageNamed:[@"BPImages.bundle" stringByAppendingPathComponent:name]];
}

+ (NSString *)shortStringFromDate:(NSDate *)date
{
    if (!date)
        return nil;
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d.MM.yyyy"];
    }
    
    dateFormatter.locale = [BPLanguageManager sharedManager].currentLocale;
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    if (!date)
        return nil;
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"d MMMM yyyy"];
    }
    
    dateFormatter.locale = [BPLanguageManager sharedManager].currentLocale;
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)timeFromDate:(NSDate *)date
{
    if (!date)
        return nil;
    
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    
    dateFormatter.locale = [BPLanguageManager sharedManager].currentLocale;
    
    return [dateFormatter stringFromDate:date];
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
