//
//  BPCycle.h
//  BabyPlanner
//
//  Created by Mykola Vyshynskyi on 12.09.13.
//  Copyright (c) 2013 Mykola Vyshynskyi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BPDate, BPProfile;

@interface BPCycle : NSManagedObject

@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) BPProfile *profile;
@end

@interface BPCycle (CoreDataGeneratedAccessors)

- (void)addDatesObject:(BPDate *)value;
- (void)removeDatesObject:(BPDate *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;

@end
