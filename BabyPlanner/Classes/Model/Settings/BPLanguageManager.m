//
//  BPLanguageManager.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPLanguageManager.h"
#import "BPSettings+Additions.h"
#import "BPUtils.h"

NSString *const BPLanguageDidChangeNotification = @"BPLanguageDidChangeNotification";

@implementation BPLanguageManager

@synthesize currentLocale = _currentLocale;

+ (BPLanguageManager *)sharedManager
{
    static BPLanguageManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (NSString *)currentLanguage
{
    DLog();
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    if (!sharedSettings[BPSettingsLanguageKey]) {
        NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        sharedSettings[BPSettingsLanguageKey] = ([languages count] ? languages : self.supportedLanguages)[0];
        sharedSettings[BPSettingsMetricKey] = @([self.supportedLanguages indexOfObject:sharedSettings[BPSettingsLanguageKey]]);
    }
    
    return sharedSettings[BPSettingsLanguageKey];
}

- (void)setCurrentLanguage:(NSString *)aLanguage
{
    DLog();
    _currentLocale = nil;

    BPSettings *sharedSettings = [BPSettings sharedSettings];
    sharedSettings[BPSettingsLanguageKey] = aLanguage;
}

- (NSLocale *)currentLocale
{
    DLog();
    if (!_currentLocale)
        _currentLocale = [[NSLocale alloc] initWithLocaleIdentifier:self.currentLanguage];
    
    return _currentLocale;
}


- (NSArray *)supportedLanguages
{
    return @[@"en", @"ru"];
}

- (NSUInteger)currentMetric
{
    DLog();
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    if (!sharedSettings[BPSettingsMetricKey])
        sharedSettings[BPSettingsMetricKey] = @([self.supportedLanguages indexOfObject:self.currentLanguage]);
    
    return [sharedSettings[BPSettingsMetricKey] unsignedIntegerValue];
}

- (void)setCurrentMetric:(NSUInteger)aMetric
{
    DLog();
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    sharedSettings[BPSettingsMetricKey] = @(aMetric);
}

- (NSArray *)supportedMetrics
{
    return @[BPLocalizedString(@"U.S."), BPLocalizedString(@"Metric")];
}

- (NSString *)localizedStringForKey:(NSString *)key
{
    NSString *path = [[NSBundle mainBundle] pathForResource:self.currentLanguage ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:nil];
}

@end
