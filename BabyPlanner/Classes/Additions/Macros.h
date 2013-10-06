//
//  Macros.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 22.07.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#ifndef BabyPlanner_Macros_h
#define BabyPlanner_Macros_h

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define DATE_COMPONENTS (NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit)

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define BPLocalizedString(key) [[BPLanguageManager sharedManager] localizedStringForKey:(key)]

#define BPDefaultCellInset 10.f

#define BPAlarmGuid 100
#define BPPickerViewHeight (216.f + 44.f)

#define BPBugSenseApiKey                    @"4d8df9f5"
#define USE_CFBUNDLEVERSION                 1

#define kBPTemperaturePickerMinTemperature 34
#define kBPTemperaturePickerMaxTemperature 42

#define BPSettingsToolbarHeight             44.f
#define BPSettingsPickerMinimalOriginY      (300.f - BPSettingsToolbarHeight)

#define BPSettingsThermometrKey             @"thermometr"
#define BPSettingsMetricKey                 @"metric"
#define BPSettingsLanguageKey               @"language"
#define BPSettingsThemeKey                  @"theme"

#define BPSettingsProfileNameKey            @"profile.name"
#define BPSettingsProfileBirthdayKey        @"profile.birthday"
#define BPSettingsProfileWeightKey          @"profile.weight"
#define BPSettingsProfileHeightKey          @"profile.height"

#define BPSettingsProfileLengthOfCycleKey           @"profile.lengthOfCycle"
#define BPSettingsProfileLastMenstruationDateKey    @"profile.lastMenstruation"
#define BPSettingsProfileMenstruationPeriodKey      @"profile.menstruationPeriod"

#define BPSettingsProfileIsPregnantKey              @"profile.isPregnant"
#define BPSettingsProfileConceivingKey              @"profile.conceiving"
#define BPSettingsProfileBoyKey                     @"profile.boy"
#define BPSettingsProfileGirlKey                    @"profile.girl"

#define BPSettingsProfileLastOvulationDateKey       @"profile.lastOvulation"
#define BPSettingsProfileChildBirthdayKey           @"profile.childBirthday"

#define BPPregnancyPeriod                   (7*38)

// TESTS

#define TEST_NORMAL_CYCLE1      0
#define TEST_NORMAL_CYCLE2      0
#define TEST_ANOVUL_CYCLE       0
#define TEST_PREGNANCY_CYCLE    0

#endif
