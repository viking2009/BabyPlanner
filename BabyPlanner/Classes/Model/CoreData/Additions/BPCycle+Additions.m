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
#import "ObjectiveRecord.h"
#import "ObjectiveSugar.h"
#import "BPSettings+Additions.h"
#import "BPDate+Additions.h"

@implementation BPCycle (Additions)

- (NSUInteger)length {
    return [self.endDate daysAfterDate:self.startDate] + 1;
}

- (NSInteger)ovulationIndex {
    NSPredicate *ovulationPredicate = [NSPredicate predicateWithFormat:@"%K == %@", @"ovulation", @YES];
    NSArray *ovulations = [[self.dates filteredSetUsingPredicate:ovulationPredicate] allObjects];
    if ([ovulations count] == 1) {
        BPDate *ovulationDate = ovulations.first;
        return [ovulationDate.day integerValue] - 1;
    }
    
    return NSNotFound;
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

- (NSComparisonResult)compare:(BPCycle *)cycle {
    // MARK: reverse order
    return [cycle.index compare:self.index];
}

+ (BPCycle *)cycleWithIndex:(NSNumber *)index
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];

    BPCycle *cycle = [self where:[NSPredicate predicateWithFormat:@"index == %@ AND profile == %@", index, sharedSettings.profile]].first;
    if (!cycle) {
        cycle = [self create:@{@"index": index}];
        cycle.profile = sharedSettings.profile;
    }
    
    return cycle;
}


@end
