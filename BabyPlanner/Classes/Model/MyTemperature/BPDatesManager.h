//
//  BPDatesManager.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 14.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBPDatesManagerSkipDays 5
#define kBPDatesManagerPrevDays 6
#define kBPDatesManagerNextDays 3
#define kBPDatesManagerMinOvulationIndex 10
#define kBPDatesManagerDefaultOvulationIndex 13

#define kBPDatesManagerFertileBefore 5
#define kBPDatesManagerFertileAfter 1

#define kBPDatesManagerBoyStart -4
#define kBPDatesManagerBoyEnd -2

#define kBPDatesManagerGirlStart -2
#define kBPDatesManagerGirlEnd 0

#define kBPDatesManagerPregnantDays 4

#define kBPDatesManagerNumberOfCyclesForAverageCandidateIndex 4

#define BP_EPSILON  0.001f

@class BPCycle;

extern NSString *const BPDatesManagerDidChangeContentNotification;

@interface BPDatesManager : NSObject

@property (nonatomic, readonly) NSDate *startDate;
@property (nonatomic, readonly) NSDate *endDate;
@property (nonatomic, readonly) NSInteger count;
@property (nonatomic, readonly) NSInteger ovulationIndex;
@property (nonatomic, readonly) NSInteger todayIndex;
@property (nonatomic, readonly) BPCycle *cycle;

- (id)initWithCycle:(BPCycle *)cycle;
- (id)objectAtIndexedSubscript:(NSUInteger)idx NS_AVAILABLE(10_8, 6_0);

- (NSInteger)indexForDate:(NSDate *)date;

@end
