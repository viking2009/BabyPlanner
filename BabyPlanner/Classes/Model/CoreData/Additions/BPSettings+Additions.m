//
//  BPSettings+Additions.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 14.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPSettings+Additions.h"

#import "BPLanguageManager.h"
#import "BPThemeManager.h"
#import "ObjectiveRecord.h"
#import "ObjectiveSugar.h"
#import "BPProfile.h"


#define BPMultiplierKg2Lb 2.20462262
#define BPMultiplierCm2Ft 0.032808399

NSString *const BPSettingsDidChangeNotification = @"BPSettingsDidChangeNotification";

@implementation BPSettings (Additions)

+ (BPSettings *)sharedSettings
{
    static BPSettings *_sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSettings = [self all].first;
        if (!_sharedSettings) {
            _sharedSettings = [self create];
            _sharedSettings.profile = [BPProfile create];
        }
    });
    
    return _sharedSettings;
}

// TODO: ?use CoreData for Profile?

- (id)objectForKeyedSubscript:(id)key
{
    if (!key)
        return nil;
    
    id result = [self valueForKeyPath:key];
    
    // TODO: set default settings here
    if ([key isEqualToString:BPSettingsProfileLengthOfCycleKey]) {
        // NOTE: setted by CoreData
//        if (!result)
//            result = @30;
    } if ([key isEqualToString:BPSettingsProfileWeightKey]) {
        float weight = [result floatValue] * ([BPLanguageManager sharedManager].currentMetric == 0 ? BPMultiplierKg2Lb : 1);
        result = @((int)(weight * 10)/10.f);
    } else if ([key isEqualToString:BPSettingsProfileHeightKey]) {
        float height = [result floatValue] * ([BPLanguageManager sharedManager].currentMetric == 0 ? BPMultiplierCm2Ft : 1);
        result = @((int)(height * 10)/10.f);
    }
        
    return result;
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!obj || !key)
        return ;
    
    id oldObj = [self objectForKeyedSubscript:key];
    if (![obj isEqual:oldObj]) {        
        if ([(id)key isEqualToString:BPSettingsProfileWeightKey]) {
            float weight = [obj floatValue] / ([BPLanguageManager sharedManager].currentMetric == 0 ? BPMultiplierKg2Lb : 1);
            obj = @(weight);
        } else if ([(id)key isEqualToString:BPSettingsProfileHeightKey]) {
            float height = [obj floatValue] / ([BPLanguageManager sharedManager].currentMetric == 0 ? BPMultiplierCm2Ft : 1);
            obj = @(height);
        }
        
        [self setValue:obj forKeyPath:(NSString *)key];
        
        if ([self save]) {
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
