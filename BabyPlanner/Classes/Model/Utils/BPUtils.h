//
//  BPUtils.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 24.06.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPLanguageManager.h"

#define RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define BPLocalizedString(key) [[BPLanguageManager sharedManager] localizedStringForKey:(key)]

#define BPDefaultCellInset 10.f

#define BPAlarmGuid 100
#define BPPickerViewHeight (216.f + 44.f)

@interface BPUtils : NSObject

+ (UIImage *)imageNamed:(NSString *)name;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
