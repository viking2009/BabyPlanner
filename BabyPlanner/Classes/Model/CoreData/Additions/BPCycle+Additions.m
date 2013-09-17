//
//  BPCycle+Additions.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCycle+Additions.h"
#import "NSDate-Utilities.h"
#import "BPLanguageManager.h"

@implementation BPCycle (Additions)

- (NSUInteger)length {
    return [self.endDate daysAfterDate:self.startDate] + 1;
}

- (NSString *)title {
    static NSDateFormatter *dateFormatter = nil;
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd.MM.yy"];
    }
    
    dateFormatter.locale = [BPLanguageManager sharedManager].currentLocale;
    
    return [NSString stringWithFormat:@"%@-%@", [dateFormatter stringFromDate:self.startDate], [dateFormatter stringFromDate:self.endDate]];
}

@end
