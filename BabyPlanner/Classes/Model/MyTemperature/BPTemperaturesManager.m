//
//  BPTemperaturesManager.m
//  BabyPlanner
//
//  Created by Nikolay Vyshynskyi on 22.08.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import "BPTemperaturesManager.h"
#import "NSDate-Utilities.h"
#import "BPDate.h"
#import "ObjectiveRecord.h"
#import "ObjectiveSugar.h"
#import "BPSettings+Additions.h"
#import <CoreData/CoreData.h>

NSString *const BPTemperaturesManagerDidChangeContentNotification = @"BPTemperaturesManagerDidChangeContentNotification";

@interface BPTemperaturesManager()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSMutableDictionary *dates;

@property (nonatomic, assign) NSDate *endDate;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger todayIndex;

@end

@implementation BPTemperaturesManager

- (id)init
{
    BPSettings *sharedSettings = [BPSettings sharedSettings];
    
    return [self initWithStartDate:sharedSettings[BPSettingsProfileLastMenstruationDateKey] ? : [NSDate date]];
}

- (id)initWithStartDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.startDate = [date dateAtStartOfDay];
        
        BPSettings *sharedSettings = [BPSettings sharedSettings];
        
        NSDate *today = [[NSDate date] dateAtStartOfDay];
        self.endDate = [self.startDate dateByAddingDays:[sharedSettings[BPSettingsProfileLengthOfCycleKey] integerValue]];
        self.endDate = [self.endDate earlierDate:today];
        // TODO: calculate;
        self.todayIndex = 0;
        self.count = [self.startDate daysBeforeDate:self.endDate] + 1;
        
        if (![self.endDate isEqualToDate:today])
            self.count++;
        
        self.dates = [[NSMutableDictionary alloc] init];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:NSManagedObjectContextDidSaveNotification object:[NSManagedObjectContext defaultContext]];
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
    NSDate *today = [[NSDate date] dateAtStartOfDay];
    
    NSDate *dateForItem;
    if (![self.endDate isEqualToDate:today]) {
        if (idx == 0)
            dateForItem = today;
        else
            dateForItem = [self.endDate dateBySubtractingDays:idx-1];
    } else
        dateForItem = [self.endDate dateBySubtractingDays:idx];
    
    BPDate *item = _dates[dateForItem];
    
    if (!item) {
        item = [BPDate where:[NSPredicate predicateWithFormat:@"date == %@ AND profile == %@", dateForItem, sharedSettings.profile]].first;
        
        if (!item) {
            item = [BPDate create:@{@"date": dateForItem}];
            item.profile = sharedSettings.profile;
        }
        
        _dates[dateForItem] = item;
    }
        
    return item;
}

- (NSInteger)indexForDate:(NSDate *)date
{
    NSDate *today = [[NSDate date] dateAtStartOfDay];
    
    if ([date isEqualToDate:today])
        return 0;
    
    NSInteger days = [date distanceInDaysToDate:self.endDate];

    if (![self.endDate isEqualToDate:today])
        days++;
    
    return (days >= 0 && days < self.count ? days : NSNotFound);
}

- (void)refresh:(NSNotification *)notification
{
    DLog(@"%@", notification);
    [self.dates removeAllObjects];
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:BPTemperaturesManagerDidChangeContentNotification object:nil];
}

@end
