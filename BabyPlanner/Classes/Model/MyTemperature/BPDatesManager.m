//
//  BPDatesManager.m
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 14.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPDatesManager.h"
#import "NSDate-Utilities.h"
#import "BPDate.h"
#import "ObjectiveRecord.h"
#import "ObjectiveSugar.h"
#import "BPSettings+Additions.h"
#import "BPDate+Additions.h"
#import "BPCycle+Additions.h"
#import "BPCyclesManager.h"
#import <CoreData/CoreData.h>

NSString *const BPDatesManagerDidChangeContentNotification = @"BPDatesManagerDidChangeContentNotification";

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

#define kBPDatesManagerNumberOfCyclesForAverageCandidateIndex 4

#define BP_EPSILON  0.001f

@interface BPDatesManager()

@property (nonatomic, strong) BPCycle *cycle;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, assign) NSDate *endDate;
@property (nonatomic, strong) NSMutableDictionary *dates;

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger ovulationCandidateIndex;
@property (nonatomic, assign) NSInteger ovulationIndex;
@property (nonatomic, assign) NSInteger todayIndex;
@property (nonatomic, assign) NSInteger conceivingIndex;
@property (nonatomic, assign) float midTemperature;

@property (nonatomic, assign) BOOL boy;
@property (nonatomic, assign) BOOL girl;


@property (nonatomic, strong) NSDictionary *testTemperatures;

- (void)calculateOvulationCandidateIndex;
- (void)calculateOvulationIndex;
- (void)calculateConceivingIndex;
- (void)calculateBoyGirl;

@end

@implementation BPDatesManager

- (id)init
{
    return [self initWithCycle:[BPCyclesManager sharedManager].currentCycle];
}

- (id)initWithCycle:(BPCycle *)cycle
{
    self = [super init];
    if (self) {
        
        self.testTemperatures = @{@"normal1": @[@36.7, @36.7, @36.5, @36.5, @36.4, @36.4, @36.3, @36.4, @36.3, @36.4,
                                               @36.4, @36.2, @36.3, @36.3, @36.6, @36.7, @36.7, @36.8, @36.9, @37.0,
                                               @37.0, @36.9, @37.0, @37.1, @37.0, @36.7, @36.7, @36.6],
                                  @"normal2": @[@36.5, @36.4, @36.3, @36.3, @36.4, @36.3, @36.5, @36.4, @36.4, @36.4,
                                               @36.3, @36.3, @36.4, @36.3, @36.3, @36.2, @36.6, @36.7, @36.8, @36.9, @37.0, @37.0,
                                               @37.1, @36.9, @37.0, @36.9, @37.0, @36.9, @36.9, @36.7],
                                  @"anovul": @[@36.5, @36.4, @36.4, @36.5, @36.6, @36.7, @36.5, @36.5, @36.7, @36.4,
                                               @36.6, @36.5, @36.6, @36.7, @36.8, @36.7, @36.9, @36.8, @36.6, @37.0,
                                               @37.0, @36.8, @36.6, @36.8, @36.7, @36.6, @36.5, @36.5],
                                  @"pregnancy": @[@37.0, @36.8, @36.8, @36.6, @36.4, @36.4, @36.3, @36.4, @36.3, @36.4,
                                                  @36.4, @36.2, @36.3, @36.3, @36.6, @36.7, @36.8, @36.9, @36.9, @37.0,
                                                  @36.7, @36.9, @37.0, @37.0, @36.9, @37.1, @37.1, @37.2, @37.1, @37.1]};
        
        self.cycle = cycle;
        
        self.startDate = [self.cycle.startDate dateAtStartOfDay];
        self.count = 56;
        self.endDate = [self.cycle.endDate dateAtStartOfDay];

        self.todayIndex = [self indexForDate:[NSDate date]];
        
        [self calculateOvulationCandidateIndex];
        
        if ([self.cycle isEqual:[BPCyclesManager sharedManager].currentCycle]) {
            [self calculateOvulationIndex];
            [self calculateConceivingIndex];
            [self calculateBoyGirl];
        } else
            self.ovulationIndex = cycle.ovulationIndex;
        
        self.dates = [[NSMutableDictionary alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];

    NSDateComponents *comps = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self.startDate];
    comps.day += idx;
    NSDate *dateForItem = [CURRENT_CALENDAR dateFromComponents:comps];

    BPDate *item = _dates[dateForItem];

    if (!item) {
        item = [BPDate dateWithDate:dateForItem];
        // MARK: add to cycle
        if (!([dateForItem isEarlierThanDate:self.cycle.startDate] || [dateForItem isLaterThanDate:self.cycle.endDate]))
            item.cycle = self.cycle;
        
        if ([self.cycle isEqual:[BPCyclesManager sharedManager].currentCycle]) {
            // fix cycle
            if ([dateForItem isLaterThanDate:self.cycle.endDate])
                item.cycle = nil;
        }
        
        _dates[dateForItem] = item;
    }
    
    BPCycle *currentCycle = [BPCyclesManager sharedManager].currentCycle;
    
    if ([self.cycle isEqual:currentCycle]) {
        item.day = @(idx + 1);
        if (![item.mmenstruation boolValue])
            item.menstruation = @(idx < [sharedSettings[BPSettingsProfileMenstruationPeriodKey] integerValue]);
        
        //    item.pregnant = @([sharedSettings[BPSettingsProfileIsPregnantKey] boolValue]);
        item.ovulation = @(idx == self.ovulationIndex);
    }
 
#if TEST_NORMAL_CYCLE1
    if (idx < [self.testTemperatures[@"normal1"] count])
        item.temperature = self.testTemperatures[@"normal1"][idx];
#elif TEST_NORMAL_CYCLE2
    if (idx < [self.testTemperatures[@"normal2"] count])
        item.temperature = self.testTemperatures[@"normal2"][idx];
#elif TEST_ANOVUL_CYCLE
    if (idx < [self.testTemperatures[@"anovul"] count])
        item.temperature = self.testTemperatures[@"anovul"][idx];
#elif TEST_PREGNANCY_CYCLE
    if (idx < [self.testTemperatures[@"pregnancy"] count])
        item.temperature = self.testTemperatures[@"pregnancy"][idx];
#endif
    
    NSString *imageName = @"point_clear";
    
//    if (idx < self.ovulationCandidateIndex)
//        imageName = @"point_green";
//    else if (idx < [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue])
//        imageName = @"point_salad";
    
    NSInteger lengthOfCycle = [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
//    if (idx < lengthOfCycle || [item.temperature floatValue] > kBPTemperaturePickerMinTemperature - BP_EPSILON)
    if (idx < MAX(lengthOfCycle, self.todayIndex + 1))
        imageName = @"point_green";
    
    //    if (self.conceivingIndex != NSNotFound && idx >= self.conceivingIndex && idx < MAX(lengthOfCycle, self.todayIndex + 1))
    BOOL isPregnant = NO;
    if ([self.cycle isEqual:currentCycle])
        isPregnant = (self.conceivingIndex != NSNotFound && idx > self.conceivingIndex && idx <= self.todayIndex);
    else
        isPregnant = [item.pregnant boolValue];
    
    if (isPregnant)
        imageName = @"point_red";
    
    if (self.ovulationIndex == NSNotFound) {
        if ((idx >= MAX(self.ovulationCandidateIndex, self.todayIndex) - kBPDatesManagerFertileBefore) && (idx <= self.ovulationCandidateIndex + kBPDatesManagerFertileAfter))
            imageName = @"point_red";
        
        if ((idx > self.ovulationCandidateIndex + kBPDatesManagerFertileAfter) && (self.todayIndex >= self.ovulationCandidateIndex + kBPDatesManagerFertileAfter) && idx < MAX(lengthOfCycle, self.todayIndex + 1))
                imageName = @"point_yellow";

        if (idx == self.ovulationCandidateIndex && self.todayIndex <= self.ovulationCandidateIndex)
            imageName = @"point_ovulation";
        
//        if (idx == self.ovulationCandidateIndex)
//            imageName = @"point_ovulation";
    } else {
        if ((idx >= self.ovulationIndex - kBPDatesManagerFertileBefore) && (idx <= self.ovulationIndex + kBPDatesManagerFertileAfter))
            imageName = @"point_red";
        
        if (idx == self.ovulationIndex)
            imageName = @"point_ovulation";
    }
    
    if ([self.cycle isEqual:currentCycle]) {
        if (isPregnant) {
            item.boy = @(self.boy);
            item.girl = @(self.girl);
        } else {
            NSInteger ovulationIndex = (self.ovulationIndex == NSNotFound ? self.ovulationCandidateIndex : self.ovulationIndex);
            item.boy = @((idx >= ovulationIndex + kBPDatesManagerBoyStart) && (idx <= ovulationIndex + kBPDatesManagerBoyEnd));
            item.girl = @((idx >= ovulationIndex + kBPDatesManagerGirlStart) && (idx <= ovulationIndex + kBPDatesManagerGirlEnd));
        }
        
        item.pregnant = @(isPregnant);
    }
    
    if ([item.menstruation boolValue])
        imageName = @"point_pink";
    
    item.imageName = imageName;
    
    return item;
}

- (NSInteger)indexForDate:(NSDate *)date
{
    if (!date)
        return NSNotFound;
    
    NSInteger days = [self.startDate distanceInDaysToDate:date];
    return (days >= 0 && days < self.count ? days : NSNotFound);    
}

- (void)calculateOvulationCandidateIndex
{
    self.ovulationCandidateIndex = kBPDatesManagerDefaultOvulationIndex;

    NSUInteger numberOfCycles = [BPCyclesManager sharedManager].numberOfCycles;
    NSInteger currentIndex = [[BPCyclesManager sharedManager].cycles indexOfObject:self.cycle];
    BPCycle *firstCycle = [BPCyclesManager sharedManager].cycles.last;
    if (currentIndex != NSNotFound && ![self.cycle isEqual:firstCycle]) {
        if (currentIndex < kBPDatesManagerNumberOfCyclesForAverageCandidateIndex) {
            BPCycle *previousCycle = [BPCyclesManager sharedManager].cycles[currentIndex + 1];

            NSUInteger ovulationIndex = previousCycle.ovulationIndex;
            if (ovulationIndex != NSNotFound)
                self.ovulationCandidateIndex = ovulationIndex;
        } else {
            NSInteger sum = 0;
            NSUInteger days = 0;
            for (NSInteger i = 1; i < numberOfCycles; i++) {
                BPCycle *previousCycle = [BPCyclesManager sharedManager].cycles[currentIndex + 1];
                
                NSUInteger ovulationIndex = previousCycle.ovulationIndex;
                if (ovulationIndex != NSNotFound) {
                    sum += ovulationIndex;
                    days++;
                }
             }
            
            if (sum && days)
                self.ovulationCandidateIndex = sum / days;
        }
    }
}

- (void)calculateOvulationIndex
{
//    BPSettings *sharedSettings = [BPSettings sharedSettings];

//    self.ovulationIndex = self.ovulationCandidateIndex;
    self.ovulationIndex = NSNotFound;
    self.midTemperature = kBPTemperaturePickerMaxTemperature;
    
    NSInteger lengthOfCycle = self.count;// [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
    
    DLog(@"self.todayIndex = %i", self.todayIndex);
    
    if (self.todayIndex < lengthOfCycle && self.todayIndex > kBPDatesManagerMinOvulationIndex - 1) {
        NSInteger minIndex = 0;
        float minTemperature = kBPTemperaturePickerMaxTemperature;
        
        // find min temperature and ovulation index
        for (NSInteger i = kBPDatesManagerSkipDays; i < self.todayIndex; i++) {
        //for (NSInteger i = self.ovulationCandidateIndex; i < self.todayIndex; i++) {
            DLog(@"1:i: %i", i);
            BPDate *date = self[i];
            float temperature = [date.temperature floatValue];
            
            if (temperature >= kBPTemperaturePickerMinTemperature && temperature < minTemperature) {
                minIndex = i;
                minTemperature = temperature;
            }
        }
        
        DLog(@"minTemperature: %f", minTemperature);
        
        // found min temperature
        if (minTemperature < kBPTemperaturePickerMaxTemperature) {
            // TODO: if not enough data
            
            DLog(@"self.ovulationIndex: %i", self.ovulationCandidateIndex);
            
            float midTemperature = minTemperature;
            DLog(@"minTemperature: %f", minTemperature);

            for (NSInteger i = self.ovulationCandidateIndex - (kBPDatesManagerPrevDays - 1); i < self.ovulationCandidateIndex; i++) {
                DLog(@"2:i: %i", i);
                BPDate *date = self[i];
                float temperature = [date.temperature floatValue];
                
                midTemperature = MAX(midTemperature, temperature);
            }

            DLog(@"midTemperature: %f", midTemperature);
            
            NSInteger maxIndex = minIndex;
            float currTemperature = minTemperature;

            for (NSInteger i = minIndex + 1; i < lengthOfCycle && currTemperature < midTemperature + BP_EPSILON; i ++) {
                DLog(@"3:i: %i", i);
                BPDate *date = self[i];
                float temperature = [date.temperature floatValue];
                DLog(@"temperature: %f, maxTemperature: %f", temperature, midTemperature);

//                if (temperature > midTemperature)
                if (temperature > midTemperature + BP_EPSILON)
                    maxIndex = i - 1;
                    
                currTemperature = temperature;
            }
            
            NSInteger ovulationIndex = maxIndex;
            DLog(@"ovulationIndex: %i", ovulationIndex);

            if (ovulationIndex < self.todayIndex) {
                NSInteger count1 = 0;
                NSInteger count2 = 0;
                
                NSInteger startIndex = ovulationIndex + 1;
                NSInteger endIndex = MIN(startIndex + kBPDatesManagerNextDays - 1, self.todayIndex);
                for (NSInteger i = startIndex; i <= endIndex; i++) {
                    DLog(@"4:i: %i", i);
                    BPDate *date = self[i];
                    float temperature = [date.temperature floatValue];
                    DLog(@"temperature: %f", temperature);
                    
                    float diff = temperature - midTemperature;
                    DLog(@"diff: %f", diff);
                    if (diff > 0) {
                        if (diff > 0.2f - BP_EPSILON)
                            count2++;
                        else if (diff > 0.1f - BP_EPSILON)
                            count1++;
                    }
                    
                }
                
                DLog(@"count1: %i, count2: %i", count1, count2);

                //if (count2 > 2 || (count2 == 2 && count1 == 1)) {
                //if (count1 > 2 || (count1 == 2 && count2 == 1) || count2 > 2) {
//                if (count1 > 1 || (count1 == 1 && count2 == 1) || count2 > 1) {
                if (count1 + count2 >= 3) {
                    self.ovulationIndex = ovulationIndex;
                    self.midTemperature = midTemperature;
                } else {
                    self.ovulationIndex = NSNotFound;
                }
            }
        } else
            self.ovulationIndex = NSNotFound;
    }
    
    
    DLog(@"self.ovulationCandidateIndex: %i", self.ovulationCandidateIndex);
    DLog(@"self.ovulationIndex: %i", self.ovulationIndex);
}

- (void)calculateConceivingIndex {
    DLog();
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    NSDate *conceiving = sharedSettings[BPSettingsProfileConceivingKey];
    if (conceiving && [sharedSettings[BPSettingsProfileIsPregnantKey] boolValue])
        self.conceivingIndex = [self indexForDate:conceiving];
    else {
        self.conceivingIndex = NSNotFound;
        
        if (self.ovulationIndex != NSNotFound) {
            BOOL isPregnant = NO;
            
            for (NSInteger i = self.ovulationIndex - 4; i <= MIN(self.ovulationIndex + 2, self.todayIndex); i++) {
                BPDate *date = self[i];
                if ([date.sexualIntercourse boolValue]) {
                    isPregnant = YES;
                    self.conceivingIndex = i;
                    break;
                }
            }
            
            if (self.conceivingIndex != NSNotFound && self.ovulationIndex != NSNotFound)
                self.conceivingIndex = MAX(self.conceivingIndex, self.ovulationIndex);
            
            // check temperature
            for (NSInteger i = self.ovulationIndex + 1; i < MIN(self.count, self.todayIndex + 1); i++) {
                BPDate *date = self[i];
                float temperature = [date.temperature floatValue];
                if (temperature && temperature < self.midTemperature) {
                    isPregnant = NO;
                    self.conceivingIndex = NSNotFound;
                    break;
                }
            }
        }
    }
    
    if (self.conceivingIndex != NSNotFound && self.ovulationIndex != NSNotFound) {
        BPSettings *sharedSettings = [BPSettings sharedSettings];
        BPDate *date = self[self.ovulationIndex];
        sharedSettings[BPSettingsProfileChildBirthdayKey] = [date.date dateByAddingDays:BPPregnancyPeriod];
    }
}

- (void)calculateBoyGirl {
    BOOL isPregnant = (self.ovulationIndex != NSNotFound && self.conceivingIndex != NSNotFound && self.conceivingIndex <= self.todayIndex);
    if (isPregnant) {
        for (NSInteger i = self.ovulationIndex - kBPDatesManagerFertileBefore; i <= self.ovulationIndex + kBPDatesManagerFertileAfter; i++) {
            BPDate *date = self[i];
            
            if (!self.boy)
                self.boy = ([date.boy boolValue] && [date.sexualIntercourse boolValue]);
            
            if (!self.girl)
                self.girl = ([date.girl boolValue] && [date.sexualIntercourse boolValue]);
        }
    }
}

- (void)refresh:(NSNotification *)notification
{
    DLog(@"%@", notification);
    [self.dates removeAllObjects];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:BPDatesManagerDidChangeContentNotification object:nil];
}

@end
