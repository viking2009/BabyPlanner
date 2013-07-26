//
//  BPSettings.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 22.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettings.h"
#import "BPLanguageManager.h"
#import "BPThemeManager.h"

#define BPMultiplierKg2Lb 2.20462262
#define BPMultiplierCm2Ft 0.032808399

NSString *const BPSettingsDidChangeNotification = @"BPSettingsDidChangeNotification";

@implementation BPSettings

+ (BPSettings *)sharedSettings
{
    static BPSettings *_sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSettings = [[self alloc] init];
    });

    return _sharedSettings;
}

// TODO: ?use CoreData for Profile?

- (id)objectForKeyedSubscript:(id)key
{
    if (!key)
        return nil;
    
    NSString *keyString = [NSString stringWithFormat:@"%@.%@", NSStringFromClass([self class]), [key description]];
    id result = [[NSUserDefaults standardUserDefaults] objectForKey:keyString];

    if ([key isEqualToString:BPSettingsProfileWeightKey]) {
        float weight = [result floatValue] * ([BPLanguageManager sharedManager].currentMetric == 0 ? BPMultiplierKg2Lb : 1);
        result = @((int)(weight * 10)/10.f);
    } else if ([key isEqualToString:BPSettingsProfileHeightKey]) {
        float height = [result floatValue] * ([BPLanguageManager sharedManager].currentMetric == 0 ? BPMultiplierCm2Ft : 1);
        result = @((int)(height * 10)/10.f);
    }
    
    DLog(@"result = %@", result)
    
    return result;
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!obj || !key)
        return ;
    
    id oldObj = [self objectForKeyedSubscript:key];
    if (![obj isEqual:oldObj]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *keyString = [NSString stringWithFormat:@"%@.%@", NSStringFromClass([self class]), [(id)key description]];
        
        if ([(id)key isEqualToString:BPSettingsProfileWeightKey]) {
            float weight = [obj floatValue] / ([BPLanguageManager sharedManager].currentMetric == 0 ? BPMultiplierKg2Lb : 1);
            obj = @(weight);
        } else if ([(id)key isEqualToString:BPSettingsProfileHeightKey]) {
            float height = [obj floatValue] / ([BPLanguageManager sharedManager].currentMetric == 0 ? BPMultiplierCm2Ft : 1);
            obj = @(height);
        }
        
        [defaults setObject:obj forKey:keyString];
        
        if ([defaults synchronize]) {
            NSString *notificationName = BPSettingsDidChangeNotification;
            if ([(id)key isEqualToString:BPSettingsLanguageKey])
                notificationName = BPLanguageDidChangeNotification;
            else if ([(id)key isEqualToString:BPSettingsThemeKey])
                notificationName = BPThemeDidChangeNotification;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self userInfo:@{key: obj}];
        }
    }
    
}

@end
