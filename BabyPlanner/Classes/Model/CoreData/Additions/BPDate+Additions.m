//
//  BPDate+Additions.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 22.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDate+Additions.h"
#import "BPSettings+Additions.h"
#import "ObjectiveRecord.h"
#import "ObjectiveSugar.h"
#import "NSDate-Utilities.h"

@implementation BPDate (Additions)

+ (BPDate *)dateWithDate:(NSDate *)aDate
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    aDate = [aDate dateAtStartOfDay];
    
    BPDate *date = [BPDate where:[NSPredicate predicateWithFormat:@"date == %@ AND profile == %@", aDate, sharedSettings.profile]].first;
    if (!date) {
        date = [BPDate create:@{@"date": aDate}];
        date.profile = sharedSettings.profile;
    }
    
    return date;
}

@end
