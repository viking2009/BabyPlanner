//
//  BPLanguageManager.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPLanguageManager.h"
#import "BPSettings.h"

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
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    if (!sharedSettings[BPSettingsLanguageKey]) {
        NSArray* languages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        sharedSettings[BPSettingsLanguageKey] = ([languages count] ? languages : self.supportedLanguages)[0];
    }
    
    return sharedSettings[BPSettingsLanguageKey];
}

- (void)setCurrentLanguage:(NSString *)newLanguage
{
    _currentLocale = nil;

    BPSettings *sharedSettings = [BPSettings sharedSettings];
    sharedSettings[BPSettingsLanguageKey] = newLanguage;
}

- (NSLocale *)currentLocale
{
    if (!_currentLocale)
        _currentLocale = [NSLocale localeWithLocaleIdentifier:self.currentLanguage];
    
    return _currentLocale;
}


- (NSArray *)supportedLanguages
{
    return @[@"en", @"ru"];
}

- (NSString *)localizedStringForKey:(NSString *)key
{
    NSString *path = [[NSBundle mainBundle] pathForResource:self.currentLanguage ofType:@"lproj"];
    return [[NSBundle bundleWithPath:path] localizedStringForKey:key value:nil table:nil];
}

@end
