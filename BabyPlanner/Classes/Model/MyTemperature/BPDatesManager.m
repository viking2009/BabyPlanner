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
#import <CoreData/CoreData.h>

NSString *const BPDatesManagerDidChangeContentNotification = @"BPDatesManagerDidChangeContentNotification";

#define kBPDatesManagerSkipDays 5
#define kBPDatesManagerPrevDays 6
#define kBPDatesManagerNextDays 3
#define kBPDatesManagerMinOvulationIndex 10
#define kBPDatesManagerDefaultOvulationIndex 13

#define BP_EPSILON  0.001f

#define TEST_NORMAL_CYCLE1  0
#define TEST_NORMAL_CYCLE2  0
#define TEST_ANOVUL_CYCLE   0

@interface BPDatesManager()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSMutableDictionary *dates;

@property (nonatomic, assign) NSDate *endDate;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger ovulationCandidateIndex;
@property (nonatomic, assign) NSInteger ovulationIndex;
@property (nonatomic, assign) NSInteger todayIndex;

@property (nonatomic, strong) NSDictionary *testTemperatures;

- (void)calculateOvulationIndex;

@end

@implementation BPDatesManager

- (id)init
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];

    return [self initWithStartDate:sharedSettings[BPSettingsProfileLastMenstruationDateKey] ? : [NSDate date]];
}

- (id)initWithStartDate:(NSDate *)date
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
                                               @37.0, @36.8, @36.6, @36.8, @36.7, @36.6, @36.5, @36.5]};
        
        self.startDate = [date dateAtStartOfDay];
        self.count = 56;
        self.endDate = [self.startDate dateByAddingDays:self.count - 1];

        self.todayIndex = [self indexForDate:[NSDate date]];
        // TODO: calculate with BPCyclesManager
        self.ovulationCandidateIndex = kBPDatesManagerDefaultOvulationIndex;
        
        [self calculateOvulationIndex];
        
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

    NSDate *dateForItem = [self.startDate dateByAddingDays:idx];

    BPDate *item = _dates[dateForItem];

    if (!item) {
        item = [BPDate dateWithDate:dateForItem];
        _dates[dateForItem] = item;
    }
    
    item.day = @(idx + 1);
    if (![item.mmenstruation boolValue])
        item.menstruation = @(idx < [sharedSettings[BPSettingsProfileMenstruationPeriodKey] integerValue]);

    item.pregnant = @([sharedSettings[BPSettingsProfileIsPregnantKey] boolValue]);
    item.ovulation = @(idx == self.ovulationIndex);
 
#if TEST_NORMAL_CYCLE1
    if (idx < [self.testTemperatures[@"normal1"] count])
        item.temperature = self.testTemperatures[@"normal1"][idx];
#elif TEST_NORMAL_CYCLE2
    if (idx < [self.testTemperatures[@"normal2"] count])
        item.temperature = self.testTemperatures[@"normal2"][idx];
#elif TEST_ANOVUL_CYCLE
    if (idx < [self.testTemperatures[@"anovul"] count])
        item.temperature = self.testTemperatures[@"anovul"][idx];    
#endif
    
    NSString *imageName = @"point_clear";
    
//    if (idx < self.ovulationCandidateIndex)
//        imageName = @"point_green";
//    else if (idx < [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue])
//        imageName = @"point_salad";
    
    NSInteger lengthOfCycle = [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
    if (idx < lengthOfCycle || [item.temperature floatValue] > kBPTemperaturePickerMinTemperature - BP_EPSILON)
        imageName = @"point_green";
    
    if (self.ovulationIndex == NSNotFound) {
        if (idx > self.ovulationCandidateIndex - 4 && idx <= self.ovulationCandidateIndex + 2)
            imageName = @"point_red";
        
        if (idx > self.ovulationCandidateIndex + 2 && idx <= self.todayIndex)
            imageName = @"point_yellow";
    } else {
        if (idx > self.ovulationCandidateIndex - 4 && idx <= MIN(self.ovulationCandidateIndex, self.ovulationIndex) + 2)
            imageName = @"point_red";
        
        if (idx > self.ovulationCandidateIndex + 2 && idx < self.ovulationIndex)
            imageName = @"point_yellow";
    }
    
    if (idx == self.ovulationIndex)
        imageName = @"point_ovulation";
    
    if ([item.menstruation boolValue])
        imageName = @"point_pink";
    
    item.imageName = imageName;
    
    return item;
}

- (NSInteger)indexForDate:(NSDate *)date
{
    NSInteger days = [self.startDate distanceInDaysToDate:date];
    return (days >= 0 && days < self.count ? days : NSNotFound);    
}

- (void)calculateOvulationIndex
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];

    self.ovulationIndex = self.ovulationCandidateIndex;

    NSInteger lengthOfCycle = [sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue];
    
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
        
        // found min temperature
        if (minTemperature < kBPTemperaturePickerMaxTemperature) {
            // TODO: if not enough data
            
            DLog(@"self.ovulationIndex: %i", self.ovulationIndex);
            
            float midTemperature = minTemperature;
            DLog(@"minTemperature: %f", minTemperature);

            for (NSInteger i = self.ovulationIndex - (kBPDatesManagerPrevDays - 1); i < self.ovulationIndex; i++) {
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
                if (count1 + count2 >= 2) {
                    self.ovulationIndex = ovulationIndex;
                } else {
                    self.ovulationIndex = NSNotFound;
                }
            }
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
