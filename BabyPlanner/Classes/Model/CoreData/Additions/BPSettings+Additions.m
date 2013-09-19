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
#import "BPUtils.h"
#import "BPCyclesManager.h"
#import "BPCycle.h"
#import "NSDate-Utilities.h"

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

- (id)objectForKeyedSubscript:(id)key
{
    if (!key)
        return nil;
    
    id result = [self valueForKeyPath:key];
    
//    if ([key isEqualToString:BPSettingsProfileWeightKey]) {
//        if ([BPLanguageManager sharedManager].currentMetric == 0)
//            result = @([BPUtils kgToLb:[result floatValue]]);
//    } else if ([key isEqualToString:BPSettingsProfileHeightKey]) {
//        if ([BPLanguageManager sharedManager].currentMetric == 0)
//            result = @([BPUtils cmToFt:[result floatValue]]);
//    }
    
    return result;
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!obj || !key || ![(id)key isKindOfClass:[NSString class]])
        return ;
    
    id oldObj = [self objectForKeyedSubscript:key];
    if (![obj isEqual:oldObj]) {        
//        if ([(id)key isEqualToString:BPSettingsProfileWeightKey]) {
//            if ([BPLanguageManager sharedManager].currentMetric == 0)
//                obj = @([BPUtils lbToKg:[obj floatValue]]);
//        } else if ([(id)key isEqualToString:BPSettingsProfileHeightKey]) {
//            if ([BPLanguageManager sharedManager].currentMetric == 0)
//                obj = @([BPUtils ftToCm:[obj floatValue]]);
//        }
        
        [self setValue:obj forKeyPath:(NSString *)key];
        
        if ([self save]) {
            // MARK: update current cycle
            if ([(id)key isEqualToString:BPSettingsProfileLastMenstruationDateKey] || [(id)key isEqualToString:BPSettingsProfileLengthOfCycleKey]) {
                BPCycle *cycle = [BPCyclesManager sharedManager].currentCycle;
                
                NSDate *startDate = self[BPSettingsProfileLastMenstruationDateKey] ? : [NSDate date];
                cycle.startDate = [startDate dateAtStartOfDay];
                
                NSInteger lengthOfCycle = [self[BPSettingsProfileLengthOfCycleKey] integerValue];
                cycle.endDate = [cycle.startDate dateByAddingDays:lengthOfCycle - 1];
                
                [cycle save];
            }
            
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
