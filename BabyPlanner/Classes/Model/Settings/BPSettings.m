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
    return [[NSUserDefaults standardUserDefaults] objectForKey:keyString];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!obj || !key)
        return ;
    
    id oldObj = [self objectForKeyedSubscript:key];
    if (![obj isEqual:oldObj]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *keyString = [NSString stringWithFormat:@"%@.%@", NSStringFromClass([self class]), [(id)key description]];
        
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
