//
//  BPCyclesManager.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPCyclesManager.h"
#import "BPCycle.h"
#import "BPProfile.h"
#import "ObjectiveRecord.h"
#import "ObjectiveSugar.h"
#import "BPSettings+Additions.h"
#import "NSDate-Utilities.h"

@implementation BPCyclesManager

+ (BPCyclesManager *)sharedManager
{
    static BPCyclesManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (NSUInteger)numberOfCycles
{
    return self.cycles.count;
}

- (NSUInteger)averageCycleLength
{
    return [[self.cycles valueForKeyPath:@"@avg.length"] unsignedIntegerValue];
}

- (NSArray *)cycles
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    NSArray *cycles = [[sharedSettings.profile.cycles allObjects] sort];
    if (![cycles count]) {
        BPCycle *cycle = [BPCycle create:@{@"index": @1}];
        
        NSDate *startDate = sharedSettings[BPSettingsProfileLastMenstruationDateKey] ? : [NSDate date];
        cycle.startDate = [startDate dateAtStartOfDay];
        
        NSInteger lengthOfCycle = [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
        cycle.endDate = [cycle.startDate dateByAddingDays:lengthOfCycle - 1];
        
        cycle.profile = sharedSettings.profile;
        [cycle save];
        
        return @[cycle];
    }
    
    return cycles;
}

- (BPCycle *)currentCycle
{
    return self.cycles.first;
}

@end
