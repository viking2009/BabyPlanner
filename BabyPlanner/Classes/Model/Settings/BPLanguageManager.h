//
//  BPLanguageManager.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const BPLanguageDidChangeNotification;

@interface BPLanguageManager : NSObject

+ (BPLanguageManager *)sharedManager;

@property (nonatomic, strong) NSString* currentLanguage;
@property (nonatomic, readonly) NSLocale* currentLocale;
@property (nonatomic, readonly) NSArray* supportedLanguages;

- (NSString *)localizedStringForKey:(NSString *)key;

@end
