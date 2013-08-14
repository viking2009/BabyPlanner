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
#import <CoreData/CoreData.h>

NSString *const BPDatesManagerDidChangeContentNotification = @"BPDatesManagerDidChangeContentNotification";

@interface BPDatesManager()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSMutableDictionary *dates;

@end


@implementation BPDatesManager

- (id)init
{
    return [self initWithStartDate:[NSDate date]];
}

- (id)initWithStartDate:(NSDate *)date
{
    self = [super init];
    if (self) {
        self.startDate = [date dateAtStartOfDay];
        self.dates = [[NSMutableDictionary alloc] init];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:NSManagedObjectContextDidSaveNotification object:[NSManagedObjectContext defaultContext]];
    }
    
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)count
{
    return 56;
}

- (NSInteger)ovulationIndex
{
    // TODO: calculate;
    return 13;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{    
    BPSettings *sharedSettings = [BPSettings sharedSettings];

    NSDate *dateForItem = [self.startDate dateByAddingDays:idx];

    BPDate *item = _dates[dateForItem];

    if (!item) {
        item = [BPDate where:[NSPredicate predicateWithFormat:@"date == %@ AND profile == %@", dateForItem, sharedSettings.profile]].first;
        
        if (!item) {
            item = [BPDate create:@{@"date": dateForItem}];
            item.profile = sharedSettings.profile;
        }
        
        _dates[dateForItem] = item;
    }
    
    item.day = @(idx + 1);
    item.pregnant = @([sharedSettings[BPSettingsProfileIsPregnantKey] boolValue]);
    item.ovulation = @(idx == self.ovulationIndex);
    
    return item;
}

- (void)refresh:(NSNotification *)notification
{
    DLog(@"%@", notification);
    [self.dates removeAllObjects];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:BPDatesManagerDidChangeContentNotification object:nil];
}

@end
